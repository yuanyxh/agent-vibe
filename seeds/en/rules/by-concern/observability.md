---
id: seed/rule/concern-observability
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When configuring monitoring, logging, alerting or troubleshooting production issues
load_via: skill
skills: [operate]
summary: Observability and cost
applies_when: { project.scale: "mvp|production" }
requires: [delivery.environments]
grow: on-signal
emits: rule/skill
verify: Each rule corresponds to a queryable signal
---

# Observability Rules

## OBS-01 Critical paths observable

**Rule**: Core user paths have success, failure and latency metrics, with correlatable trace identifiers.

**Prohibited**: Production incidents being discoverable only through user feedback.

**Verify**: After artificially inducing a failure, it can be located in metrics or logs.

## OBS-02 Actionable alerts

**Rule**: Each alert states the impact, basis for judgment and suggested action; alerts with no action item are removed or downgraded.

**Prohibited**: Configuring log anomalies directly as alerts.

**Verify**: Each alert in the list maps to handling steps.

## OBS-03 Visible cost

**Rule**: Resource, storage and invocation costs are recorded periodically, and abnormal growth can be attributed to a feature or traffic.

**Prohibited**: Not recording cost changes.

**Verify**: Cost reports can be split by environment and major feature.

## OBS-04 Logs contain no sensitive information

**Rule**: Do not write credentials, tokens or personal sensitive data into logs or traces.

**Prohibited**: Printing complete request bodies for troubleshooting convenience.

**Verify**: No sensitive fields can be found in sampled logs.
