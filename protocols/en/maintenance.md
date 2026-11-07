# Maintenance Protocol

Keep the agent environment healthy and make learning happen without relying on the user remembering to ask.

## Triggers

| Trigger | Condition |
| --- | --- |
| Stale report | `.agent/agent-health.md` is older than `agent.maintenance_stale_days` |
| Change event | A defect fix, release, refactor, or user correction produced new evidence |
| Behavior conflict | The agent ignores rules, invokes the wrong skill, or contradicts memory |
| Asset change | Before adding, removing, or restructuring a rule, skill, prompt, hook, or MCP server |
| Schedule | The configured cadence is reached |
| User request | The user asks for a check, retrospective, or cleanup |

## Mechanism Classes

| Class | Behavior | Degrades to |
| --- | --- | --- |
| `native-hook` | The platform fires a lifecycle event and can inject a reminder or receive a decision | `session-scheduler` |
| `session-scheduler` | The platform can run a prompt on a timer while a session is active | `cloud-automation` |
| `cloud-automation` | A remote agent runs on a schedule or external event | `os-ci-scheduler` |
| `os-ci-scheduler` | An operating-system scheduler or CI job invokes the agent | `advisory` |
| `advisory` | The contract states the trigger, and the agent checks explicitly | none |

## Modes

- `advisory`: contract rule only. Lowest reliability, no platform configuration.
- `hook`: platform lifecycle hook injects a short reminder. Default when the platform supports it.
- `scheduled`: platform automation, operating-system cron, or CI schedule. Use for cadence; do not rely on it for same-session capture.

A project may combine `hook` and `scheduled`. When the platform has no hook, degrade to `advisory` and mark the degradation in the contract.

## State and Throttle

Use `.agent/.maintenance-state` as the only state file:

```text
last_run: <ISO-8601>
last_reminder: <ISO-8601>
pending: learn | steward | sandbox
```

- `agent.maintenance_stale_days` defaults to 7.
- Do not remind twice within 24 hours.
- At most one reminder per session.
- A blocking stop is opt-in; when enabled, block at most once per session and never repeat for the same pending item.
- After a successful run, clear `pending` and update `last_run`.

## Hook Contract

- Finish within 2 seconds; no network access.
- Read-only for project content: never edit project files, never commit, never send data; only `.agent/.maintenance-state` may be updated for throttling.
- Idempotent: repeated invocations produce the same result.
- Output one short reminder line, or nothing when the report is fresh.
- On error or timeout, exit 0 and append the failure to `.agent/agent-health.md`; do not block the session.
- Never include secrets, personal paths, or production addresses in output.

## Learn Trigger

- Run after a defect fix, release, refactor, or user correction.
- Run only when new evidence exists; when no new fact exists, record nothing.
- Route findings to `.agent/lessons.md`, `.agent/backlog.md`, or a refactor task; do not auto-refactor.

## Steward Trigger

- Run when the report is stale, behavior conflicts with assets, or an asset change is planned.
- Inspect prompts, rules, skills, memory, hooks, MCP, subagents, commands, plugins, and environment.
- Do not inspect business code health; hand that to `learn` or `review`.

## Sandbox Trigger

- Run before integration or end-to-end verification that could touch shared or production systems.
- Run when external services, credentials, devices, or operating systems must be simulated.
- Block when isolation is impossible; state exactly what cannot be verified.

## Degradation

| Missing capability | Preferred action |
| --- | --- |
| Native hook | Session scheduler or contract reminder |
| Session scheduler | Cloud automation or operating-system/CI schedule |
| Cloud automation | Operating-system/CI schedule |
| Any automatic mechanism | Advisory rule plus explicit invocation |
| Isolation runtime | Process-level isolation with temporary data and ports |
| Process-level isolation | Block and list unverifiable items |

Never claim automatic triggering when the mechanism does not exist. Mark it `degraded` in the contract.

## Safety

- Never run maintenance or isolation against production data, credentials, or endpoints.
- Deletions move assets to trash or an archive; never delete in place.
- Apply changes to rules, skills, memory, or prompts only after user confirmation.
- Do not write secrets, personal paths, hostnames, or internal addresses into reports.

## Verification

- A fresh report produces no reminder; a stale or missing report produces exactly one.
- Repeating the hook within the throttle window produces no second reminder.
- Removing the hook produces an explicit gap in the contract, not a silent failure.
- A scheduled job dry run shows the intended cadence and last-run state.
- After a maintenance run, `last_run` and `pending` match the actual result.

## Prohibited

- Auto-editing agent assets or committing changes.
- Reporting a reminder as a completed check.
- Using a blocking hook without explicit user opt-in.
- Storing production data or credentials in maintenance or sandbox files.
