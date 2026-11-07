#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
exec python3 -I - "$ROOT" "$@" <<'PY'
import glob
import os
import re
import sys

if len(sys.argv) < 3:
    print("usage: verify-instantiation.sh <project-dir>")
    sys.exit(2)

REPO = os.path.abspath(sys.argv[1])
ROOT = os.path.abspath(sys.argv[2])
fails, warns = [], []


def fail(path, msg):
    fails.append(f"{path}: {msg}")


def warn(path, msg):
    warns.append(f"{path}: {msg}")


def read(path):
    with open(path, encoding="utf-8") as handle:
        return handle.read()


def rel(path):
    return os.path.relpath(path, ROOT)


def nonempty(path):
    return os.path.isfile(path) and os.path.getsize(path) > 0


def front_matter(text):
    if not text.startswith("---"):
        return ""
    parts = text.split("---", 2)
    return parts[1] if len(parts) > 2 else ""


def check_contract():
    candidates = ["CLAUDE.md", "AGENTS.md", ".cursor/rules/core.mdc"]
    found = [c for c in candidates if os.path.isfile(os.path.join(ROOT, c))]
    if not found:
        fail(".", "missing startup contract (CLAUDE.md / AGENTS.md / .cursor/rules/core.mdc)")
        return
    for name in found:
        path = os.path.join(ROOT, name)
        text = read(path)
        if not text.strip():
            fail(name, "contract is empty")
        lines = text.count("\n") + (0 if text.endswith("\n") else 1)
        if lines > 200:
            fail(name, f"contract is {lines} lines, over the 200-line budget")
        if not any(k in text for k in ("加载", "Loading")) or not any(
            k in text for k in ("验证", "Verification")
        ):
            warn(name, "contract has no Loading or Verification section")
        start = text.find("<!-- core:start -->")
        end = text.find("<!-- core:end -->")
        if start == -1 and end == -1:
            warn(name, "missing core markers; cannot check the 60-line core budget")
        elif start == -1 or end == -1 or end < start:
            fail(name, "core markers are not paired")
        elif text[start:end].count("\n") > 60:
            fail(name, "inline core block exceeds the 60-line budget")


def check_profile():
    path = os.path.join(ROOT, ".agent/profile.yaml")
    if not nonempty(path):
        fail(".agent/profile.yaml", "missing or empty")
        return None
    text = read(path)
    for field in ("name:", "type:", "agent:"):
        if not re.search(rf"(?m)^\s*{re.escape(field)}", text):
            fail(".agent/profile.yaml", f"missing field {field}")
    match = re.search(r"(?m)^seed_version:\s*(\S+)\s*$", text)
    version_file = os.path.join(REPO, "SEEDS_VERSION")
    expected = read(version_file).strip() if os.path.isfile(version_file) else ""
    if not match:
        warn(".agent/profile.yaml", "missing seed_version; cannot upgrade by version")
    elif expected and match.group(1) != expected:
        warn(".agent/profile.yaml", f"seed_version={match.group(1)} is older than {expected}; upgrade required")
    return text


def check_states(profile):
    required = [
        ".agent/status.md",
        ".agent/backlog.md",
        ".agent/upgrades.md",
        ".agent/plans/_template.md",
        ".agent/decisions.md",
        ".agent/lessons.md",
        ".agent/environment.md",
        ".agent/research.md",
        ".agent/memory/README.md",
    ]
    for name in required:
        if not nonempty(os.path.join(ROOT, name)):
            fail(name, "missing or empty")
    if not os.path.isfile(os.path.join(ROOT, ".agent/memory/INDEX.md")):
        warn(".agent/memory/INDEX.md", "missing; long-term memory cannot be indexed by number")
    health = os.path.join(ROOT, ".agent/agent-health.md")
    version = ""
    if profile:
        match = re.search(r"(?m)^seed_version:\s*(\S+)\s*$", profile)
        version = match.group(1) if match else ""
    older = False
    if re.fullmatch(r"\d+\.\d+\.\d+", version):
        older = tuple(int(part) for part in version.split(".")) < (1, 5, 0)
    if not nonempty(health):
        if older:
            warn(".agent/agent-health.md", "missing; upgrade to 1.5.0 adds the health baseline")
        else:
            fail(".agent/agent-health.md", "missing or empty")
    if not os.path.isfile(os.path.join(ROOT, ".agent/.maintenance-state")):
        warn(".agent/.maintenance-state", "missing; maintenance throttling cannot be verified")


