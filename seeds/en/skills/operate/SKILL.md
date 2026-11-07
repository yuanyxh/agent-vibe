---
name: operate
description: Triggers when the user says "how is production", "check the monitoring", "there are alerts", "user feedback", or "operations and maintenance". Summarizes runtime status, anomalies, and cost, and gives next actions.
id: seed/skill/operate
kind: skill
summary: Runtime maintenance
applies_when: { project.type: any }
requires: [delivery.environments]
grow: on-signal
emits: skill/operate
verify: The report includes data sources and time ranges
---

# Runtime Maintenance

## Goal

Judge whether the system is healthy based on facts and turn anomalies and feedback into actionable work items.

## Reading rules

Before executing, read `.agent/rules/observability.md` and `deploy.md`; skip and state if a file does not exist.

## Steps

1. **Gather data**: read monitoring, logs, alerts, user feedback, and resource costs; state the time range and source.
2. **Judge**: distinguish normal fluctuation, needs observation, and needs handling.
3. **Attribute**: move issues needing handling to `hunt`; route requirement-like feedback into `.agent/backlog.md` with an ID, priority, status, and source.
4. **Report**: give a health conclusion, anomaly list, cost changes, and recommended actions.
5. **Record**: write the conclusion into `.agent/status.md`.

## Completion criteria

- Every conclusion has a data source.
- Every anomaly has an owner: handled, scheduled, or explicitly not handled with a reason.

## Prohibited

- Concluding with "should be fine" unsupported by data.
- Treating user feedback directly as an implemented requirement.
- Making production changes without confirmation.
