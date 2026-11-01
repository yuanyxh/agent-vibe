---
id: knowledge/authorization
kind: knowledge
summary: Common patterns for roles, menus, APIs, and data permissions
applies_when: { project.domain: "web-app|backend|mobile" }
triggers: [designing a permission model, privilege escalation, adding roles or data scopes]
sources: [User design document "Permission Design", OWASP authorization guide]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Permissions and Authorization

## Problem

Allow the right operations on the right people and the right data, and make privilege escalation detectable.

## Patterns

- **Model**: user → role → permission; add department, tenant, or resource-ownership dimensions when data scope is needed.
- **Three-layer checks**: hiding UI elements is for experience; API checks are the security boundary; the data layer filters rows and fields by ownership.
- **Deny by default**: deny when a rule cannot explicitly allow.
- **Least privilege**: roles grant only the permissions needed for the work; runtime accounts are likewise minimized.
- **Auditing**: permission changes and sensitive operations record the actor, object, time, and result.

## Data permissions

Horizontal privilege escalation (accessing others' data) and vertical privilege escalation (performing high-privilege operations) must be checked separately: beyond API permissions, resource ownership must also be checked.

## Trade-offs

- Permission caching improves performance, but the cache must be invalidated after changes.
- Role hierarchies are easy to manage, but tend to cause permission bloat; review them periodically.

## Verification

- Different roles get results for the same API that match the matrix.
- Direct API calls cannot bypass UI restrictions.
- Access to resources that do not belong to the user is denied.
- Permission changes take effect in caches within an acceptable time.

## Counterexamples

- Only hiding buttons in the frontend.
- APIs that only check "logged in" and not "allowed to do what".
- Super administrators bypassing auditing.
- Permission rules scattered across business code.

## Sources

User "Permission Design"; verify specific framework capabilities against the current ecosystem.
