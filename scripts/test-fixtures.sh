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

HOOK="$ROOT/seeds/scaffolds/hooks/agent-maintenance"
chmod +x "$HOOK" "$ROOT/tests/fixtures/golden/.claude/hooks/agent-maintenance.sh"

TMP=""
BROKEN_HEALTH=""
cleanup() {
  for dir in "$TMP" "$BROKEN_HEALTH"; do
    if [ -n "$dir" ] && [ -d "$dir" ]; then
      mv "$dir" "${dir}.used" 2>/dev/null || true
    fi
  done
}
trap cleanup EXIT

if output="$("$HOOK" --root "$ROOT/tests/fixtures/golden")"; then
  if [ -n "$output" ]; then
    echo "FAIL maintenance hook emitted a reminder for a fresh report"
    exit 1
  fi
else
  echo "FAIL maintenance hook failed on a fresh report"
  exit 1
fi

TMP="$(mktemp -d)"
mkdir -p "$TMP/.agent"
cp "$ROOT/tests/fixtures/golden/.agent/profile.yaml" "$TMP/.agent/profile.yaml"
cp "$ROOT/tests/fixtures/golden/.agent/agent-health.md" "$TMP/.agent/agent-health.md"
touch -t 202001010000 "$TMP/.agent/agent-health.md"

if ! output="$("$HOOK" --root "$TMP")"; then
  echo "FAIL maintenance hook failed on a stale report"
  exit 1
fi
if ! grep -q "older than" <<<"$output"; then
  echo "FAIL maintenance hook did not report a stale report"
  exit 1
fi

mv "$TMP/.agent/agent-health.md" "$TMP/.agent/agent-health.md.moved"
if ! output="$("$HOOK" --root "$TMP")"; then
  echo "FAIL maintenance hook failed on a missing report"
  exit 1
fi
if ! grep -q "missing" <<<"$output"; then
  echo "FAIL maintenance hook did not report a missing report"
  exit 1
fi

BROKEN_HEALTH="$(mktemp -d)"
cp -R "$ROOT/tests/fixtures/golden/." "$BROKEN_HEALTH/"
mv "$BROKEN_HEALTH/.agent/agent-health.md" "$BROKEN_HEALTH/.agent/agent-health.md.moved"
if output="$("$VERIFY" "$BROKEN_HEALTH" 2>&1)"; then
  echo "FAIL missing agent-health.md was accepted"
  exit 1
fi
if ! grep -q "agent-health.md" <<<"$output"; then
  echo "FAIL missing agent-health.md did not trigger the health check"
  exit 1
fi

echo "OK fixtures: golden passes, broken is rejected, commit-msg behaves correctly"
