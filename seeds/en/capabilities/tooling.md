---
id: capability/tooling
kind: capability
summary: Choose tools that are more suitable than default methods for the current task
triggers:
  - The task belongs to a specialized area such as performance, networking, security, accessibility, databases, mobile, or visualization
  - Existing methods cannot obtain the required evidence
  - The user asks "is there a better way"
questions:
  - "Which type of evidence is needed: runtime, network, rendering, query plan, or human judgment"
  - Whether installing tools, connecting to external services, or incurring costs is allowed
  - Whether the team already has a reusable toolchain
research:
  - Tools, services, and protocols currently available in the area
  - Permissions, data boundaries, and costs required by the tools
  - Applicable versions and known limitations of the tools
generates:
  - type: recommendation
    examples: [candidate tool comparison, adoption rationale, costs and alternatives]
  - type: config
    examples: [debug configuration, analysis scripts, collection rules]
verify:
  - The recommendation has a clear mapping to the problem
  - After adoption, it yields evidence that default methods cannot
  - No tools are installed or external services connected before user confirmation
---

# Tool Selection

## Goal

When specialized evidence is needed, choose the right tool rather than forcing general-purpose methods.

## Recommendation format

1. The current problem and the missing evidence.
2. Candidate methods (including default methods).
3. For each candidate: applicability, permission requirements, cost, and limitations.
4. Recommended option and fallback plan.
5. Execute after confirmation.

## Generation principles

- Tool names appear only as examples; actual recommendations must consider the current environment and user authorization.
- Prefer the existing toolchain, then new tools.
- When external data, credentials, or costs are involved, state the boundaries.
- Write recommendations to the decision log for later review.

## Verification

After adopting the recommended tool, it can answer questions that default methods cannot; otherwise revert and record the reason.
