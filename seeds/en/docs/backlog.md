---
id: seed/doc/backlog
kind: doc
summary: Single queue for unplanned and deferred work
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/backlog
verify: Every open item has a priority, status, and source
---

# Backlog

## Items

| ID | Item | Priority and status | Source and notes |
| --- | --- | --- | --- |
| todo-YYYYMMDD-NNN | <one-line outcome> | <P0-P3; open/active/blocked/done/dropped> | <user/incident/review/plan; plan path or note> |

## Rules

- One item per row; IDs are stable and never reused.
- Priority: P0 blocks release or users, P1 current phase, P2 later phase, P3 optional.
- Hold only unplanned or deferred work; current task steps stay in the task plan.
- An item has exactly one home; link the plan instead of copying its steps.
- On completion or rejection, update the status and move the row to the archive below.

## Archive

| ID | Item | Result | Date |
| --- | --- | --- | --- |
| <id> | <item> | <done/dropped and reason> | <date> |
