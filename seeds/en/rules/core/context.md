---
id: seed/rule/core-context
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: always
summary: Context and single source of truth
applies_when: { project.type: any }
requires: []
grow: on-init
emits: rule/always
verify: Status file exists and is updated
---

# Context Rules

## CTX-01 Single source of truth

**Rule**: The project's current goals, progress and blockers are written only in `.agent/status.md`; decisions are written only in `.agent/decisions.md`. Other documents reference them instead of copying.

**Prohibited**: Maintaining conflicting progress or decisions across multiple files.

**Verify**: At any moment there is only one current status, and it matches the actual build results.

## CTX-02 Artifacts are context

**Rule**: Each stage reads only the artifacts of the previous stage and the current project profile, without relying on conversation memory.

**Prohibited**: Assuming the agent remembers the content of the previous session.

**Verify**: A new session can continue the work using only `.agent/` and the project documents.

## CTX-03 Facts first

**Rule**: Code, tests, build output and runtime logs take precedence over documents and memory. When they conflict, verify the facts first, then correct the documents.

**Prohibited**: Overriding the user's current statement with memory content.

**Verify**: Conclusions are accompanied by command output, file paths or test results.
