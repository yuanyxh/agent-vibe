---
id: adapter/codex
applies_when: { agent.platform: codex }
---

# Codex Adapter

## Placement

| Logical artifact | Target location |
| --- | --- |
| `skill/<name>` | `.agents/skills/<name>/SKILL.md` |
| `rule/always` | Inlined into `AGENTS.md`, ≤ 60 lines |
| `rule/path` | Subdirectory `AGENTS.md`; degrade to `.agent/rules/<name>.md` + index when the current version does not support hierarchical reading |
| `rule/skill` | `.agent/rules/<name>.md`, referenced by the skill body |
| `rule/read` | `.agent/rules/<name>.md`, contract index marks `degraded` |
| `contract` | `AGENTS.md` |
| `state/<name>` | `.agent/<name>.md` (`state/profile` is `.agent/profile.yaml`, `state/memory` is `.agent/memory/README.md`) |
| `project/root` | Project root directory |

## Skill Format

The `SKILL.md` header keeps only:

```yaml
---
name: <kebab-case>
description: When to trigger, including phrasings the user may use
---
```

The first paragraph of the body states the goal and completion conditions, followed by steps, artifacts, rule paths to read, and prohibitions. All seed metadata is stripped.

Skills are explicitly invoked via `$<name>` and can also be triggered by description. Keep the complete skill directory when installing into a project; copying only `SKILL.md` loses referenced resources.

## Loading Strategy

| Layer | Mechanism | Trigger |
| --- | --- | --- |
| L0 | Inlined in `AGENTS.md` | Every session |
| L1 | Subdirectory `AGENTS.md` | When entering that directory; degrade when unsupported |
| L2 | `.agents/skills/*/SKILL.md` body reads `.agent/rules/*.md` | When the skill is invoked |
| L3 | Contract index points to `.agent/` files | Explicitly read when a trigger is hit |

- When `.agents/skills/` is unavailable, fall back to `.agent/skills/` and mark `degraded` in the contract.
- Content without a native mechanism must state the read action explicitly and must not be described as "automatically loaded".
- `AGENTS.md` ≤ 200 lines, core inline ≤ 60 lines, a single on-demand rule ≤ 120 lines; wrap the core block with `<!-- core:start -->` and `<!-- core:end -->`.

## Asset Inventory

Read names and descriptions only, do not copy content, and do not record personal paths.

| Scope | Location |
| --- | --- |
| Project | `AGENTS.md`, `.agents/skills/`, `.agent/rules/`, project-level MCP configuration |
| User | `~/.agents/skills/`, `~/.codex/config.toml` |
| Plugins and tools | Skill packs and MCP services listed by the platform |

On conflict, project rules and the user's current statement prevail; third-party content is not adopted by default.

## Limitations

Skill directories, hierarchical `AGENTS.md`, and MCP configuration locations may differ across versions. Verify the current version before generation; when it cannot be confirmed, write via the degraded path and annotate it, and do not assume automatic loading.
