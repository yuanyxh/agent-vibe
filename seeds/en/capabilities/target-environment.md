---
id: capability/target-environment
kind: capability
summary: The project explicitly declares and verifies its target runtime environments
triggers:
  - New project initialization
  - The user describes the user base, devices, or deployment platform
  - A compatibility defect occurs
questions:
  - Which platforms and devices it runs on
  - The minimum and maximum versions for each platform
  - "What hard constraints exist (network, storage, permissions, memory, offline)"
  - Whether there are accessibility, performance, or compliance goals
research:
  - Current version distribution and support policies of the selected platforms
  - Build targets and compatibility configuration methods of the selected technology stack
  - Capability limits of the target platforms
generates:
  - type: config
    examples: [compatibility declarations, build targets, degradation and polyfill strategies]
  - type: test
    examples: [compatibility matrix, target environment smoke checks]
  - type: doc
    examples: [supported range description]
verify:
  - The supported range has explicit version or capability boundaries
  - Build artifacts match the declarations
  - Beyond the supported range, there is understandable degradation or messaging
---

# Target Runtime Environments

## Goal

Make "what is supported and what is not" a verifiable fact rather than a verbal promise.

## Generation principles

- Support ranges come from user goals and real usage data, not tool defaults.
- When the user does not specify, use the technology stack's official defaults and note the source and preconditions.
- Platform versions are external facts and must be verified before generation; never write version numbers from memory.
- Constraints must translate into build configuration, a test matrix, or runtime checks; implement at least one of the three.

## Verification

Produce artifacts with the declared build configuration and run smoke checks in the lowest supported environment.

## Boundary

This capability declares and verifies the supported runtime range. Creating a disposable environment that cannot reach production belongs to `capability/isolated-environment`.
