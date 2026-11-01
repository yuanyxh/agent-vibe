---
id: seed/rule/core-safety
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: always
summary: Safety and the bottom line for irreversible operations
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/always
verify: Each rule can be triggered by a pre-operation check
---

# Safety Rules

## SEC-01 Confirm before irreversible operations

**Rule**: For operations that delete data, force-push, overwrite others' changes, publish publicly or incur costs, explain the impact and the rollback method before executing.

**Prohibited**: Executing irreversible operations without confirmation.

**Verify**: Operation records contain the impact description and user confirmation.

## SEC-02 Credentials never enter the repository

**Rule**: Keys, tokens and connection strings are injected only through environment variables or secret management.

**Prohibited**: Writing credentials into source code, configuration examples, logs or commit records.

**Verify**: No real credentials can be found in the repository or logs.

## SEC-03 Deletion made recoverable

**Rule**: When deleting files or data, prefer moving them to the trash or keeping a backup.

**Prohibited**: Permanently deleting user content that may still be needed.

**Verify**: Deleted paths can be recovered from the trash or a backup.

## SEC-04 Least privilege

**Rule**: When adding accounts, tokens or database roles, use the least privilege required to complete the task.

**Prohibited**: Granting administrator or full-database privileges for convenience.

**Verify**: The privilege list corresponds item by item to the task requirements.
