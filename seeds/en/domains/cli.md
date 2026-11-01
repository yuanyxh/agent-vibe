---
id: domain/cli
kind: domain
summary: Command-line tools and scripts
applies_when: { project.domain: cli }
core_concerns:
  - Output streams friendly to pipes
  - Exit codes and error semantics
  - Non-interactive and CI usable
  - Configuration precedence and defaults
  - Cross-platform and terminal capabilities
questions:
  - Primary usage: humans, scripts, or CI
  - Which operating systems and terminals must be supported
  - Whether an interactive mode is required
research:
  - Signal and terminal capability differences across target platforms
  - Conventions of the chosen argument-parsing library
generates:
  - type: config
    examples: [argument and configuration parsing, exit code table, log levels]
  - type: test
    examples: [pipe tests, no-TTY tests, interruption tests]
verify:
  - Results can be consumed by pipes, and diagnostics go to standard error
  - Failures return a stable non-zero exit code
  - Core flows complete without terminal input
pitfalls:
  - Logs and results mixed in the same output stream
  - Returning 0 on failure
  - Leaving incomplete artifacts after interruption
---

# Command-Line Tools

## Goal

Usable both by humans and reliably invoked by scripts and CI.

## Generation Principles

- Put only results on standard output and diagnostics on standard error.
- Keep exit codes stable and documented.
- Provide a non-interactive equivalent for every interactive option.
- Make configuration precedence explicit: arguments > environment variables > configuration file > defaults.

## Verification

Run core commands in four environments: no TTY, pipes, signal interruption, and cross-platform.
