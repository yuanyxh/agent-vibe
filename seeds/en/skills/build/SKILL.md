---
name: build
description: Triggers when the user asks to implement a requirement, change functionality, continue development, fix a small issue, or says "develop this", "implement it", or "pick it up". Implements in small steps according to the current project state and self-tests.
id: seed/skill/build
kind: skill
summary: Daily iterative development loop
applies_when: { project.type: any }
requires: [project.type, stack.language, quality.test_level]
grow: on-init
emits: skill/build
verify: Each increment is runnable and the status file is updated
---

# Iterative Development

## Pre-checks

- The current directory must contain `.agent/profile.yaml`; when missing, run `init` first and do not write code directly.
- If the current directory is the seed repository, stop and switch to the target project.
- The base's rules, skills, and contract must be non-empty; an empty directory counts as uninitialized.

## Goal

Turn one clear requirement into a runnable, revertible small increment while keeping project state traceable.

## Reading rules

Before executing, read `.agent/rules/engineering.md`, `design.md`, `vcs.md`, and `testing.md`; skip and state if a file does not exist.

## Steps

1. **Read state**: read `.agent/status.md` and related rules to confirm the current goal, in-progress tasks, and blockers.
2. **Define the increment**: choose the smallest slice that can be completed and verified within a single session. Decompose first when scope is unclear; do not guess requirements. Distinguish goals from examples per REQ-01, and list non-goals when confirming scope; when multiple reasonable interpretations exist, record the candidate trade-offs per REQ-05.
3. **Search for reuse**: before creating a module, function, or component, use project search means (full-text search, dependency graph, export list) to find existing implementations with the same responsibility and their callers; reuse or extend when a usable implementation exists, otherwise explain the reason for creating a new one in the delivery summary.
4. **Implement**: follow the rules matching the current phase; change only task-related files. When `quality.test_level` is `strict`, write a failing test first for each slice per TST-05; fix defects per TST-02.
5. **Self-test**: run the test and build commands declared by the project; explain when they cannot run. When a UI exists, also actually launch it once and take a screenshot or equivalent assertion; running the build alone does not count as self-testing. Label the evidence level per TST-07; when self-testing is impossible, output a handoff checklist per TST-09. Write verification data to the system temporary directory, not inside the project; when it must be inside the project, add ignore rules and clean up afterward.
6. **Engineering checks**: run the formatting, lint, and type-check commands declared by the profile; fix any failure before continuing.
7. **Pre-commit checks**: confirm the diff contains only the changes intended for this task, with no generated artifacts, credentials, local configuration, or verification leftovers; generate the commit message per the commit convention.
8. **Commit**: commits, pushes, and history rewrites are operations that require authorization. When the user has not explicitly authorized them, provide only commit suggestions and commands, do not execute.
9. **Update state**: record completed items, next steps, and blockers in `.agent/status.md`; write decisions to `.agent/decisions.md`.
10. **Deliver**: provide a change summary (including reuse or new-creation conclusions), verification commands and results, and commit status.

## Completion criteria

- The increment is runnable, and test results come from this actual execution.
- Formatting, lint, and type checks pass as required by the profile.
- The workspace has no verification leftovers, and the diff contains only the changes intended for this task.
- Commits are completed per convention, or a commit suggestion awaiting authorization is clearly provided.
- The status file is consistent with the code.
- No undocumented dependency or configuration changes are introduced.
- Existing implementations were searched before creating a shared unit, and the delivery summary explains the reuse or new-creation reasoning.

## Prohibited

- Implementing multiple unrelated requirements at once.
- Replacing actual execution with "should work".
- Overwriting or discarding the user's existing uncommitted changes.
- Creating a unit that overlaps with existing implementations without searching first.
- Performing irreversible operations without confirmation.
