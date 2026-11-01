# Regression Example: A Red Alert-Style RTS

Used to verify that init does not get carried away by technology stack questions under a request such as "I want to build a Red Alert game".

## User

> I want to build a Red Alert-style game.

## Correct init behavior

### Round 1: Positioning

- Project name and one-line goal
- Form: Web / desktop / console
- Scale: prototype / MVP / complete
- Domain: game / RTS

### Round 2: Minimum mandatory domain questions

| Question | Why it cannot be skipped |
| --- | --- |
| Single-player or multiplayer | Determines architecture, synchronization, servers, and testing approach |
| Target platforms and devices | Determines engine, input, and performance baseline |
| Asset sources and copyright | Determines whether original assets can be used or content must be created from scratch |
| MVP scope | Factions, units, buildings, levels, and map counts |
| Input devices | Keyboard and mouse, touch, gamepad |
| Performance targets | Unit count, frame rate, load time |
| Saves and progress | Whether persistence and recovery are required |
| Distribution | Web, installer, store |

### Round 3: Technology stack and delivery

Only after positioning and domain questions are confirmed, ask about language, engine, build, testing, and distribution.

### Round 4: Quality and governance

Test levels, performance budgets, licensing, asset declarations, supply chain.

### Completeness gate

Output a checklist confirming that each of the following has a value or an explicit inference:

- Required project profile fields
- Minimum mandatory domain questions
- Development and target environments
- Build, test, and release
- Licensing and asset sources

## Incorrect behavior

- When the user says "build a Red Alert game", only asking "which technology stack/engine".
- Handing over a solution or writing code right after asking about the stack.
- No project profile, domain definition, rules, or quality gate.
- Not confirming asset copyright and MVP scope.

## Acceptance

If "start work after only asking about the stack" occurs, the init entry or the completeness gate is judged to have failed.
