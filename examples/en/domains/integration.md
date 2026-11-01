---
id: example/domain/integration
kind: domain
summary: Third-party integration, callbacks, messaging, and data synchronization
applies_when: { project.domain: integration }
core_concerns:
  - Contracts and version compatibility
  - Timeouts, retries, and idempotency
  - Callback signature verification and replay
  - Rate limiting and quotas
  - Reconciliation and discrepancy handling
  - Sandbox and production isolation
questions:
  - The counterparty's contract and versioning strategy
  - Acceptable latency and failure handling
  - Whether callbacks and reconciliation are required
  - Credentials and data boundaries
research:
  - The counterparty's current interface and signature-verification specifications
  - The counterparty's rate-limiting and retry recommendations
generates:
  - type: config
    examples: [request layer, signature verification, retries and backoff, idempotency keys, reconciliation jobs]
  - type: doc
    examples: [integration guide, troubleshooting, data boundaries]
verify:
  - Duplicate callbacks produce no duplicate side effects
  - Counterparty timeouts and rate limits have explicit handling
  - Reconciliation detects and handles discrepancies
pitfalls:
  - Missing idempotency keys causing duplicate entries
  - Callbacks without signature verification
  - Writing counterparty sandbox data into production
---

# Third-Party Integration

## Goal

Maintain correct data when external system contracts change, networks fail, and deliveries are duplicated.

## Generation Principles

- Record contracts and versions explicitly; confirm changes before implementing them.
- Make all write operations idempotent; verify the signature of every callback.
- Cap retries with backoff; never automatically retry non-idempotent operations.
- Reconcile regularly, with a closed loop for handling discrepancies.
- Document credentials and data boundaries.

## Verification

Verify with five scenarios: duplicate delivery, timeout, rate limiting, signature-verification failure, and reconciliation discrepancy.
