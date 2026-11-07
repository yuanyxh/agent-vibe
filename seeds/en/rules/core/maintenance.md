---
id: seed/rule/core-maintenance
kind: rule
version: 1
updated: 2026-11-07
review_by: 2027-02-07
status: active
load: always
summary: Agent maintenance, learn capture, and isolated verification
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/always
verify: Maintenance, learn, and isolation actions have evidence and user confirmation
---

# Maintenance Rules

## MNT-01 Capture after change

**Rule**: After a defect fix, release, refactor, or user correction, run `learn` with concrete evidence; when no new fact exists, record nothing.

**Prohibited**: Recording guesses; repeating an existing lesson.

**Verify**: Each new lesson maps to a command, file, or user statement.

## MNT-02 Periodic agent check

**Rule**: Run `steward` when the health report is older than the configured interval, agent behavior conflicts with rules or skills, or before adding or removing rules, skills, prompts, hooks, or MCP servers.

**Prohibited**: Auto-editing rules, skills, memory, or prompts; deleting assets without confirmation.

**Verify**: The report has evidence and every applied change has user confirmation.

## MNT-03 Isolate before E2E

**Rule**: Before integration or end-to-end verification, use `sandbox` to create an isolated environment; never run against production or shared staging.

**Prohibited**: Using production credentials or data; faking E2E when isolation is unavailable.

**Verify**: The sandbox report shows isolated endpoints, synthetic data, passed E2E, and teardown.

## MNT-04 User correction wins

**Rule**: When memory, rules, or prior conclusions conflict with the user's current correction, stop and confirm, then mark the old entry superseded.

**Prohibited**: Overwriting the user's current statement with memory.

**Verify**: The decision record shows the correction and the superseded entry.
