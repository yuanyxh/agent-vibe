---
id: adapter/generic
applies_when: { agent.platform: generic }
---

# Generic Agent Adapter

Applies to agents that support the `AGENTS.md` convention.

## Placement

| Logical artifact | Target location |
| --- | --- |
| `rule/always` | Inlined in `AGENTS.md`, ≤ 60 lines |
| `rule/path` | Subdirectory `AGENTS.md` (when the platform supports hierarchical reading); otherwise `.agent/rules/<name>.md` + index |
| `rule/skill` | `.agent/rules/<name>.md`, referenced by the skill body |
| `rule/read` | `.agent/rules/<name>.md`, contract index marks `degraded` |
| `skill/<name>` | `.agent/skills/<name>/SKILL.md` |
| `contract` | `AGENTS.md` |
| `state/<name>` | `.agent/<name>.md` (`state/profile` is `.agent/profile.yaml`, `state/memory` is `.agent/memory/README.md`) |
| `project/root` | Project root directory |

## Loading Strategy

| Layer | Mechanism | Trigger |
| --- | --- | --- |
| L0 | Inlined in `AGENTS.md` | Every session |
| L1 | Subdirectory `AGENTS.md` | When entering that directory |
| L2 | `.agent/skills/*/SKILL.md` body reads `.agent/rules/*.md` | When the skill is invoked |
| L3 | Contract index points to `.agent/` files | Explicitly read when a trigger is hit |

- When the platform supports hierarchical `AGENTS.md`, use L1; when it does not, L1 degrades to index + read, and this is marked in the contract.
- Content without a native mechanism must not be described as "automatically loaded"; the read action must be stated explicitly.
- `AGENTS.md` ≤ 200 lines, core inline ≤ 60 lines, a single on-demand rule ≤ 120 lines.
- Seed metadata is not written into target rule files. Do not generate rules whose `status` is not active or whose `review_by` has expired.

## Asset Inventory

Read names and descriptions only, do not copy content, and do not record personal paths.

| Scope | Location |
| --- | --- |
| Project | `AGENTS.md`, `.agent/skills/`, `.agent/rules/`, platform MCP configuration |
| User | User-level skills and rules |
| Plugins and tools | Skill packs and MCP tools listed by the platform |

On conflict, project rules and the user's current statement prevail; third-party content is not adopted by default.

## Contract Requirements

The top of `AGENTS.md` states the one-sentence project description, form, and technology stack, followed by:

1. Index of rule files and loading timing.
2. Index of skill directories and trigger conditions.
3. Work loop and verification commands.
4. Runtime conventions: self-check, facts first, authorization boundaries, output, files, tools, memory, platform neutrality.
5. Breakpoint rules.
6. Self-learning file locations.

If the agent supports automatic skill discovery by directory, `.agent/skills/` takes effect directly; otherwise list the path of each skill in the contract and require on-demand reading. Wrap the core inline block with `<!-- core:start -->` and `<!-- core:end -->`, with ≤ 60 lines inside.

## Limitations

Different agents have different context injection mechanisms; rule files must be self-contained and must not assume automatic loading.
