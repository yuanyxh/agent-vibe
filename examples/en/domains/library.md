---
id: example/domain/library
kind: domain
summary: Libraries, SDKs, and component packages that others depend on
applies_when: { project.domain: library }
core_concerns:
  - Public interface and compatibility
  - Semantic versioning and migration
  - Dependency minimization
  - Documentation and runnable examples
  - Type and error contracts
questions:
  - Consumers' language and runtime range
  - Compatibility commitments and release cadence
  - Whether multi-package management is required
research:
  - Versioning and release conventions of the target ecosystem
  - Common integration approaches used by consumers
generates:
  - type: config
    examples: [export manifest, versioning strategy, release pipeline]
  - type: doc
    examples: [API documentation, migration guide, examples]
verify:
  - Public interfaces have type and error documentation
  - Examples run and their results match the description
  - Breaking changes include migration notes
pitfalls:
  - Minor versions changing existing behavior
  - Runtime dependency bloat
  - Examples inconsistent with the current version
---

# Libraries and SDKs

## Goal

Let consumers upgrade safely and integrate correctly without reading the source code.

## Generation Principles

- Public interfaces are contracts; manage changes with semantic versioning.
- Keep only required runtime dependencies.
- Make error types distinguishable by callers.
- Documentation examples must actually be executed.

## Verification

Install and call the public interfaces in a minimal example project, verifying types, errors, and the upgrade path.
