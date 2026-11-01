---
id: seed/question/project-profile
kind: question
summary: Project profile question tree and completeness criteria
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/profile
verify: All required fields have values, and no inferred item is unmarked
---

# Project Profile

init maintains only one profile. Questioning, growth, and verification all use it as input.

## Fields

| Field | Required | Default | Description |
| --- | --- | --- | --- |
| `seed_version` | Yes | Current `SEEDS_VERSION` | Seed version used to generate the foundation, compared during upgrades |
| `project.name` | Yes | None | Project name, also used for directory and package names |
| `project.one_liner` | Yes | None | One sentence describing what it does and who it is for |
| `project.type` | Yes | None | web / mobile / backend / desktop / cli / library |
| `project.domain` | Yes | Derived from type and purpose | Domain name; can be multiple; an open set, not limited to the preset list |
| `project.scale` | Yes | mvp | prototype / mvp / production |
| `project.team` | No | solo | solo / small / large |
| `stack.language` | Yes | Recommended by type | Programming language |
| `stack.framework` | Yes | Recommended by type | Main framework; can be none |
| `stack.package_manager` | Yes | Recommended by language | Package manager |
| `stack.runtime` | No | Recommended by language | Runtime version constraints |
| `ui.has_ui` | Yes | Derived from type | Whether a visual interface exists |
| `ui.design_system` | No | none | Component library or design system |
| `ui.i18n` | No | false | Whether multiple languages are needed |
| `ui.a11y` | No | standard | none / standard / strict |
| `data.storage` | Yes | none | none / file / sqlite / postgres / mysql / mongo / cloud |
| `data.auth` | Yes | none | none / session / jwt / oauth / sso |
| `data.files` | No | none | none / local / s3 |
| `data.external_services` | No | [] | List of third-party services |
| `delivery.vcs` | Yes | git | git / none |
| `delivery.repo_host` | Yes | github | github / gitlab / gitee / local |
| `delivery.branch_strategy` | Yes | Derived from team | trunk / feature-branch |
| `delivery.ci` | Yes | Recommended by repo_host | github-actions / gitlab-ci / none |
| `delivery.deploy_target` | Yes | Recommended by type | static / serverless / container / vps / app-store / none |
| `delivery.environments` | Yes | [dev, prod] | Environment list |
| `delivery.domain` | No | None | Access domain |
| `quality.test_level` | Yes | standard | none / basic / standard / strict |
| `quality.security_level` | Yes | standard | basic / standard / high |
| `quality.format` | Yes | Recommended by language | Formatter name, or none |
| `quality.lint` | Yes | Recommended by language | Static check tool name, or none |
| `quality.typecheck` | No | Recommended by language | Type check tool name, or none |
| `quality.perf_budget` | No | None | Measurable performance limits |
| `quality.compliance` | No | [] | privacy / payment / health / finance |
| `verify.install` | Yes | Derived from package manager | Dependency installation command |
| `verify.build` | Yes | Derived from technology stack | Build command |
| `verify.format` | Yes | Derived from quality.format | Format check command |
| `verify.lint` | Yes | Derived from quality.lint | Static check command |
| `verify.typecheck` | No | Derived from quality.typecheck | Type check command |
| `verify.test` | Yes | Derived from test level | Test command |
| `verify.run` | No | Derived from form | Local startup command |
| `dev.editors` | No | [] | Editors or IDEs actually used by the user; if unspecified, generate no related configuration |
| `dev.toolchain_managers` | No | [] | Version management method; if unspecified, write only version declarations |
| `dev.task_entry` | No | None | Command entry preference; if unspecified, follow ecosystem defaults |
| `dev.containerized` | No | false | Whether a containerized development environment is needed |
| `dev.env_files` | No | true | Whether environment variable examples are needed |
| `target.platforms` | Yes | Derived from type | Target platforms and devices, free text |
| `target.versions` | No | {} | Minimum supported version for each platform |
| `target.constraints` | No | [] | Hard constraints such as network, storage, permissions, memory, and offline |
| `governance.openness` | Yes | private | private / public |
| `governance.license` | No | internal when private | License identifier; required for public projects |
| `governance.contribution` | No | Derived from openness | Contribution and review method |
| `governance.security_contact` | No | None | Security issue reporting channel |
| `supply_chain.dependency_updates` | No | Derived from scale | Dependency update responsibility and frequency |
| `supply_chain.vulnerability_scan` | No | Derived from scale | Vulnerability scanning requirements |
| `supply_chain.license_audit` | No | false | Whether license auditing is needed |
| `supply_chain.sbom` | No | false | Whether a bill of materials is needed |
| `agent.platform` | Yes | claude-code | claude-code / cursor / codex / generic |
| `agent.rules_scope` | Yes | core+type+concern | Rule loading scope |

## Question order

Each round asks at most four questions, only about missing fields whose prerequisites are already determined. Each question includes a recommended value; if the user answers "use the recommendation," the default is adopted.

1. **Positioning**: name, one_liner, type, domain, scale. Name the domain by purpose, industry, and problem space; free text is allowed. When unsure, write candidates first and define them during generation according to `seeds/en/domains/_schema.md`.
2. **Technology stack**: Dynamically generate language, framework, package manager, and runtime options by `type`.
3. **Interface**: Ask about design system, internationalization, and accessibility only when `ui.has_ui` is true.
4. **Data**: Storage, authentication, files, third-party services.
5. **Delivery**: Version control, repository hosting, branch strategy, CI, deployment target, environments, domain.
6. **Quality**: Test level, security level, formatting, static checks, type checks, performance budget, compliance requirements.
7. **Collaboration**: Ask about review method and changelog requirements only when `team != solo`.
8. **Environment**: Editor and toolchain preferences, target platforms and versions, hard constraints. Do not press for items the user did not mention; register them as pending growth.
9. **Governance and supply chain**: Openness, license, security reporting method. For production or public projects, ask about dependency update and scanning requirements.
10. **Agent**: Platform and rule scope.
11. **Seed version**: Do not ask; during generation, take `SEEDS_VERSION` from the seed repository and write it to `seed_version`.

## Inference rules

Fields that can be inferred from existing answers or repository facts are not asked about, but must be marked "inferred" in the summary. For example:

- When `type = web`, `ui.has_ui = true`.
- When `repo_host = github` and CI is unspecified, recommend `github-actions`.
- When `scale = prototype` and the test level is unspecified, recommend `basic`.
- Default `delivery.vcs` to `git` when unspecified; when `team = solo`, `branch_strategy = trunk`; otherwise `feature-branch`.
- Recommend mainstream tools for `quality.format/lint/typecheck` by language and derive the `verify.*` commands accordingly.
- Derive `project.domain` from `type`, industry, and purpose; the name is free text and does not require a same-named definition to exist in the seed repository.
- Derive `target.platforms` from `project.type`; verify version ranges during generation, and do not hardcode them here.
- When `governance.openness = public`, the license must be asked. When `scale = production`, dependency updates and vulnerability scanning are enabled by default.
- Product names appear only as user answers or examples, never as field defaults.
- When files such as `package.json`, `pom.xml`, or `go.mod` exist in the repository, read the facts first instead of asking.

## Completeness criteria

Only when all required fields in the table have values and every inferred value is marked in the summary may the generation phase begin.

## Summary format

Output once before generation: field, value, source (user answer / default / inference). The user may change any item. After confirmation, write to `.agent/profile.yaml`, with `seed_version` taken from the seed repository's `SEEDS_VERSION`.
