# One Complete Growth

Example project: a local bookkeeping command-line tool. Shown only to demonstrate the process; it does not imply a recommended technology stack.

## 1. Load init

User: Help me build a bookkeeping tool from scratch.

The agent reads `seeds/en/skills/init/SKILL.md`, detects that the directory is empty, and starts asking questions.

## 2. Round 1: Positioning

| Question | Recommendation | User answer |
| --- | --- | --- |
| Project name | ledger | Accepted |
| One-line summary | Record and summarize daily income and expenses locally | Accepted |
| Form | cli | Accepted |
| Scale | mvp | Accepted |

## 3. Round 2: Technology stack

Based on `project.type = cli`, the agent offers language and package manager options. The user chooses the recommended values.

## 4. Later rounds

Complete data, delivery, quality, and the agent platform according to the question tree. The user answers "use the recommendation" for each round.

## 5. Summary confirmation

The agent outputs all fields and their sources. The user changes only one item: CI is not needed. Everything else is confirmed.

## 6. Growth

Generate according to `protocols/en/grow.md` (landing points shown with the Claude Code adapter as an example):

```text
ledger/
├── <normal project structure>
├── AGENTS.md
├── .claude/
│   ├── skills/{build,review,hunt,learn,upgrade,ship,operate}/SKILL.md
│   └── rules/{core,build,review,deploy}.md
└── .agent/
    ├── profile.yaml
    ├── status.md
    ├── decisions.md
    └── lessons.md
```

Matched rules: all of `core`; `by-type/cli`; `by-concern/testing`. Not matched: `deploy` because the deployment target is none, `ui` because there is no interface.

## 7. Verification

Run `protocols/en/verify.md`: all paths exist, no placeholders remain, build and test commands pass, and the contract contains the four indexes.

## 8. Later cycles

- Implement a command: load `build`.
- Find an amount precision bug: load `hunt` and add a regression test.
- Before merging: load `review`.
- Retrospective: load `learn` and write project lessons to `.agent/lessons.md`.
- Outdated dependencies: load `upgrade`.
- Release a new version: load `ship`.
