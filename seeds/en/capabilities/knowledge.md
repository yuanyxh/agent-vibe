---
id: capability/knowledge
kind: capability
summary: Load general architecture and engineering knowledge as needed for the task, rather than injecting an entire volume
triggers:
  - Entering a new problem domain
  - Needing to choose among multiple patterns
  - The same type of problem recurring
  - The user asks "how is this usually done"
questions:
  - Which domain the current problem belongs to
  - Whether internal conventions or constraints already exist
  - Whether patterns, checklists, or decision grounds are needed
research:
  - Current official specifications and mature practices in the domain
  - Applicable versions and preconditions of the conclusions
generates:
  - type: knowledge pack
    examples: [problem definition, patterns and trade-offs, verification checklist, counterexamples]
  - type: index
    examples: [topic index, trigger conditions, sources and freshness]
verify:
  - Knowledge packs are actually referenced and influence decisions
  - Conclusions have sources and scope
  - Knowledge packs are not enforced as project rules
---

# Knowledge Capability

## Goal

Provide actionable patterns and trade-offs when needed, rather than stuffing a large volume of documentation into context at once.

## Knowledge pack format

Each entry contains only five parts:

1. **Problem**: In what scenarios it occurs.
2. **Pattern**: Reusable practices and structures.
3. **Trade-offs**: Costs, limits, and inapplicable conditions.
4. **Verification**: How to judge that it was done right.
5. **Counterexamples**: Common ways to fail.

## Loading rules

- Load by domain and task phase, taking only related topics at a time.
- Knowledge packs are references, not mandatory rules; when they conflict with project rules, project rules prevail.
- Cite the topic and version to avoid treating old conclusions as facts.

## Maintenance

- New knowledge packs enter the project first; after repeated verification, abstract them according to `protocols/en/distill.md`.
- Mark outdated entries or entries that conflict with current standards for review; do not silently keep them.
