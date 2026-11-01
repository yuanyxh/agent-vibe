---
id: seed/rule/concern-ui
kind: rule
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
trigger: When implementing or modifying interfaces, interactions and accessibility
load_via: path
path_scope: ui
summary: Interface and interaction
applies_when: { ui.has_ui: true }
requires: [ui.design_system, ui.a11y]
grow: on-init
emits: rule/path
verify: Rules can be judged in interface walkthroughs
---

# Interface Rules

## UIX-01 Complete states

**Rule**: Every data area has four states: loading, empty, error and success, and each states the available actions.

**Prohibited**: Implementing only the success state.

**Verify**: The interface remains understandable when the network is disconnected and when empty data is returned.

## UIX-02 Timely feedback

**Rule**: Operations taking longer than 100 milliseconds give in-progress feedback; failures explain the reason and recovery method.

**Prohibited**: No feedback at all after an operation, or only changing the mouse cursor.

**Verify**: On a slow network, users can tell what the system is doing.

## UIX-03 Consistency first

**Rule**: Copy, spacing, interaction and error messages for similar elements stay consistent, and existing patterns are reused first.

**Prohibited**: Inventing a new interaction paradigm for a single page.

**Verify**: Interface elements in similar scenarios can be compared and are consistent.

## UIX-04 Accessibility

**Rule**: Meet the accessibility level declared in the project profile; core flows are completable with the keyboard.

**Prohibited**: Completing critical operations only through dragging, hovering or color distinction.

**Verify**: Keyboard and screen-reader walkthroughs pass.
