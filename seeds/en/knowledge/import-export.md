---
id: knowledge/import-export
kind: knowledge
summary: Validation, preview, and error handling for bulk import and export
applies_when: { project.domain: "web-app|backend" }
triggers: [designing bulk import, report export, template changes]
sources: [User design document "Import Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Import and Export

## Problem

Let large amounts of data enter and leave the system safely, and let users locate and correct errors.

## Patterns

- **Template versions**: templates carry version numbers; prompt or auto-map when importing with old templates.
- **Layered validation**: format validation, business validation, permission validation; validate everything before writing.
- **Preview**: before import, show how many rows will be added, updated, or skipped and the first batch of errors.
- **Partial success**: state the strategy explicitly: full rollback or per-row commit; per-row commit must provide an error report.
- **Error location**: report the row number, column name, original value, and reason.
- **Asynchrony**: route large files through background jobs with progress and downloadable results.
- **Export**: respect the current filters and permissions; stream large result sets to avoid memory blowups.

## Trade-offs

| Strategy | Suitable for | Cost |
| --- | --- | --- |
| Full rollback | Strong consistency, small batches | One bad row blocks everything |
| Per-row commit | Large batches, partial failure tolerable | Requires error reports and retries |

## Verification

- Invalid rows are reported accurately and produce no side effects.
- Large files do not cause memory exhaustion.
- Template version mismatches give a clear prompt.
- Export results match the filters and permissions.

## Counterexamples

- Reading and writing simultaneously, leaving half a batch behind on failure.
- Returning only "import failed" without row numbers.
- Loading the entire file at once.
- Exports ignoring data permissions.

## Sources

User "Import Design".
