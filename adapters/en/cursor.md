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
| `state/plans` | `.agent/plans/<task-slug>.md` |
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
| Plugins and tools | Installed extensions, MCP services, and configured Automations |

On conflict, project rules and the user's current statement prevail; third-party content is not adopted by default.

## Automations and Scheduling

Mechanism classes, throttling, and degradation follow `protocols/en/maintenance.md`.

- Cursor Automations run agents on a schedule or on events such as a Slack message, Linear issue, GitHub pull request, PagerDuty incident, or custom webhook; they run in a cloud sandbox and can use MCP and a memory tool.
- There is no local lifecycle hook equivalent. Maintenance degrades to `advisory` contract rules plus explicit `steward` command invocation, or to a Cursor Automation when the project allows cloud execution.
- For isolated verification, prefer a Cursor Automation or a remote container; local process isolation remains the fallback.
- Do not claim automatic local triggering when only a cloud automation exists.

## Budget

- `AGENTS.md` ≤ 200 lines.
- `core.mdc` ≤ 60 lines.
- A single on-demand rule ≤ 120 lines.
- Do not set all rules to `alwaysApply: true`.

## Limitations

`globs` can only constrain file scope and cannot convey task phases; task-type rules are read by commands, and the mechanism is annotated in the contract.
