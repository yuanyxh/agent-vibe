---
id: example/domain/desktop
kind: domain
summary: Desktop applications and local tools
applies_when: { project.domain: desktop }
core_concerns:
  - Installation, upgrade, and uninstallation
  - Code signing and system permissions
  - Multi-platform differences
  - Crash reporting and logs
  - Automatic updates and rollback
questions:
  - Target operating systems and minimum versions
  - Whether signing and notarization are required
  - Update channels and rollback strategy
  - Which system permissions are needed
research:
  - Signing, notarization, and sandbox requirements of target platforms
  - Current recommended practices for update mechanisms
generates:
  - type: config
    examples: [packaging and signing, update channels, crash reporting, permission declarations]
  - type: doc
    examples: [installation and upgrade instructions, troubleshooting]
verify:
  - Installation, upgrade, and uninstallation all complete
  - Failed updates can roll back
  - Crashes produce locatable reports
pitfalls:
  - Blocked by the system due to missing signatures
  - The application becomes unusable after a failed update
  - Inconsistent path and permission handling across platforms
---

# Desktop Applications

## Goal

Users can install safely, upgrade smoothly, and recover when problems occur.

## Generation Principles

- Perform signing and notarization according to the target platform's current requirements.
- Keep a rollback-capable version before updating.
- Handle platform differences centrally, not scattered across business code.
- Follow least privilege for local files and system permissions.

## Verification

Complete installation, upgrade, uninstallation, and one failed rollback on a clean system.
