# Scaffold conventions

The core repository defines **structural requirements**, not the directory layout or configuration of a specific framework. Concrete technical structure comes from one of two sources: an optional technology pack under `packs/`, or the agent generating it from these conventions.

## Generation priority

1. A matching technology pack exists in `packs/` → generate from the pack.
2. No matching pack → the agent generates a minimal runnable structure from these conventions and the public conventions of the chosen stack.
3. Both paths must run `protocols/en/verify.md`; a failing command counts as a failure.

## General requirements

Every generated project must have:

| Item | Criterion |
| --- | --- |
| Dependency manifest | Declares all runtime and development dependencies; versions are locked |
| Entry point | A clear startup entry; the run command works |
| Build | A build command; artifacts are reproducible |
| Tests | A test command; at least one executable test |
| Configuration | Environment differences are injected through configuration; sample configuration contains no real credentials |
| Documentation | README explains install, run, and test |
| Ignore rules | Version control ignores build outputs, dependency directories, and local configuration |
| Local hooks | Executable, `core.hooksPath` configured, and commands match `verify.format` / `verify.lint` |

## Structural elements by project type

| Type | Required | Must not contain |
| --- | --- | --- |
| web | Entry page, routing or view organization, styling approach, build output | Server-side secrets |
| backend | Startup entry, routing/API layer, configuration loading, health check | Frontend build chain |
| cli | Command entry, argument parsing, exit codes, help output | A long-running service process |
| library | Public entry, export manifest, documentation, version policy | Example business logic |
| mobile | Application entry, page organization, platform configuration, build targets | Platform-independent server code |
| desktop | Main process and UI entry, packaging configuration, platform signing placeholder | Undeclared native dependencies |

## Hooks and templates

| Template | Destination | Requirement |
| --- | --- | --- |
| `hooks/pre-commit` | `.githooks/pre-commit` | Replace `{{verify.format}}`, `{{verify.lint}}`, `{{verify.typecheck}}`; use `none` when undeclared; executable |
| `hooks/commit-msg` | `.githooks/commit-msg` | Validate `type(scope): summary` per VCS-02; executable |
| `hooks/agent-maintenance` | Adapter-defined hook location | Emit one reminder when the health report is missing or stale; no network; executable |
| `github/PULL_REQUEST_TEMPLATE.md` | `.github/PULL_REQUEST_TEMPLATE.md` | Generated when `repo_host=github` |

Install with `git config core.hooksPath .githooks`. Hooks and CI must run the same commands; a failure blocks the commit.

## Minimalism

- Generate only the files needed for the project to run, test, and build.
- Do not pre-populate business code, sample pages, or unused dependencies.
- Every generated file must be used by the build or by verification.

## Done criterion

After generating in an empty directory, the install, build, and test commands all succeed, and no placeholders remain in the output.
