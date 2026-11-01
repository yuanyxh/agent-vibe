---
id: capability/data
kind: capability
summary: Data models are evolvable, backup-capable, and deletable
triggers:
  - The project persists data
  - Structural changes or data incidents occur
  - Personal data and retention periods are involved
questions:
  - Where data lives and who owns it
  - How structural changes are released and rolled back
  - How long data must be retained and how it is deleted
  - What the backup and recovery objectives are
research:
  - Migration mechanisms and limits of the selected storage
  - Retention and deletion requirements under applicable regulations
generates:
  - type: config
    examples: [migration scripts, backup jobs, data validation]
  - type: doc
    examples: [data map, retention and deletion policy, recovery drill records]
verify:
  - Migrations have a corresponding rollback plan
  - Backups can be restored and have been drilled
  - Deletion requests can be fully executed
---

# Data

## Goal

Data structure changes do not break existing data, data loss is recoverable, and deletion requests can be fulfilled.

## Generation principles

- Write the migration and rollback before changing the structure.
- Destructive changes require backups or a dual-write transition.
- Retention and deletion policies come from business and regulatory requirements, not defaults.
- The data map records data categories, locations, purposes, and owners.

## Verification

Run a complete migration and rollback on a copy; restore once from backup and verify integrity.
