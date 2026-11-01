---
id: knowledge/testing
kind: knowledge
summary: Test layering, behavior assertions, and quality gates
applies_when: { project.type: any }
triggers: [designing a testing strategy, defect regression, pre-release verification]
sources: [User design document "Testing Principles"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Testing Strategy

## Problem

Prove behavior correct with executable evidence and detect regressions quickly after changes.

## Patterns

- **Layering**: unit tests verify pure logic; integration tests verify boundaries and collaboration; end-to-end tests verify critical user paths.
- **Behavior first**: assert observable results, not internal implementation.
- **Defect first as failure**: write a failing test before fixing.
- **Independent and repeatable**: do not depend on order, real time, network, or shared state.
- **Test data**: generate with factories or fixtures; avoid maintaining large data blocks by hand.
- **Quality gates**: commands are written into the startup contract and actually executed before release; coverage is a reference, not a goal.

## Trade-offs

| Layer | Speed | Confidence | Suitable for |
| --- | --- | --- | --- |
| Unit | Fast | Local | Logic and boundaries |
| Integration | Medium | Collaboration | APIs, storage, permissions |
| End-to-end | Slow | Global | Critical paths |

## Verification

- Tests pass in random order and when run individually.
- Failure messages locate the behavior and input.
- Defect fixes have corresponding regression tests.
- Quality gates run in a clean environment.

## Counterexamples

- Writing assertion-free tests for coverage.
- Sharing mutable state between tests.
- Testing only the success path.
- Replacing executable quality gates with manual judgment.

## Sources

User "Testing Principles".
