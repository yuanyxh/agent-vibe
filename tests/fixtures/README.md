# Instantiation regression fixtures

- `golden/`: a minimal snapshot of one init run, covering the contract, state, rules, skills, memory index, and executable hooks.
- `broken/`: a negative fixture that deliberately violates contract, metadata, and hook rules; it must be rejected.

Run `scripts/test-fixtures.sh`. If a seed change breaks the golden fixture, decide first whether the fixture is stale or the generation rules regressed. Never edit the fixture just to make it pass.
