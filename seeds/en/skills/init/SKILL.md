---
name: init
description: Triggers when the user proposes any project, product, game, website, service, or tool requirement from scratch, says "start", "kick off", "I want to build", "build me a", "set up from scratch", "new project", or "initialize", or when the current directory has no `.agent/profile.yaml`. Complete the project profile and completeness checks first, then proceed to implementation; do not choose a technology stack and start coding directly.
id: seed/skill/init
kind: skill
summary: Project initialization control
applies_when: { project.type: any }
requires: []
grow: on-init
emits: skill/init
verify: Profile complete, project buildable, startup contract present
---

# Initialize Project

## Mandatory entry

Check the following before technology selection, solution design, or writing code:

1. Whether `.agent/profile.yaml` exists and has all required fields.
2. When it is missing or incomplete, this skill is the only entry point and the questioning and confirmation must be completed first.
3. Do not replace this process with think, websearch, or a directly proposed solution.
4. When the user says "start", "kick off", or "build an X" and no profile exists, treat it as an explicit trigger of this skill.

## Goal

Turn a one-sentence idea into a developable project, and let any later agent entering the project know the rules, skills, and work loop.

## Completion criteria

- The target project path is separate from the seed repository.
- All required fields in `.agent/profile.yaml` have values, and `seed_version` equals the current `SEEDS_VERSION`; the domain, environment, and memory files exist and are non-empty.
- `.agent/environment.md` contains a scriptable driving method: startup command, entry point to open the target UI, screenshot or assertion means, and log paths. Missing these means the base is incomplete.
- `.agent/agent-health.md` contains a baseline, next check date, and maintenance mode; `.agent/.maintenance-state` exists.
- The isolation decision is recorded: `.agent/sandbox.md` when isolation is generated, otherwise the reason in `.agent/status.md`.
- Rules and skills have been instantiated at adapter locations, and the files are non-empty.
- The startup contract exists and contains resident constraints, loading strategy, skill index, and work loop.
- `.agent/research.md` exists and is non-empty; external facts have sources, versions, and query dates.
- The agent asset inventory has conclusions, and adoption, adaptation, and rejection all have reasons.
- The project skeleton and engineering configuration are executable.
- The user has confirmed the base.
- The project contains no business feature code (except the minimal skeleton).
- All checks in `protocols/en/verify.md` pass.

## Steps

### 1. Probe the status quo and target path

Read the current directory. If code or build files already exist, identify the technology stack and fill it into the profile, then ask about unconfirmed items. Do not overwrite existing files.

Also determine the target project path:

- The target path must be separate from the seed repository; do not develop directly inside the seed repository.
- The path is confirmed by the user; do not generate anything before confirmation.
- If the current directory is the seed repository, only read; do not write business code.

### 2. Iterative questioning

Ask in rounds per `seeds/en/questions/project-profile.md`. Rules:

- At most four questions per round, covering only missing fields.
- Questions are layered by dependency: ask only questions whose prerequisites are settled; verify factual questions yourself first and do not throw them at the user.
- Give a recommended value and reason for each question.
- Do not ask what can be inferred from context or repository facts; mark such items as inferred.
- Use the default value when the user answers "go with the recommendation".
- Update the field status table after each round: asked, inferred, defaulted, missing.
- When not all required fields have values, continue questioning; do not proceed to generation just because the user answered about the technology stack.
- Cover the minimum required questions for the domain per `seeds/en/questions/domain-questions.md`; do not proceed to generation until covered.
- Handle answers per REQ-01 to REQ-04: record examples separately from goals, ask follow-up questions based on the questions themselves beyond the checklist, and list non-goals when confirming scope.
- After generating the domain definition, merge its `questions` into the questioning queue and confirm them one by one.
- Ask maintenance cadence and mode, isolation level, and egress policy only when the profile lacks them; use the defaults in `seeds/en/questions/project-profile.md`.

### 3. Research and alignment

After the technology stack, form factor, and domain are determined, verify current best practices per `protocols/en/research.md`:

- Version baselines, support windows, deprecation and migration guides.
- Officially recommended combinations of project structure, testing, static analysis, formatting, and build.
- Common defects related to the project's scale, target platforms, and performance budget.
- Practices that conflict with seed defaults or existing code.
- Inventory skills, rules, commands, and sub-agents at the project level, user level, and in plugins, plus available MCP tools; assess applicability, conflicts, sources, licenses, and maintenance status.
- Verify the platform's maintenance mechanisms (hook, session scheduler, cloud automation, OS/CI schedule) and isolation primitives (container, process, virtual machine, emulator, mock), with version and query date.

Each conclusion includes source, version, query date, and adoption or rejection reason. Conclusions are merged into the confirmation summary in step 5; after the target directory is created, write them to `.agent/research.md`; do not generate before confirmation.

### 4. Completeness gate

Output a checklist before generation:

| Check | Requirement |
| --- | --- |
| Required fields | All required fields in `project-profile.md` have values |
| Domain | Every `project.domain` has a definition and its core questions are confirmed |
| Environment | The development environment and target runtime environment are confirmed or explicitly inferred |
| Delivery | Version control, build, and deployment targets are confirmed |
| Quality | Testing, security, formatting, and static analysis are confirmed |
| Governance | Visibility and license are confirmed |
| Supply chain | Dependency update and scanning requirements for production projects are confirmed |

Continue questioning if any item is missing; do not proceed to generation.

### 5. Confirmation summary

