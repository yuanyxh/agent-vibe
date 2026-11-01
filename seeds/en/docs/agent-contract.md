---
id: seed/doc/agent-contract
kind: doc
summary: Project bootstrap contract generated for the agent
applies_when: { project.type: any }
requires: [project.name, project.type, agent.platform]
grow: on-init
emits: contract
verify: Loading strategy, skill index, work loop, and breakpoint rules are all present, and the always-on content stays within budget
---

# {{project.name}}

{{project.one_liner}}

Form: {{project.type}}  Stack: {{stack.language}} / {{stack.framework}}  Quality budget: {{quality.perf_budget}}

## Before Starting Any Task

1. If `.agent/profile.yaml` is missing, load `init` first to complete the project profile and completeness check; do not choose a stack or write code directly.
2. Read the current goal and blockers in `.agent/status.md` once; do not traverse `.agent/`.
3. Use the loading strategy below to fetch only the content matched by this task; do not read unmatched content.
4. Before making technology choices, upgrading, adding new dependencies, or adding skills/rules, read the corresponding conclusions and sources in `.agent/research.md`.

## Always-On Constraints

{{core_rules}}

## Runtime Conventions

1. **Phase self-check**: Do not repeat a completed phase; on failure, diagnose first, then retry.
2. **Facts first**: Code, tests, logs, and official materials outrank memory and guesses; every plan must be verifiable.
3. **Authorization boundary**: Obtain user confirmation before committing, pushing, releasing, deleting, incurring costs, or sending data externally.
4. **Output**: Lead with the conclusion, be concise, and do not repeat completed content.
5. **Files**: Use absolute paths; read the needed range in one pass; check the current state before editing; make deletions recoverable.
6. **Tools**: Prefer the dedicated tools provided by the environment; when missing, use equivalent means and record the degradation.
7. **Memory**: Write key decisions into project status; memory must not override the user's current corrections.
8. **Comments**: Write only necessary information; no one-off comments or long explanations.
9. **Language and time zone**: Follow the user's settings; do not switch on your own.
10. **Platform neutrality**: Do not treat the current Agent platform as the only implementation; leave differences to adapters.

## Loading Strategy

| Content | Layer | Trigger | Mechanism |
| --- | --- | --- | --- |
| This contract and always-on constraints | L0 | Every session | Automatically loaded by the platform |
{{loading_table}}
| `.agent/domains/` | L3 | Concern involves that domain | Read on demand |
| `.agent/knowledge/` | L3 | Matches an index topic | 1–3 packs per session |
| `.agent/decisions.md`, `lessons.md` | L3 | Need historical basis or retrospective | Read on demand |
| `.agent/environment.md` | L3 | Install or build failure, or environment change | Read on demand |
| `.agent/research.md` | L3 | Technology choice, upgrade, or new dependency | Read on demand |
| `.agent/memory/` | L3 | Need cross-session conclusions | Read on demand |

Do not copy rule, profile, status, or skill body text into this file. Always-on total ≤ 200 lines.

## Skill Index

| Skill | Trigger |
| --- | --- |
| `init` | Missing profile, new project from scratch, or initialization |
| `build` | Implement requirements, continue development |
| `review` | Review changes, pre-merge check |
| `hunt` | Error, crash, regression |
| `learn` | Capture experience, retrospective |
| `upgrade` | Dependency and runtime upgrade |
| `ship` | Release, go live, deploy |
| `operate` | Monitoring, alerting, user feedback |
| `delegate` | Delegate to sub-agents or parallel workers |

## Work Loop

Implement → self-test → review → update status → release → observe.

## Commit Convention

- One commit does one thing; message format `type(scope): summary`, with type limited to feat / fix / refactor / test / docs / chore / perf / build.
- Commits, pushes, merges, and history rewrites all require explicit user authorization; without authorization, provide only suggestions and commands.
- Do not commit generated artifacts, dependency directories, local configuration, credentials, or verification data.

## Engineering Quality Gates

| Check | Command |
| --- | --- |
| Format | `{{verify.format}}` |
| Static analysis | `{{verify.lint}}` |
| Type check | `{{verify.typecheck}}` |
| Test | `{{verify.test}}` |

Local hooks and CI run the same set of commands.

## Collaboration

- Branch strategy: `{{delivery.branch_strategy}}`.
- Key modules have designated reviewers; update documentation before changing interfaces or data models.
- Write user-facing changes to the changelog, and attach migration notes to breaking changes.

## Self-Learning

Write project lessons to `.agent/lessons.md`. Patterns reusable across projects enter the seed library only after user confirmation.

## Breakpoint Rules

Pause and wait for the user in only four cases: irreversible operations, cost incurrence, privacy or compliance involvement, and conflicts between goals. Otherwise proceed with defaults and record them in the decision log.

## Verification Commands

| Purpose | Command |
| --- | --- |
| Install | `{{verify.install}}` |
| Build | `{{verify.build}}` |
| Format check | `{{verify.format}}` |
| Static analysis | `{{verify.lint}}` |
| Type check | `{{verify.typecheck}}` |
| Test | `{{verify.test}}` |
| Run | `{{verify.run}}` |
