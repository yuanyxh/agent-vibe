#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
VERIFY="$ROOT/scripts/verify-instantiation.sh"

chmod +x "$ROOT/tests/fixtures/golden/.githooks/pre-commit"
chmod +x "$ROOT/tests/fixtures/golden/.githooks/commit-msg"

if ! "$VERIFY" "$ROOT/tests/fixtures/golden"; then
  echo "FAIL golden fixture 未通过"
  exit 1
fi

if output="$("$VERIFY" "$ROOT/tests/fixtures/broken" 2>&1)"; then
  echo "FAIL broken fixture 被误判为通过"
  echo "$output"
  exit 1
fi

if ! grep -q "缺少 pre-commit 钩子" <<<"$output"; then
  echo "FAIL broken fixture 未触发钩子缺失检查"
  echo "$output"
  exit 1
fi

COMMIT_MSG="$ROOT/tests/fixtures/golden/.githooks/commit-msg"
if ! "$COMMIT_MSG" <(printf 'feat(seed): add hook\n'); then
  echo "FAIL commit-msg 拒绝了合法提交信息"
  exit 1
fi

if "$COMMIT_MSG" <(printf 'update\n') >/dev/null 2>&1; then
  echo "FAIL commit-msg 接受了非法提交信息"
  exit 1
fi

echo "OK fixtures：golden 通过，broken 被拒绝，commit-msg 行为正确"
