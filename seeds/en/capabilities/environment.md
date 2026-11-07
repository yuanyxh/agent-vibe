---
id: capability/environment
kind: capability
summary: Detect available tools in an unknown environment, and provide alternatives or blocking when they are missing
triggers:
  - New project initialization
  - A new machine, new session, or environment change
  - A tool command fails or a version is insufficient
  - The user mentions environment differences
questions:
  - Target platform and architecture
  - Whether installing tools or using containers is allowed
  - Network, proxy, and mirror restrictions
research:
  - Common tools and equivalent alternatives on the current platform
  - Version ranges required by the project declarations
generates:
  - type: doc
    examples: [environment detection records, available tool matrix, missing items and alternatives]
  - type: config
    examples: [version declarations, task entry points, degradation switches]
verify:
  - Detection results are reproducible in the current environment
  - Missing items have alternatives or a clear blocking reason
  - Local paths and versions are not hardcoded as project defaults
---

# Environment Capability

## Goal

When switching to another machine or agent environment, first know "what is available, what is missing, and what to do" instead of assuming tools exist.

## Detection order

1. Runtime and version
2. Package manager and dependency installation method
3. Build, test, static checks
4. Version control and hosting CLI
5. Diagnostics, browsers, and automation
6. Containers, cloud CLI, and external services

## Classification

| Status | Criterion |
| --- | --- |
| Available | The command exists and the version meets the project declaration |
| Partially available | The command exists but the version is insufficient or capabilities are limited |
| Missing | The command does not exist |

## Handling

- When an equivalent alternative exists, prefer it and record the difference.
- When installation is needed, explain the purpose, source, and impact, and obtain user confirmation.
- When acceptance depends on a missing item and no alternative exists, block explicitly; do not silently skip.
- Write detection results to `.agent/environment.md`, including the time, commands, and conclusions.

## Prohibited

- Writing local paths, versions, or mirror addresses as project defaults.
- Faking verification results because a tool is missing.
- Installing global tools or modifying system configuration without confirmation.

## Boundary

This capability probes the development and target toolchain. Periodic inspection of prompts, rules, skills, memory, hooks, MCP, and subagents belongs to `capability/agent-environment`.
