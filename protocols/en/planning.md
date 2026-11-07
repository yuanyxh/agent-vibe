# Planning Protocol

Context is finite and lossy. The plan, agreements, and pending work must live in files; the conversation is only the channel that writes them.

## File Boundaries

| File | Responsibility | Excludes |
| --- | --- | --- |
| `.agent/status.md` | Current goal, progress summary, blockers | Step detail and drift history |
| `.agent/plans/<task-slug>.md` | Current task goal, steps, agreements, drift, handoff | Unrelated future work |
| `.agent/backlog.md` | Unplanned or deferred items, priority, source | Current task steps |
| `.agent/decisions.md` | Durable decisions and rollback | Step status |
| `.agent/memory/` | Long-term facts and user preferences | Task plans |

One fact, one home. Reference by path or ID; never maintain two copies.

## When a Plan Is Required

- The task has multiple dependent steps.
- The work spans sessions or may be interrupted.
- The user confirmed a plan, scope, or constraint.
- The context window is near its limit or work is handed to another agent.
- The task changes an agreed acceptance criterion.

A single reversible step may skip the plan file, but the reason is recorded in `status.md`. Skipping the plan is never allowed when the user has confirmed one.

## Write Timing

1. **Before work**: copy `.agent/plans/_template.md` to `.agent/plans/<task-slug>.md`, then fill the goal, non-goals, acceptance, agreements, and ordered steps. Each step names its dependency and evidence. `_template.md` is never treated as an active plan.
2. **After each step**: set the step status and attach evidence (command, file, or test). Never mark done without evidence.
3. **On deviation**: append a drift entry instead of editing history. Scope and acceptance changes require user confirmation before continuing.
4. **On interruption**: fill the handoff section with the last completed step and the exact next action.
5. **On completion**: reconcile every step; move unfinished items to the backlog; mark the plan `done` or `abandoned`; update `status.md`.

## Drift Types

| Type | Signal | Response |
| --- | --- | --- |
| Scope | New requirement, out-of-scope work, or a dropped requirement | Stop, confirm with the user, update non-goals and steps |
| Order | A dependency or blocker invalidates the sequence | Record the change, reorder, state the impact |
| Acceptance | The agreed criterion is no longer testable or valid | Confirm the replacement with the user before continuing |
| Context | Resuming from a summary or a new session | Read status, plan, and drift log; reconstruct from code and tests, do not guess |

A drift entry records date, type, change, reason, affected steps, and decision. Silent drift is the failure this protocol exists to prevent.

## Recovery Order

1. Startup contract.
2. Current goal and plan link in `status.md`.
3. The linked plan, including steps and drift log.
4. `backlog.md` when selecting the next task.
5. Decisions and lessons only when the task needs history.
6. Code, tests, and logs as evidence.

The plan is intent, not proof. When it conflicts with current code, tests, or the user's current correction, the current facts and correction prevail; then correct the plan.

## Capacity and Archiving

- A plan is at most 120 lines and 15 steps; split larger work into separate tasks.
- A backlog holds at most 100 open rows; move done and dropped rows to the archive section.
- A plan without updates for 14 days is marked `paused`; confirm with the user before resuming.
- Completed plans remain as history; do not delete them and do not reuse their task slugs.

## Boundaries

- The plan never overrides the user's current correction.
- Architectural decisions belong in `decisions.md`; the plan references them.
- Step evidence belongs in the plan or the delivery summary; do not duplicate it in status.
- The backlog is not a wish list: every item needs a source and a priority.

## Prohibited

- Keeping a multi-step plan only in conversation.
- Silently changing scope, order, or acceptance criteria.
- Marking a step complete without evidence.
- Maintaining the same item in multiple files.
- Carrying completed steps as open work.
- Using the plan to justify ignoring newer facts.
