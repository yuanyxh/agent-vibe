# Technology Packs

Optional extensions that make project structures reproducible for a specific technology stack. The core repository does not bundle any technology pack.

## When Needed

- The same technology stack needs repeated project creation.
- The team has unified conventions for directories and configuration.
- On-the-spot generation is unstable and needs to be fixed.

Only these cases justify building a pack; other projects are generated on the spot by the agent.

## Structure

```text
packs/<pack-name>/
├── pack.yaml
└── files/            # optional, files to copy as-is
```

```yaml
---
id: pack/<name>
summary: <technology stack and applicable form>
applies_when:
  project.type: web
  stack.framework: react
requires: [stack.package_manager]
provides:
  - build and development commands
  - directory structure
verify:
  install: <command>
  build: <command>
  test: <command>
---
```

The body describes: directory conventions, responsibilities of key files, differences from other technology stacks, and known limitations.

## Constraints

- Technology packs may only provide structure, configuration, and commands; they must not override seed rules; on conflict, seeds prevail.
- Packs must not contain credentials, private addresses, or business code.
- A pack is considered usable only after it has actually generated and passed verification commands.
- Technology packs are private assets after forking and are not recommended for contribution back to the core repository; general patterns should first be distilled into seeds per `protocols/en/distill.md`.
