---
id: capability/isolated-environment
kind: capability
summary: Create an end-to-end verifiable isolated environment so verification never touches production
triggers:
  - Integration or end-to-end verification may touch shared or production systems
  - External services, credentials, data, devices, or operating systems must be simulated
  - The user says "tests affect production", "isolated environment", "sandbox", or "reproducible verification"
  - A test is blocked because no safe environment exists
questions:
  - What must be isolated: data, network, credentials, external services, OS, devices, hardware
  - Required fidelity and which parts may be simulated
  - Available isolation primitives and their licensing and limits
  - Egress policy, data policy, and teardown expectations
research:
  - Current container, process, virtual-machine, emulator, and service-mock options for the stack
  - Licensing, platform support, and hardware requirements
  - How to detect production endpoints and credentials before use
generates:
  - type: config
    examples: [container or virtual-machine definition, environment overrides, network policy, mock service configuration]
  - type: script
    examples: [up, seed, verify, down, residue check]
  - type: doc
    examples: [isolation report, fidelity and limitations, runbook]
  - type: test
    examples: [end-to-end smoke test, production-endpoint guard]
verify:
  - No production endpoint, credential, or dataset is reachable
  - The end-to-end path passes in the isolated environment
  - Teardown leaves no containers, volumes, temporary directories, or reservations
---

# Isolated Verification Environment

## Goal

Give every integration and end-to-end check a safe, disposable, reproducible environment, so testing never blocks on production risk.

## Isolation Levels

| Level | Use when | Limits |
| --- | --- | --- |
| `container` | The runtime and dependencies can be packaged; network and data can be isolated | Kernel and host capabilities are shared; hardware and OS-specific behavior may differ |
| `process` | A container runtime is unavailable; temporary ports, directories, and data are enough | Weaker network and filesystem isolation; process can still reach host resources |
| `virtual-machine` | The target is a different OS, a mobile device, or a desktop platform that needs real system behavior | Higher startup cost and licensing constraints; slower feedback |
| `block` | No level can provide the required fidelity | No E2E claim; list exactly what cannot be verified |

## Isolation Objects

| Object | Requirement |
| --- | --- |
| Data | Synthetic or disposable; never copy production data |
| Network | Deny egress by default; allow only declared test dependencies |
| Credentials | Test-only values; never production secrets |
| External services | Local mock, stub, or recorded fixture; state is reset per run |
| OS and device | Emulator, simulator, or virtual machine when platform behavior matters |
| Hardware | Declare unavailable hardware and block checks that depend on it |
| Time and randomness | Fix or control when the test depends on them |

## Safety Invariants

- Detect production endpoints, credentials, and datasets before creation; abort on a hit.
- Never run migrations or destructive commands against a non-isolated database.
- Use temporary ports, directories, volumes, and networks; do not reserve shared resources.
- End with teardown and a residue check.
- Keep evidence: commands, logs, test output, and the exact isolation boundary.

## Selection Order

1. `container` when the runtime can be packaged and the network and data can be isolated.
2. `process` when a container runtime is unavailable but temporary resources are enough.
3. `virtual-machine` when the target OS, device, or platform behavior cannot be reproduced otherwise.
4. `block` when fidelity is insufficient; state the unverifiable items instead of weakening the test.

## Output

Write `.agent/sandbox.md`:

- Chosen level, reason, and rejected alternatives.
- What is isolated, what is simulated, and what remains real.
- Commands to start, seed, verify, and tear down.
- Fidelity limits and checks that cannot run.
- Evidence from the last run and the residue check.

## Degradation

| Missing | Action |
| --- | --- |
| Container runtime | Use process isolation with temporary ports, directories, and data |
| Emulator or virtual machine | Block device-specific checks; list manual checks |
| Mock for an external service | Use a local stub or recorded fixture; if impossible, block that path |
| Any isolation | Do not run the test against production; block and record the reason |

## Counterexamples

- Pointing the test at a shared staging database because it is convenient.
- Copying production data into a local environment.
- Calling a process-level run "fully isolated" when it can still reach production endpoints.
- Reporting E2E as passed when the test ran against a mock that does not exercise the real boundary.
