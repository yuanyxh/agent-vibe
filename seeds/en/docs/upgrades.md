---
id: seed/doc/upgrades
kind: doc
summary: Dependency version scan and upgrade recommendations
applies_when: { project.type: any }
requires: []
grow: on-init
emits: state/upgrades
verify: Every candidate has current and latest versions, a change type, a recommendation, a reason, and a scan date
---

# Dependency Upgrades

Last scan: <date>
Command: `<verify.outdated or none>`
Scope: <direct dependencies, runtimes, toolchains>

## Candidates

| Package or runtime | Current to latest | Change | Recommendation |
| --- | --- | --- | --- |
| <name> | <current> to <latest> | <patch/minor/major/security> | <now/next/hold; reason> |

## Decisions

| Date | Item | Decision | Basis |
| --- | --- | --- | --- |
| <date> | <name and version> | <upgraded/deferred/rejected> | <test result, advisory, or user confirmation> |

## Rules

- Record the scan command and date; do not present remembered versions as current.
- Check security fixes first; a high-severity advisory cannot be silently deferred.
- Recommend one upgrade batch at a time; major versions require an explicit risk note and user confirmation.
- Accepted recommendations enter the plan or backlog; this file records the candidates and decisions, not execution steps.
- Re-scan after each upgrade batch and before a release.
