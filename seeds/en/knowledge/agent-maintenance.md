---
id: knowledge/agent-maintenance
kind: knowledge
summary: Agent environment rot patterns, evidence, false positives, and verification
applies_when: { project.type: any }
triggers: [agent health check, stale rules or skills, memory conflict, prompt drift, repeated corrections, periodic maintenance]
sources: [Agent maintenance practice and review conclusions]
version: 1
updated: 2026-11-07
review_by: 2027-02-07
status: active
load: on-demand
---

# Agent Maintenance

## Problem

An agent environment rots without breaking the build: rules contradict, skills stop triggering, memory drifts from code, prompts describe an old project, hooks fail silently, and unused assets consume context. None of these fail a test, but they make the agent less reliable over time.

## Rot Patterns

| Pattern | Evidence | Risk |
| --- | --- | --- |
| Rule conflict | Two rules prescribe different behavior for the same situation | The agent chooses arbitrarily |
| Stale rule or skill | Expired review date, old version, superseded content | Wrong guidance survives |
| Duplicate asset | Two rules or skills cover the same trigger | Context waste and inconsistent behavior |
| Dead reference | A rule, skill, or contract points to a missing file or asset | The instruction cannot be followed |
| Budget overflow | Always-on content or skill descriptions exceed their budget | Later content is truncated or ignored |
| Silent hook failure | Hook exits without surfacing an error | Maintenance appears to run but does not |
| MCP failure | Server unavailable, auth expired, or permission too narrow | Tools disappear without explanation |
| Memory drift | Memory contradicts code, decisions, or the user's current correction | The agent repeats an outdated fact |
| Repeated correction | The same user correction or defect recurs | A missing rule, skill, or memory entry |
| Dead asset | A rule or skill is never referenced or invoked | Maintenance cost without value |
| Leakage | Secrets, personal paths, hostnames, or internal addresses in assets | Security and portability risk |

## Evidence

- File and line references, command output, and configuration fragments.
- Git history for repeated fixes, reverted decisions, and churn without a decision record.
- Status, decisions, lessons, backlog, and memory for unresolved or superseded conclusions.
- Session records when available for repeated prompts, ignored rules, and wrong skill selection.
- Deterministic checks for counts, duplicates, references, dates, and secret patterns.

## False Positives

- A skill may be invoked rarely but still critical; check trigger evidence before calling it dead.
- A rule may be loaded by a platform mechanism that text search cannot see.
- A memory entry may be intentionally historical; check its status and supersession.
- A hook may be registered outside the project; check the effective configuration.
- A duplicate may be a deliberate project override; check the precedence rule.

## Cadence

- Check after a defect fix, release, refactor, or user correction when new evidence exists.
- Check on a fixed cadence, weekly by default for active projects.
- Check before adding or removing a rule, skill, prompt, hook, or MCP server.
- Do not check more often than the throttle allows; noisy reminders get ignored.

## Verification

- Every finding has evidence, severity, and a recommended action.
- Applied changes have user confirmation and a rollback path.
- A removed asset is recoverable.
- A stale report produces exactly one reminder; a fresh report produces none.
- After a run, the report timestamp and pending state match the actual result.

## Counterexamples

- Deleting an unreferenced rule without checking platform-level loading.
- Treating a reminder as a completed check.
- Reporting business code rot as agent environment rot.
- Keeping every asset because deletion feels risky; archive instead.
