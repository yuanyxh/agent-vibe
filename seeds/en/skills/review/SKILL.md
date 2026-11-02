---
name: review
description: Triggers when the user says "review", "look at the changes", "check the code", "take a look before merging", or "any problems". Reviews current changes, reports defects and rule violations, and does not make unauthorized modifications.
id: seed/skill/review
kind: skill
summary: Change review
applies_when: { project.type: any }
requires: [quality.security_level]
grow: on-init
emits: skill/review
verify: Every finding includes a location and evidence
---

# Change Review

## Goal

Find real defects before merge or release instead of restating the diff.

## Reading rules

Before executing, read `.agent/rules/collaboration.md`, `design.md`, `testing.md`, and the path rules for the changed scope; skip and state if a file does not exist.

## Steps

1. **Determine scope**: read the workspace status, commit history, and diff; distinguish committed changes, uncommitted changes, and the user's pre-existing changes.
2. **Check by priority**: correctness, security and privacy, data consistency, error handling, reuse and abstraction (duplicate implementations, premature abstraction, circular dependencies), test coverage, branch base and workspace hygiene, commit conventions and atomicity, formatting and lint results, rule violations.
3. **Verify assumptions**: report only what can be confirmed from code, tests, or commands; mark uncertain items as to be verified.
4. **Output findings**: order by severity; each includes file and line number, problem, trigger condition, and recommended action.
5. **Conclusion**: clearly state mergeable, needs changes, or blocked.

## Completion criteria

- Every finding can be located to specific code or a commit.
- When `delivery.vcs` is `git`, the change starts from a clean task branch per VCS-07, or deviations are listed.
- Commit messages follow the convention, or non-compliant items are listed.
- The conclusion is consistent with the findings.
- Responsibility overlap between new code and existing implementations has been checked, with evidence for the conclusion.
- No unauthorized modifications, commits, or releases were performed.

## Prohibited

- Listing style preferences as defects.
- Reporting problems without a verdict.
- Directly changing code or committing without authorization.
