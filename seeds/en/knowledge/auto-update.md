---
id: knowledge/auto-update
kind: knowledge
summary: Client upgrades, signing, canary rollout, and rollback
applies_when: { project.domain: "desktop|mobile" }
triggers: [designing an upgrade channel, releasing a new version, upgrade failure]
sources: [User design document "Auto Update Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Auto Update

## Problem

Let users upgrade smoothly to new versions and recover usability when an upgrade fails.

## Patterns

- **Version checks**: separate stable and preview channels; the check endpoint can degrade gracefully.
- **Package integrity**: verify the signature or hash after download; reject unsigned packages.
- **Incremental and full**: prefer incremental updates and fall back to full packages on failure.
- **Install timing**: user-controlled; force updates only for security or compatibility blockers, with reasons stated.
- **Canary rollout**: roll out gradually by percentage or audience; pause on anomalies.
- **Rollback**: retain the previous version; roll back automatically when startup fails.
- **Resumable downloads**: large packages support resumption and verification.

## Trade-offs

| Strategy | Suitable for | Cost |
| --- | --- | --- |
| Silent auto update | Low-risk fixes | Users lose a sense of control |
| Prompt then update | Regular versions | Lower update rate |
| Forced update | Security or protocol changes | Requires clear explanation and fallback |

## Verification

- Tampered packages are rejected at install.
- The app remains usable after an interrupted upgrade.
- A new version that fails to start can roll back.
- Canary anomalies can be stopped quickly.

## Counterexamples

- No signature verification.
- The app cannot start after a failed upgrade.
- Forced updates without notice.
- No canary; all at once.

## Sources

User "Auto Update Design".
