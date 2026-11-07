---
id: seed/doc/plan
kind: doc
summary: Task plan and execution ledger
applies_when: { project.type: any }
requires: []
grow: on-demand
emits: state/plans
verify: Every step has a status and evidence, and every drift entry has a reason and impact
---

# Task Plan: <task title>

Status: active | paused | done | abandoned
Updated: <date>
Branch: <task branch or none>

## Goal

<One outcome this task must achieve>

## Non-Goals

- <What this task explicitly does not cover>

## Acceptance

- <Observable result or command that proves completion>

## Agreements

| Date | Agreement | Source |
| --- | --- | --- |
| <date> | <Confirmed scope, constraint, or convention> | <user/session> |

## Steps

| ID | Step and dependency | Status | Evidence |
| --- | --- | --- | --- |
| S1 | <action; depends on none/S0> | <pending/in progress/done/blocked> | <command, file, or test> |

## Drift Log

| Date | Change and type | Reason | Impact and decision |
| --- | --- | --- | --- |
| <date> | <what changed; scope/order/acceptance/context> | <why> | <affected steps; confirmed/rolled back> |

## Handoff

- Current position: <last completed step>
- Next action: <exact next step>
- Open questions: <none or question>
