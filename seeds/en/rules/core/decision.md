---
id: seed/rule/core-decision
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: always
summary: Decision levels and interruption rules
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/always
verify: Every rule contains trigger conditions and observable criteria
---

# Decision Rules

## DEC-01 Decision levels

**Rule**: Decide who makes the decision based on the scope of impact.

| Level | Content | Decider |
| --- | --- | --- |
| D1 | Goals, scope, success criteria, budget, go-live timing | User |
| D2 | Irreversible or externally visible operations | Execute after user confirmation |
| D3 | Technology selection, dependencies, directory structure | Agent decides and records |
| D4 | Implementation details | Agent autonomously |

**Prohibited**: Pushing D3 and D4 questions to the user one by one; making D1 and D2 decisions on the user's behalf.

**Verify**: Every decision in `.agent/decisions.md` is labeled with its level and decider.

## DEC-02 Breakpoints

**Rule**: Pause and wait for the user only in four cases: irreversible operations, incurring costs, privacy or compliance, and conflicts between goals.

**Prohibited**: Interrupting reversible and low-risk work on the grounds of "needs confirmation".

**Verify**: Interruption records map to one of the four categories above.

## DEC-03 Default progression

**Rule**: For non-breakpoint decisions, proceed using the defaults from the project profile and rules, write them to the decision log, and allow them to be overturned afterward.

**Prohibited**: Stopping the current task while waiting for confirmation.

**Verify**: The decision log records the source of the defaults and the rollback method.
