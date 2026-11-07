# Loading Protocol

Rules and persistent content are not injected in full by directory; they are layered by "whether every task needs it" and mapped to real mechanisms of the target platform.

## Four Layers

| Layer | Content | Enters context | Budget |
| --- | --- | --- | --- |
| L0 always-on | Non-violable bottom lines, loading index, verification commands | Every session | Contract ≤ 200 lines, core ≤ 60 lines |
| L1 path | Rules relevant only to certain files or directories | When matching files are touched | Per file ≤ 120 lines |
| L2 task | Rules needed only when certain kinds of work occur | When the corresponding skill is invoked | Per file ≤ 120 lines |
| L3 reference | Domains, knowledge, decisions, lessons, environment, memory | Read when explicitly needed | ≤ 3 files per time |

Budget takes precedence over rule completeness. When over budget, move low-frequency content down to the next layer instead of compressing it into a longer always-on file.

## Rule Seed Fields

```yaml
load: always | on-demand
load_via: path | skill | read   # required for on-demand
path_scope: source | ui | server | tests | config | domain
skills: [build, review]         # required when load_via=skill
```

- `always`: only core bottom lines are allowed. At generation time, each is compressed into a one-line summary (number + behavior + prohibition) inlined into the bootstrap contract; no separate unscoped rule file is generated, and the full text remains in the seed layer.
- `path`: at generation time, mapped to actual globs by `path_scope` and written into a platform-recognized prefix.
- `skill`: the rule file is placed at the logical location and required to be read before execution by the body of the corresponding skill.
- `read`: explicit degradation when the platform has no native mechanism; the trigger and path must be stated in the contract index and marked `degraded`.

## Path Scopes

`path_scope` is resolved to actual globs at generation time according to the project skeleton and is not hard-coded in seeds.

| `path_scope` | Resolution target |
| --- | --- |
| `source` | Source directories, such as `src/**`, `apps/*/src/**`, `packages/*/src/**` |
| `ui` | Page, component, and style directories |
| `server` | Server, API, and data access directories |
| `tests` | Test files and test configuration |
| `config` | Build, formatting, static check, and pipeline configuration |
| `domain` | Core module directories specified by domain definitions |

An empty resolution means the rule does not apply to this project; skip it and record the reason. Do not leave unscoped L1 rules.

## Platform Matrix

| Platform | L0 | L1 | L2 | L3 |
| --- | --- | --- | --- | --- |
| Claude Code | Inlined in `CLAUDE.md` | `.claude/rules/*.md` + `paths` | `.agent/rules/*.md`, read by skills | Index + read on demand |
| Cursor | `.cursor/rules/core.mdc`, `alwaysApply: true` | `.mdc` + `globs` | `.cursor/commands/<skill>.md` references rules | Index + read on demand |
| Codex | Inlined in `AGENTS.md` | Subdirectory `AGENTS.md`; degrade when unsupported | `.agents/skills/*/SKILL.md`, invoked via `$<name>`; fall back to `.agent/skills/` and mark degraded when the directory is unavailable | Index + read on demand |
| Generic | Inlined in `AGENTS.md` | Degrade when no native mechanism | Index + read | Index + read |

When a platform has no native mechanism, do not claim "on-demand loading"; the degradation method must be marked in the contract.

## Persistent Content

By default, none enters always-on, except the following:

| Content | Layer | Read timing |
| --- | --- | --- |
| Profile summary (name, form, technology stack, quality budget) | L0 | Inlined into the contract |
| `.agent/status.md` | L3 | Read once at the start of each task; read the current goal, plan link, and blockers |
| `.agent/plans/<task-slug>.md` | L3 | When status links a plan; read that plan when resuming |
| `.agent/backlog.md` | L3 | When selecting the next task or reporting pending work |
| `.agent/upgrades.md` | L3 | Dependency upgrade, security advisory, or release |
| `.agent/decisions.md`, `lessons.md` | L3 | When historical rationale or retrospective is needed |
| `.agent/environment.md` | L3 | On installation or build failure, or when changing environments |
| `.agent/agent-health.md` | L3 | Maintenance is due, agent behavior conflicts with assets, or an asset change is planned |
| `.agent/sandbox.md` | L3 | Before integration or end-to-end verification, or when tests may touch shared or production systems |
| `.agent/domains/*.md` | L3 | When the domain's concerns are involved |
| `.agent/knowledge/*.md` | L3 | When matched by the index; 1 to 3 per time |
| `.agent/memory/` | L3 | When cross-session conclusions are needed |

The full profile, decisions, and lessons must not be copied into the contract.

Maintenance triggers, modes, and mechanism classes are defined in `protocols/en/maintenance.md`; adapters map them to real platform features.

## Generation Requirements

1. Generate the loading checklist first: which layer each item belongs to, its trigger condition, and its target mechanism.
2. Write only L0 into always-on files; wrap the core inline block with `<!-- core:start -->` and `<!-- core:end -->`, with ≤ 60 lines inside; L2 rules are referenced by skill bodies, not copied.
3. L1 must have an executable matching scope; an empty scope is treated as L0 or L3 and must not remain in L1.
4. All `skills` of L2 must exist; if one is missing, do not generate that rule and record the reason.
5. The index in the contract records only paths, triggers, and mechanisms, not rule bodies.
6. After generation, check the actual loading result: in Claude Code, use `/context` to inspect Memory files; on other platforms, check according to their mechanisms.

## Prohibited

- Rule files without `paths` entering `.claude/rules/` other than core.
- Using `@import` to pull in on-demand rules; imported and referencing files load simultaneously.
- Copying skill bodies into the contract or rule files.
- Traversing and reading `.agent/` at startup.
- Pretending that an "index" is native on-demand loading when the platform does not support it, without marking degradation.

## Verification

- The line counts of the always-on file and the core are within budget.
- Every on-demand item can point to its actual loading mechanism and trigger condition.
- The startup read set contains only the contract and status files.
- After deleting any on-demand file, an explicit gap appears under the corresponding trigger condition rather than a silent failure.
