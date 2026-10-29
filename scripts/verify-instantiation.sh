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
        fail(".", "缺少启动契约（CLAUDE.md / AGENTS.md / .cursor/rules/core.mdc）")
        return
    for name in found:
        path = os.path.join(ROOT, name)
        text = read(path)
        if not text.strip():
            fail(name, "契约为空")
        lines = text.count("\n") + (0 if text.endswith("\n") else 1)
        if lines > 200:
            fail(name, f"契约 {lines} 行，超过 200 行预算")
        if "加载" not in text or "验证" not in text:
            warn(name, "契约未出现“加载”或“验证”章节")
        start = text.find("<!-- core:start -->")
        end = text.find("<!-- core:end -->")
        if start == -1 and end == -1:
            warn(name, "缺少 core 标记，无法核对核心 60 行预算")
        elif start == -1 or end == -1 or end < start:
            fail(name, "core 标记不成对")
        elif text[start:end].count("\n") > 60:
            fail(name, "核心内联块超过 60 行预算")


def check_profile():
    path = os.path.join(ROOT, ".agent/profile.yaml")
    if not nonempty(path):
        fail(".agent/profile.yaml", "缺失或为空")
        return None
    text = read(path)
    for field in ("name:", "type:", "agent:"):
        if not re.search(rf"(?m)^\s*{re.escape(field)}", text):
            fail(".agent/profile.yaml", f"缺少字段 {field}")
    match = re.search(r"(?m)^seed_version:\s*(\S+)\s*$", text)
    version_file = os.path.join(REPO, "SEEDS_VERSION")
    expected = read(version_file).strip() if os.path.isfile(version_file) else ""
    if not match:
        warn(".agent/profile.yaml", "缺少 seed_version，无法按版本升级")
    elif expected and match.group(1) != expected:
        warn(".agent/profile.yaml", f"seed_version={match.group(1)} 低于当前 {expected}，需要升级")
    return text


def check_states():
    required = [
        ".agent/status.md",
        ".agent/decisions.md",
        ".agent/lessons.md",
        ".agent/environment.md",
        ".agent/research.md",
        ".agent/memory/README.md",
    ]
    for name in required:
        if not nonempty(os.path.join(ROOT, name)):
            fail(name, "缺失或为空")
    if not os.path.isfile(os.path.join(ROOT, ".agent/memory/INDEX.md")):
        warn(".agent/memory/INDEX.md", "缺失，长期记忆无法按编号检索")


def check_profile_domain(profile):
    if not profile:
        return
    if not re.search(r"(?m)^\s*domain:", profile):
        return
    domains = glob.glob(os.path.join(ROOT, ".agent/domains/*.md"))
    if not domains:
        fail(".agent/domains/", "画像声明了 domain，但没有领域定义文件")
    for path in domains:
        if not nonempty(path):
            fail(rel(path), "领域定义为空")


def check_rules():
    for path in glob.glob(os.path.join(ROOT, ".claude/rules/*.md")):
        text = read(path)
        if "paths:" not in front_matter(text):
            fail(rel(path), "路径规则缺少 paths")
        if len(text.splitlines()) > 120:
            fail(rel(path), "路径规则超过 120 行预算")
    for path in glob.glob(os.path.join(ROOT, ".cursor/rules/*.mdc")):
        text = read(path)
        meta = front_matter(text)
        is_core = os.path.basename(path) == "core.mdc"
        if not is_core and "alwaysApply: true" in meta:
            fail(rel(path), "非核心规则不得 alwaysApply: true")
        if not is_core and "globs:" not in meta and "description:" not in meta:
            fail(rel(path), "路径规则缺少 globs 或 description")
    for path in glob.glob(os.path.join(ROOT, ".agent/rules/*.md")):
        if len(read(path).splitlines()) > 120:
            fail(rel(path), "按需规则超过 120 行预算")


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
        fail(".", "没有可触发的技能文件")
        return
    for path in found:
        text = read(path)
        meta = front_matter(text)
        body = text.split("---", 2)[-1].strip() if meta else text.strip()
        if not body:
            fail(rel(path), "技能正文为空")
        if path.endswith("SKILL.md"):
            for field in ("name:", "description:"):
                if field not in meta:
                    fail(rel(path), f"技能头缺少 {field}")


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
            fail(rel(path), "残留种子元数据")
    for name in ("CLAUDE.md", "AGENTS.md"):
        path = os.path.join(ROOT, name)
        if not os.path.isfile(path):
            continue
        text = read(path)
        for token in ("{{", "<待填>"):
            if token in text:
                fail(name, f"残留占位符 {token}")


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
            fail(f".githooks/{name}", f"缺少 {name} 钩子")
            continue
        hooks.append(path)
        if not os.access(path, os.X_OK):
            fail(rel(path), "钩子不可执行")
        text = read(path)
        if not text.strip():
            fail(rel(path), "钩子为空")
        if "{{" in text:
            fail(rel(path), "钩子存在未替换占位符")
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
            fail(hook_label, f"钩子或 CI 未执行 verify.{key}: {command}")
    git_config = os.path.join(ROOT, ".git/config")
    if hooks and os.path.isfile(git_config):
        config = read(git_config)
        installed = "hooksPath" in config or os.path.isfile(os.path.join(ROOT, ".git/hooks/pre-commit"))
        if not installed:
            warn(hook_label, "存在钩子但未确认 core.hooksPath 生效")
    if delivery.get("repo_host") == "github":
        templates = (".github/PULL_REQUEST_TEMPLATE.md", ".github/pull_request_template.md")
        if not any(os.path.isfile(os.path.join(ROOT, name)) for name in templates):
            warn(".github/PULL_REQUEST_TEMPLATE.md", "GitHub 项目缺少 PR 模板")


if not os.path.isdir(ROOT):
    print(f"FAIL 目标目录不存在: {ROOT}")
    sys.exit(1)

check_contract()
profile = check_profile()
check_states()
check_profile_domain(profile)
check_rules()
check_skills()
check_metadata()
check_hooks(profile)

print(f"检查实例化 {ROOT} | 错误 {len(fails)} | 警告 {len(warns)}")
for line in fails:
    print(f"FAIL {line}")
for line in warns:
    print(f"WARN {line}")
sys.exit(1 if fails else 0)
PY
