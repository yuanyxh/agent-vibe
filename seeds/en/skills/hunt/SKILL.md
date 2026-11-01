---
name: hunt
description: Triggers when the user says "investigate", "error", "not working", "crashed", "regressed", "it used to work", or "cannot find the cause". Reproduce first, then locate the root cause; add regression verification after the fix.
id: seed/skill/hunt
kind: skill
summary: Defect investigation
applies_when: { project.type: any }
requires: []
grow: on-init
emits: skill/hunt
verify: Reproduction steps, root-cause evidence, and regression tests are all present
---

# Defect Investigation

## Goal

Find the smallest cause that explains the symptom instead of making the error disappear.

## Reading rules

Before executing, read `.agent/rules/testing.md` and the path rules of the involved modules; skip and state if a file does not exist.

## Steps

0. **Confirm an executable entry point**: confirm the target can be started with one command, the reproduction path is reachable, and logs and screenshots can be obtained. When missing, add the entry point or declare that verification is impossible; do not change code without an entry point.
1. **Reproduce**: record the input, environment, command, and complete error output. When reproduction is impossible, add observability first; do not guess.
2. **Narrow**: use bisection, minimal cases, logs, and flags to eliminate possibilities until a single suspect remains.
3. **Root cause**: explain the trigger condition, code path, and why it was not exposed before.
4. **Fix**: change only code related to the root cause; preserve existing behavior.
5. **Regression**: add a test or check that captures the defect and run related tests.
6. **Capture**: write reusable lessons into `.agent/lessons.md`.

## Completion criteria

- The reproduction entry point is executable and recorded.
- There is a failing reproduction before the fix and passing evidence after the fix, with evidence levels labeled per TST-07.
- The causal chain between root cause and symptom is explainable.
- The regression check fails when the defect recurs.

## Prohibited

- Changing code without reproducing.
- Masking problems by catching exceptions, extending timeouts, or retrying.
- Fixing only symptoms without recording the root cause.
