---
name: delegate
description: Triggers when a development, investigation, or review task needs to be handed to a sub-agent, parallel worker, or another session. Pass only the goal, boundaries, and acceptance criteria so the executor reads context and decides independently.
id: seed/skill/delegate
kind: skill
summary: Minimal context for sub-agent delegation
applies_when: { project.type: any }
requires: []
grow: on-init
emits: skill/delegate
verify: The delegated content contains no technology choices, implementation steps, or expected answers
---

# Delegation

## Goal

Let the executor judge independently based on repository facts instead of reproducing the delegator's conclusions.

## Pass only these

- Goal: what result to achieve.
- Hard constraints: boundaries that must not be violated (compliance, security, budget, time).
- Acceptance criteria: what counts as done.
- Resource locations: locations of the seed repository, project directory, and status files.

## Do not pass

- Technology choices, frameworks, libraries, and versions.
- Directory structure, implementation steps, or code snippets.
- Specific values of profile fields.
- Expected answers, conclusions, or "how it should be done".
- The delegator's own analysis process.

## The executor must do these

1. Read the seeds and project state.
2. Ask questions along a question tree or infer independently.
3. Verify external facts.
4. Record decisions and sources.
5. Run verification and report.

## Exceptions

Security and compliance boundaries, constraints explicitly specified by the user, and existing project facts may be passed, but their sources must be marked.

## Acceptance

The delegator checks only results and evidence and does not make decisions on the executor's behalf.
