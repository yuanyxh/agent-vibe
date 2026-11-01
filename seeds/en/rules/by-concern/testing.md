---
id: seed/rule/concern-testing
kind: rule
version: 3
updated: 2026-10-29
review_by: 2027-01-29
status: active
load: on-demand
trigger: When writing tests, fixing defects or verifying before release
load_via: skill
skills: [build, review]
summary: Testing and quality gates
applies_when: { project.type: any }
requires: [quality.test_level]
grow: on-init
emits: rule/skill
verify: Each rule can be verified by a command or check
---

# Testing Rules

## TST-01 Verify behavior

**Rule**: Tests assert user-observable behavior and contracts, not internal implementation details.

**Prohibited**: Exposing private implementation to make tests pass.

**Verify**: Behavior tests still pass after refactoring internal structure.

## TST-02 Defects fail first

**Rule**: Before fixing a defect, write a test that fails; after the fix, that test passes.

**Prohibited**: Changing code directly without evidence of reproduction.

**Verify**: The test fails before the fix and passes after it.

## TST-03 Independent and repeatable

**Rule**: Tests do not depend on execution order, external time, the real network or shared mutable state.

**Prohibited**: Tests affecting each other through leftover data.

**Verify**: Tests pass in random order and when run individually.

## TST-04 Quality gates are command-based

**Rule**: The commands for the test levels are written into the startup contract and must actually run before release.

**Prohibited**: Replacing executable quality gates with human judgment.

**Verify**: The most recent execution results are recorded in `.agent/status.md`.

## TST-05 Red-green loop at the strict level

**Rule**: When `quality.test_level` is `strict`, advance new features in vertical slices: first write a failing test, then write just enough implementation to make it pass, then move to the next slice.

**Prohibited**: Writing all tests before implementing; implementing before writing tests; spanning multiple slices at once.

**Verify**: The delivery summary lists slices and their tests; each test was failing before the implementation.

## TST-06 Independent expected values

**Rule**: Expected values in assertions come from known literals, pre-verified examples or specifications, and are not recomputed by the logic under test in the same way.

**Prohibited**: Generating expected values with the same formula as the implementation under test, or asserting that a constant equals itself.

**Verify**: Tests still pass when the implementation algorithm changes but behavior stays the same; tests fail when the implementation is wrong.

## TST-07 Evidence levels

**Rule**: Verification conclusions at delivery must be labeled with an evidence level, and the strength of a conclusion must not exceed its evidence level:

- **L1 Existence**: The build passes, the artifact contains the target symbol, and the code path is reachable.
- **L2 Behavior**: Tests, scripts or log assertions prove the target branch executes as expected.
- **L3 End-to-end**: Real interactions, running processes or screenshots prove that user-perceivable results are correct.

**Prohibited**: Using L1 evidence to state "the feature works", "verification passed" or "fixed".

**Verify**: Each conclusion in the delivery summary is labeled with its level; when L3 is not reached, list the pending items and responsible parties.

## TST-08 Verification for systems that cannot be unit tested

**Rule**: For systems that cannot be unit tested (GUI, hardware, interaction, external services), add verification based on repeatability: prefer automated scripts plus screenshot/screen-recording/log assertions, then structured manual steps; commit scripts, assertions and samples.

**Prohibited**: Skipping verification on the grounds that there is no test framework, or substituting one-off manual operations for repeatable verification.

**Verify**: When a similar defect recurs, existing scripts or assertions provide a failure signal.

## TST-09 Handing off manual verification

**Rule**: When verification must be performed by a human, output a handoff checklist: no more than 5 action steps, the expected phenomenon for each step, and the report format (pass/fail plus actual phenomenon); confirm the required permissions and recovery method before execution.

**Prohibited**: Delegating verification wholesale with only "deploy and test it" or "you try it".

**Verify**: Another person can execute the checklist directly without context and give a clear conclusion.
