---
id: adapter/cursor
applies_when: { agent.platform: cursor }
---

# Cursor Adapter

## Placement

| Logical artifact | Target location |
| --- | --- |
| `rule/always` | `.cursor/rules/core.mdc`, `alwaysApply: true`, ≤ 60 lines |
| `rule/path` | `.cursor/rules/<name>.mdc`, `alwaysApply: false` + `globs` |
| `rule/skill` | `.agent/rules/<name>.md`, referenced by the corresponding command body |
| `rule/read` | `.agent/rules/<name>.md`, contract index marks `degraded` |
| `skill/<name>` | `.cursor/commands/<name>.md` |
| `contract` | `AGENTS.md` |
| `state/<name>` | `.agent/<name>.md` (`state/profile` is `.agent/profile.yaml`, `state/memory` is `.agent/memory/README.md`) |
| `project/root` | Project root directory |

## Rule File Header

```yaml
---
description: <when to load>
globs: <relevant file scope, optional>
alwaysApply: <true only for core>
---
```

Map from the seed header: `load_via=path` → `alwaysApply: false` + `globs`; `load_via=skill` or `read` → do not generate `.mdc`; read via the command or the contract index. Only core uses `alwaysApply: true`, merged into a single file.

`description` states trigger conditions, `globs` states file scope; at least one of the two must be present, otherwise it is treated as always-on and must not be used for non-core. Seed metadata itself is not written into target files. Do not generate rules whose `status` is not active or whose `review_by` has expired. Wrap the core inline block in `AGENTS.md` with `<!-- core:start -->` and `<!-- core:end -->`, with ≤ 60 lines inside.

## Skill Handling

Cursor has no native mechanism equivalent to Skill. Write skill bodies to `.cursor/commands/<name>.md`, state in the first paragraph of the body the `.agent/rules/*.md` to read before execution, and list trigger conditions in `AGENTS.md`. When the command mechanism is unavailable, mark `degraded` in the contract.

## Asset Inventory

Read names and descriptions only, do not copy content, and do not record personal paths.

| Scope | Location |
| --- | --- |
| Project | `.cursor/rules/`, `.cursor/commands/`, `.cursor/mcp.json`, `AGENTS.md` |
| User | User-level rules and commands |
| Plugins and tools | Installed extensions and MCP services |

On conflict, project rules and the user's current statement prevail; third-party content is not adopted by default.

## Budget

- `AGENTS.md` ≤ 200 lines.
- `core.mdc` ≤ 60 lines.
- A single on-demand rule ≤ 120 lines.
- Do not set all rules to `alwaysApply: true`.

## Limitations

`globs` can only constrain file scope and cannot convey task phases; task-type rules are read by commands, and the mechanism is annotated in the contract.
