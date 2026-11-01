---
id: capability/dev-environment
kind: capability
summary: The project runs reproducibly in the environment used by developers
triggers:
  - New project initialization
  - The user mentions editor, IDE, terminal, or toolchain preferences
  - "It doesn't run on my machine" occurs
questions:
  - Which editors or IDEs are used
  - Whether language and tool versions must be pinned
  - Which command entry point is preferred
  - Whether containerization or remote development is needed
research:
  - Current workspace configuration methods for the selected editor
  - Current usage of the selected toolchain version manager
  - Conventions of the selected command entry point
generates:
  - type: config
    examples: [editor workspace configuration, version declarations, task entry points, debug configuration]
  - type: doc
    examples: [environment setup instructions, troubleshooting]
verify:
  - A new environment can be running within ten minutes by following the documentation
  - Version declarations match those used by CI
  - Configuration files contain no personal paths or credentials
---

# Development Environment

## Goal

Anyone following the repository instructions gets a development environment consistent with the maintainer's; differences are stated explicitly rather than passed on by word of mouth.

## Generation principles

- First understand the environment the user actually uses; do not assume an editor.
- Verify current official practices before generating specific configuration after the environment is determined; product names in examples are not defaults.
- If the environment is unspecified, generate only environment-independent parts (version declarations, task entry points, setup instructions) and register the rest as pending growth.
- Separate personal preferences from project requirements: keep personal configuration in local ignored files and project-required configuration in version control.

## Verification

On a machine that has never been configured, installation, startup, and tests can be completed using only the repository documentation.
