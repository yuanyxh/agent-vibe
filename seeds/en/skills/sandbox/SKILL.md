---
name: sandbox
description: Triggers when integration or end-to-end tests may touch shared or production systems, when external services, credentials, data, or devices must be simulated, when the user says "tests affect production", "isolated environment", "sandbox", or "end-to-end verification", or when a test is blocked because no safe environment exists. Probes the target runtime and creates a disposable environment with synthetic data and denied egress.
id: seed/skill/sandbox
kind: skill
summary: Create and verify an isolated environment
applies_when: { project.type: any }
requires: []
grow: on-init
emits: skill/sandbox
verify: E2E passes in isolation and teardown leaves no residue
---

# Isolated Sandbox

## Goal

Run integration and end-to-end checks in a disposable environment that cannot reach production.

## Completion criteria

- The chosen isolation level and its limits are recorded.
- No production endpoint, credential, or dataset is reachable.
- The end-to-end path passes, or the unverifiable items are listed.
- Teardown leaves no containers, volumes, temporary directories, or reservations.

## Before executing

Read `.agent/profile.yaml` for target platforms, data, and verification commands; read `.agent/environment.md` for available primitives; read `.agent/sandbox.md` if it exists. Do not create anything before the user confirms the plan.

## Steps

1. **Probe**: identify the target runtime, required services, test commands, ports, environment variables, and existing isolation primitives. Probe read-only.
2. **Classify**: list what must be isolated: data, network, credentials, external services, OS, devices, hardware, time, randomness.
3. **Guard**: scan configuration and environment files for production endpoints, credentials, and shared databases. On a hit, stop and show the evidence; do not create the environment.
4. **Choose a level**: `container`, `process`, `virtual-machine`, or `block`. State why the higher levels are unavailable or unnecessary.
5. **Plan**: write `.agent/sandbox.md` with the level, isolated objects, files to create, ports, synthetic data, mocks, commands, teardown, residue check, and limitations. Ask for confirmation.
6. **Create**: generate only the declared configuration and scripts; use temporary resources; seed synthetic data; keep test credentials separate from real ones.
7. **Verify**: run the end-to-end path; capture command, logs, exit code, and evidence. On failure, keep the environment until the cause is understood, then tear down.
8. **Teardown**: stop and remove containers, volumes, networks, temporary directories, and reservations; run the residue check.
9. **Record**: append the result and limitations to `.agent/sandbox.md`; put blocked checks in `.agent/backlog.md`; add confirmed decisions to `.agent/decisions.md`.

## Safety

- Default deny egress; allow only declared test dependencies.
- Use synthetic or disposable data; never copy production data.
- Never use production credentials or run migrations against a non-isolated database.
- Do not leave shared resources reserved after the run.
- Do not weaken the test to make it pass; block and state what cannot be verified.

## Prohibited

- Running E2E against production or shared staging.
- Calling process-level isolation "fully isolated" when it can still reach production.
- Reporting a mock-only path as a real boundary test.
- Creating environment files or scripts before confirmation.
- Committing generated sandbox artifacts or credentials.
