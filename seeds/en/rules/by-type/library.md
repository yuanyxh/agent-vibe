---
id: seed/rule/type-library
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When designing or modifying public interfaces, versions and releases
load_via: path
path_scope: source
summary: General rules for reusable libraries
applies_when: { project.type: library }
requires: []
grow: on-init
emits: rule/path
verify: Rules are language-agnostic and decidable
---

# Library Rules

## LIB-01 Public interfaces stable

**Rule**: Public interfaces have explicit semantics and a versioning policy; breaking changes bump the major version and include migration instructions.

**Prohibited**: Changing existing interface behavior in a minor version.

**Verify**: The interface list matches the version records.

## LIB-02 Minimal dependencies

**Rule**: Keep only necessary runtime dependencies; development dependencies do not enter release artifacts.

**Prohibited**: Introducing large dependencies for a small amount of functionality.

**Verify**: Every dependency in the release artifact's dependency list has a rationale.

## LIB-03 Errors are handleable

**Rule**: Error types can be distinguished and handled by callers, and exceptions are not swallowed.

**Prohibited**: Returning only string errors or failing silently.

**Verify**: Callers can distinguish error types without parsing text.

## LIB-04 Documentation is the contract

**Rule**: Every public interface has purpose, parameters, return values, errors and examples.

**Prohibited**: Public interfaces lacking documentation, or examples that cannot be executed.

**Verify**: Documentation examples run and their results match the description.
