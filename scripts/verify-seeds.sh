#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
exec python3 -I - "$ROOT" "$@" <<'PY'
import datetime
import glob
import os
import re
import sys

ROOT = sys.argv[1]
STRICT = "--strict" in sys.argv[2:]
os.chdir(ROOT)

REQUIRED = {
    "rule": "id kind version updated review_by status load summary applies_when verify",
    "skill": "name description id kind summary applies_when requires grow emits verify",
    "question": "id kind summary applies_when grow emits verify",
    "capability": "id kind summary triggers questions research generates verify",
    "knowledge": "id kind summary applies_when triggers sources version updated review_by status load",
    "domain": "id kind summary applies_when core_concerns questions research generates verify pitfalls",
    "principle": "id kind summary applies_when verify",
    "doc": "id kind summary applies_when verify",
}
SCAN_ROOTS = (
    "AGENTS.md",
    "README.md",
    "CAPABILITIES.md",
    "AGENTS.zh.md",
    "README.zh.md",
    "CAPABILITIES.zh.md",
)
SCAN_DIRS = ("seeds", "protocols", "adapters", "examples")
SKIP_NAMES = {"README.md", "INDEX.md", "_schema.md"}
PATH_SCOPES = {"source", "ui", "server", "tests", "config", "domain"}
ADAPTER_FILES = ("claude-code.md", "cursor.md", "codex.md", "generic.md")
PLATFORM_LABELS = {
    "en": ("Claude Code", "Cursor", "Codex", "Generic"),
    "zh": ("Claude Code", "Cursor", "Codex", "通用"),
}
DENY_TECH = re.compile(
    r"\b(React|Vue|Angular|Svelte|Next\.js|Nuxt|Spring|Django|Flask|FastAPI|Rails|"
    r"Laravel|Flutter|SwiftUI|Electron|Tauri|Express|NestJS|Ktor|Gin|Actix)\b",
    re.I,
)
PERSONAL_PATH = re.compile(r"/Users/|/home/|~/Documents|[A-Za-z]:\\\\")
PLATFORM_PATH = re.compile(r"\.claude/|\.cursor/|CLAUDE\.md|\.agents/")

fails, warns = [], []


def fail(path, msg):
    fails.append(f"{path}: {msg}")


def warn(path, msg):
    warns.append(f"{path}: {msg}")


def parse(path):
    text = open(path, encoding="utf-8").read()
    if not text.startswith("---"):
        return None, text
    parts = text.split("---", 2)
    if len(parts) < 3:
        return None, text
    keys = {}
    for line in parts[1].splitlines():
        match = re.match(r"^([a-z_]+):\s*(.*)$", line)
        if match:
            keys[match.group(1)] = match.group(2).strip()
    return keys, text


def scan_files():
    found = sorted(glob.glob("seeds/en/**/*.md", recursive=True))
    found += sorted(glob.glob("examples/en/domains/*.md"))
    return found


def check_rule(path, keys, text):
    load = keys.get("load", "")
    if load not in ("always", "on-demand"):
        fail(path, f"invalid load: {load or 'missing'}")
    if "version" in keys and not re.fullmatch(r"\d+", keys["version"]):
        fail(path, "version must be an integer")
    for field in ("updated", "review_by"):
        value = keys.get(field, "")
        if value and not re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
            fail(path, f"{field} must use YYYY-MM-DD")
    review_by = keys.get("review_by", "")
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", review_by):
        if datetime.date.fromisoformat(review_by) < datetime.date.today():
            warn(path, f"review_by is past due: {review_by}")
    if keys.get("status") not in ("active", "deprecated", "superseded"):
        fail(path, f"invalid status: {keys.get('status', 'missing')}")
    if load == "always" and keys.get("status") != "active":
        warn(path, f"non-active rule still uses always: {keys.get('status')}")
    if load != "on-demand":
        return
    if not keys.get("trigger"):
        fail(path, "on-demand rule is missing trigger")
    via = keys.get("load_via", "")
    if via not in ("path", "skill", "read"):
        fail(path, f"invalid load_via: {via or 'missing'}")
    if via == "path" and keys.get("path_scope") not in PATH_SCOPES:
        fail(path, f"invalid path_scope: {keys.get('path_scope', 'missing')}")
    if via == "skill":
        names = re.findall(r"[a-z][a-z0-9-]*", keys.get("skills", ""))
        if not names:
            fail(path, "load_via=skill but skills is not declared")
        for name in names:
            if not os.path.exists(f"seeds/en/skills/{name}/SKILL.md"):
                fail(path, f"references a missing skill: {name}")


