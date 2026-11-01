---
id: knowledge/design-patterns
kind: knowledge
summary: Reuse decisions, abstraction timing, and pattern selection
applies_when: { project.type: any }
triggers: [growing code duplication, runaway abstraction, pattern selection, refactoring]
sources: [General software design experience and code review conclusions]
version: 1
updated: 2026-10-24
review_by: 2027-01-24
status: active
load: on-demand
---

# Code Design and Patterns

## Problem

Duplication makes fixes incomplete, premature abstraction makes shared units hard to use, and pattern overuse lengthens call chains. All three come from treating structure as the goal instead of as a response to change points.

## Patterns

- **Distinguish duplication first**: duplicated code is not duplicated logic. First judge whether two places change for the same reason; merge only when the reason is the same, otherwise keep both and let them evolve separately.
- **Abstraction timing**: extract on the third occurrence; mark the second occurrence but do not force abstraction then. Scenarios known to diverge long term may keep duplication.
- **Change-point driven**: abstract only around known change points. A parameter with only one value is not a change point.
- **Search order before creating**: full-text search by domain terms and synonyms → check the module export list → inspect the dependency graph for similar capabilities → check callers for an existing entry point; create only after all four steps find nothing.
- **Reuse decision order**: direct reuse → extend parameters or wrap via composition → lift a shared unit → create new; later options require clearer justification.
- **Dependency direction**: stable ends do not depend on volatile ends; business logic depends on abstractions, and concrete implementations are injected by the assembly layer.
- **Composition first**: convey differences with parameters, callbacks, and composition; use inheritance only for stable "is-a" relationships.
- **Choose patterns by change point**:
  - Algorithm replaceable: strategy.
  - Isolate an external interface: adapter.
  - Complex or replaceable creation: factory.
  - One-to-many notification: observer.
  - Orthogonal behavior stacking: decorator.
- **Refactoring rhythm**: small steps, revertible, preserving behavior at each step; add behavior guardrails before changing structure.

## Trade-offs

- **Duplication vs abstraction**: a little duplication costs less than a wrong abstraction; but multiple copies of the same business rule must converge.
- **Inheritance vs composition**: inheritance expresses classification, composition expresses capability; choose composition when classification is unstable.
- **Patterns vs direct implementation**: patterns add indirection and pay off only when the change point really exists.
- **General vs local**: write the local implementation first, decide on lifting when a second caller appears, and record the reason when not lifting.
- **Unification vs divergence**: forcing different semantics together for uniformity fills shared units with switches.

## Verification

- Changing one business rule requires editing only one place.
- Adding a variant requires no changes to existing shared units.
- The dependency graph is acyclic, and replacing an implementation does not change business code.
- The design description can point to the specific change point each pattern addresses.
- Refactoring commits contain no behavior changes, and check results are identical before and after.

## Counterexamples

- Extracting a shared component because two pages look similar, then adding boolean switches endlessly.
- Reusing a few lines with inheritance, and the base class gradually takes on every scenario.
- Adding interfaces, factories, and configuration for "possible future extension" that is never used.
- Taking "used a certain pattern" as proof of correct design.
- Fixing bugs incidentally in a refactoring commit, making issues impossible to attribute.
- The same entity having multiple names across code, APIs, and documentation.

## Sources

General software design experience and code review conclusions; contains no specific project implementation.
