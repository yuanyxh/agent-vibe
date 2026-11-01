# agent-vibe

[![Seed checks](https://github.com/yuanyxh/agent-vibe/actions/workflows/seed-check.yml/badge.svg?branch=main)](https://github.com/yuanyxh/agent-vibe/actions/workflows/seed-check.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Seed version](https://img.shields.io/badge/seeds-1.1.0-informational)](SEEDS_VERSION)

English | [中文](README.zh.md)

A technology- and project-agnostic seed repository for agent-assisted software development. Fork it, load the `init` skill, and the agent interviews you about the project profile before instantiating rules, skills, and project structure into the locations your agent platform expects.

## Why

Agent setups usually start with a pile of prompts and a vague sense of "write clean code". That order produces context that is too large, too specific, or too late.

agent-vibe flips the order: profile first, seeds second, project last. The project profile decides which rules, capabilities, domain definitions, and knowledge packs are worth loading. Everything else stays out of context until it is needed.

## What it is not

- Not a scaffold collection: it does not ship ready-made application code.
- Not a rule document dump: rules are seeds, selected by the project profile before they land.
- Not a runtime framework: the repository itself is not executed.

## What it is

| Area | Purpose |
| --- | --- |
| `seeds/en/` | Abstract seeds: principles, capabilities, rules, skills, question trees, and structural requirements, all independent of a specific technology or platform. |
| `seeds/zh/` | The Chinese mirror of the same seeds. `seeds/en/` is authoritative for generation. |
| `seeds/en/capabilities/` | Capability definitions: what must be guaranteed, when to trigger, what to ask, what to research, and how to verify. Concrete outputs are generated after the context is known. |
| `seeds/en/domains/` | Domain definition schema and high-frequency reference domains. Domains are an open set: reuse a reference when it matches, otherwise generate one from context. |
| `seeds/en/knowledge/` | General architecture knowledge packs: authentication, authorization, caching, queues, files, notifications, consistency, time zones, import/export, PDF, updates, configuration, testing, components, deployment, observability, and system definition. Load by topic, never wholesale. |
| `protocols/en/` | Protocols for growth, distillation, verification, evolution, upgrades, loading, research, environment discovery, and memory. Rules carry a lifecycle and a loading mechanism. |
| `adapters/en/` | Platform mappings: where seeds land for Claude Code, Cursor, Codex, or a generic `AGENTS.md`. |
| `packs/` | Optional technology packs. The core repository ships none; add your own when a project needs a fixed stack. |
| `examples/en/` | Complete walkthroughs and domain examples. Not read by `init`. |

Every directory under `protocols/`, `adapters/`, `examples/`, `packs/`, and `seeds/` has an `en/` and a `zh/` version. The `en/` tree is the source used for generation. Root-level documents use a language suffix instead: `README.md` and `README.zh.md`.

## Quick start

1. Fork or copy this repository into your new project directory.
2. Install the entry skill using `adapters/en/<your-platform>/install.md` so the platform can trigger `init` automatically.
3. Tell the agent "I want to build an X" or "start". `init` asks one round of questions at a time until the profile and the required domain questions are complete.
4. Confirm the profile. The agent generates the engineering baseline in the target directory: project skeleton, engineering configuration, `.agent/`, rules, skills, and the startup contract.
5. After you confirm the baseline, `init` ends. Continue feature work in the target project with `build`, not in this seed repository.

## Repository layout

```text
agent-vibe/
├── README.md / README.zh.md
├── CAPABILITIES.md / CAPABILITIES.zh.md
├── AGENTS.md / AGENTS.zh.md
├── CHANGELOG.md / CHANGELOG.zh.md
├── CONTRIBUTING.md / CONTRIBUTING.zh.md
├── SECURITY.md / SECURITY.zh.md
├── LICENSE
├── SEEDS_VERSION
├── seeds/
│   ├── en/                  # authoritative seeds
│   ├── zh/                  # Chinese mirror
│   └── scaffolds/           # platform-neutral hooks and templates
├── protocols/{en,zh}/
├── adapters/{en,zh}/
├── examples/{en,zh}/
├── packs/{en,zh}/
├── scripts/                 # repository checks, not shipped as seeds
├── tests/                   # golden fixtures for instantiation checks
└── .github/                 # CI and community templates
```

## Capabilities

What each capability does, when it triggers, and what you get: see [CAPABILITIES.md](CAPABILITIES.md).

## What you get after init

The example below uses Claude Code. Other platforms are described under `adapters/en/`.

```text
<project>/
├── <normal project structure>          # generated from the profile
├── .githooks/{pre-commit,commit-msg}   # pre-commit checks and commit message validation
├── .github/PULL_REQUEST_TEMPLATE.md    # pre-merge checklist for GitHub projects
├── CLAUDE.md                           # startup contract: always-on baseline + loading index
├── .claude/
│   ├── skills/                         # skill bodies, triggered on demand
│   └── rules/                          # path-scoped rules only
└── .agent/
    ├── profile.yaml                    # project profile, including seed_version
    ├── research.md                     # best-practice research brief
    ├── rules/                          # task rules read by skills
    ├── memory/                         # INDEX.md plus topic files
    ├── status.md                       # single source of truth
    ├── decisions.md                    # decision log
    └── lessons.md                      # self-learning record
```

Only `CLAUDE.md` is always loaded. Everything else enters context by path, by skill, or by explicit read; the rules live in `protocols/en/loading.md`. `.agent/` is platform-neutral and shared by all platforms. The remaining paths are decided by the adapter.

## Ongoing loop

| Situation | Load |
| --- | --- |
| Day-to-day development | `build` |
| Defect investigation | `hunt` |
| Change review | `review` |
| Experience distillation | `learn` |
| Parallel subtasks | `delegate` |
| Dependency and framework upgrades | `upgrade` |
| Release | `ship` |
| Runtime maintenance | `operate` |

## Seed versioning

- The seed repository version is in `SEEDS_VERSION`; changes are recorded in `CHANGELOG.md`.
- Generated projects record `seed_version` in `.agent/profile.yaml` and upgrade via `protocols/en/upgrade-seeds.md`.
- External rule libraries are a manual source of inspiration only. Nothing is synchronized automatically; imported material is stripped of project details and rewritten in seed format.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Before opening a pull request, run:

```bash
scripts/check-format.sh
scripts/verify-seeds.sh --strict
scripts/test-fixtures.sh
```

CI runs the same checks on every push and pull request.

## License

[MIT](LICENSE)
