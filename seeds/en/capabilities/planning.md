---
id: capability/planning
kind: capability
summary: Keep tasks, agreements, and plans in files so work survives context loss and plan drift
triggers:
  - A task spans multiple steps or sessions
  - The user confirms a plan, scope, or constraint
  - Context is near its limit or the task is handed off
  - Work deviates from the agreed plan
questions:
  - Whether the project needs a cross-task backlog or only per-task plans
  - Plan granularity and who confirms scope changes
  - Retention and archiving rules for completed plans
research:
  - Whether the current environment offers a native plan or task mechanism
  - Existing status, decision, and memory files and their boundaries
generates:
  - type: protocol
    examples: [plan lifecycle, write timing, drift detection, recovery order, archiving]
  - type: doc
    examples: [task plan template, backlog template]
  - type: config
    examples: [plan directory, backlog file]
verify:
  - A new session can resume the task from status and the plan alone
  - Every plan step has a status and evidence
  - Plan changes record their reason and impact
  - Open items live in the backlog, not only in conversation
---

# Planning

## Goal

Make the task plan, user agreements, and pending work durable enough to survive context limits, session restarts, and model handoffs, and make plan drift visible instead of silent.

## Files and responsibilities

| File | Owns | Must not contain |
| --- | --- | --- |
| `.agent/status.md` | Current goal, progress summary, blockers | Step-by-step detail |
| `.agent/plans/<task-slug>.md` | Current task plan, steps, agreements, drift | Unrelated future work |
| `.agent/backlog.md` | Unplanned or deferred items and priority | Current step detail |
| `.agent/decisions.md` | Durable decisions and rollback | Step status |
| `.agent/memory/` | Long-term facts and preferences | Task plans |

One fact has one home; other files reference it by path or ID instead of copying.

## Plan lifecycle

1. Before work: write the goal, non-goals, acceptance criteria, confirmed agreements, and ordered steps.
2. During work: update step status and evidence after each step.
3. On deviation: append a drift entry with type, reason, impact, and decision.
4. On interruption: fill the handoff section with current position and next action.
5. On completion: reconcile every step, move leftovers to the backlog, and mark the plan done or abandoned.

A plan that exists only in conversation is invalid, because the next session cannot recover it.

## Recovery order

1. Startup contract.
2. Current goal and plan link in `.agent/status.md`.
3. The linked plan, including its drift log.
4. `.agent/backlog.md` when choosing the next task.
5. Decisions and lessons only when the task needs history.
6. Code, tests, and logs as evidence.

The plan is intent; code and tests remain the evidence. When memory or plan conflicts with current facts or the user's current correction, the current facts and correction prevail.

For lifecycle details, write timing, drift handling, and capacity limits, see `protocols/en/planning.md`.

## Prohibited

- Keeping a multi-step plan only in the conversation.
- Changing the agreed scope or acceptance criteria without recording it and confirming it with the user.
- Marking a step complete without evidence.
- Maintaining the same to-do in both status and backlog.
