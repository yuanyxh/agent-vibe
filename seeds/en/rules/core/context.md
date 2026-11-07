---
id: seed/rule/core-context
kind: rule
version: 2
updated: 2026-11-02
review_by: 2027-02-02
status: active
load: always
summary: Context and single source of truth
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/always
verify: Status file exists and is updated
---

# Context Rules

## CTX-01 Single source of truth

**Rule**: The project's current goal, progress summary and blockers are written only in `.agent/status.md`; execution detail is written only in the current plan; unplanned work is written only in `.agent/backlog.md`; decisions are written only in `.agent/decisions.md`. Other documents reference them by path or ID instead of copying.

**Prohibited**: Maintaining conflicting progress, plans, to-dos, or decisions across multiple files.

**Verify**: At any moment there is only one current status, and it matches the actual build results.

## CTX-02 Artifacts are context

**Rule**: Each stage reads only the artifacts of the previous stage and the current project profile, without relying on conversation memory.

**Prohibited**: Assuming the agent remembers the content of the previous session.

**Verify**: A new session can continue the work using only `.agent/` and the project documents.

## CTX-03 Facts first

**Rule**: Code, tests, build output and runtime logs take precedence over documents and memory. When they conflict, verify the facts first, then correct the documents.

**Prohibited**: Overriding the user's current statement with memory content.

**Verify**: Conclusions are accompanied by command output, file paths or test results.

## CTX-04 Plan before multi-step work

**Rule**: A multi-step or multi-session task writes its goal, non-goals, acceptance criteria, confirmed agreements, and ordered steps to `.agent/plans/<task-slug>.md` before implementation.

**Prohibited**: Keeping the plan only in conversation; starting a confirmed multi-step plan without writing it down.

**Verify**: The plan file exists and every step maps to an actual result.

## CTX-05 Reconcile every step

**Rule**: After each step, update its status and evidence. When scope, order, or acceptance changes, append a drift entry with reason, impact, and decision; scope and acceptance changes require user confirmation.

**Prohibited**: Marking a step complete without evidence; silently changing an agreed plan; rewriting drift history.

**Verify**: Step status and evidence match the latest execution, and every drift entry maps to a decision or user confirmation.

## CTX-06 One backlog

**Rule**: Work that is not in the current plan goes to `.agent/backlog.md` with a stable ID, priority, status, and source.

**Prohibited**: Keeping to-dos only in conversation; maintaining the same item in both the backlog and the status or plan.

**Verify**: Every open item has one home, and completing an item updates that single record.
