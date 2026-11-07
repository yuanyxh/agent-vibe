---
id: capability/agent-assets
kind: capability
summary: Inventory and evaluate agent assets in the project, user, and plugins to avoid duplication and conflicts
triggers:
  - After the technology stack and project profile are determined
  - Before adding a skill, rule, or subagent
questions:
  - Whether user-level or third-party skills are allowed
  - Whether team conventions must be followed
research:
  - Existing project-level skills, rules, commands, and subagents
  - Available user-level and plugin items, their sources, and maintenance status
  - Capabilities and permission boundaries of available MCP tools
generates:
  - { type: doc, examples: [asset inventory conclusions in the research brief] }
verify:
  - Each item has an adopt, adapt, or ignore conclusion with rationale
  - No content of unknown origin is copied and no personal paths are recorded
---

# Agent Asset Inventory

## Desired outcome

Before generating the foundation, know what is already available, what can be used, and what will conflict, so you avoid duplicate generation or overriding existing conventions.

## Criteria

- Project-level assets take precedence over user-level and third-party assets.
- On conflict, the user's current instructions and project rules prevail; do not silently override.
- For third-party assets, first verify the source, license, maintenance status, and security boundary before deciding whether to adopt them.
- Record only names, conclusions, and rationale; do not copy content or run scripts of unknown origin.

## Instantiation steps

1. Inventory project-level skills, rules, commands, subagents, and contracts at the locations listed by the adapter.
2. Read only the names and descriptions of user-level and plugin assets; do not write them into the project.
3. Record available MCP tools and their permission and data boundaries.
4. For each item, state adopt, adapt, or ignore, with applicability and conflicts.
5. Write the conclusions to the asset inventory section of `.agent/research.md`.

## Counterexamples

- Generating a skill with the same name as an existing skill without taking inventory first.
- Copying user-level rules or third-party skill content directly into the project.
- Adopting a plugin of unknown origin that is unmaintained or has overly broad permissions.
- Recording personal directories or internal addresses in documentation.

## Boundary

This capability performs the initial inventory before generation. Periodic health checks, rot detection, and consolidation after generation belong to `capability/agent-environment`.
