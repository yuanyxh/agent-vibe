---
id: domain-schema
kind: schema
summary: Format and generation method for domain definitions
load: on-demand
trigger: When generating, reading, or updating a domain definition
status: active
version: 1
updated: 2026-10-23
review_by: 2027-01-23
---

# Domain Definition Specification

Domains are an open set and need not be enumerated in advance. `seeds/en/domains/` provides a small number of high-frequency reference definitions to reuse when matched; when nothing matches, generate one on site according to this specification.

## When to Generate

- When the project profile determines `project.domain`.
- When entering a new industry, platform, or problem space.
- When existing domain definitions cannot cover the current problem, and the problem recurs in two or more projects.

## A Domain Must Contain

| Field | Requirement |
| --- | --- |
| `summary` | One sentence describing what this kind of project must solve |
| `applies_when` | Which profiles match |
| `core_concerns` | 3–8 core professional concerns, each verifiable |
| `questions` | Domain questions that must be confirmed with the user |
| `research` | External facts that must be verified before generation |
| `generates` | The **categories** of possible outputs; do not write concrete implementations |
| `verify` | How to prove the concerns are covered |
| `pitfalls` | Common failure modes |

## Generation Steps

1. Extract domain keywords from the project profile, the user's description, and existing code.
2. Verify the domain's current practices, standards, and regulations; record sources and dates.
3. Write verifiable `core_concerns`; avoid slogans.
4. Write to the project's `.agent/domains/<name>.md` and register it in the bootstrap contract.
5. When reused in two or more projects, propose promotion to an example or shared definition according to `protocols/en/distill.md`.

## Prohibited

- Making one domain the default for all projects.
- Replacing context-driven generation with a fixed checklist.
- Writing specific products, versions, or configurations into a domain definition.
- Asserting that a standard "must be so" without verifying its source.

## References

`seeds/en/domains/` provides high-frequency reference definitions (web-app, backend, cli, web-marketing, desktop) to reuse when matched; `examples/en/domains/` provides references for other writing styles and is not a fixed set.
