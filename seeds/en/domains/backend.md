---
id: domain/backend
kind: domain
summary: API services, background jobs, and data-intensive systems
applies_when: { project.domain: backend }
core_concerns:
  - Authentication, authorization, and least privilege
  - Input validation, injection, and sensitive data
  - Concurrency, idempotency, locking, and transaction boundaries
  - Timeouts, retries, rate limiting, and backpressure
  - Consistency and compensation
  - Observability and capacity
questions:
  - Callers and trust boundaries
  - Concurrency volume and data consistency requirements
  - Acceptable interruption and data-loss windows
  - Whether services are distributed and whether compensation is needed
research:
  - Security baseline of the chosen runtime and framework
  - Transaction and isolation levels of the chosen storage
  - Current usage of queuing and rate-limiting mechanisms
generates:
  - type: config
    examples: [authentication and authorization, input validation, rate limiting, connection pooling, health checks]
  - type: test
    examples: [concurrency tests, idempotency tests, privilege-escalation tests, fault injection]
verify:
  - Unauthorized and privilege-escalating requests are rejected
  - Duplicate requests produce no duplicate side effects
  - Declared degradation occurs when dependencies fail
pitfalls:
  - Performing remote calls inside a transaction
  - Retries without idempotency keys causing duplicate writes
  - Error responses leaking stack traces or internal addresses
---

# Backend Services

## Goal

Maintain correct data and correct permissions under failure and concurrency, with problems that can be located.

## Generation Principles

- Validate every input outside the trust boundary.
- Design idempotency keys for write operations according to business semantics.
- Do not perform remote calls or long waits inside transaction boundaries.
- Derive timeout, retry, and rate-limit parameters from real capacity, not defaults.
- Correlate logs, metrics, and traces with a unified identifier, and do not record sensitive information.

## Verification

The four scenarios of concurrency, duplicate delivery, dependency timeout, and privilege escalation must each have an executable verification method.
