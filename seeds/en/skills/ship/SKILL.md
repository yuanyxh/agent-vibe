---
name: ship
description: Triggers when the user says "release", "go live", "deploy", "cut a version", or "push to production". Checks quality gates before release, performs the release, and provides a rollback path.
id: seed/skill/ship
kind: skill
summary: Release and deployment
applies_when: { project.type: any }
requires: [delivery.deploy_target, delivery.environments, quality.test_level]
grow: on-init
emits: skill/ship
verify: Quality gates pass, release notes exist, and rollback steps are executable
---

# Release

## Goal

Safely deliver a verified version to the target environment with rollback always available.

## Pre-checks

- Review is complete, and defects are handled or explicitly waived.
- Tests, build, formatting, and lint pass on the target version.
- The version number is determined per semantic versioning, and the changelog and release notes are generated.
- The commit history is cleaned up, and the workspace has no uncommitted release content.
- Rollback steps are documented, and a critical step has been rehearsed.

Stop and state the gap when any item is not satisfied.

## Reading rules

Before executing, read `.agent/rules/deploy.md` and `vcs.md`; skip and state if a file does not exist.

## Steps

1. **Confirm scope**: the changes included, affected environments, and users.
2. **Release**: tag, merge to the mainline, or execute the deployment method declared by the project; these are irreversible or externally visible operations, so obtain user confirmation before executing.
3. **Verify**: check health endpoints, critical paths, and error rates.
4. **Observe**: monitor within the agreed window; handle anomalies per the rollback steps.
5. **Record**: record the version, time, result, and known issues in `.agent/status.md`.

## Completion criteria

- The running version in the target environment matches the released version.
- The version record, changelog, and commit tag are consistent.
- Critical path verification passes.
- The rollback method and observation results are recorded.

## Prohibited

- Releasing directly while skipping quality gates.
- Going live without a rollback path.
- Declaring completion immediately after release without runtime verification.
