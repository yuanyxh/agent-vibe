---
id: capability/governance
kind: capability
summary: The project has clear contracts for authorization, contribution, and security communication
triggers:
  - The project is public or involves multi-person collaboration
  - The user asks about licenses, contribution methods, or vulnerability reporting
questions:
  - Whether the project is public
  - What license is used
  - How contributions and review are organized
  - Through which channel security issues are reported
research:
  - Community health file conventions on the selected hosting platform
  - Official text and obligations of the selected license
generates:
  - type: doc
    examples: [license, contribution guide, code of conduct, security policy, support channels]
  - type: config
    examples: [review owners, issue and change request templates, branch protection requirements]
verify:
  - The license is consistent in the repository and metadata
  - Security reporting channels are actually usable
  - Templates and review requirements are recognized by the platform
---

# Project Governance

## Goal

External contributors and users know what they can do, how to do it, and whom to contact when problems arise.

## Generation principles

- Private projects generate only necessary items: license, security reporting method, and decision records.
- Public projects add a contribution guide, code of conduct, support channels, and templates.
- Generate platform-specific files according to current conventions after the hosting platform is determined; do not preset a platform path as the default.
- Use the official license text; do not rewrite it.

## Verification

A new contributor can complete one compliant change submission using only the repository documentation.
