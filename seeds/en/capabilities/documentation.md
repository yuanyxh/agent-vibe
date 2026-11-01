---
id: capability/documentation
kind: capability
summary: Project knowledge can be recovered by newcomers and your future self
triggers:
  - New project initialization
  - Member changes or task handover
  - "I don't know why it was written this way" occurs
questions:
  - "Who the readers are: users, contributors, or maintainers"
  - Which decisions need a record
  - What language the documentation uses
research:
  - Documentation organization conventions in the selected ecosystem
  - How the selected hosting platform renders documentation
generates:
  - type: doc
    examples: [usage instructions, architecture description, decision records, troubleshooting, handover notes]
  - type: config
    examples: [documentation checks, link validation]
verify:
  - New members can complete their first run and first change by following the documentation
  - Commands in the documentation are executable
  - Key decisions include context and trade-offs
---

# Documentation

## Goal

Documentation answers "how to use it, why it is designed this way, and what to do when something goes wrong" rather than restating code.

## Generation principles

- Split by reader: users, contributors, maintainers.
- Decision records state context, alternatives, and trade-offs, not slogan conclusions.
- Commands and paths must be executable; examples must be real.
- Documentation language follows the user; do not default to a particular language.

## Verification

Have someone not involved in the project complete a first run using only the documentation; execute all commands successfully.
