---
id: example/domain/web-app
kind: domain
summary: Admin backends, SaaS, and middle platforms that require login and business operations
applies_when: { project.domain: web-app }
core_concerns:
  - Authentication, sessions, and permission model
  - Lists, filtering, pagination, and bulk operations
  - Form validation and error recovery
  - Server state and cache invalidation
  - Privilege escalation and auditing
  - Internationalization and accessibility
questions:
  - Roles and permission boundaries
  - Key business paths and data volumes
  - Whether auditing and operation logs are required
  - Multilingual and device adaptation requirements
research:
  - Authentication and caching mechanisms of the chosen framework
  - How the permission model lands on the server side
  - Pagination and virtualization approaches for large lists
generates:
  - type: config
    examples: [route guards, permission matrix, request layer, caching strategy]
  - type: test
    examples: [permission escalation tests, key-path tests]
verify:
  - Unauthenticated and privilege-escalating access is rejected by the server
  - Lists remain usable at target data volumes
  - Form errors can be located and recovered from
pitfalls:
  - Hiding entries only in the front end without validating the API
  - Client cache diverging from server state
  - Missing empty, loading, and error states
---

# Admin Backends and Middle Platforms

## Goal

Let different roles complete business operations efficiently within clear permission boundaries, with privilege escalation and misoperations detectable and recoverable.

## Generation Principles

- Enforce permissions on the server; the front end only improves experience.
- Lists, forms, and detail views must have loading, empty, error, and success states.
- Manage server state centrally in the request layer to avoid divergent caches.
- Write audit records for key operations, including the operator, time, and object.

## Verification

Execute the same operation with different roles to confirm the server rejects privilege escalation; measure list responses at target data volumes.
