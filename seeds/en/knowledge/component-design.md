---
id: knowledge/component-design
kind: knowledge
summary: Component layering, state ownership, and design systems
applies_when: { ui.has_ui: true }
triggers: [component bloat, inconsistent style, building a design system]
sources: [User design documents "Component Design" and "Frontend Theme Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Components and Theme

## Problem

Make the UI reusable, composable, and consistently evolvable instead of copying page code repeatedly.

## Patterns

- **Layering**: base components (buttons, inputs) → composite components (forms, tables) → business components (order cards) → pages.
- **State ownership**: keep local state inside components; lift cross-component state; leave server state to the request layer.
- **Contracts**: few but clear props; choose controlled or uncontrolled explicitly and document it; event names convey intent.
- **Composition first**: compose with children and slots; avoid adding a boolean switch for every scenario.
- **Styling**: centralize design tokens (color, spacing, typography); components do not reach in and modify internal styles.
- **Accessibility**: semantic elements, keyboard, focus, labels, and error messages are part of the component contract.

## Trade-offs

- Premature abstraction creates hard-to-use generic components; abstract after the third repetition.
- Business components depend on the domain model and should not sink into the base layer.

## Verification

- The same component behaves consistently across pages.
- Core operations can be completed with the keyboard.
- Theme switching does not break layout or contrast.
- Component examples run directly.

## Counterexamples

- One component covering every scenario with many boolean switches.
- Pages directly modifying a component's internal styles.
- Base components depending on business APIs.
- Supporting mouse input only.

## Sources

User "Component Design" and "Frontend Theme Design".
