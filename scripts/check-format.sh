#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
exec python3 -I - "$ROOT" <<'PY'
import os
import subprocess
import sys

ROOT = os.path.abspath(sys.argv[1])
SKIP_DIRS = (".git/", ".utility/", ".build/", "node_modules/")
MAX_BYTES = 1024 * 1024
fails = []
checked = 0


def git_files():
    paths = set()
    for args in (("ls-files", "-z"), ("ls-files", "--others", "--exclude-standard", "-z")):
        result = subprocess.run(["git", "-C", ROOT, *args], capture_output=True)
        paths.update(item for item in result.stdout.split(b"\0") if item)
    return sorted(paths)


def read_bytes(rel):
    with open(os.path.join(ROOT, rel), "rb") as handle:
        return handle.read()


def report(rel, line, msg):
    suffix = f":{line}" if line else ""
    fails.append(f"{rel}{suffix}: {msg}")


for raw in git_files():
    rel = raw.decode("utf-8", errors="replace")
    if any(part in rel for part in SKIP_DIRS):
        continue
    path = os.path.join(ROOT, rel)
    if not os.path.isfile(path) or os.path.getsize(path) > MAX_BYTES:
        continue
    data = read_bytes(rel)
    if b"\0" in data[:8192]:
        continue
    checked += 1
    if data.startswith(b"\xef\xbb\xbf"):
        report(rel, None, "UTF-8 BOM")
    if b"\r" in data:
        report(rel, None, "包含 CRLF 或 CR 换行")
    if data and not data.endswith(b"\n"):
        report(rel, None, "文件末尾缺少换行")
    text = data.decode("utf-8", errors="replace")
    for number, line in enumerate(text.splitlines(), 1):
        if "\t" in line:
            report(rel, number, "包含 Tab")
        stripped = line.rstrip(" \t")
        if stripped != line:
            markdown_break = rel.endswith(".md") and line.endswith("  ") and not line.endswith("   ")
            if not markdown_break:
                report(rel, number, "行尾空白")

print(f"检查格式 {checked} 个文件 | 错误 {len(fails)}")
for line in fails[:50]:
    print(f"FAIL {line}")
if len(fails) > 50:
    print(f"FAIL ... 其余 {len(fails) - 50} 项省略")
sys.exit(1 if fails else 0)
PY
