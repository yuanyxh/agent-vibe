---
name: upgrade
description: Triggers when the user says "upgrade dependencies", "the version is too old", "there is a security vulnerability", or "update the framework", or when routine maintenance is due. Assesses upgrade risk in tiers, executes in batches, and retains rollback points.
id: seed/skill/upgrade
kind: skill
summary: Dependency and runtime upgrades
applies_when: { project.type: any }
requires: [stack.language, stack.package_manager]
grow: on-signal
emits: skill/upgrade
verify: Test results before and after the upgrade are comparable, and the rollback method is clear
---

# Upgrade

## Goal

Update dependencies, runtimes, and toolchains under controlled risk to keep the project sustainably maintainable.

## Reading rules

Before executing, read `.agent/rules/engineering.md` and `testing.md`; skip and state if a file does not exist.

## Steps

1. **Detect**: run `verify.outdated` and `verify.audit`; when a command is `none`, state the degradation. Record current and latest versions, change type, advisories, and scan date for direct dependencies, runtimes, and toolchains in `.agent/upgrades.md`.
2. **Recommend**: for each candidate recommend now, next, or hold with a reason. Security fixes come first; major versions require a risk note. Wait for user confirmation before upgrading.
3. **Tier**: patch, minor, major, breaking; upgrade only one category at a time.
4. **Plan**: write the batch, impact scope, required code changes, verification commands, and rollback method to `.agent/plans/<task-slug>.md` per CTX-04.
5. **Execute**: update lock files and run the build and tests.
6. **Verify**: compare test, build, and critical-path results before and after the upgrade; a failed batch is rolled back before the next one starts.
7. **Record**: update the decision row in `.agent/upgrades.md` and record the upgrade reason, versions, and rollback point in `.agent/decisions.md`; move deferred items to `.agent/backlog.md`.

## Completion criteria

- `.agent/upgrades.md` has a scan date, command, and a recommendation for every candidate.
- Every batch of upgrades has comparable verification results before and after.
- Breaking changes are handled or explicitly recorded as unhandled.
- Deferred or rejected candidates have a reason and a backlog entry.

## Prohibited

- Upgrading all dependencies at once.
- Continuing to stack upgrades while tests fail.
- Skipping security advisories and ignoring high-severity items.
- Reporting remembered versions as current without running the detection command.
- Auto-upgrading major versions without user confirmation.
