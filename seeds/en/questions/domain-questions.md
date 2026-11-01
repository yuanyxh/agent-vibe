---
id: seed/question/domain-questions
kind: question
summary: Minimum required questions by domain
applies_when: { project.type: any }
requires: [project.domain]
grow: on-init
emits: state/profile
verify: Every domain's minimum required questions have answers or explicit inferences
---

# Minimum Required Domain Questions

Domain definitions can be generated on the fly, but the following questions must enter the question queue and must not be skipped just because the technology stack was asked first.

| Domain | Required questions |
| --- | --- |
| Game / 3D | Single-player or online; target platforms and devices; asset sources and copyright; MVP scope (factions, units, buildings, levels); input devices; performance targets; saves and progression; distribution method |
| Marketing site / content site | Target search engines and regions; who maintains content; whether multiple languages are needed; analytics and cookie compliance; sharing and structured data |
| Admin console / SaaS | Roles and permission boundaries; key business paths; data volume; whether auditing is needed; multiple languages and terminal adaptation |
| Backend / API | Callers and trust boundaries; concurrency and consistency requirements; acceptable interruption and data loss windows; authentication and authorization; capacity and rate limiting |
| CLI | Human, script, or CI; target operating systems and terminals; whether interactive mode is needed; configuration precedence |
| Library / SDK | User languages and runtime ranges; compatibility commitments; release cadence; whether multi-package management is needed |
| Mobile | Target platforms and minimum OS versions; offline capabilities; system permissions; distribution channels and review requirements |
| Desktop | Target operating systems; signing and notarization; update channels and rollback; system permissions |
| Third-party integration | Counterparty contracts and versions; latency and failure handling; callback signature verification; reconciliation; sandbox and production isolation |

## Usage

1. After the project profile determines `project.domain`, read the required questions in the corresponding row.
2. Each item must either have a user answer or be marked as an inference with its basis.
3. Do not enter the generation phase while required questions remain uncovered.

## Prohibited

- Starting work after asking only about the technology stack.
- Deferring required domain questions to "later."
- Using defaults to mask key business choices (single-player/online, copyright, distribution method).
