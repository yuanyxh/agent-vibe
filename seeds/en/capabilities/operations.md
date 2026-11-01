---
id: capability/operations
kind: capability
summary: Runtime status is observable, anomalies are discoverable, and failures are recoverable
triggers:
  - The project is deployed to a shared environment or production
  - The user asks about monitoring, alerting, or on-call
  - An online incident occurs
questions:
  - Which paths are critical paths
  - How anomalies are detected
  - The acceptable interruption duration and data loss window
  - Who is responsible for response
research:
  - Monitoring and logging capabilities of the selected runtime platform
  - Tracing and metrics integration methods for the selected technology stack
generates:
  - type: config
    examples: [health checks, logging conventions, metrics and alerts, rollback steps]
  - type: doc
    examples: [runbook, incident handling process]
verify:
  - Critical paths have success and failure signals
  - Alerts map to handling actions
  - Rollback and recovery steps are executable
---

# Operations

## Goal

When the system has problems, detect them before users perceive them at scale and recover using known steps.

## Generation principles

- Define critical paths and acceptable loss before choosing tools.
- Every alert must have an action item; delete or downgrade alerts with no action item.
- Logs and traces must not contain credentials or sensitive personal data.
- Provide verification methods for backups and recovery at generation time, not just configuration.

## Verification

Create a failure deliberately, locate the cause from signals, and complete a recovery drill.
