---
id: seed/rule/concern-documentation
kind: rule
version: 1
updated: 2026-10-24
review_by: 2027-01-24
status: active
load: on-demand
trigger: When writing or modifying documentation, README, interface descriptions, operation guides, change records and Markdown files
load_via: skill
skills: [build, review, learn]
summary: Document types, Markdown conventions and Chinese typesetting
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/skill
verify: Each rule can be judged by documentation checks or manual review
---

# Documentation Rules

## DOC-01 Type documents by purpose

**Rule**: Documents fall into four types: tutorials, how-to guides, reference and explanation. Tutorials are for learning, how-to guides for completing tasks, reference for looking up facts, and explanation for understanding reasons. One document serves only one type.

**Prohibited**: Expanding design rationale in a how-to guide, or embedding a complete tutorial in a reference document.

**Verify**: Each document can state its audience and purpose in one sentence and belongs to only one type.

## DOC-02 State applicability first

**Rule**: Begin with the purpose, intended audience and prerequisites; separate body steps from reference information; end with verification results or next steps.

**Prohibited**: Going straight into details under the title, leaving readers unable to judge applicability.

**Verify**: Readers can judge from the first paragraph whether the document solves their problem.

## DOC-03 Directories and naming

**Rule**: Organize directories by audience or document type; use lowercase, hyphen-separated and semantically clear file names; each document has a unique entry point.

**Prohibited**: Piling all documents in the root directory or a single README.

**Verify**: The target document can be located within ten minutes by directory.

## DOC-04 Documentation at the same version as code

**Rule**: Update documentation in the same commit as the corresponding code; label change records with version and date.

**Prohibited**: Documentation lagging behind the implementation for a long time.

**Verify**: The code change list and documentation change list are synchronized.

## DOC-05 Heading hierarchy

**Rule**: A file has only one first-level heading; heading levels progress one step at a time; heading text is unique within a page; convey hierarchy with headings rather than bold text.

**Prohibited**: Skipping levels, duplicating headings, or passing off bold text as headings.

**Verify**: Documentation checks report no warnings about heading levels, duplicate headings or heading format.

## DOC-06 Code blocks

**Rule**: Use fenced code blocks with a language tag for code, commands, configuration and output; use inline code for identifiers and command fragments.

**Prohibited**: Indented code blocks, missing language tags, or mixing logs and results in the same block.

**Verify**: All code blocks render with highlighting, and their content can be copied and executed directly.

## DOC-07 Links

**Rule**: Link text describes the target content; use relative paths for internal links; provide full URLs for external links.

**Prohibited**: "Click here", bare URLs, or absolute links to local paths or temporary branches.

**Verify**: Link checks pass; no broken links after renaming headings.

## DOC-08 Images

**Rule**: Images have alternative text; screenshots are labeled with version and state; prefer vector or high-resolution images.

**Prohibited**: Missing alternative text, outdated screenshots, or conveying information only through color.

**Verify**: The document remains understandable with images disabled.

## DOC-09 Block structure and whitespace

**Rule**: Leave blank lines before and after headings, lists, code blocks and tables; use consistent markers and indentation within a list; use one line-ending policy throughout the project.

**Prohibited**: Mixing list markers, stacking blank lines, trailing whitespace, or mixing line-ending policies.

**Verify**: Documentation checks report no warnings about block structure or whitespace; diffs reflect only semantic changes.

## DOC-10 Limited inline HTML

**Rule**: Prefer native Markdown syntax; when HTML is truly needed, limit it to tags supported by the target renderer.

**Prohibited**: Using HTML layout instead of Markdown structure; relying on tags supported by only a single platform.

**Verify**: Structure is consistent in the target renderer and in plain-text preview.

## DOC-11 Voice and sentence structure

**Rule**: Use the second person, active voice and short sentences; place conditions before instructions; use sentence case for headings and document names.

**Prohibited**: Stacked passive voice, long complex sentences, or using "we" to refer to the reader.

**Verify**: A randomly sampled paragraph identifies the actor and the action; heading capitalization is consistent.

## DOC-12 Consistent terminology

**Rule**: Use the same name for the same concept throughout; define it or provide a Chinese-English pair on first occurrence; maintain a glossary in one place.

**Prohibited**: Mixing synonyms or using undefined abbreviations.

**Verify**: Searching a concept yields only one definition.

## DOC-13 Chinese typesetting

**Rule**: Put a space between Chinese and English or numbers; use full-width punctuation in Chinese body text; keep code, commands, paths and file names as-is; provide Chinese-English pairs for proper nouns on first occurrence.

**Prohibited**: Joining Chinese and English directly, using half-width punctuation in Chinese body text, or translating code identifiers.

**Verify**: Sampled paragraphs are typeset consistently; code block content is neither translated nor rewritten.

## DOC-14 Checks in the pipeline

**Rule**: Implement Markdown structure and typesetting rules as automated checks, integrated into local hooks and CI at the same level as code checks.

**Prohibited**: Enforcing formatting standards only through human memory.

**Verify**: Non-compliant documents are blocked before commit or merge.
