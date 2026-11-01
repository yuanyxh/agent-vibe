# Contributing

Thanks for improving agent-vibe. This repository is a seed repository: it describes reusable agent development practice and does not contain a business application.

## Before you start

- Read `AGENTS.md` for directory responsibilities and the seed format.
- Search existing seeds before adding a new one.
- Keep changes technology- and project-agnostic. A seed must be instantiable by at least two projects with different stacks.
- Remove concrete project names, paths, accounts, secrets, and version numbers before submitting.

## Development workflow

1. Fork the repository and create a branch from `main`.
2. Make the change in both language trees when documentation changes: edit `en/` first, then mirror it in `zh/`.
3. Run the checks locally:

```bash
scripts/check-format.sh
scripts/verify-seeds.sh --strict
scripts/test-fixtures.sh
```

4. Commit with a conventional message, such as `feat(seeds): add a capability seed` or `docs: clarify the loading protocol`.
5. Open a pull request and fill in the template. CI runs the same checks.

## Adding or changing seeds

- Use the frontmatter fields documented in `AGENTS.md`. Do not invent platform-specific fields.
- Declare a real loading mechanism for every on-demand rule: `path`, `skill`, or `read`.
- Update `SEEDS_VERSION` and `CHANGELOG.md` when the change affects the public seed contract.
- Do not copy an external rule library automatically. Rewrite imported material in seed format and remove project details.
- Keep each rule under the line budget enforced by the checks.

## Documentation and translation

- English (`en/`, `README.md`) is authoritative; Chinese (`zh/`, `README.zh.md`) is a mirror.
- Both sides must keep the same headings, tables, list counts, and file names.
- Translate natural language only. Leave commands, paths, identifiers, and code blocks unchanged.
- Cross-references inside a language tree must point to that tree.

## Reporting security issues

Do not open a public issue for a vulnerability. Follow [SECURITY.md](SECURITY.md).

## Code of conduct

By participating, you agree to follow [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
