# Verification Protocol

Check whether the instantiation result is usable after generation.

## Seed Repository Self-Check

After modifying `seeds/en/`, `protocols/en/`, or `adapters/en/`, run `scripts/check-format.sh`, `scripts/verify-seeds.sh --strict`, and `scripts/test-fixtures.sh`. Fix failures first; `--strict` treats warnings as failures.

`scripts/verify-instantiation.sh <project path>` verifies one real generated base; `tests/fixtures/` are regression samples, and seed changes must not degrade the samples.

## General Checks

| Item | Criterion |
| --- | --- |
| Paths exist | All seed `emits` are realized |
| No placeholder residue | Target files contain no `{{`, `TODO`, or `<to fill>` |
| Rules executable | Each rule contains trigger conditions and observable verification methods |
| Skills triggerable | Each skill has a name, description, and clear loading conditions |
| Contract complete | The bootstrap contract is at the adapter-specified location and lists always-on constraints, loading strategy, skill index, work loop, and runtime conventions |
| Memory degradable | Without an external memory service, the status, decisions, lessons, and long-term memory in `.agent/` suffice to restore context |
| Environment probed | `.agent/environment.md` records tool status, alternatives, and uncertain items |
| Knowledge indexable | The project has a knowledge index listing loading topics and trigger conditions, not injected wholesale |
| No platform residue | Seed files contain no platform paths such as `.claude/`, `.cursor/`, or `CLAUDE.md` |
| Status traceable | `.agent/status.md` records generated and ungenerated items |
| Project buildable | The build command declared by the profile executes successfully |
| Engineering gates | Format, lint, and type-check commands execute successfully as declared by the profile |
| Hooks executable | `pre-commit` and `commit-msg` exist and are executable, with commands consistent with `verify.format` / `verify.lint` |
| PR template | A PR template exists when `repo_host=github` |
| Version control ready | VCS is initialized; ignore rules cover generated artifacts, dependencies, local configuration, and verification data |
| Commit compliance | Committed records comply with commit conventions; if uncommitted, explain the reason and pending authorization actions |
| External facts traceable | Version numbers, platform support scope, and tool usage have sources and query times |
| Research traceable | `.agent/research.md` exists; each conclusion has a source, version, and query date; rejected items have reasons |
| Practices adopted | Conclusions affecting the base have entered generated artifacts or are recorded in the decision log |
| Agent assets inventoried | The research brief includes inventory conclusions; accepted, adapted, and ignored items all have reasons; content of unknown origin is not copied |
| Capability coverage | Each declared capability's generated items or reasons for not generating are recorded; nothing is silently skipped |
| Base non-empty | Profile, domains, environment, memory, rules, skills, and contract all exist and are non-empty files |
| No business functionality | init artifacts contain only skeleton and configuration, without business modules or game logic |
| Domain coverage | Each `project.domain` has a definition file (in the seed repository or the project), and each `core_concerns` item has a generated artifact, test, or reason for non-coverage |
| Rule metadata complete | Each rule has version, updated, review_by, status, load |
| Rules not expired | `review_by` is later than the current date, or review has been completed and updated |
| Loading strategy consistent | `always` is inlined only into the contract; `on-demand` is mapped to path, skill, or explicit read per `load_via`; always-on is within budget |
| On-demand triggerable | Each `on-demand` rule has `load_via` and the corresponding mechanism exists |
| Rule loading layered | `path` has executable `paths` or `globs`; `skill` is referenced by a skill body; `read` is marked degraded in the contract |
| No unscoped rules | Apart from core, there are no unscoped rule files loaded by the platform in every session |
| Always-on budget | Bootstrap contract ≤ 200 lines; core inline ≤ 60 lines |
| No always-on copying | The contract does not copy rule bodies, full profiles, status, decisions, or skill bodies |
| Startup read set | "Before starting any task" reads only the contract and `.agent/status.md`, not traversing `.agent/` |
| No full-load mechanism | `@import` is not used to pull in on-demand rules; non-core rules are not set to `alwaysApply: true` |
| No seed metadata residue | Target `SKILL.md` has only platform-recognized fields; rule files have no seed metadata, and path rules retain only the platform field `paths` |
| Version traceable | `.agent/profile.yaml` contains `seed_version` equal to `SEEDS_VERSION` at generation time |
| Memory traceable | `.agent/memory/INDEX.md` exists, entry IDs are stable, and archives are searchable by ID |
| Instantiation regressable | The golden fixture passes `scripts/verify-instantiation.sh`; seed changes do not degrade verification results |

## Conflict Checks

- No two contradictory rules may exist on the same topic.
- When project-level rules conflict with seed rules, an explicit override relationship must be marked in one place.
- Rules must not reference nonexistent files or skills.

## Failure Handling

When verification fails, list the failed items, reasons, and fix actions. Do not declare initialization complete while any failure exists.
