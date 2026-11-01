---
id: seed/doc/decisions
kind: doc
summary: Decision log
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/decisions
verify: Each decision includes its level, decider, and rollback method
---

# Decision Log

| Date | Level | Decision | Decider | Basis | Rollback method |
| --- | --- | --- | --- | --- | --- |
| <date> | D1-D4 | <decision> | <user/Agent> | <fact or default> | <rollback steps> |

## Recording Rules

- D1 and D2 must be decided by the user; record the key points of the user's own words.
- D3 is decided by the Agent; record the source of the default value.
- When a decision is overturned, add a new entry; do not delete the old record.
