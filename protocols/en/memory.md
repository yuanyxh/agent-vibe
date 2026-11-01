# Memory Protocol

By default, write memory into the project; external memory services are only optional enhancements.

## Locations

| Content | Location |
| --- | --- |
| Current goal and progress | `.agent/status.md` |
| Decisions and rollback | `.agent/decisions.md` |
| Evidence-backed experience | `.agent/lessons.md` |
| Long-term facts, preferences, and constraints | `.agent/memory/INDEX.md` and `.agent/memory/<topic>.md` |

## Write Timing

- Key decisions and trade-offs.
- User preferences or corrections.
- Defect root causes and regression methods.
- Release results and known issues.
- Handover information when a task is interrupted.

## Write Rules

1. Write only one fact per memory.
2. Each memory has a stable ID `mem-YYYYMMDD-NNN`; once written, an ID is never reused.
3. Attach sources: session, command output, file, or test.
4. Mark the applicable scope: project-only, stack-specific, or possibly universal.
5. Merge with existing entries when synonymous; do not add duplicates.
6. When overturned by a new fact, mark the supersession relationship; do not delete history.

## Entry Format

Each memory in `.agent/memory/<topic>.md` uses a level-2 heading ID, and the body must not exceed 5 lines:

```markdown
## mem-20261029-001

Fact: <one sentence>
Source: <session / command / file / test>
Scope: project | stack | universal
Status: active | superseded
Supersedes: <mem-id, optional>
External: <provider>:<id>, optional
```

`INDEX.md` keeps only a one-line summary:

```text
| id | summary | scope | status | updated | file |
```

## Retrieval Order

1. `.agent/status.md`
2. `.agent/decisions.md`
3. `.agent/lessons.md`
4. `.agent/memory/INDEX.md`; after a match, read the corresponding topic file
5. External memory service (if present)

Memory is a clue, not evidence. When it conflicts with the current code, tests, or user statement, current facts prevail.

## Capacity and Archiving

- Active entries in `INDEX.md` are capped at 100 lines; archive first when exceeded, do not keep appending.
- Archive conditions: status is `superseded`, or not updated for over a year and outside the current scope.
- Move archived entries to `.agent/memory/archive/<year>.md`; mark the index line `archived` and keep the ID.
- Archiving does not delete content; search the archive by ID when traceability is needed.
- When a topic file exceeds 120 lines, split it by subtopic and update the "file" column of the index accordingly.

## External Entry References

External memory stores only references and summaries; the body remains in the external service:

- Writing an external entry for the first time requires explicit user authorization, and the service name, entry ID, and write time must be recorded.
- The `External` field of a local entry uses a stable `<provider>:<id>` reference; one external entry can correspond to only one local ID.
- External entries also need an entry title and summary, to facilitate degradation when the service is unavailable.
- When the external service is unavailable or an entry is deleted, degrade locally to the summary, do not block the task, and record the disconnected entries in `status.md`.
- Do not write project names, paths, credentials, or business data into external entries.

## External Memory

When the environment provides an external memory service, sync is allowed, but it must:

- Write only sanitized general patterns.
- Not write project names, paths, credentials, or business data.
- Keep in-project memory fully usable when the external service is unavailable.

## Promotion

For patterns repeatedly validated within the project, propose entry into the seed repository per `protocols/en/distill.md`; automatic promotion without user confirmation is prohibited.

## Prohibited

- Overwriting the user's current correction with memory.
- Recording a one-off event as a general law.
- Letting memory become a blocker for task execution.
