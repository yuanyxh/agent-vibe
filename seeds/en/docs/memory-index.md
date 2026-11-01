---
id: seed/doc/memory-index
kind: doc
summary: Index of long-term memory within the project
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/memory
verify: Each memory has a source and scope of applicability
---

# Project Memory

## Long-Term Facts

| Fact | Source | Scope | Date |
| --- | --- | --- | --- |
| <fact> | <session/command/file> | <project/stack/general> | <date> |

## User Preferences

| Preference | Source | Still valid |
| --- | --- | --- |
| <preference> | <source> | <yes/to confirm> |

## Domain Constraints

| Constraint | Source | Impact |
| --- | --- | --- |
| <constraint> | <source> | <impact> |

## To Verify

| Lead | Required evidence |
| --- | --- |
| <lead> | <how to verify> |

## Rules

- Write only one fact per record.
- When conflicting with current facts, current facts prevail; annotate the original entry.
- Project details must not enter cross-project memory or the seed library.
