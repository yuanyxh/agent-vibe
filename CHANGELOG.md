# Changelog

The seed repository is versioned by `SEEDS_VERSION` using semantic versioning. Generated projects record `seed_version` in `.agent/profile.yaml` and upgrade per `protocols/en/upgrade-seeds.md`.

## 1.5.0 - 2026-11-07

- Add `capability/agent-environment` and `steward`: periodic inspection of prompts, rules, skills, memory, hooks, MCP, subagents, commands, plugins, and environment; rot findings with evidence and reversible actions.
- Add `capability/isolated-environment` and `sandbox`: choose container, process, virtual machine, or block; create a disposable end-to-end environment with synthetic data, denied egress, and teardown checks.
- Add `protocols/{en,zh}/maintenance.md` and MNT-01 to MNT-04: capture after change, periodic agent check, isolate before E2E, and user correction wins.
- Extend `learn` with architecture, anti-pattern, and dead-code detection; add `code-health` and `agent-maintenance` knowledge packs.
- Add maintenance and isolation fields to the profile; `init` creates the health baseline and records the isolation decision; adapters map hooks, automations, and schedulers with explicit degradation.

## 1.4.0 - 2026-11-02

- Add dependency checks: lock file existence, reproducible install, vulnerability and license audit, and upgrade scan.
- Add `stack.lockfile`, `verify.outdated`, and `verify.audit` to the project profile, startup contract, and verification commands.
- Add `.agent/upgrades.md` for version candidates, recommendations, and upgrade decisions.
- Extend `upgrade` with detection, recommendation, confirmation, and post-upgrade re-scan; extend the supply-chain capability and instantiation checks.

## 1.3.0 - 2026-11-02

- Add the planning capability, the planning protocol, and task plan and backlog document seeds.
- Add `CTX-04` to `CTX-06`: multi-step plans must be written to `.agent/plans/`, reconciled step by step with evidence, and unplanned work must live in a single `.agent/backlog.md`.
- Wire planning into `init`, `build`, and `operate`, the startup contract, the loading strategy, bootstrap, and verification.
- Add drift logging with reason and impact so plan changes are visible instead of silent.
- Generated projects upgrading from 1.2 add `.agent/backlog.md` and `.agent/plans/_template.md`; initialization now creates both.

## 1.2.0 - 2026-11-02

- Add `VCS-07` task branch isolation: verify a clean tree, create `<type>/<task-slug>` from the latest trunk, never develop directly on the trunk, and handle pre-existing changes explicitly.
- Add `delivery.trunk_branch` to the project profile, startup contract, and instantiation flow.
- Make `build` and `review` perform branch preflight and check branch base and workspace hygiene.

## 1.1.0 - 2026-11-01

- Restructure documentation into `en/` and `zh/` trees under `seeds/`, `protocols/`, `adapters/`, `examples/`, and `packs/`.
- Make English the authoritative documentation language and add a complete Chinese mirror.
- Add `LICENSE` (MIT), `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, issue templates, and an expanded `.gitignore`.
- Extend `scripts/verify-seeds.sh` to validate both language trees, their platform matrices, adapters, and cross-document links.
- Translate user-facing script output to English.
- Add bilingual README, CAPABILITIES, AGENTS, and CHANGELOG.

## 1.0.0 - 2026-10-29

- First versioned release: add `SEEDS_VERSION`, this changelog, and `protocols/upgrade-seeds.md`.
- Add the Codex adapter; `generic` now covers generic platforms only.
- Add five high-frequency domain reference definitions: web-app, backend, cli, web-marketing, desktop.
- Add entry numbering, capacity archival, and external entry references to the memory protocol.
- Add instantiation checks and a golden fixture; extend semantic checks in the seed verifier.
- Add CI so seed checks run on every push and pull request.
