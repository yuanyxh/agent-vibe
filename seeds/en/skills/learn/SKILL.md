---
name: learn
description: Triggers when the user says "record this", "capture the lesson", "summarize into the project", or "retrospective", when experience needs to be captured after a defect or release, or when the user asks for an architecture review, anti-pattern scan, dead-code check, or post-refactor review. Writes experience into project lessons and proposes promotion to a general seed when appropriate.
id: seed/skill/learn
kind: skill
summary: Self-learning, code health detection, and knowledge capture
applies_when: { project.type: any }
requires: [project.type]
grow: on-init
emits: skill/learn
verify: Every lesson has a factual source and scope of applicability
---

# Self-Learning

## Goal

Prevent the same kind of problem from recurring while avoiding elevating incidental experience into a general rule.

Before executing, read `.agent/rules/documentation.md`; skip and state if the file does not exist.

## Code health scan

Run this scan when the trigger is a defect, refactor, release, review, or an explicit code-health request. Use existing static checks, tests, and project search; every finding needs `file:line` or command output.

| Dimension | Look for |
| --- | --- |
| Architecture | Cyclic dependencies, layer violations, unstable dependency direction, duplicated domain logic, leaky abstractions, god module |
| Anti-patterns | God object, feature envy, primitive obsession, long parameter list, copy-paste, magic numbers, swallowed errors, temporal coupling, boolean flag parameter |
| Dead code | Unused files, exports, or dependencies; unreachable branches; commented-out code; stale feature flags; orphan assets or configuration |

- Separate evidence from suspicion and mark confidence.
- Route each finding to a new lesson, a backlog item, or a refactor task.
- Do not refactor or delete in this skill; deletions move to trash or an archive.

## Steps

1. **Collect facts**: defects, rework, release issues, or user corrections from this session, with evidence.
2. **Scan code health**: run the three dimensions above when the trigger requires it; record `file:line`, severity, and confidence.
3. **Determine scope**: project-specific, technology-stack related, or cross-project general.
4. **Write into the project**: write project-specific lessons into `.agent/lessons.md` in the format of scenario, fact, decision, and scope of applicability.
5. **Propose promotion**: judge cross-project patterns per `protocols/en/distill.md`, form seed candidates, and submit them for user confirmation.
6. **Deduplicate**: merge with existing lessons or rules that mean the same thing; do not record twice.

## Completion criteria

- Every lesson traces back to one concrete event.
- Every code health finding has evidence, severity, confidence, and a destination.
- General candidates are not written into the seed repository without user confirmation.

## Prohibited

- Recording guesses without evidence.
- Using an anti-pattern name as a substitute for evidence.
- Auto-refactoring or deleting code; deletions move to trash or an archive.
- Writing project names, paths, credentials, or business data into general seeds.
- Automatically modifying `seeds/en/`.
