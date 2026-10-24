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
SCAN_ROOTS = ("AGENTS.md", "README.md", "CAPABILITIES.md")
SCAN_DIRS = ("seeds", "protocols", "adapters", "examples")
SKIP_NAMES = {"README.md", "INDEX.md", "_schema.md"}
PATH_SCOPES = {"source", "ui", "server", "tests", "config", "domain"}

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
    found = sorted(glob.glob("seeds/**/*.md", recursive=True))
    found += sorted(glob.glob("examples/domains/*.md"))
    return found


def check_rule(path, keys, text):
    load = keys.get("load", "")
    if load not in ("always", "on-demand"):
        fail(path, f"load 非法: {load or '缺失'}")
    if "version" in keys and not re.fullmatch(r"\d+", keys["version"]):
        fail(path, "version 必须是整数")
    for field in ("updated", "review_by"):
        value = keys.get(field, "")
        if value and not re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
            fail(path, f"{field} 格式应为 YYYY-MM-DD")
    review_by = keys.get("review_by", "")
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", review_by):
        if datetime.date.fromisoformat(review_by) < datetime.date.today():
            warn(path, f"review_by 已过期: {review_by}")
    if keys.get("status") not in ("active", "deprecated", "superseded"):
        fail(path, f"status 非法: {keys.get('status', '缺失')}")
    if load == "always" and keys.get("status") != "active":
        warn(path, f"非 active 规则仍为 always: {keys.get('status')}")
    if load != "on-demand":
        return
    if not keys.get("trigger"):
        fail(path, "on-demand 规则缺少 trigger")
    via = keys.get("load_via", "")
    if via not in ("path", "skill", "read"):
        fail(path, f"load_via 非法: {via or '缺失'}")
    if via == "path" and keys.get("path_scope") not in PATH_SCOPES:
        fail(path, f"path_scope 非法: {keys.get('path_scope', '缺失')}")
    if via == "skill":
        names = re.findall(r"[a-z][a-z0-9-]*", keys.get("skills", ""))
        if not names:
            fail(path, "load_via=skill 但未声明 skills")
        for name in names:
            if not os.path.exists(f"seeds/skills/{name}/SKILL.md"):
                fail(path, f"引用不存在的技能: {name}")


def check_kind(path, keys, text):
    kind = keys.get("kind", "")
    if kind in ("schema", "index"):
        return False
    if kind not in REQUIRED:
        fail(path, f"未知 kind: {kind or '缺失'}")
        return True
    for field in REQUIRED[kind].split():
        if field not in keys:
            fail(path, f"缺少字段 {field}")
    if kind == "rule":
        check_rule(path, keys, text)
    if kind == "skill" and not keys.get("description"):
        fail(path, "技能缺少 description")
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
            fail(path, "缺少 front matter")
        continue
    if not check_kind(path, keys, text):
        continue
    checked += 1
    for field in ("id", "summary"):
        if not keys.get(field):
            fail(path, f"{field} 为空")
    if keys.get("id"):
        if keys["id"] in ids:
            fail(path, f"id 重复: {keys['id']} 也在 {ids[keys['id']]}")
        ids[keys["id"]] = path
    if keys.get("kind") == "rule":
        for rid in re.findall(r"^##\s+([A-Z][A-Z0-9]+-\d+)\b", text, re.M):
            if rid in rule_ids:
                warn(path, f"规则编号重复: {rid} 也在 {rule_ids[rid]}")
            rule_ids[rid] = path

idx_path = "seeds/knowledge/INDEX.md"
if os.path.exists(idx_path):
    idx = open(idx_path, encoding="utf-8").read()
    listed = set(re.findall(r"`([A-Za-z0-9_-]+\.md)`", idx))
    actual = {os.path.basename(p) for p in glob.glob("seeds/knowledge/*.md")} - {"INDEX.md"}
    for item in sorted(listed - actual):
        fail(idx_path, f"索引列出但文件不存在: {item}")
    for item in sorted(actual - listed):
        fail(idx_path, f"知识包未列入索引: {item}")

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
            fail(path, f"引用不存在: {ref}")
    for target in link_ref.findall(text):
        target = target.strip().split()[0].strip("<>")
        if not target or target.startswith(("#", "/")) or re.match(r"^[A-Za-z][A-Za-z0-9+.-]*:", target):
            continue
        local = target.split("#", 1)[0]
        if local and not os.path.exists(os.path.normpath(os.path.join(os.path.dirname(path), local))):
            fail(path, f"链接不存在: {target}")

print(f"检查种子 {checked} 个 | 错误 {len(fails)} | 警告 {len(warns)}")
for line in fails:
    print(f"FAIL {line}")
for line in warns:
    print(f"WARN {line}")
sys.exit(1 if fails or (STRICT and warns) else 0)
PY
