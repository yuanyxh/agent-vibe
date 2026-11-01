# Seed Upgrade Protocol

Generated projects are upgraded incrementally by seed version, not re-initialized. Upgrade is a merge, not an overwrite.

## Triggers

- The seed repository `SEEDS_VERSION` is higher than `seed_version` in the project `.agent/profile.yaml`.
- The user says "sync seeds", "upgrade the base", or "upstream rules were updated".

## Prerequisites

- Read the entries between the two versions in `CHANGELOG.md`; when the project lacks `seed_version`, treat it as `0.0.0`, add the field first, then upgrade.
- Read the project `.agent/profile.yaml`, `status.md`, `decisions.md`, and `.agent/rules/` to confirm which content has been modified by the project.
- Output the upgrade checklist (added, modified, deprecated, conflicting) and wait for user confirmation; do not write without confirmation.

## Classification

| Change | Handling |
| --- | --- |
| New rules, skills, domains | Filter by profile and write; if not applicable, record the reason for skipping |
| Modified rules | Compare with project rules of the same name; if the project has customized it, record a conflict and do not overwrite |
| Deprecated rules | Keep the project file, mark the replacement; remove from the contract index |
| Protocol or adapter changes | Update only the contract index and loading mechanism; do not rewrite rule bodies |
| New profile fields | Fill in defaults and mark the source; items affecting generated artifacts require user confirmation |

## Order

1. Back up the list of files to be changed; do not move user files.
2. Merge category by category: status → profile fields → rules → skills → domains → contract index.
3. After merging each category, run `scripts/verify-instantiation.sh <project path>`; stop on failure.
4. Write conflicts to `.agent/decisions.md`, recording old value, new value, trade-off, and effective scope.
5. After all pass, update `seed_version` to the target version.
6. Record in `.agent/status.md` the upgraded version, time, skipped items, and to-dos.

## Prohibited

- Overwriting project-customized rules or skills directly with upstream files.
- Updating `seed_version` without verification.
- Smuggling business functionality changes into an upgrade.
- Automatic synchronization from external rule libraries; external content may enter this repository only after manual screening as seed candidates per `protocols/en/distill.md`.

## Rollback

The file list and conflict records before the upgrade are the basis for rollback. During rollback, restore files according to the list and write back the old `seed_version`; do not delete upgrade records.