def list_items(text, field):
    for line in text.splitlines():
        match = re.match(rf"^{field}:\s*\[(.*)\]\s*$", line)
        if match:
            return [item.strip() for item in match.group(1).split(",") if item.strip()]
    items = []
    in_block = False
    for line in text.splitlines():
        if not in_block:
            in_block = re.match(rf"^{field}:\s*$", line) is not None
            continue
        if re.match(r"^[a-z_]+:", line):
            break
        match = re.match(r"^\s*-\s+(.+)$", line)
        if match:
            items.append(match.group(1).strip())
    return items


def check_domain(path, text):
    front = text.split("---", 2)[1]
    concerns = list_items(front, "core_concerns")
    if not 3 <= len(concerns) <= 8:
        fail(path, f"core_concerns must contain 3-8 items, found {len(concerns)}")
    for field in ("questions", "research", "verify", "pitfalls"):
        if not list_items(front, field):
            fail(path, f"{field} must not be empty")


def check_kind(path, keys, text):
    kind = keys.get("kind", "")
    if kind in ("schema", "index"):
        return False
    if kind not in REQUIRED:
        fail(path, f"unknown kind: {kind or 'missing'}")
        return True
    for field in REQUIRED[kind].split():
        if field not in keys:
            fail(path, f"missing field {field}")
    if kind == "rule":
        check_rule(path, keys, text)
    if kind == "skill" and not keys.get("description"):
        fail(path, "skill is missing description")
    if kind == "domain":
        check_domain(path, text)
    return True


files = scan_files()
ids = {}
rule_ids = {}
checked = 0
for path in files:
    name = os.path.basename(path)
    keys, text = parse(path)
    if keys is None:
        if name not in SKIP_NAMES:
            fail(path, "missing front matter")
        continue
    if not check_kind(path, keys, text):
        continue
    checked += 1
    for field in ("id", "summary"):
        if not keys.get(field):
            fail(path, f"{field} is empty")
    if keys.get("id"):
        if keys["id"] in ids:
            fail(path, f"duplicate id: {keys['id']} also in {ids[keys['id']]}")
        ids[keys["id"]] = path
    if keys.get("kind") == "rule":
        for rid in re.findall(r"^##\s+([A-Z][A-Z0-9]+-\d+)\b", text, re.M):
            if rid in rule_ids:
                fail(path, f"duplicate rule id: {rid} also in {rule_ids[rid]}")
            rule_ids[rid] = path

idx_path = "seeds/en/knowledge/INDEX.md"
if os.path.exists(idx_path):
    idx = open(idx_path, encoding="utf-8").read()
    listed = set(re.findall(r"`([A-Za-z0-9_-]+\.md)`", idx))
    actual = {os.path.basename(p) for p in glob.glob("seeds/en/knowledge/*.md")} - {"INDEX.md"}
    for item in sorted(listed - actual):
        fail(idx_path, f"index lists a missing file: {item}")
    for item in sorted(actual - listed):
        fail(idx_path, f"knowledge pack is not listed in the index: {item}")

scan = [p for p in SCAN_ROOTS if os.path.exists(p)]
for base in SCAN_DIRS:
    scan += sorted(glob.glob(f"{base}/**/*.md", recursive=True))
path_ref = re.compile(r"`((?:seeds|protocols|adapters|packs)/[^`\s]+\.md)`")
link_ref = re.compile(r"\]\(([^)]+)\)")
for path in scan:
    text = open(path, encoding="utf-8").read()
    for ref in path_ref.findall(text):
        if any(ch in ref for ch in "<>{*}"):
            continue
        if not os.path.exists(ref):
            fail(path, f"reference does not exist: {ref}")
    for target in link_ref.findall(text):
        target = target.strip().split()[0].strip("<>")
        if not target or target.startswith(("#", "/")) or re.match(r"^[A-Za-z][A-Za-z0-9+.-]*:", target):
            continue
        local = target.split("#", 1)[0]
        if local and not os.path.exists(os.path.normpath(os.path.join(os.path.dirname(path), local))):
            fail(path, f"link does not exist: {target}")

