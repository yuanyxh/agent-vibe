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

1. **Inventory**: list the current and latest versions and security advisories for direct dependencies, runtimes, and toolchains.
2. **Tiering**: four categories — patch, minor, major, breaking; security fixes first.
3. **Plan**: upgrade only one category at a time; state the impact scope, required code changes, and rollback method.
4. **Execute**: update lock files, run the build and tests.
5. **Verify**: compare test, build, and critical-path results before and after the upgrade.
6. **Record**: record the upgrade reason, versions, and rollback point in `.agent/decisions.md`.

## Completion criteria

- Every batch of upgrades has comparable verification results before and after.
- Breaking changes are handled or explicitly recorded as unhandled.

## Prohibited

- Upgrading all dependencies at once.
- Continuing to stack upgrades while tests fail.
- Skipping security advisories and ignoring high-severity items.
