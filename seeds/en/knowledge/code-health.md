---
id: knowledge/code-health
kind: knowledge
summary: Architecture, anti-pattern, and dead-code detection catalogue
applies_when: { project.type: any }
triggers: [architecture review, anti-pattern scan, dead-code check, post-refactor review, recurring defects]
sources: [General software design experience and code review conclusions]
version: 1
updated: 2026-11-07
review_by: 2027-02-07
status: active
load: on-demand
---

# Code Health

## Problem

Code degrades through small decisions: a dependency points the wrong way, a shortcut becomes a pattern, a branch stops being reachable. The goal is to find these with evidence before they make change expensive.

## Architecture Signals

| Signal | Evidence | Risk |
| --- | --- | --- |
| Cyclic dependency | Import or call graph cycle | Changes propagate in both directions; tests become entangled |
| Layer violation | A lower layer imports a higher layer | Business logic depends on delivery details |
| Unstable dependency | Stable module depends on a frequently changing module | Every change ripples into the core |
| Duplicated domain logic | Same rule implemented in multiple modules | Fixes diverge; data becomes inconsistent |
| Leaky abstraction | Callers depend on internal details | Implementation changes break callers |
| God module | One module owns unrelated responsibilities | Merge conflicts, slow review, unclear ownership |
| Distributed monolith | Services must deploy together | Coupling remains, operational cost rises |

## Anti-Patterns

| Pattern | Evidence | Risk |
| --- | --- | --- |
| God object | A class or module with many unrelated methods and fields | Hard to test and change |
| Feature envy | A method uses another object's data more than its own | Responsibility is misplaced |
| Primitive obsession | Raw strings or numbers carry domain meaning | Invalid states become representable |
| Long parameter list | Many positional parameters, especially booleans | Call sites are hard to read and easy to misuse |
| Copy-paste | Near-identical blocks with small differences | Fixes miss copies |
| Magic number | Unexplained literal in logic | Intent and change impact are unclear |
| Swallowed error | Empty catch or ignored failure | Defects become silent |
| Temporal coupling | Correctness depends on call order not expressed in types | Ordering bugs recur |
| Boolean flag parameter | One function does two behaviors selected by a flag | Callers and tests branch internally |

## Dead Code

| Signal | Evidence | Action |
| --- | --- | --- |
| Unused file or export | No import, reference, or route | Confirm dynamic loading, then move to trash |
| Unused dependency | Manifest entry with no import or build use | Confirm tooling usage, then remove |
| Unreachable branch | Condition cannot be true under declared types or config | Simplify or document why it remains |
| Commented-out code | Large disabled block with no explanation | Recover from version control; do not keep it |
| Stale feature flag | Flag always on or off in every environment | Remove flag and one branch |
| Orphan asset or config | No build, runtime, or documentation reference | Confirm, then archive |

## Evidence Standard

- Cite `file:line`, a command output, or a graph result.
- Separate detection from interpretation; mark confidence.
- Check dynamic loading, reflection, configuration, and external entry points before calling code dead.
- A pattern name alone is not evidence.

## Tradeoffs

- A short-lived duplication can be cheaper than a premature abstraction; report it, do not force a fix.
- A god module may be a deliberate boundary during migration; record the exit condition.
- Dead code may be kept for compatibility; require a documented owner and removal date.

## Verification

- The dependency graph is acyclic, or every cycle has an owner and a plan.
- Changing one business rule requires no synchronized edits in copied logic.
- Removing dead code does not change observable behavior; tests or a baseline confirm it.
- Every accepted anti-pattern has a reason and a review date.

## Counterexamples

- Refactoring while fixing a defect without a behavior baseline.
- Deleting an export because a text search missed dynamic loading.
- Reporting every long function as a god object without evidence of mixed responsibility.
- Treating a pattern name as a finding.
