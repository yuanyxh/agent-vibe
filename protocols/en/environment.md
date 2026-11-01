# Environment Probing Protocol

## Timing

- New project initialization.
- New machine, new session, or switching agent environment.
- Dependency installation, build, or test command failure.
- Change in the runtime version declared by the project.

## Steps

1. **Read declarations**: requirements in the project profile, version files, and build configuration.
2. **Probe**: run read-only commands in the order of runtime, package manager, build and test, version control, diagnostics, containers, and hosting.
3. **Assess**: record as available, partially available, or missing, with versions and command output summaries.
4. **Choose alternatives**: prefer existing tools; next use built-in language capabilities; suggest installation only as a last resort.
5. **Record**: write to `.agent/environment.md`, including time, platform, tools, status, alternatives, and impact.
6. **Verify**: confirm the quality gates declared by the project are executable in the current environment, or clearly state which cannot be executed and why.

## Degradation Rules

| Missing item | Preferred alternative |
| --- | --- |
| Container runtime | Local process or build artifact smoke test |
| Browser automation | Unit tests and build checks; record E2E as not executed |
| Hosting CLI | Local git operations; record remote steps as not executed |
| External memory service | In-project `.agent/` files |

## Refresh

Re-probe when the environment changes, a command fails, or a new session begins; keep timestamps on old records and do not overwrite historical conclusions.

## Sanitization

- Record only the minimum information needed for reproducibility.
- Do not write hostnames, internal addresses, personal paths, or account names; use `<host>` and `<registry>` placeholders when needed.
- For internal mirrors, record only "use the environment proxy or private source"; do not record addresses.
- Environment records are in-project files and must not enter the seed repository or cross-project memory directly.

## Prohibited

- Substituting guesses for probing.
- Writing the conclusion from one environment as fact for all environments.
- Installing tools or changing system configuration without authorization.
