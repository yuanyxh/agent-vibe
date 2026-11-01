---
id: seed/rule/concern-design
kind: rule
version: 1
updated: 2026-10-24
review_by: 2027-01-24
status: active
load: on-demand
trigger: When writing, modifying or refactoring source code, or reviewing code structure
load_via: skill
skills: [build, review]
summary: Code reuse, responsibility boundaries and design patterns
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/skill
verify: Each rule can be judged in code
---

# Design Rules

## DES-01 Extract on repetition

**Rule**: Extract a shared unit when the same logic appears a third time; before extracting, confirm the differences are only parameters or composition.

**Prohibited**: Building a general layer in advance for a scenario that occurs only once, or copying without recording the source.

**Verify**: Changing a business rule in one place requires no synchronized changes to identical logic elsewhere.

## DES-02 Bounded abstraction

**Rule**: A shared unit exposes only the parameters and behavior callers actually need, and extension points are driven by real requirements.

**Prohibited**: Covering different scenarios with boolean switches, or pre-building extension points that no one uses.

**Verify**: Every parameter is used by at least one caller; adding a scenario requires no changes inside the shared unit.

## DES-03 Single responsibility

**Rule**: A module or function has only one reason to change, and its responsibility can be summarized in one sentence without coordinating conjunctions.

**Prohibited**: A single unit performing validation, transformation, storage and presentation at the same time.

**Verify**: When requirements change, modifications are concentrated and predictable.

## DES-04 Unidirectional dependencies

**Rule**: Dependencies point toward the more stable and more abstract end; business logic does not depend on concrete implementation details.

**Prohibited**: Circular dependencies and reverse cross-layer calls.

**Verify**: The dependency graph is acyclic; replacing an implementation requires no changes to callers' business code.

## DES-05 Composition first

**Rule**: Reuse behavior through composition and explicit parameters first; use inheritance only to represent stable polymorphic relationships.

**Prohibited**: Building inheritance hierarchies to reuse a small amount of code, or adding scenario switches to a base class.

**Verify**: New variants are created through composition without modifying existing units.

## DES-06 Introduce patterns by problem

**Rule**: Before introducing a design pattern, state the problem to solve, candidate solutions and reasons for abandonment.

**Prohibited**: Using a pattern name as the design rationale, or pre-building pattern structures for possible future requirements.

**Verify**: The design description identifies the concrete change point; removing the pattern makes the problem reproducible.

## DES-07 Refactoring preserves behavior

**Rule**: Submit refactoring separately from feature changes; have behavior tests or an equivalent baseline before refactoring.

**Prohibited**: Fixing defects or changing output as a side effect of refactoring.

**Verify**: The same set of behavior checks yields identical results before and after refactoring.

## DES-08 Naming reflects the domain

**Rule**: Use domain vocabulary in naming, keep one name per concept, and limit abbreviations to those commonly used by the team.

**Prohibited**: Multiple names for the same concept, or names that do not match behavior.

**Verify**: New members can infer purpose from names; searching a concept yields only one definition.

## DES-09 Search before creating

**Rule**: Before adding a module, function or component, use project search to find existing implementations with the same responsibility, and create a new one only after confirming it cannot be reused.

**Prohibited**: Creating a unit with overlapping responsibility without searching first.

**Verify**: Delivery or review records identify the search scope and conclusion; the new unit has no peer implementation.
