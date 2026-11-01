---
id: capability/memory
kind: capability
summary: Preserve key facts across sessions and degrade when no external memory service is available
triggers:
  - A new session starts
  - Key decisions, user preferences, defect root causes, or release results occur
  - The environment provides no external memory service
questions:
  - Whether memory needs to span projects
  - Retention periods and sensitive information boundaries
  - Whether writing to an external memory service is allowed
research:
  - Memory services available in the current environment and their data boundaries
  - Locations of available project status and lessons files
generates:
  - type: protocol
    examples: [write timing, retrieval order, deduplication and promotion rules, degradation paths]
  - type: config
    examples: [project memory directory, external service integration or local degradation]
verify:
  - A new session can recover key context from project status and lessons alone
  - When memories conflict, current facts prevail
  - Functionality is not blocked when no external memory service exists
  - The index stays within capacity limits and archived entries remain traceable by ID
---

# Memory

## Goal

Preserve key facts across sessions while preventing memory from becoming an unverifiable "second truth."

## Layers

Write to the project by default; external services are optional enhancements only.

| Layer | Location | Content |
| --- | --- | --- |
| Project status | `.agent/status.md`, `decisions.md` | Current goals, progress, decisions, and rollbacks |
| Project lessons | `.agent/lessons.md` | Evidence-based defect root causes and experience |
| Long-term memory | `.agent/memory/INDEX.md` and topic files | Long-term facts, user preferences, and domain constraints |
| Cross-project memory | External service provided by the environment (optional) | Reusable patterns after de-identification |

## Entries and references

- Each memory has a stable ID `mem-YYYYMMDD-NNN`; the index stores only summaries, and the body is split by topic.
- When capacity is exceeded, archive to `archive/<year>.md` first; do not delete or reuse IDs.
- Reference external entries as `<provider>:<id>`, leave the body external, and degrade to a summary when the service is unavailable.
- Creating external entries requires explicit user authorization.

## Write timing

- Key decisions and trade-offs.
- User preferences or corrections.
- Defect root causes and regression methods.
- Release results and known issues.
- Handover information when a task is interrupted.

## Retrieval order

1. Project status and decisions.
2. Project lessons.
3. External memory (if present).
4. Current code, tests, and logs.

Memory is a clue, not evidence. When it conflicts with current facts, facts prevail.

## Degradation

When no external memory service exists, `.agent/` in the project must remain fully usable: status, decisions, lessons, and long-term memory are enough to recover context. Never block a task because memory is missing, and never treat memory as authorization.

For specific write timing, formats, and promotion rules, see `protocols/en/memory.md`.

## Prohibited

- Writing project names, paths, credentials, or business data into cross-project memory.
- Using memory to override the user's current correction.
- Recording a one-off event directly as a general rule.
