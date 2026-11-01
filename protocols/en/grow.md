# Grow Protocol

Instantiate abstract seeds into target project content.

## Triggers

| Trigger | Condition |
| --- | --- |
| `on-init` | All required fields in the project profile `profile.yaml` have values |
| `on-signal` | A clear signal appears in the conversation or code, and the corresponding fields are determined |
| `on-demand` | The user or agent explicitly requests generation of a certain kind of content |

Stop when context is insufficient; ask first. Filling with guessed values is prohibited.

## Steps

0. **Choose sources**: for project structure, prefer a matching technology pack in `packs/en/`; when no pack matches, generate on the spot according to the structural requirements in `seeds/scaffolds/README.md`. Both kinds of sources must pass verification.
1. **Match**: for artifact seeds, compare `applies_when` against the profile and check prerequisite fields with `requires`; condition values support `a|b` for either, `!x` for exclusion, and undeclared dimensions are treated as unrestricted. For capability seeds, use `triggers` to decide whether to enter. Domain definitions prefer matching in `seeds/en/domains/`; when none matches, generate on the spot per `_schema.md`, which is not considered a failure. Neither produces fixed logical artifacts.
2. **Order**: rules and documents first, then skills, then project structure and configuration; dependencies take precedence.
3. **Research**: read `.agent/research.md`; if missing, verify first per `protocols/en/research.md`. When artifacts depend on external facts (version numbers, tool usage, platform support scope, community conventions), the research conclusion takes precedence; writing defaults from memory is prohibited. Record sources, versions, and query times.
4. **Instantiate**: replace placeholder variables in the body, remove inapplicable branches, and retain judgment criteria. Do not generate dimensions whose context is undetermined; record them as pending growth.
5. **Resolve placement**: seeds declare only logical artifacts (such as `rule/always`, `rule/path`, `rule/skill`, `skill/init`, `contract`, `state/status`); the adapter corresponding to the current `agent.platform` resolves them to physical paths per `protocols/en/loading.md`. Placeholders `{{core_rules}}`, `{{loading_table}}`, and `{{skill/<name>}}` in contract templates are also replaced via the mapping. Platform directories must not appear in seeds.
6. **Strip metadata**: before writing to disk, remove the seed's `id/kind/version/updated/review_by/status/load/trigger/summary/applies_when/requires/grow/emits/verify`, keeping only fields recognized by the target platform and the body; `trigger` is converted into read conditions in the bootstrap contract.
7. **Write to disk**: write according to the resolution result; existing files must not be overwritten; instead produce a diff suggestion for user confirmation.
8. **Verify**: execute `protocols/en/verify.md`; failures must not be silently skipped.
9. **Record**: in `.agent/status.md`, record the generation checklist, ungenerated items and reasons, and sources and query times of external facts.

## Conflict Rules

- When the project profile conflicts with seed defaults, the profile prevails, and the difference is written to `.agent/decisions.md`.
- When two seeds produce the same logical artifact, the later one must merge and must not overwrite existing content.
- Existing project files must not be overwritten.
- The seed layer must not write any product, platform, or version as a default; product names may appear only as examples.

## Output

At the end of generation, output three items: generated, not generated with reasons, and content that can be grown next time.
