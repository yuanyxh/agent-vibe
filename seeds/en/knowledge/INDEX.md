---
id: knowledge/index
kind: index
summary: Index of general architecture knowledge packs
load: on-demand
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
---

# Knowledge Pack Index

Load by task topic; take only the relevant entries per session, never inject the whole collection. Knowledge packs are references, not mandatory rules; when they conflict with project rules, project rules take precedence.

| Topic | File | Suitable cases | Trigger |
| --- | --- | --- | --- |
| Login and identity | `authn.md` | Systems with users, sessions, or third-party login | Designing or changing the authentication flow |
| Permissions and authorization | `authorization.md` | Role, menu, API, or data permissions | Designing a permission model or encountering privilege escalation |
| Caching | `caching.md` | Hot data, repeated computation, permission caching | Performance bottlenecks or consistency issues |
| Async jobs and queues | `async-jobs.md` | Long jobs, batch processing, retries | Introducing background jobs or message queues |
| File service | `file-service.md` | Upload, download, preview, storage | Designing file capabilities |
| Notifications | `notification.md` | In-app messages, email, SMS, push | Designing notifications or outreach |
| Eventual consistency | `consistency.md` | Cross-service and third-party sync, reconciliation | State out of sync |
| Time zones and internationalization | `timezone-i18n.md` | Multiple regions, languages, dates and amounts | Product entering a new region |
| Import and export | `import-export.md` | Bulk data, templates, reports | Designing import or export |
| Document generation | `pdf-generation.md` | PDF, printing, reports | Generating distributable documents |
| Auto update | `auto-update.md` | Desktop or client distribution | Designing an upgrade channel |
| Configuration | `configuration.md` | Environment differences, feature flags | Scattered configuration or frequent code changes |
| Testing strategy | `testing.md` | Layered testing, quality gates | Designing tests or defect regression |
| Code design and patterns | `design-patterns.md` | Module reuse, abstraction timing, pattern choice | Growing duplication or runaway abstraction |
| Components and theme | `component-design.md` | UI reuse, design systems | Component bloat or inconsistent style |
| Deployment automation | `deployment.md` | Build, release, rollback | Moving to continuous delivery |
| Exceptions and traces | `observability.md` | Crashes, error reporting, user traces | Online issues are hard to locate |
| System definition and standardization | `system-definition.md` | Project kickoff, terminology, boundaries | New project or multi-person collaboration |
| Defect types and debugging techniques | `debugging-playbook.md` | Jank, memory, hangs, slow queries, UI display and interaction | Choosing debugging tools or locating root causes |

## Loading rules

- Read the index first, then one to three related topics.
- When citing, state the topic and version.
- For new patterns repeatedly validated in a project, propose a new knowledge pack per `protocols/en/distill.md`.
