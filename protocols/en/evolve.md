# Evolution Protocol

Rules, capabilities, and skills all have lifecycles and must be reviewable, replaceable, and deprecable.

## Metadata

Rule-type seeds must contain:

| Field | Meaning |
| --- | --- |
| `version` | Integer, incremented on each substantive change |
| `updated` | Last modified date |
| `review_by` | Date by which review is required; defaults to three months later |
| `status` | active / deprecated / superseded |
| `load` | always / on-demand |
| `load_via` | path / skill / read, maintained per `protocols/en/loading.md` |

## Review Triggers

- `review_by` expires.
- A major version change occurs in a dependency or platform.
- An incident, regression, or user correction occurs.
- Conflicting rules of the same kind appear.

## Review Actions

1. Verify whether the rule is still consistent with current facts.
2. If consistent, update only `review_by`.
3. If adjustment is needed, increment `version` and state the reason for the change.
4. When superseded, mark it `superseded` and point to the new rule number; do not delete the original text.
5. When no longer applicable, mark it `deprecated` and state the reason and replacement.

## Prohibited

- Silently deleting rules or rewriting history.
- Allowing expired rules to remain active in generation.
- Writing project-specific experience into the general layer without user confirmation.

## Output

Write review results to the project status or the seed repository change log, including date, conclusion, and rationale.
