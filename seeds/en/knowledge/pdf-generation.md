---
id: knowledge/pdf-generation
kind: knowledge
summary: Generation, fonts, pagination, and concurrency for distributable documents
applies_when: { project.domain: "backend|web-app" }
triggers: [generating PDFs, printing, report export, Chinese typesetting]
sources: [User design document "PDF Generation Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Document Generation

## Problem

Reliably turn structured data into documents that paginate, print, and render consistently across environments.

## Patterns

- **Separate template and data**: the template handles layout, data supplies content; templates are versioned.
- **Fonts**: embed required fonts, especially for Chinese; do not depend on the runtime environment's system fonts.
- **Pagination**: repeated table headers, line breaks across pages, headers and footers, and page numbers; measure long tables in advance.
- **Concurrency**: isolate generation processes, limit concurrency and memory; route large documents through async jobs.
- **Traceability**: documents record template version, generation time, and data snapshot.
- **Security**: escape user input; add watermarks or permission marks as business requires.

## Trade-offs

| Approach | Pros | Cost |
| --- | --- | --- |
| HTML to PDF | Reuses frontend layout | Weaker control over pagination and fonts |
| Dedicated typesetting library | Precise control | Learning and maintenance cost |
| Client-side generation | Reduces server load | Environment differences and unstable performance |

## Verification

- Chinese text, special characters, and very long text do not overflow.
- Cross-page table headers and page numbers are correct.
- Concurrent generation does not contaminate other outputs.
- Output is consistent in target readers and print environments.

## Counterexamples

- Depending on system fonts, causing garbled text on another machine.
- No pagination control, so long tables break incorrectly.
- Generating large documents synchronously and blocking requests.
- Template and code versions out of sync.

## Sources

User "PDF Generation Design".
