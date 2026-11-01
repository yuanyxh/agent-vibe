---
id: seed/rule/type-web
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When implementing or modifying Web pages, routing, interactions and frontend data flow
load_via: path
path_scope: source
summary: General rules for Web projects
applies_when: { project.type: web }
requires: []
grow: on-init
emits: rule/path
verify: Rules are framework-agnostic and decidable
---

# Web Rules

## WEB-01 Reproducible builds

**Rule**: Dependency lock files are committed; the build command reproducibly produces the same artifacts in a clean environment.

**Prohibited**: Using floating dependency versions without locking.

**Verify**: Reinstalling and building succeeds after clearing the cache.

## WEB-02 Boundary validation

**Rule**: Validate all data from the browser, URL, storage and third parties before it enters business logic.

**Prohibited**: Trusting key fields such as permissions, price and identity passed from the client.

**Verify**: Constructed invalid input is rejected with a clear error.

## WEB-03 Consistent permissions

**Rule**: Hiding entry points in the frontend is only an experience optimization; the server must independently validate permissions.

**Prohibited**: Using interface invisibility as access control.

**Verify**: Unauthorized requests are rejected when the interface is called directly.

## WEB-04 Performance budget

**Rule**: First-screen size, critical-path latency and request count have measurable upper limits; optimize before releasing when limits are exceeded.

**Prohibited**: Continuously adding dependencies and resources without a budget.

**Verify**: Compare the build artifact report with the budget in the project profile.

## WEB-05 Accessibility baseline

**Rule**: Interactive elements are keyboard operable, forms have labels, images have alternative text, and color contrast meets the project profile requirements.

**Prohibited**: Conveying key information only through color or mouse events.

**Verify**: Keyboard walkthroughs and automated checks pass.
