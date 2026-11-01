---
id: capability/best-practices
kind: capability
summary: After the technology stack is determined, verify current best practices to avoid freezing outdated usage
triggers:
  - After the technology stack, runtime, or main dependencies are determined
  - Before introducing a new framework or major version upgrade
questions:
  - Whether the team already has conventions that must be followed
  - Whether existing versions or runtime environments must be supported
research:
  - Current official stable versions, LTS, and support windows
  - Deprecations, breaking changes, and migration guides
  - Officially recommended engineering combinations and project structures
generates:
  - { type: doc, examples: [.agent/research.md, decision log entries] }
verify:
  - Each conclusion has a source, version, and query date
  - Adopted items map to generated artifacts or decisions
---

# Best Practice Research

## Desired outcome

The foundation is generated from currently verifiable practices, not the seed author's memory or outdated tutorials.

## Criteria

- Versions and support ranges come from official sources, not search result summaries.
- Recommendations state their applicability conditions; do not apply large-company solutions directly to small projects.
- Differences from seed defaults are recorded; do not silently override them.

## Instantiation steps

1. Extract the technology stack, runtime, target platforms, and scale constraints from the project profile.
2. Verify versions, deprecations, structure, and engineering combinations according to `protocols/en/research.md`.
3. Write conclusions to `.agent/research.md`, marking each as adopted or rejected.
4. Merge conclusions that affect foundation generation into the confirmation summary.
5. After generation, record sources and query times in `.agent/status.md`.

## Counterexamples

- Writing "use the latest version" without a version number or source.
- Applying the directory structure of an official example to a project of mismatched scale.
- Leaving research conclusions only in the conversation instead of the generated artifacts.
