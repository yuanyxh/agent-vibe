---
id: knowledge/observability
kind: knowledge
summary: Logs, metrics, traces, and error reporting
applies_when: { project.scale: "mvp|production" }
triggers: [locating online issues, establishing monitoring, integrating error reporting]
sources: [User design document "App Traces and Exception Reporting"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Observability

## Problem

When the system has problems, detect them before users perceive them at scale and locate the cause quickly.

## Patterns

- **Structured logs**: time, level, correlation ID, event, key fields; avoid large free-text blocks.
- **Metrics**: success rate, latency, throughput, and resource usage on critical paths.
- **Tracing**: propagate correlation IDs across services to reconstruct the full path of one request.
- **Error reporting**: crashes and exceptions carry stack traces, version, environment, and user-agnostic identifiers; deduplicate and aggregate.
- **User traces**: sequences of key operations for reproduction; collection must meet privacy requirements.
- **Alerting**: every alert has impact, judgment basis, and handling action; delete alerts with no action item.
- **Redaction**: logs and traces must not record credentials, tokens, or sensitive personal data.

## Trade-offs

| Means | Cost | Suitable for |
| --- | --- | --- |
| Logs | High storage | Details and auditing |
| Metrics | Low | Trends and alerting |
| Tracing | Medium | Cross-service location |
| User traces | Privacy risk | Reproducing user issues |

## Verification

- Artificially induced failures can be located through metrics or logs.
- Logs for the same request can be joined by correlation ID.
- Alerts map to handling steps.
- Sampled logs contain no sensitive fields.

## Counterexamples

- Logging only, without correlation IDs.
- Recording full request bodies and tokens.
- Alerts without action items.
- Sampling rates too low, losing critical issues.

## Sources

User "App Traces and Exception Reporting".
