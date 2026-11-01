---
id: seed/doc/lessons
kind: doc
summary: Captured project lessons
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/lessons
verify: Each lesson has a factual source and scope of applicability
---

# Project Lessons

## Format

### <date> <one-line title>

- **Context**: What happened.
- **Facts**: Logs, tests, or reproduction evidence.
- **Decision**: What to do from now on.
- **Scope**: This project only / this stack / possibly general.
- **Promotion**: Not evaluated / proposed / confirmed.

## Rules

- Record only experience backed by evidence.
- Merge duplicates with existing entries; do not add synonymous entries.
- Entries marked "possibly general" may enter the seed library only after user confirmation.
