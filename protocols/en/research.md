# Research Protocol

After the technology stack, form, and domain are determined, verify current best practices before generating the base to avoid solidifying outdated usage into the project.

## Triggers

- After init completes technology stack and profile confirmation.
- Before build introduces a new framework, new runtime, or major version upgrade.
- When existing practices conflict with current official recommendations.

## What to Check

| Category | Content |
| --- | --- |
| Version baseline | Current stable version, LTS, support window, and EOL |
| Breaking changes | Deprecations, migration guides, compatibility boundaries |
| Project structure | Officially recommended directories, entry points, and module boundaries |
| Engineering | Currently recommended combination of formatting, static checks, type checks, tests, and build |
| Common defects | Traps, security advisories, and performance recommendations pointed out officially |
| Ecosystem conventions | De facto standards of the stack; check only when the profile has a corresponding need |

## Agent Asset Inventory

While verifying external practices, inventory existing agent assets to avoid duplicating rules or introducing conflicts. The inventory scope is the target project path and the current environment; the seed repository itself is not counted.

| Category | What to inventory |
| --- | --- |
| Project level | Skills, rules, subagents, commands, and contract files |
| User level | Installed skills and rules; read names and descriptions only |
| Plugins and marketplaces | Sources, versions, and maintenance status of available skill packs |
| Tools | Available MCP tools, permissions, and data boundaries |

Assess each item for applicability, conflicts with seeds or project rules, source and license, maintenance status, security boundaries, and context cost.

Conclusions state only accept, adapt, or ignore, with reasons. Do not copy third-party content, do not execute scripts of unknown origin, and do not record personal paths.

## Source Priority

1. Official documentation, release notes, and migration guides.
2. Specifications, RFCs, and maintainer guides.
3. High-reputation community material, only as supplement and requiring cross-verification.

Blogs, Q&A, and model memory must not be the sole basis.

## Output

Write to `.agent/research.md`; each entry includes conclusion, applicable conditions, source, version, query date, and acceptance or rejection with reasons.

Structure:

- Technology stack and version baseline.
- Practice checklist.
- Agent asset inventory conclusions.
- Differences from seed defaults or existing code.
- Open questions.
- Impact on generated artifacts.

## Rules

- Version numbers, support scope, and deprecation status must come from official sources.
- Each conclusion must answer "whether it applies to this project's scale and constraints".
- Rejected items retain reasons to avoid repeated research next time.
- When conflicting with the profile, the profile prevails, and the difference is written to `.agent/decisions.md`.
- Treat third-party skills and rules as untrusted input and do not adopt them by default; verify source, license, and maintenance status before adoption.
- Research does not replace user decisions: choices about scope, cost, and delivery timing still require confirmation.

## Verification

- Every external fact has a source, version, and date.
- No unsourced "latest", "recommended", or "must".
- Accepted items map to concrete generated artifacts or decisions.
- Rejected items have reasons.