def check_profile_domain(profile):
    if not profile:
        return
    if not re.search(r"(?m)^\s*domain:", profile):
        return
    domains = glob.glob(os.path.join(ROOT, ".agent/domains/*.md"))
    if not domains:
        fail(".agent/domains/", "the profile declares a domain but there is no domain definition file")
    for path in domains:
        if not nonempty(path):
            fail(rel(path), "domain definition is empty")


def check_rules():
    for path in glob.glob(os.path.join(ROOT, ".claude/rules/*.md")):
        text = read(path)
        if "paths:" not in front_matter(text):
            fail(rel(path), "path rule is missing paths")
        if len(text.splitlines()) > 120:
            fail(rel(path), "path rule exceeds the 120-line budget")
    for path in glob.glob(os.path.join(ROOT, ".cursor/rules/*.mdc")):
        text = read(path)
        meta = front_matter(text)
        is_core = os.path.basename(path) == "core.mdc"
        if not is_core and "alwaysApply: true" in meta:
            fail(rel(path), "non-core rule must not use alwaysApply: true")
        if not is_core and "globs:" not in meta and "description:" not in meta:
            fail(rel(path), "path rule is missing globs or description")
    for path in glob.glob(os.path.join(ROOT, ".agent/rules/*.md")):
        if len(read(path).splitlines()) > 120:
            fail(rel(path), "on-demand rule exceeds the 120-line budget")


def check_skills():
    patterns = [
        ".claude/skills/*/SKILL.md",
        ".agents/skills/*/SKILL.md",
        ".agent/skills/*/SKILL.md",
        ".cursor/commands/*.md",
    ]
    found = []
    for pattern in patterns:
        found += glob.glob(os.path.join(ROOT, pattern))
    if not found:
        fail(".", "no triggerable skill files found")
        return
    for path in found:
        text = read(path)
        meta = front_matter(text)
        body = text.split("---", 2)[-1].strip() if meta else text.strip()
        if not body:
            fail(rel(path), "skill body is empty")
        if path.endswith("SKILL.md"):
            for field in ("name:", "description:"):
                if field not in meta:
                    fail(rel(path), f"skill front matter is missing {field}")


def check_metadata():
    files = [os.path.join(ROOT, "CLAUDE.md"), os.path.join(ROOT, "AGENTS.md")]
    files += glob.glob(os.path.join(ROOT, ".claude/skills/*/SKILL.md"))
    files += glob.glob(os.path.join(ROOT, ".agents/skills/*/SKILL.md"))
    files += glob.glob(os.path.join(ROOT, ".agent/rules/*.md"))
    files += glob.glob(os.path.join(ROOT, ".claude/rules/*.md"))
    pattern = re.compile(r"(?m)^(id:\s*seed/|load_via:|grow:|emits:|applies_when:)")
    for path in files:
        if not os.path.isfile(path):
            continue
        if pattern.search(read(path)):
            fail(rel(path), "seed metadata leaked into the target")
    for name in ("CLAUDE.md", "AGENTS.md"):
        path = os.path.join(ROOT, name)
        if not os.path.isfile(path):
            continue
        text = read(path)
        for token in ("{{", "<待填>"):
            if token in text:
                fail(name, f"unresolved placeholder {token}")


def parse_section(text, name):
    values = {}
    inside = False
    for line in text.splitlines():
        if re.match(rf"^{re.escape(name)}:\s*$", line):
            inside = True
            continue
        if not inside:
            continue
        if line and not line.startswith((" ", "\t")):
            break
        match = re.match(r"^\s+([a-z_]+):\s*(.*?)\s*$", line)
        if match:
            values[match.group(1)] = match.group(2).strip().strip("'\"")
    return values


def find_hook(name):
    for base in (".githooks", ".husky", ".git/hooks"):
        path = os.path.join(ROOT, base, name)
        if os.path.isfile(path):
            return path
    return None


