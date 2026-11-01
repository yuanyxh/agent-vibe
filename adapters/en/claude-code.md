---
id: adapter/claude-code
applies_when: { agent.platform: claude-code }
---

# Claude Code Adapter

## Placement

| Logical artifact | Target location |
| --- | --- |
| `skill/<name>` | `.claude/skills/<name>/SKILL.md` |
| `rule/always` | Inlined into `CLAUDE.md`, not a separate file |
| `rule/path` | `.claude/rules/<name>.md`, header contains only `paths` |
| `rule/skill` | `.agent/rules/<name>.md`, referenced by the corresponding skill body |
| `rule/read` | `.agent/rules/<name>.md`, contract index marks degraded |
| `contract` | `CLAUDE.md` |
| `state/<name>` | `.agent/<name>.md` (`state/profile` is `.agent/profile.yaml`, `state/memory` is `.agent/memory/README.md`) |
| `project/root` | Project root directory |
| Permissions and hooks | `.claude/settings.json` |

## Skill Format

`SKILL.md` uses the following header:

```yaml
---
name: <kebab-case>
description: When to trigger, including phrasings the user may use
---
```

The first paragraph of the body states the goal and completion conditions, followed by steps, artifacts, and prohibitions. Other files referenced within a skill use relative paths, with loading timing stated.

Seed header fields `id`, `kind`, `version`, `updated`, `review_by`, `status`, `load`, `load_via`, `path_scope`, `skills`, `trigger`, `summary`, `applies_when`, `requires`, `grow`, `emits`, and `verify` are used only for matching during growing and **must not be written into target files**. Target `SKILL.md` keeps only `name` and `description`; path rules keep only the platform field `paths`, and other rules write only the body.

## Rule Format

- `rule/always`: merged and inlined into `CLAUDE.md`, each compressed into a one-line summary (number + behavior + prohibition), total lines ≤ 60; the full body does not enter the project.
- `rule/path`: write to `.claude/rules/<name>.md`; the YAML header allows only `paths`, with a glob list as the value.
- `rule/skill`: write to `.agent/rules/<name>.md`, required to be read before execution by the skill body.
- `rule/read`: write to `.agent/rules/<name>.md`, mark `degraded` in the contract index.

**Files in `.claude/rules/` without `paths` are loaded in every session.** Therefore, apart from core, do not generate unscoped rules; core is already inlined, so do not generate `core.md`.

## Bootstrap Contract

`CLAUDE.md` must contain:

1. A one-sentence project description, form, technology stack, and quality budget.
2. Loading strategy: content, layer, trigger conditions, actual mechanism.
3. Skill index: names and trigger conditions.
4. Work loop and verification commands.
5. Runtime conventions: self-check, facts first, authorization boundaries, output, files, tools, memory, platform neutrality.
6. Self-learning locations and breakpoint rules.

The contract writes only the index and summaries, not copying rule bodies, profiles, status, decisions, or skill bodies. Wrap the core inline block with `<!-- core:start -->` and `<!-- core:end -->`, with ≤ 60 lines inside.

## Asset Inventory

Read names and descriptions only, do not copy content, and do not record personal paths.

| Scope | Location |
| --- | --- |
| Project | `.claude/skills/`, `.claude/rules/`, `.claude/agents/`, `.claude/commands/`, `.claude/settings.json`, `CLAUDE.md` |
| User | `~/.claude/skills/`, `~/.claude/agents/`, `~/.claude/CLAUDE.md` |
| Plugins and tools | Installed plugins, MCP service list |

On conflict, project rules and the user's current statement prevail; third-party content is not adopted by default.

## Loading Strategy

| Layer | Mechanism | Trigger |
| --- | --- | --- |
| L0 | `CLAUDE.md` | Every session |
| L1 | `paths` of `.claude/rules/*.md` | Automatically loaded when matching files are operated on |
| L2 | `.claude/skills/*/SKILL.md` body reads `.agent/rules/*.md` | When the skill is invoked |
| L3 | Contract index points to `.agent/` files | Explicitly read when a trigger is hit |

- Do not use `@import` to pull in on-demand rules; imported content and the referencing file load simultaneously.
- Keep the always-on total within 200 lines; when exceeded, move low-frequency content down to L1 to L3.
- Skill `description` states only trigger conditions; the body states steps and the rule paths to read.
- After generation, use `/context` to check Memory files, and the `InstructionsLoaded` hook to check lazy-loading reasons.
- Do not generate rules whose `status` is not `active`; if `review_by` has expired, review first per `protocols/en/evolve.md`.
