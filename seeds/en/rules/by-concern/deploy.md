---
id: seed/rule/concern-deploy
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When releasing, deploying, rolling back or configuring environments
load_via: skill
skills: [ship, operate]
summary: Release and deployment
applies_when: { project.type: any, delivery.deploy_target: "!none" }
requires: [delivery.deploy_target, delivery.environments]
grow: on-init
emits: rule/skill
verify: Each rule maps to a release checklist
---

# Deployment Rules

## DPL-01 Rollback-ready

**Rule**: Every release has an explicit rollback version and procedure, and critical steps have been rehearsed.

**Prohibited**: Going live without a rollback path.

**Verify**: Rollback steps are recorded in the release notes.

## DPL-02 Configuration separated from code

**Rule**: Environment differences are injected through configuration or environment variables, and the same build artifact can be deployed to different environments.

**Prohibited**: Hardcoding environment addresses, secrets and switches in code.

**Verify**: No environment-specific values can be found in the build artifact.

## DPL-03 Consistent environments

**Rule**: Development, staging and production keep consistent runtime versions, dependencies and configuration structure, with differences documented in a list.

**Prohibited**: Going to production directly after verifying only locally.

**Verify**: The environment difference list exists and has been reviewed.

## DPL-04 Release notes

**Rule**: Every release includes the version, changes, impact scope, known issues and rollback method.

**Prohibited**: Silent releases without notes.

**Verify**: Release records are traceable to versions and change lists.

## DPL-05 Post-release verification

**Rule**: After release, check health status and critical paths, and confirm no anomalies within the observation window before concluding.

**Prohibited**: Declaring completion as soon as the deployment command succeeds.

**Verify**: Health check and critical-path results are recorded in the status file.
