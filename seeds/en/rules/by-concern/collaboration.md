---
id: seed/rule/concern-collaboration
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When collaborating with multiple people, reviewing changes or handing off tasks
load_via: skill
skills: [review]
summary: Multi-person collaboration
applies_when: { project.team: "small|large" }
requires: [delivery.branch_strategy]
grow: on-init
emits: rule/skill
verify: Each rule can be checked in the collaboration process
---

# Collaboration Rules

## COL-01 Reviewable changes

**Rule**: Each change states the background, approach, impact and verification method; keep it small and focused so others can understand it.

**Prohibited**: Committing large mixed changes that cannot be reviewed.

**Verify**: Reviewers can judge correctness without relying on the author's explanation.

## COL-02 Contract first

**Rule**: For changes to interfaces, data models and configuration items, update the documentation and version first, then change the implementation.

**Prohibited**: Changing the implementation before updating the documentation, causing passive breakage for callers.

**Verify**: The change order of contract documents and implementation is traceable.

## COL-03 Decisions recorded

**Rule**: Architectural choices and irreversible decisions are written to the decision log, including alternatives and reasons for abandonment.

**Prohibited**: Key decisions existing only in conversations or in someone's head.

**Verify**: New members can understand the decision context from the decision log.

## COL-04 Explicit review responsibility

**Rule**: Key modules have designated reviewers or owners; review comments must be addressed or explicitly declined.

**Prohibited**: Modules with no owner and review comments with no response.

**Verify**: The module list has owners; review records have conclusions.

## COL-05 Conflict avoidance

**Rule**: Split tasks by module or file boundaries; long-running tasks synchronize with the trunk periodically to avoid large-area conflicts.

**Prohibited**: Multiple people rewriting the same area at the same time.

**Verify**: Merge conflict size stays manageable, and task splits have boundary descriptions.

## COL-06 Changelog

**Rule**: User-facing changes are written to the changelog, describing additions, fixes, breaking changes and migration methods.

**Prohibited**: Breaking changes without migration instructions.

**Verify**: Every release version has a corresponding changelog entry.

## COL-07 Handoff-ready

**Rule**: When a task is interrupted, update the status file with what is done, what is not done, risks and next steps.

**Prohibited**: Relying on verbal handoff.

**Verify**: Others can continue the task using only the status file.

## COL-08 Minimal delegation context

**Rule**: When handing a task to a sub-agent or parallel worker, pass only the goal, hard constraints, acceptance criteria and resource locations; the executor reads the project context and decides independently.

**Prohibited**: Passing technology selection, implementation steps, project profile values, expected answers or your own analysis process.

**Verify**: Delegation content contains none of the prohibited items; execution results are based on repository facts rather than the delegator's conclusions.
