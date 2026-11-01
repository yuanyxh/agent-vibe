---
id: seed/principle/core
kind: principle
summary: The eight basic principles of the seed repository
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/always
verify: Each principle maps to observable behavior
---

# Principles

## P-01 Humans make the fewest decisions

Bring humans only before four types of decisions: goals, irreversibility, cost, and compliance. The rest is advanced by the agent based on the project profile and defaults, with rollback recorded.

## P-02 Abstract growth, concrete implementation

The seed repository maintains only general concepts. Everything in a specific project—rules, skills, directories, configuration—grows after the context is determined; do not copy it by hand.

## P-03 Artifacts are context

Stages hand off through files, not conversation memory. A new session can continue by reading only `.agent/` and project documentation.

## P-04 Facts first

Code, tests, builds, and runtime output take precedence over documentation and memory. On conflict, verify the facts first, then correct the description.

## P-05 Rollback

Every change leaves a rollback path. Irreversible operations must explain their impact in advance and obtain confirmation.

## P-06 Rules are judgeable

A rule must answer "how to judge whether it is followed." Slogans that cannot be verified are not rules.

## P-07 No coupling

The general layer contains no specific projects, paths, accounts, version numbers, or platform directories. Platform differences exist only in adapters.

## P-08 One-way dependency

Concrete may depend on abstract; abstract must not depend on concrete. Distillation may carry only general patterns, never project facts.
