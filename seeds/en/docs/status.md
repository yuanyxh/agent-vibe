---
id: seed/doc/status
kind: doc
summary: Single source of truth for the project
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/status
verify: Status matches actual build results
---

# Project Status

## Current Goal

<One sentence describing the outcome to achieve in this phase>

Plan: `.agent/plans/<task-slug>.md` (or none for a single reversible step)

## In Progress

| Task | Plan step | Status | Blocked |
| --- | --- | --- | --- |
| <task> | <S1/S2/none> | <in progress/waiting> | <none/reason> |

## Completed

- <date> <result> <evidence: command or link>

## Next Steps

1. <next action; keep details in the plan or backlog, not here>

## Recent Verification

| Time | Command | Result |
| --- | --- | --- |
| <time> | `<command>` | <pass/fail> |

## Known Issues

- <issue>: <impact and plan link or backlog ID>
