---
id: adapter/claude-code-install
applies_when: { agent.platform: claude-code }
---

# Claude Code Installation

The seed repository itself does not run directly. After forking to the target project, first install the entry skill to a location where Claude Code can trigger it automatically.

## Steps

1. Create `.claude/skills/init/`.
2. Copy `seeds/en/skills/init/SKILL.md`, keeping only the `name` and `description` header; leave the body unchanged.
3. Confirm `.claude/skills/init/SKILL.md` exists, and that `description` contains natural-language phrasings such as "start", "kick off", "I want to build", and "help me make".
4. Generate the `CLAUDE.md` bootstrap contract; the first item states: when `.agent/profile.yaml` is missing, run init first.
5. Start a new session, enter "I want to build an X", and confirm that init is loaded and starts asking questions.

## Why

`seeds/en/skills/` contains abstract seeds that the platform does not discover automatically. Only when located at `.claude/skills/` is it triggered by `description`. Without installation, the model may go straight into technology selection or coding.

## Post-Installation Self-Check

- When no profile is provided, the agent must not select a technology stack directly.
- Questions cover positioning, domain, environment, delivery, quality, governance, and supply chain.
- Output a completeness checklist before generation.

## Other Platforms

See the corresponding adapters for the placement of Cursor and generic `AGENTS.md`; the core requirement is the same: the entry must be in a location the platform can discover.
