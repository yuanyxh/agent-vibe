---
id: capability/release
kind: capability
summary: Versions are reproducibly buildable, traceable, and revertible
triggers:
  - First release
  - The user requests a release or delivery
  - A release incident occurs
questions:
  - Where it is released and who uses it
  - How version numbers are defined
  - Whether signing, notarization, or automatic updates are required
research:
  - Current release requirements of the selected distribution channel
  - Signing and notarization processes of the selected platform
generates:
  - type: config
    examples: [version and tag rules, build artifacts, release pipeline]
  - type: doc
    examples: [release notes, installation and upgrade instructions, rollback steps]
verify:
  - The same version can be built repeatedly
  - Release records are traceable to commits
  - Reverting to the previous version is executable
---

# Release

## Goal

Every delivery can answer: which commit it was built from, what it contains, how to install it, and how to roll back.

## Generation principles

- Version numbering rules come from the user and distribution channel constraints; do not preset them.
- Release notes target users and describe changes and impact; do not copy commit logs.
- Signing, notarization, and automatic updates are external facts; verify current processes before generation.
- Release actions are irreversible or externally visible; obtain user confirmation before execution.

## Verification

Rebuild from the same commit to obtain an equivalent artifact; complete one installation and one rollback by following the documentation.
