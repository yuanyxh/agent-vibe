# Bootstrap Generation Protocol

init is only responsible for instantiating seeds into a developable engineering base; it is not responsible for implementing business functionality.

## Prerequisites

- Project profile confirmed.
- Target project path determined and separated from the seed repository.
- Minimum required domain questions covered.

## Artifact Checklist

The following must actually exist and be non-empty in the target project:

| Artifact | Criterion |
| --- | --- |
| `.agent/profile.yaml` | All required fields complete, including `seed_version` |
| `.agent/status.md`, `decisions.md`, `lessons.md` | Have initial content |
| `.agent/memory/README.md`, `INDEX.md` | Exist and the index is searchable |
| `.agent/environment.md` | Contains probe records |
| `.agent/research.md` | Contains version baseline, practice checklist, agent asset inventory, sources, and accept/reject reasons |
| `.agent/domains/<name>.md` | One per domain |
| `.agent/knowledge/README.md` | Contains topics and trigger conditions |
| Rule files | Placed in layers per `protocols/en/loading.md`; core inlined, the rest may point to actual mechanisms |
| Skill files | At least one valid skill; header contains only platform fields; body states the rules to read |
| Bootstrap contract | Contains always-on constraints, loading strategy, skill index, work loop, and verification commands |
| Engineering configuration | Formatting, static checks, type checks, ignore rules |
| Local hooks | `pre-commit` and `commit-msg` executable, `core.hooksPath` set, commands consistent with `verify.format` / `verify.lint` |
| PR template | `.github/PULL_REQUEST_TEMPLATE.md` exists when `repo_host=github` |
| Project skeleton | A minimal buildable structure without business functionality |

## Order

1. Create the target directory.
2. Write the status, profile (including `seed_version`), and memory index skeleton.
3. Perform environment probing.
4. Write best practices and agent asset inventory conclusions per `protocols/en/research.md`.
5. Generate the project skeleton and engineering configuration.
6. Grow capabilities and domain definitions.
7. Generate the loading checklist per `protocols/en/loading.md`: the layer, trigger, and mechanism for each item.
8. Instantiate rules and skills, writing file by file; creating only directories is forbidden.
9. Generate the bootstrap contract, inlining only always-on content and the index.
10. Verify that everything is non-empty, executable, and within budget.
11. Output the base checklist and wait for user confirmation.
12. End init after user confirmation.

## Verification

- Use the directory checklist to confirm every artifact exists and is non-empty.
- Run `scripts/verify-instantiation.sh <target path>` and reduce errors to zero.
- Check research: `.agent/research.md` exists; external facts have sources, versions, and dates; accepted items have mappings.
- Run engineering commands: format check, static check, build.
- Check that skill headers contain only platform-recognized fields and rules contain no seed metadata.
- Check loading: always-on ≤ 200 lines, core inlined ≤ 60 lines, no unscoped rules other than core.
- Check that every on-demand item has an actual mechanism; mark degradation when no native mechanism exists.
- Check that the startup read set contains only the contract and status files.
- Any failure must be fixed first; do not proceed to final confirmation.

## Ending

After confirmation, output explicitly:

```text
Base ready: <target path>
For subsequent development, run build in that directory.
```

init ends here. Do not continue implementing business functionality or game logic within init.

## Prohibited

- Creating only empty directories without writing content.
- Developing a business project directly inside the seed repository.
- Mixing base generation and business development in one execution.
- Continuing to write feature code before the base is confirmed.