Output the complete profile and a research conclusion summary, marking the source of each item. Wait for the user to confirm or modify in one pass. Do not generate before confirmation.

### 6. Generate the base (no business features)

Execute per `protocols/en/bootstrap.md` and `protocols/en/grow.md`. init stops at the base; business features are handled by the subsequent `build`.

First write the research conclusions from step 3 into `.agent/research.md`, then perform the following steps.

1. Create the directory at the target path; the target path must not be the seed repository.
2. `.agent/profile.yaml` (including `seed_version`), `status.md`, `backlog.md`, `upgrades.md`, `decisions.md`, `lessons.md`, `agent-health.md`, `.maintenance-state`, `memory/README.md`, and `memory/INDEX.md`; `.agent/plans/_template.md` is the plan template and task plans are created from it on demand. Probe `stack.lockfile` and derive `verify.outdated` and `verify.audit`; write the initial scan into `upgrades.md`, or record `none` with a reason.
3. Run the environment probe from `protocols/en/environment.md` and write `.agent/environment.md`; it must state the scriptable driving method (startup command, UI entry point, screenshot or assertion means, log paths), and explain the alternative verification method when scripting is impossible. Also probe isolation primitives; when `capability/isolated-environment` triggers, write the plan to `.agent/sandbox.md` without creating the environment, otherwise record the reason in `status.md`.
4. Project skeleton: prefer a matching technology pack in `packs/en/`; when none matches, generate on the spot per the structural requirements in `seeds/scaffolds/README.md`, and mark "no technology pack used" in the report.
5. Version control: detect the default branch and record it as `delivery.trunk_branch`; initialize the repository per the profile, generate ignore rules covering build artifacts, dependencies, local configuration, and verification data; the first commit requires user authorization.
6. Engineering configuration: generate formatting, static analysis, type checking, and local hook configuration, with commands consistent with `verify.*`. Generate `pre-commit` and `commit-msg` from `seeds/scaffolds/hooks/`, replace placeholders, make them executable, and install them via `core.hooksPath`; when `repo_host=github`, generate `.github/PULL_REQUEST_TEMPLATE.md`. Hooks must cover at least `verify.format` and `verify.lint`. When `agent.maintenance_mode=hook`, generate the maintenance hook from `seeds/scaffolds/hooks/agent-maintenance` at the adapter hook location and register it; when the platform cannot hook, degrade to `advisory` and mark it in the contract.
7. Capability growth: check each item in `seeds/en/capabilities/` and decide per `triggers` and the profile whether to generate, skip, or wait; research capabilities are already completed in step 3, register them as generated, and do not repeat. Do not generate dimensions whose context is undetermined; register the reason. Select related knowledge packs per `seeds/en/knowledge/INDEX.md` and write them into the project index.
8. Domain growth: resolve a definition for each `project.domain` — reuse if `seeds/en/domains/` has a match, otherwise generate on the spot per `seeds/en/domains/_schema.md` and write it into the project's `.agent/domains/`; cover `core_concerns` one by one, and register reasons for uncovered items. When reusing a definition, keep the body and strip the seed metadata.
9. Rules: filter by `applies_when`, excluding non-active and expired entries; layer per `protocols/en/loading.md`: merge `always` inline into the contract (≤ 60 lines), generate rule files with path scopes for `path`, write `skill` into `.agent/rules/` and reference it from skill bodies, and mark `read` as degraded in the contract. Strip seed metadata and keep only the body.
10. Skills: write each file to the target location; every `SKILL.md` must have a body and state the rules to read before execution; do not create empty directories only.
11. Startup contract: write resident constraints, loading strategy, skill index, work loop, and verification commands; write only the index and summaries, not full rule text.
12. Use the current platform's adapter to resolve the above logical artifacts into physical paths and persist them.

### 7. Base verification gate

Run the checks in `protocols/en/verify.md` and `protocols/en/bootstrap.md`:

- Profile, domains, environment, agent health, memory, research, rules, skills, and contract all exist and are non-empty.
- Maintenance mode is backed by a real mechanism or explicitly marked degraded; the isolation decision is recorded.
- Research conclusions have sources, versions, and query dates, and adopted items map to generated artifacts.
- The agent asset inventory conclusion exists, and no content of unknown origin was copied.
- Engineering commands are executable.
- Rules contain no seed metadata, and skills contain only platform fields.
- The project contains no business feature code (except the minimal skeleton).

Fix any failure before proceeding to confirmation; do not proceed.

### 8. Confirm and finish

Output the base checklist and wait for user confirmation. After confirmation, output:

```text
Baseline ready: <target path>
Run build in that directory for subsequent development.
```

init ends here. Do not continue implementing business features or game logic within init.

## Prohibited

- Generating files before the profile is confirmed.
- Overwriting the user's existing project files.
- Fabricating technology stack facts; ask when probing is impossible.
- Generating engineering configuration or dependencies before completing best-practice research.
- Generating duplicate or conflicting skills and rules without inventorying existing agent assets.
- Claiming to use a technology pack that does not exist.
- Writing a specific framework's directory conventions back into the seed layer.
- Writing all rules at once; write only the parts matching the current profile.
- Creating only empty directories without writing rules, skills, and contract.
- Developing a business project directly inside the seed repository.
- Continuing to write business features before the base is confirmed.

## Loading maintenance

Persist per the layers in `protocols/en/loading.md`. The contract writes only paths, triggers, and mechanisms, not full text. After generation, verify the resident budget and whether each on-demand item has a real executable loading mechanism.
