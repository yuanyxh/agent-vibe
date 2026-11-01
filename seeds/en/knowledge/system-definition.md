---
id: knowledge/system-definition
kind: knowledge
summary: System boundaries, terminology, roles, and non-goals
applies_when: { project.type: any }
triggers: [new project kickoff, multi-person collaboration, frequent requirement changes]
sources: [User design documents "System Definition" and "Standardization"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# System Definition and Standardization

## Problem

Align participants on "what the system is, what it is not, and what terms mean" to reduce rework.

## Patterns

- **One-sentence positioning**: what it does, for whom, and what problem it solves.
- **Boundaries**: what the system is responsible for and explicitly what it is not (non-goals).
- **Roles and scenarios**: who uses it under what conditions, and what the core paths are.
- **Glossary**: one concept, one name; avoid mixing synonyms.
- **Quality attributes**: measurable goals for performance, availability, security, and compliance.
- **External dependencies**: depended-on systems, contracts, and behavior on failure.
- **Decision records**: key choices and trade-offs for future readers.

## Trade-offs

- Oversized documentation lags behind; keep only the parts that affect decisions.
- Non-goals matter as much as goals; missing non-goals lead to scope creep.

## Verification

- New members can restate the system boundaries and core paths.
- The same term is consistent across documentation, code, and UI.
- Requirement discussions can cite non-goals to reject out-of-scope requests.
- Quality attributes have measurable indicators.

## Counterexamples

- Only a feature list, with no boundaries.
- Multiple names for the same concept.
- Quality goals written as "high performance" or "high availability".
- Decisions that exist only in meeting notes.

## Sources

User "System Definition" and "Standardization".
