---
id: seed/rule/type-cli
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When implementing or modifying commands, parameters, output and exit codes
load_via: path
path_scope: source
summary: General rules for command-line tools
applies_when: { project.type: cli }
requires: []
grow: on-init
emits: rule/path
verify: Rules are language-agnostic and decidable
---

# CLI Rules

## CLI-01 Output is pipeable

**Rule**: Write normal results to standard output, and diagnostics and errors to standard error; support non-interactive environments.

**Prohibited**: Mixing logs and results in the same output stream.

**Verify**: After redirecting standard output, results can be parsed and errors remain visible.

## CLI-02 Meaningful exit codes

**Rule**: Success is 0; expected failures use stable non-zero exit codes listed in the documentation.

**Prohibited**: Returning 0 on failure.

**Verify**: Exit codes for each failure scenario match the documentation.

## CLI-03 Usable non-interactively

**Rule**: Every interactive option has a corresponding parameter or environment variable, so it can run in CI without prompts.

**Prohibited**: Requiring manual input to complete the core flow.

**Verify**: The core commands succeed in an environment without terminal input.

## CLI-04 Interruptible and resumable

**Rule**: Long-running operations respond to interrupt signals and leave a resumable state or explicit partial results.

**Prohibited**: Leaving artifacts whose completeness cannot be determined after an interruption.

**Verify**: Behavior is predictable when executed again after being terminated mid-way.