for path in files:
    keys, _ = parse(path)
    if not keys or keys.get("kind") != "rule" or keys.get("load_via") != "skill":
        continue
    names = re.findall(r"[a-z][a-z0-9-]*", keys.get("skills", ""))
    base = os.path.basename(path)
    referenced = False
    for name in names:
        skill_path = f"seeds/en/skills/{name}/SKILL.md"
        if os.path.exists(skill_path) and base in open(skill_path, encoding="utf-8").read():
            referenced = True
            break
    if not referenced:
        fail(path, f"load_via=skill but the declared skill does not reference {base}")

for lang in ("en", "zh"):
    loading_path = f"protocols/{lang}/loading.md"
    if not os.path.exists(loading_path):
        fail(loading_path, "missing loading protocol")
        continue
    loading = open(loading_path, encoding="utf-8").read()
    for label in PLATFORM_LABELS[lang]:
        if not re.search(rf"^\|\s*{re.escape(label)}\s*\|", loading, re.M):
            fail(loading_path, f"platform matrix missing {label}")
    for adapter in ADAPTER_FILES:
        if not os.path.exists(f"adapters/{lang}/{adapter}"):
            fail(f"adapters/{lang}/{adapter}", "adapter referenced by the platform matrix is missing")
    for path in glob.glob(f"adapters/{lang}/*.md"):
        if os.path.basename(path) not in ADAPTER_FILES:
            fail(path, "adapter is not listed in the platform matrix")

docs = "".join(open(p, encoding="utf-8").read() for p in ("README.md", "CAPABILITIES.md"))
for path in glob.glob("seeds/en/skills/*/SKILL.md"):
    skill = os.path.basename(os.path.dirname(path))
    if skill not in docs:
        fail(path, f"skill {skill} is not registered in README or CAPABILITIES")

if not os.path.exists("SEEDS_VERSION"):
    fail("SEEDS_VERSION", "missing")
else:
    version = open("SEEDS_VERSION", encoding="utf-8").read().strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        fail("SEEDS_VERSION", f"invalid version: {version}")
    if not os.path.exists("CHANGELOG.md"):
        fail("CHANGELOG.md", "missing")
    elif f"## {version}" not in open("CHANGELOG.md", encoding="utf-8").read():
        fail("CHANGELOG.md", f"missing changelog entry for {version}")

for path in glob.glob("seeds/en/**/*.md", recursive=True):
    text = open(path, encoding="utf-8").read()
    hit = DENY_TECH.search(text)
    if hit:
        fail(path, f"seed mentions a concrete stack: {hit.group(0)}")
    if PERSONAL_PATH.search(text):
        fail(path, "seed contains a personal path")
    hit = PLATFORM_PATH.search(text)
    if hit:
        fail(path, f"seed contains a platform path: {hit.group(0)}")

for base in ("seeds", "protocols", "adapters", "examples", "packs"):
    en_files = {
        os.path.relpath(p, f"{base}/en")
        for p in glob.glob(f"{base}/en/**/*.md", recursive=True)
    }
    zh_files = {
        os.path.relpath(p, f"{base}/zh")
        for p in glob.glob(f"{base}/zh/**/*.md", recursive=True)
    }
    for rel in sorted(en_files - zh_files):
        fail(f"{base}/zh/{rel}", "missing Chinese mirror")
    for rel in sorted(zh_files - en_files):
        fail(f"{base}/en/{rel}", "missing English source")

for name in ("README", "CAPABILITIES", "AGENTS", "CHANGELOG", "CONTRIBUTING", "SECURITY"):
    for suffix in (".md", ".zh.md"):
        if not os.path.exists(f"{name}{suffix}"):
            fail(f"{name}{suffix}", "missing bilingual document")

print(f"checked {checked} seeds | {len(fails)} errors | {len(warns)} warnings")
for line in fails:
    print(f"FAIL {line}")
for line in warns:
    print(f"WARN {line}")
sys.exit(1 if fails or (STRICT and warns) else 0)
PY