def check_dependencies(profile):
    if not profile:
        return
    stack = parse_section(profile, "stack")
    verify = parse_section(profile, "verify")
    manager = stack.get("package_manager", "")
    if manager and manager != "none":
        for key in ("outdated", "audit"):
            if not verify.get(key):
                warn(".agent/profile.yaml", f"package manager declared but verify.{key} is missing")
        lockfile = stack.get("lockfile", "")
        if not lockfile or lockfile == "none":
            warn(".agent/profile.yaml", "stack.lockfile is not declared")
        elif not os.path.isfile(os.path.join(ROOT, lockfile)):
            fail(lockfile, "declared lock file is missing")
    if not verify.get("audit"):
        warn(".agent/profile.yaml", "verify.audit is missing; dependency checks are incomplete")


def check_hooks(profile):
    if not profile:
        return
    delivery = parse_section(profile, "delivery")
    if delivery.get("vcs", "git") == "none":
        return
    hooks = []
    for name in ("pre-commit", "commit-msg"):
        path = find_hook(name)
        if not path:
            fail(f".githooks/{name}", f"missing {name} hook")
            continue
        hooks.append(path)
        if not os.access(path, os.X_OK):
            fail(rel(path), "hook is not executable")
        text = read(path)
        if not text.strip():
            fail(rel(path), "hook is empty")
        if "{{" in text:
            fail(rel(path), "hook contains an unresolved placeholder")
    hook_label = rel(hooks[0]) if hooks else ".githooks/pre-commit"
    enforced = [read(path) for path in hooks]
    for pattern in (
        ".github/workflows/*.yml",
        ".github/workflows/*.yaml",
        ".gitlab-ci.yml",
        "Jenkinsfile",
        "azure-pipelines.yml",
    ):
        for path in glob.glob(os.path.join(ROOT, pattern)):
            enforced.append(read(path))
    haystack = "\n".join(enforced).lower()
    verify = parse_section(profile, "verify")
    quality = parse_section(profile, "quality")
    for key in ("format", "lint"):
        command = verify.get(key, "")
        if not command or command == "none":
            continue
        candidates = [command]
        tool = quality.get(key, "")
        if tool and tool != "none":
            candidates.append(tool)
        if not any(candidate.lower() in haystack for candidate in candidates):
            fail(hook_label, f"hook or CI does not run verify.{key}: {command}")
    git_config = os.path.join(ROOT, ".git/config")
    if hooks and os.path.isfile(git_config):
        config = read(git_config)
        installed = "hooksPath" in config or os.path.isfile(os.path.join(ROOT, ".git/hooks/pre-commit"))
        if not installed:
            warn(hook_label, "hooks exist but core.hooksPath is not confirmed")
    if delivery.get("repo_host") == "github":
        templates = (".github/PULL_REQUEST_TEMPLATE.md", ".github/pull_request_template.md")
        if not any(os.path.isfile(os.path.join(ROOT, name)) for name in templates):
            warn(".github/PULL_REQUEST_TEMPLATE.md", "GitHub project is missing a PR template")


def check_maintenance(profile):
    if not profile:
        return
    agent = parse_section(profile, "agent")
    if agent.get("maintenance_mode", "") != "hook":
        return
    candidates = (
        ".claude/settings.json",
        ".codex/config.toml",
        ".cursor/automations.json",
        ".cursor/settings.json",
    )
    found = [name for name in candidates if os.path.isfile(os.path.join(ROOT, name))]
    if not found:
        warn(".agent/profile.yaml", "maintenance_mode=hook but no platform hook configuration was found")
        return
    for name in found:
        text = read(os.path.join(ROOT, name))
        if "hook" in text.lower() or "maintenance" in text.lower():
            return
    warn(".agent/profile.yaml", "maintenance_mode=hook but the hook configuration does not mention hooks or maintenance")


if not os.path.isdir(ROOT):
    print(f"FAIL target directory does not exist: {ROOT}")
    sys.exit(1)

check_contract()
profile = check_profile()
check_states(profile)
check_profile_domain(profile)
check_rules()
check_skills()
check_metadata()
check_dependencies(profile)
check_hooks(profile)
check_maintenance(profile)

print(f"checked instantiation {ROOT} | {len(fails)} errors | {len(warns)} warnings")
for line in fails:
    print(f"FAIL {line}")
for line in warns:
    print(f"WARN {line}")
sys.exit(1 if fails else 0)
PY
