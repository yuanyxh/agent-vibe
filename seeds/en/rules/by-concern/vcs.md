---
id: seed/rule/concern-vcs
kind: rule
version: 2
updated: 2026-11-02
review_by: 2027-02-02
status: active
load: on-demand
trigger: When committing, merging, cleaning up history or handling branches
load_via: skill
skills: [build, ship]
summary: Version control and commit conventions
applies_when: { delivery.vcs: git }
requires: [delivery.branch_strategy]
grow: on-init
emits: rule/skill
verify: Each rule can be checked by git commands or logs
---

# Version Control Rules

## VCS-01 Atomic commits

**Rule**: One commit completes one thing and can be reviewed and rolled back independently; unrelated changes are split into multiple commits.

**Prohibited**: Mixing features, refactoring and formatting in the same commit.

**Verify**: Each commit's diff can be described in one sentence, and rolling back a single commit does not break other features.

## VCS-02 Commit message conventions

**Rule**: Commit messages use `type(scope): summary`, with type limited to feat / fix / refactor / test / docs / chore / perf / build; the body explains the reason and impact, and references the task ID when necessary.

**Prohibited**: Using meaningless summaries such as "update", "fix bug" or "wip".

**Verify**: Each message in the commit log allows the change type and purpose to be judged; the `commit-msg` hook rejects non-compliant formats.

## VCS-03 Pre-commit checks

**Rule**: Before committing, confirm the diff contains only this change's intent; do not commit generated artifacts, dependency directories, local configuration, credentials or verification data.

**Prohibited**: Using `git add -A` instead of confirming item by item.

**Verify**: `git status` corresponds item by item to the diff; ignore rules cover the above categories.

## VCS-04 Commits require authorization

**Rule**: Committing, pushing, merging and rewriting history all require explicit user authorization; when the user has not authorized, provide only suggestions and commands.

**Prohibited**: Automatically committing or pushing to any branch.

**Verify**: Commit records correspond one-to-one with user authorizations.

## VCS-05 Branch strategy

**Rule**: Single-person projects default to trunk-based development; multi-person projects use short-lived branches and synchronize with the trunk before merging. Force-pushing to shared branches is prohibited.

**Prohibited**: Long-lived branches and rewriting history on shared branches.

**Verify**: The branch list matches the strategy; the history of shared branches only grows and is never changed.

## VCS-06 Readable history

**Rule**: Clean up commits before merging and remove debugging leftovers; important changes state the motivation and trade-offs in the body.

**Prohibited**: Merging temporary commits from development directly into the trunk.

**Verify**: The trunk history allows the project's evolution to be understood at commit granularity.

## VCS-07 Task branch isolation

**Rule**: Before starting a requirement or defect, run `git status --porcelain` and `git branch --show-current`. For `feature-branch`, create a short-lived branch from the latest trunk named `<type>/<task-slug>` (`type` is feat / fix / refactor / docs / chore) with `git switch <trunk> && git pull --ff-only && git switch -c <type>/<task-slug>`, and do all work for the task on it; for `trunk`, confirm the current branch is the trunk and synchronize with the remote before starting, and use a task branch for work that spans sessions or needs isolation. When the tree is dirty, stop and ask whether the changes belong to this task, should be committed, or should be stashed; never carry them silently. Delete the task branch after merge.

**Prohibited**: Developing directly on the trunk or an unrelated branch; starting from a stale trunk; mixing unrelated uncommitted changes into the task branch.

**Verify**: The branch name and base are recorded; the starting tree is clean or the ownership of existing changes is confirmed by the user; `git merge-base --is-ancestor origin/<trunk> HEAD` passes before merge.
