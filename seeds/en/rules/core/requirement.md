---
id: seed/rule/core-requirement
kind: rule
version: 2
updated: 2026-10-24
review_by: 2027-01-24
status: active
load: always
summary: Requirement interpretation, example boundaries and solution convergence
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/always
verify: Each item can be judged in the project profile, decision records or delivery summary
---

# Requirement Rules

## REQ-01 Examples are not specifications

**Rule**: Examples, screenshots, reference products and solutions named by the user are all understanding material, not the complete requirement set. First record goals, constraints and example implementations separately, then judge the dimensions not covered by the examples.

**Prohibited**: Copying examples as specifications; defaulting to the approach in the examples for dimensions the examples do not cover.

**Verify**: Goals and examples are listed separately in the project profile or decision records; dimensions not covered by the examples have explicit values or are marked as pending.

## REQ-02 Purpose before means

**Rule**: When the user specifies an implementation approach, first restate the problem and constraints it is meant to solve; if the means conflict with the goal or a more suitable means exists, propose candidates and trade-offs.

**Prohibited**: Skipping goal confirmation because the user named a solution; or replacing the user's specified means without explanation.

**Verify**: Decision records map to the goal, the chosen means and the rationale for the trade-off; replacements of means are confirmed or explained.

## REQ-03 Questions before checklists

**Rule**: Domain must-ask items are a lower bound. Before entering the solution phase, check item by item across user, scenario, data, failure, boundaries and cost, distinguishing known, inferred and unknown; ask only questions whose prerequisites are already settled, and verify facts yourself first.

**Prohibited**: Skipping questions because a checklist does not list them; filling unknown items with the implicit assumptions of examples; throwing verifiable facts at the user.

**Verify**: Known items have sources, inferred items have grounds, and unknown items enter the pending-confirmation list or are registered as defaults; each round of questions has no unsettled prerequisites.

## REQ-04 Non-goals explicit

**Rule**: When defining scope, list non-goals at the same time; requests beyond the non-goals are confirmed before being expanded.

**Prohibited**: Having only a feature list, with no boundaries or grounds for refusal.

**Verify**: The project profile or decision records include non-goals; out-of-scope requests have confirmation records.

## REQ-05 Bounded divergence

**Rule**: When multiple reasonable interpretations or solutions exist, record at least two candidates at different levels (problem-interpretation level and implementation level) and the trade-offs; present them to the user only for D1/D2 decisions, and write the rest into decision records.

**Prohibited**: Providing only one path that follows the user's example; or turning divergence into multiple rounds of questions without recommendations.

**Verify**: Decision records contain candidates, trade-offs and reasons for abandonment; all user-facing questions carry recommendations.
