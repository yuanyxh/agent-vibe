# agent-vibe repository conventions

This repository is a seed repository. It is not run directly as a business project.

## Directory responsibilities

- `README.md`: the entry point for users; only onboarding steps and output structure.
- `CAPABILITIES.md`: capability navigation; only what exists, when to use it, and what you get. Do not copy protocol details.
- `seeds/en/`: authoritative abstract content. It must not contain concrete project names, paths, accounts, secrets, or technology versions.
- `seeds/zh/`: the Chinese mirror of `seeds/en/`. Keep the structure and semantics aligned with the English side.
- `seeds/en/capabilities/`: capability definitions; only triggers, problems, research items, output categories, and verification criteria. Do not write product-specific configuration. The memory capability defines protocols, layers, and degradation only; it never stores memory content.
- `seeds/en/domains/`: the domain definition schema (`_schema.md`) and high-frequency reference definitions. Domains are an open set; when no reference matches, generate one from context. `examples/en/domains/` is a writing reference only.
- `seeds/en/knowledge/`: general architecture knowledge packs and an index. Only problems, patterns, tradeoffs, verification, and counterexamples. No concrete project implementation. Load by topic.
- `protocols/en/`: growth, distillation, verification, evolution, upgrade, loading, research, environment discovery, and memory protocols. Changes to a protocol must be mirrored in `adapters/`.
- `adapters/en/`: platform landing-point mappings for Claude Code, Cursor, Codex, and generic platforms. Only locations and format conversion, never business content.
- `SEEDS_VERSION`, `CHANGELOG.md`: the public version of the seed repository and its change record; the basis for `seed_version` and upgrades in generated projects.
- `tests/`: golden fixtures for instantiation checks. `.github/`: seed checks for pushes and pull requests.
- `packs/`: optional technology packs, added by forks. The core repository ships none.
- `scripts/`: repository self-checks (format, seeds, instantiation). They do not enter seed outputs.
- `.githooks/`: pre-commit entry points; they only call `scripts/`, never carry rule content.
- `examples/en/`: complete examples, which may contain a concrete technology stack, but are never read by `init`.

## Language layout

- Directories use language subdirectories: `protocols/{en,zh}/`, `adapters/{en,zh}/`, `examples/{en,zh}/`, `packs/{en,zh}/`, `seeds/{en,zh}/`.
- Root documents use a language suffix: `README.md` and `README.zh.md`, and the same pattern for `CAPABILITIES`, `AGENTS`, `CHANGELOG`, `CONTRIBUTING`, and `SECURITY`.
- `seeds/en/` is authoritative for generation and validation. `seeds/zh/` is a human-readable mirror.
- Language copies must stay structurally aligned: same headings, table shapes, list counts, file names, and cross-reference targets inside their own language tree.

## Seed format

Output seeds (rule / skill / playbook / scaffold / doc / config / question):

```yaml
---
id: seed/<kind>/<name>
kind: rule | skill | playbook | scaffold | doc | config | question
version: 1
updated: YYYY-MM-DD
review_by: YYYY-MM-DD
status: active | deprecated | superseded
load: always | on-demand
trigger: <trigger condition for on-demand loading; optional when load is always>
load_via: path | skill | read        # rule only; required when on-demand
path_scope: source | ui | server | tests | config | domain
skills: [build, review]              # required when load_via=skill
summary: one-sentence description
applies_when: { project.type: any }
requires: []
grow: on-init | on-signal | on-demand
emits: <logical artifact, such as rule/always, rule/path, rule/skill, skill/init, contract, state/status>
verify: checks after instantiation
---
```

These fields exist only in the seed layer; they are not configuration fields for any platform. Platforms only understand their own built-in fields, such as Claude Code skill `name`/`description` and Cursor rule `description`/`globs`/`alwaysApply`. During generation, strip them or convert them through an adapter; never write them into the target project verbatim.

Lifecycle fields are maintained per `protocols/en/evolve.md`; loading is implemented per `protocols/en/loading.md`: `always` is inlined into the contract, `on-demand` uses the mechanism named by `load_via`, and `trigger` only appears in the contract index.

Rule seeds must declare their loading path explicitly. Never write `on-demand` without a mechanism: `path` maps through `path_scope` to a file scope, `skill` points through `skills` to the triggering skill, and `read` is the explicit degradation path for platforms without a native mechanism.

Domain definitions describe the professional core of a class of projects; the format is in `seeds/en/domains/_schema.md`. A domain can be generated in the seed repository or in a project's `.agent/domains/`; it never produces a fixed file directly:

```yaml
---
id: domain/<name>
kind: domain
summary: what this kind of project must solve
applies_when: { project.domain: <name> }
core_concerns: [professional questions that must be answered]
questions: [what to confirm with the user]
research: [external facts to verify before generation]
generates: [{ type: config, examples: [possible artifacts] }]
verify: [how to prove coverage]
pitfalls: [common failure modes]
---
```

Knowledge packs are reference material, not rules:

```yaml
---
id: knowledge/<topic>
kind: knowledge
summary: one-sentence description
applies_when: { project.domain: <name> }
triggers: [when to read this]
sources: [sources and evidence]
version: 1
updated: YYYY-MM-DD
review_by: YYYY-MM-DD
status: active
load: on-demand
---
```

The body contains problems, patterns, tradeoffs, verification, and counterexamples. Do not write concrete project implementations.

Capabilities do not produce fixed files directly; they use another set of fields:

```yaml
---
id: capability/<name>
kind: capability
summary: the result that must be guaranteed
triggers: [when this is needed]
questions: [what to confirm with the user]
research: [external facts to verify before generation]
generates: [{ type: config, examples: [possible artifacts] }]
verify: [how to prove the result is achieved]
---
```

The body contains concepts, decision criteria, instantiation steps, and counterexamples only. Do not write concrete implementation code.

## Entry point for new requirements

When the user proposes a new project, a new product, or anything that starts from zero, load `seeds/en/skills/init/SKILL.md` first. Only after the profile, domain questions, and completeness check are done may you move to technology selection and implementation. Do not enter think, research, or coding directly.

`init` stops at "engineering baseline + user confirmation". It must not implement business features. After the baseline is confirmed, switch to the target project and run `build` there.

## Hard constraints

- A seed must be instantiable by at least two projects with different technology stacks; otherwise it does not belong in this repository.
- Technology-specific content goes into a separate file under `seeds/` and is limited by `applies_when`.
- Any lesson from a concrete project must lose its project details before entering `seeds/`.
- External rule libraries (such as Agent Rules) are manual sources only. Nothing is synchronized automatically; imported content must be stripped of project details and rewritten in seed format.
- After changing seeds, both `scripts/verify-seeds.sh --strict` and `scripts/test-fixtures.sh` must pass. Run `scripts/check-format.sh` as well.
- Keep `seeds/en/` and `seeds/zh/` in sync. A change to one language tree requires the same change in the other.
