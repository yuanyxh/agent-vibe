---
id: knowledge/consistency
kind: knowledge
summary: Eventual consistency across services and third-party synchronization
applies_when: { project.domain: "backend|integration" }
triggers: [cross-service writes, third-party sync, state inconsistency]
sources: [User design documents "Heterogeneous Systems & Realistic Eventual Consistency Design" and "Third-Party System State Synchronization"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Eventual Consistency

## Problem

When two systems cannot update atomically at the same time, how to make state eventually consistent and make differences discoverable and repairable.

## Patterns

- **Local transaction + events**: write business data and events in the same transaction; deliver events asynchronously.
- **Idempotent consumption**: deduplicate by event ID or business key.
- **State machine**: define states and allowed transitions; reject illegal transitions.
- **Compensation**: perform the reverse operation on failure; compensation itself must also be idempotent.
- **Reconciliation**: periodically compare both sides' states, output differences, and repair them automatically or manually.
- **Watermarks and versions**: use version numbers or time watermarks to decide which is newer, preventing old events from overwriting new state.

## Trade-offs

| Approach | Suitable for | Cost |
| --- | --- | --- |
| Strong consistency | Same database, low latency | Not feasible across services |
| Eventual consistency + reconciliation | Cross-service, third-party | Brief inconsistency |
| Dual writes | Transitional period | Prone to divergence; requires checks |

## Verification

- Duplicate events do not produce duplicate side effects.
- Out-of-order events do not cause state to regress.
- Reconciliation detects artificially created differences.
- Compensation failures have alerts and a manual entry point.

## Counterexamples

- Assuming callbacks always succeed and arrive exactly once.
- No reconciliation, letting differences accumulate.
- Old events overwriting new state.
- Non-idempotent compensation operations.

## Sources

User "Heterogeneous Systems & Realistic Eventual Consistency Design" and "Third-Party System State Synchronization"; verify specific mechanisms against the current ecosystem.
