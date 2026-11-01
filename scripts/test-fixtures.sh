#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
VERIFY="$ROOT/scripts/verify-instantiation.sh"

chmod +x "$ROOT/tests/fixtures/golden/.githooks/pre-commit"
chmod +x "$ROOT/tests/fixtures/golden/.githooks/commit-msg"

if ! "$VERIFY" "$ROOT/tests/fixtures/golden"; then
  echo "FAIL golden fixture did not pass"
  exit 1
fi

if output="$("$VERIFY" "$ROOT/tests/fixtures/broken" 2>&1)"; then
  echo "FAIL broken fixture was accepted"
  echo "$output"
  exit 1
fi

if ! grep -q "missing pre-commit hook" <<<"$output"; then
  echo "FAIL broken fixture did not trigger the missing-hook check"
  echo "$output"
  exit 1
fi

COMMIT_MSG="$ROOT/tests/fixtures/golden/.githooks/commit-msg"
if ! "$COMMIT_MSG" <(printf 'feat(seed): add hook\n'); then
  echo "FAIL commit-msg rejected a valid message"
  exit 1
fi

if "$COMMIT_MSG" <(printf 'update\n') >/dev/null 2>&1; then
  echo "FAIL commit-msg accepted an invalid message"
  exit 1
fi

echo "OK fixtures: golden passes, broken is rejected, commit-msg behaves correctly"
