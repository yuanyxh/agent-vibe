---
name: steward
description: Triggers when the user says "agent check", "health check", "clean up rules or memory", "agent rot", "prompt/MCP/hook check", or "periodic maintenance", or when the health report is stale, the agent ignores rules, invokes the wrong skill, contradicts memory, or before adding or removing agent assets. Inspects the agent environment only, not business code.
id: seed/skill/steward
kind: skill
summary: Agent environment health check and consolidation
applies_when: { project.type: any }
requires: []
grow: on-init
emits: skill/steward
verify: Every finding has evidence and applied changes have confirmation
---

# Agent Environment Steward

## Goal

Find and reduce rot in the agent's own environment, without touching business code.

## Completion criteria

- Every finding has evidence, severity, and a recommended action.
- Applied changes have user confirmation and are reversible.
- The health report and backlog reflect the actual state.
- Business code architecture and dead code are handed to `learn` or `review`.

## Before executing

Read the contract and `.agent/agent-health.md`; if either is missing, state the gap and create only the report baseline. Read `.agent/profile.yaml` for cadence, stale threshold, and maintenance mode.

## Steps

1. **Snapshot**: platform, model, time, git branch and dirty state, report age, configured mode and cadence, available evidence sources.
2. **Inventory**: list, do not copy, prompts and contract, rules, skills, memory, hooks and automations, MCP servers, subagents, commands, plugins, and environment records.
3. **Deterministic checks**: run the checks below and record command output.
4. **Evidence review**: inspect git history, status, decisions, lessons, memory, and session records when available for repeated fixes, repeated corrections, ignored rules, and wrong skill selection.
5. **Triage**: assign severity `blocker`, `high`, `medium`, `low`; confidence `high`, `medium`, `low`; action `keep`, `merge`, `split`, `deprecate`, `move-to-trash`, `add`.
6. **Confirm and apply**: present findings; apply only with user confirmation. Move removed assets to trash or an archive. Never edit business code or commit.
7. **Record**: append a timestamped section to `.agent/agent-health.md`; add deferred work to `.agent/backlog.md`; add confirmed decisions to `.agent/decisions.md`; update `last_run` and `pending` in `.agent/.maintenance-state`.
8. **Recommend cadence**: state the current mode, whether it works, and the next check date. Generate hook, scheduler, or automation configuration only after confirmation.

## Deterministic checks

| Check | Evidence |
| --- | --- |
| Contract and core budget | Line counts against the configured limits |
| Duplicate or conflicting IDs | Repeated rule, skill, or memory identifiers |
| Broken references | Rule, skill, contract, and resource paths that do not resolve |
| Expired assets | `review_by` earlier than today; old versions |
| Memory index | Index line count, duplicate facts, entries without sources |
| Leakage | Secret, credential, personal-path, hostname, and internal-address patterns |
| Hook health | Hook files exist, are executable, and are registered |
| MCP health | Servers declared, credentials referenced without values, unused servers |
| Skill trigger risk | Description length, overlapping triggers, names absent from the index |
| Stale environment | Environment record older than the last toolchain change |

## Severity

- `blocker`: agent cannot follow the contract or a critical asset is broken.
- `high`: rules conflict, secrets leak, or a required hook or MCP server is dead.
- `medium`: stale or duplicate assets that waste context or cause wrong choices.
- `low`: cosmetic, naming, or documentation drift.

## Prohibited

- Reporting business code rot as agent environment rot.
- Editing rules, skills, memory, prompts, or MCP configuration without confirmation.
- Deleting assets in place instead of moving them to trash or an archive.
- Treating a reminder as a completed check.
- Committing changes.
