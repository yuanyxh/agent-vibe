---
id: seed/rule/type-backend
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When implementing or modifying interfaces, data access, concurrency and transactions
load_via: path
path_scope: server
summary: General rules for backend services
applies_when: { project.type: backend }
requires: []
grow: on-init
emits: rule/path
verify: Rules are technology-stack agnostic and decidable
---

# Backend Rules

## BE-01 Boundary validation

**Rule**: Request parameters, messages and external responses complete type, range and permission validation at the boundary layer.

**Prohibited**: Passing unvalidated data directly into domain logic or the database.

**Verify**: Invalid input returns a clear error and produces no side effects.

## BE-02 Idempotency

**Rule**: Write operations that may be delivered repeatedly have an idempotency key or deduplication mechanism.

**Prohibited**: Assuming the caller sends the request only once.

**Verify**: Repeated requests yield consistent results and no duplicate data.

## BE-03 Transaction boundaries

**Rule**: Data modifications for a single business operation complete within the same transaction; cross-service operations have a compensation plan.

**Prohibited**: Making remote calls or long waits inside a transaction.

**Verify**: On mid-way failure, data stays consistent or can be compensated.

## BE-04 Errors do not leak internals

**Rule**: External errors contain understandable information and a trace identifier, without stack traces, SQL, paths or internal addresses.

**Prohibited**: Returning exception text directly to the client.

**Verify**: When an exception is triggered, the response body contains no internal details.

## BE-05 Migrations can be rolled back

**Rule**: Database schema changes can be rolled back, or there is a data backup plan when they cannot.

**Prohibited**: Executing destructive changes without a backup in production.

**Verify**: Migration and rollback scripts exist in pairs and have been rehearsed.
