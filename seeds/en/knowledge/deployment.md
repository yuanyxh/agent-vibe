---
id: knowledge/deployment
kind: knowledge
summary: Reproducible builds, release strategies, and rollback
applies_when: { delivery.deploy_target: "!none" }
triggers: [establishing a release process, going live, rollback]
sources: [User design document "Automated Deployment Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Deployment

## Problem

Make the same version repeatably deployable, observable, and revertible.

## Patterns

- **Build once**: deploy the same artifact to multiple environments; inject environment differences through configuration.
- **Pipeline**: install, static checks, tests, build, release, verification; stop on any failed step.
- **Release strategies**: choose rolling, blue-green, or canary by risk; prefer canary for critical services.
- **Health checks**: separate liveness and readiness; verify critical paths after release.
- **Database migrations**: make them backward compatible first, then release code, then clean up; each step can be rolled back or rolled forward with a fix.
- **Rollback**: retain the previous version and configuration; rehearse the rollback steps.
- **Release records**: version, changes, impact scope, known issues, and rollback method.

## Trade-offs

| Strategy | Pros | Cost |
| --- | --- | --- |
| Rolling | Saves resources | Old and new versions coexist |
| Blue-green | Fast switching | Double resources |
| Canary | Low risk | Requires traffic control |

## Verification

- A clean environment builds successfully from lock files.
- Health checks and critical paths pass after release.
- Rolling back to the previous version is executable.
- Migrations are compatible with the code version.

## Counterexamples

- Rebuilding in every environment.
- No rollback path.
- Irreversible migrations without backups.
- Declaring completion as soon as deployment succeeds without runtime verification.

## Sources

User "Automated Deployment Design".
