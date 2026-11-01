# Capabilities

This document answers three questions: **what capabilities exist, when to use them, and what you get**.

## Understand it in one minute

| Layer | Role | In one sentence |
| --- | --- | --- |
| Rules `seeds/en/rules/` | What you must not do | Safety, permissions, commits, and file-operation guardrails |
| Capabilities `seeds/en/capabilities/` | What must be guaranteed | Environment, memory, governance, supply chain, operations |
| Skills `seeds/en/skills/` | What to do in a situation | Init, build, hunt, review, release |
| Knowledge `seeds/en/knowledge/` | How to do it better | Authentication, caching, queues, consistency, and other patterns |
| Domains `seeds/en/domains/` | Professional concerns for this kind of project | Marketing site, admin console, backend, CLI, desktop |

Rules and capabilities are constraints. Skills are actions. Knowledge is reference material. Domains are professional concerns.

## 1. Starting a project

| Capability | You might say | The agent will | You will see |
| --- | --- | --- | --- |
| Project init | "Build an X from scratch" | Interview you round by round, confirm the profile, generate the engineering baseline, and stop | Target project, `.agent/`, `.claude/`, startup contract; feature work continues in the target project with `build` |
| Environment discovery | "I changed computers" or "it will not run" | Probe tool versions and propose alternatives or blockers | `.agent/environment.md` |
| Domain definition | "Build a 3D / marketing / backend project" | Reuse a reference from `seeds/en/domains/` when it matches, otherwise generate core questions and a coverage table | `.agent/domains/<name>.md` |
| Best-practice research | "What is the stable way to do this today?" | Check official versions, deprecations, and recommended combinations; record accepted and rejected options with reasons | `.agent/research.md` |
| Agent asset inventory | "Is there an existing skill or rule?" or "will this conflict?" | Inventory project, user, and plugin assets; assess provenance, licenses, and conflicts | Inventory conclusions in the research brief |
| Knowledge packs | "How is authorization usually done?" | Read the matching topic and give patterns, tradeoffs, and verification | A proposal, never a wholesale dump |
| Memory | "What was that decision last time?" | Read status, decisions, lessons, and long-term memory | Restored context without relying on conversation history |

## 2. Day-to-day development

| Skill | You might say | The agent will | You will see |
| --- | --- | --- | --- |
| `build` | "Implement this" or "continue" | Read status, implement in small steps, self-test, and suggest a commit | Code, status updates, commit suggestions |
| `hunt` | "It errors", "it does not work", "it regressed" | Reproduce, narrow the scope, find the root cause, fix, and add a regression check | Fix, root cause, `.agent/lessons.md` |
| `review` | "Look at the diff" or "check before merging" | Review the diff, check the rules, and give a verdict | Findings ordered by severity |
| `learn` | "Record this" or "retrospective" | Distill evidence-backed lessons and propose promotion | Project lessons or seed candidates |
| `upgrade` | "Dependencies are old" or "there is a vulnerability" | Inventory, classify, batch upgrades, and verify | Upgrade record and rollback points |
| `delegate` | "Run this in parallel" or "hand it to a subagent" | Pass only the goal, boundaries, acceptance criteria, and resource locations | Subtask results that do not contaminate your judgment |
| Tool recommendation | "Is there a better way?" | Give candidates, reasons, costs, and alternatives | Recommendation and decision record |

## 3. Delivery and operations

| Capability or skill | You might say | The agent will | You will see |
| --- | --- | --- | --- |
| `ship` | "Go live" or "release" | Check quality gates, release, verify, and prepare a rollback plan | Release record and rollback procedure |
| `operate` | "How is production?" or "there is an alert" | Summarize monitoring, incidents, feedback, and cost | Operations report and next steps |
| Release capability | "Deliver it to the customer" | Version strategy, build, signing, and distribution | Traceable release artifacts |
| Observability | "Production issues are hard to diagnose" | Logs, metrics, traces, and alerts | Signals you can act on |
| Data capability | "We need backups" or "we need deletion" | Migration, backup, retention, and deletion strategy | An executable plan |
| Seed upgrade | "Sync the seeds" or "upstream rules changed" | Compare `SEEDS_VERSION`, classify and merge, record conflicts | Updated baseline, `seed_version`, and migration record |

## 4. Project governance

| Capability | You might say | The agent will | You will see |
| --- | --- | --- | --- |
| Development environment | "I use VS Code or IDEA" | Check the current practice for that environment before generating configuration | Editor configuration or an equivalent description |
| Target environment | "Support Chrome 120+ or Safari 17" | Verify compatibility practices and build targets | Compatibility declaration and checks |
| Governance | "We are open-sourcing this" or "several people will collaborate" | Generate a license, contribution guide, and security policy | Community health files |
| Supply chain | "This is a production project" or "we need vulnerability scanning" | Locking, update policy, audit, and SBOM | Configuration and reports |
| Documentation | "We need a handoff" or "newcomers cannot follow this" | Usage, architecture, decisions, and troubleshooting | Documentation people can act on |
| Rule evolution | "This rule is outdated" | Review, bump the version, and supersede or deprecate | Version and replacement relationships |

## 5. How capabilities are loaded

Layers, budgets, and platform mechanisms live in one place: `protocols/en/loading.md`. Summary: L0 contract is always on, L1 path rules, L2 skill triggers, L3 explicit reads; the contract is at most 200 lines, and the inline core is at most 60 lines.

## 6. Complete examples

### Example 1: Build a product marketing site

> You: Build a product marketing site that search engines can index.

Agent: Load `init` → ask about the industry, languages, content maintenance, and analytics → verify current build and SEO best practices into `.agent/research.md` → generate the `web-marketing` domain definition → read the SEO knowledge pack → generate the engineering baseline and startup contract → run the baseline checks.

You get: project structure, `.agent/domains/web-marketing.md`, a layered loading strategy, and a buildable baseline. Page structure, metadata, sitemap, and crawl rules are implemented by later `build` runs.

### Example 2: A new computer

> You: It will not run after I changed computers.

Agent: Read `.agent/environment.md` → re-probe the runtime, package manager, and build tools → propose alternatives for missing items, ask before installing anything → update the environment record → re-run quality gates.

You get: a reproducible environment description and an explicit list of missing items and alternatives.

### Example 3: The home page is slow

> You: The home page loads slowly. Take a look.

Agent: Load `hunt` → reproduce and collect data → recommend browser performance tooling → read the caching and frontend knowledge packs → identify the specific resource or request → fix → add a regression check → record the lesson.

You get: the root cause, the fix, reproducible verification, and a lesson.

### Example 4: Three people working together

> You: Three people will work on this project.

Agent: Generate the `collaboration` rule → define the branch strategy, review method, and changelog → write it into the startup contract → apply the commit and review process to every later change.

You get: branch and review conventions, commit rules, and handoff-ready status files.

## 7. Opting out

Do not generate it and do not load it. When the profile has no matching need, the capability is skipped and the reason is recorded in `.agent/status.md`. Nothing is silently added to the project.

## 8. Where files live

| To learn about | Look at |
| --- | --- |
| All rules | `seeds/en/rules/` |
| All capabilities | `seeds/en/capabilities/` |
| All skills | `seeds/en/skills/` |
| All knowledge packs | `seeds/en/knowledge/INDEX.md` |
| How to define a domain | `seeds/en/domains/_schema.md` |
| Generation and verification flow | `protocols/en/` |
| Seed version and upgrades | `SEEDS_VERSION`, `CHANGELOG.md`, `protocols/en/upgrade-seeds.md` |
| Platform landing points | `adapters/en/` |
