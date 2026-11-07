---
id: capability/agent-environment
kind: capability
summary: Inspect and maintain the agent environment itself, without auditing business code
triggers:
  - The health report is stale or the user asks for an agent check
  - The agent ignores rules, invokes the wrong skill, or contradicts memory
  - Before adding, removing, or restructuring prompts, rules, skills, hooks, MCP, or subagents
  - A defect repeats or the user corrects the same behavior more than once
questions:
  - Which agent assets exist at project, user, and plugin scope
  - Which evidence sources are available (git history, memory, session records, hook and MCP configuration)
  - How often to check and whether automatic reminders are allowed
  - What may be changed automatically versus only proposed
research:
  - Current platform locations and formats for prompts, rules, skills, hooks, MCP, subagents, and commands
  - Current skill-listing and context budgets that affect triggering
  - Available static checks for broken references, duplicate IDs, expired reviews, and secret leakage
generates:
  - type: doc
    examples: [agent environment health report, asset inventory, rot findings, recommended actions]
  - type: config
    examples: [maintenance schedule or hook configuration, review dates, asset index updates]
  - type: test
    examples: [stale-report reminder check, broken-reference check]
verify:
  - Every finding has evidence and a severity
  - Applied changes have user confirmation and are reversible
  - Business code rot is not reported as agent environment rot
---

# Agent Environment Capability

## Goal

Keep the agent's own environment trustworthy: prompts, rules, skills, memory, hooks, MCP servers, subagents, commands, plugins, and the tools they depend on.

## Scope

| Asset | What to inspect |
| --- | --- |
| Platform and model | Platform, model, context window, permissions, sandbox, session storage |
| Prompts and contract | Contract, always-on block, unresolved placeholders, contradictory instructions, stale project description |
| Rules | Layering, scope, duplicates, conflicts, expiry, unreferenced rules, budget overflow |
| Skills | Trigger descriptions, overlap, duplicate names, missing resources, unused skills, reference validity |
| Memory | Index size, duplicate or contradictory entries, missing sources, stale scope, archive integrity |
| Hooks and automations | Configured hooks, dead or failing hooks, silent failures, duplicate schedules, timeouts |
| MCP | Server availability, tool overlap, expired auth, permission scope, secret leakage, unused servers |
| Subagents, commands, plugins | Duplicates, orphaned entries, broken references, provenance, license, maintenance status |
| Environment | Runtime and toolchain drift, missing probes, stale environment record |
| Evidence | Git history, status, decisions, lessons, memory, session records, configuration files |

## Corruption Signals

| Signal | Example |
| --- | --- |
| Contradiction | Two rules prescribe different behavior for the same situation |
| Staleness | `review_by` expired, version old, project description no longer true |
| Duplication | Two skills cover the same trigger; two memory entries state the same fact |
| Dead reference | Rule points to a missing skill or file; skill resource is absent |
| Budget overflow | Always-on contract over budget; skill listing truncates descriptions |
| Silent failure | Hook or MCP server fails without surfacing an error |
| Memory conflict | Memory contradicts code, decisions, or the user's current correction |
| Repeated correction | The same user correction or defect recurs without a new lesson or rule |
| Dead asset | A rule or skill is never referenced, never invoked, or fully superseded |
| Leakage | Secrets, personal paths, hostnames, or internal addresses in agent assets |

## Evidence Sources

- Git log and diff: repeated fixes, reverted decisions, churn without a decision record.
- `.agent/status.md`, `decisions.md`, `lessons.md`, `backlog.md`, and `memory/`: conclusions, supersessions, unresolved items.
- Session records when the platform exposes them: repeated prompts, ignored instructions, wrong skill selection.
- Hook, MCP, and platform configuration: registration, permissions, timeouts, last error.
- Deterministic checks: line counts, duplicate IDs, broken links, expired dates, secret patterns.

## Output

Write `.agent/agent-health.md` with a timestamped section:

- Scope checked and skipped items with reasons.
- Findings ordered by severity: blocker, high, medium, low.
- Each finding: evidence, impact, recommendation, and confidence.
- Recommended action: keep, merge, split, deprecate, move to trash, or add.
- Applied changes with user confirmation; otherwise an explicit pending list.

Put deferred work in `.agent/backlog.md`; put confirmed decisions in `.agent/decisions.md`.

## Apply Policy

- Propose first; apply only after user confirmation.
- Move deleted assets to trash or an archive; never delete in place.
- Never edit business code from this capability.
- Never auto-commit.
- When the user corrects a memory or rule, the current statement wins; mark the old entry superseded.

## Boundary

- This capability does not audit business code architecture, anti-patterns, or dead code; use `learn` or `review` for that.
- Initial asset inventory before generation belongs to `capability/agent-assets`; this capability is the periodic health check after generation.
- Development tool probing belongs to `capability/environment`; this capability checks whether the agent's own environment and assets are consistent.

## Counterexamples

- Reporting a skill as unused without checking trigger evidence.
- Treating a stale memory as fact after the user corrected it.
- Deleting a rule because it was not referenced, without checking platform-level loading.
- Auditing business modules and calling the result agent environment rot.
