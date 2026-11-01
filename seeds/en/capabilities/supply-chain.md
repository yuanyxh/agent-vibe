---
id: capability/supply-chain
kind: capability
summary: Dependencies have trustworthy sources, are traceable, and can be updated
triggers:
  - Introducing third-party dependencies
  - The project enters production
  - A security advisory occurs
questions:
  - Who is responsible for dependency updates and how often
  - Whether vulnerability scanning and license auditing are required
  - Whether a bill of materials or release signing is required
research:
  - Current state of locking and audit tools in the selected ecosystem
  - Dependency update mechanisms of the selected hosting platform
generates:
  - type: config
    examples: [dependency update policy, vulnerability scanning jobs, license checks]
  - type: doc
    examples: [dependency admission and upgrade instructions, bill of materials]
verify:
  - Lock files are committed and installations are reproducible
  - High-severity vulnerabilities have handling records
  - New dependencies have source and license records
---

# Supply Chain

## Goal

Every piece of code and artifact entering the project can answer: where it came from, what version it is, who approved it, and how it is updated.

## Generation principles

- Lock before updating: the lock file is the single source of truth.
- Choose an update policy based on the ecosystem and team capabilities; do not preset specific tools as defaults.
- Scan and audit commands must be executable and included in quality gates or scheduled tasks.
- Generate a bill of materials and signatures only when the user explicitly requests them.

## Verification

Reinstall from the lock file to obtain the same dependency tree; high-severity items have explicit fix or acceptance records.
