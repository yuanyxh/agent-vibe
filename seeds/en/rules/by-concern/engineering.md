---
id: seed/rule/concern-engineering
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When configuring formatting, static analysis, type checking or local hooks
load_via: skill
skills: [build]
summary: Engineering baseline
applies_when: { project.type: any }
requires: [quality.format, quality.lint]
grow: on-init
emits: rule/skill
verify: Each rule corresponds to an executable command or configuration file
---

# Engineering Rules

## ENG-01 Unified formatting

**Rule**: Commit the formatting tool and configuration, and run them before committing; do not adjust formatting by hand.

**Prohibited**: Multiple styles in the same file, or formatting that produces unrelated diffs.

**Verify**: The formatting command is idempotent, and repeated execution produces no new changes.

## ENG-02 Static analysis

**Rule**: Commit the lint rule set and include it in the quality gate; fix existing violations before enabling new rules.

**Prohibited**: Suppressing warnings in bulk with ignore comments.

**Verify**: The lint command exits with code 0, and every ignored item has a rationale.

## ENG-03 Type checking

**Rule**: When the language supports static typing, include the type-check command in the quality gate; public interfaces must have type annotations.

**Prohibited**: Bypassing checks with an arbitrary type.

**Verify**: The type-check command passes, and the interface list has annotations.

## ENG-04 Consistent editors

**Rule**: Unify line endings, encoding, indentation and trailing whitespace, and commit the configuration.

**Prohibited**: Depending on individual editor settings.

**Verify**: Checkout in different environments produces no formatting diffs.

## ENG-05 Dependency locking

**Rule**: Commit the lock file and install using locked versions.

**Prohibited**: Floating versions that lead to inconsistent build results.

**Verify**: Installation in a clean environment succeeds using the lock file.

## ENG-06 Local and CI consistency

**Rule**: Local hooks and CI run the same set of commands; hook failures block commits or merges.

**Prohibited**: Passing locally but failing in CI, or vice versa.

**Verify**: The command lists on both sides match.

## ENG-07 Generated artifacts not committed

**Rule**: Build artifacts, caches, coverage reports and verification data do not enter version control.

**Prohibited**: Substituting committed generated artifacts for reproducible builds.

**Verify**: Ignore rules cover every category of generated artifacts.
