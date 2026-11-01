---
name: learn
description: Triggers when the user says "record this", "capture the lesson", "summarize into the project", or "retrospective", or when experience needs to be captured after a defect or release ends. Writes experience into project lessons and proposes promotion to a general seed when appropriate.
id: seed/skill/learn
kind: skill
summary: Self-learning and knowledge capture
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

## Steps

1. **Collect facts**: defects, rework, release issues, or user corrections from this session, with evidence.
2. **Determine scope**: project-specific, technology-stack related, or cross-project general.
3. **Write into the project**: write project-specific lessons into `.agent/lessons.md` in the format of scenario, fact, decision, and scope of applicability.
4. **Propose promotion**: judge cross-project patterns per `protocols/en/distill.md`, form seed candidates, and submit them for user confirmation.
5. **Deduplicate**: merge with existing lessons or rules that mean the same thing; do not record twice.

## Completion criteria

- Every lesson traces back to one concrete event.
- General candidates are not written into the seed repository without user confirmation.

## Prohibited

- Recording guesses without evidence.
- Writing project names, paths, credentials, or business data into general seeds.
- Automatically modifying `seeds/en/`.
