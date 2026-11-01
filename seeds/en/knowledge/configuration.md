---
id: knowledge/configuration
kind: knowledge
summary: Layered configuration, validation, and feature flags
applies_when: { project.type: any }
triggers: [environment differences, scattered configuration, need for canary or flags]
sources: [User design document "Configuration"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Configuration

## Problem

Make the same code behave correctly across environments and customers while preventing configuration from becoming hidden code.

## Patterns

- **Layering**: defaults → environment configuration → secrets/runtime injection; priority is explicit.
- **Validation**: validate types, required fields, and ranges at startup; fail when missing instead of continuing with empty values.
- **Secrets**: inject only through environment or secret management; example files contain no real values.
- **Feature flags**: each flag has an owner, default, and expiry; clean up after launch.
- **Change auditing**: who changed which configuration and when, with the ability to roll back.
- **Hot reload**: enable only for safe items; keep old values and alert on failure.

## Trade-offs

| Method | Suitable for | Risk |
| --- | --- | --- |
| Configuration files | Stable, versioned | Changes require a release |
| Environment variables | Containers and secrets | Hard to audit and validate |
| Configuration center | Dynamic adjustment | Depends on an external service |

## Verification

- Startup fails and names the item when required configuration is missing.
- Type errors in configuration are rejected.
- Behavior returns to the default after a flag is turned off.
- Configuration changes are traceable to a person and time.

## Counterexamples

- Secrets committed to the repository.
- Configuration reads scattered everywhere with no unified validation.
- Flags without expiry, accumulating over time.
- Hot reload failures making the service unavailable.

## Sources

User "Configuration".
