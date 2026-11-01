# Distill Protocol

Converge experience validated in concrete projects into abstract seeds.

## Triggers

- The `learn` skill finds the same pattern recurring in more than two projects or more than two iterations.
- The user explicitly requests distillation.

## Admission Criteria

An experience becomes a seed candidate only when it satisfies all of the following conditions at once:

1. Has observable evidence: defect reproduction, test results, review conclusions, or release incidents.
2. Is independent of technology stack, or can be precisely scoped by `applies_when`.
3. Can be written as a decidable rule rather than a slogan.

## Sanitization

Before entering seeds, remove: project names, absolute paths, account names, secrets, internal links, version numbers, people's names, and specific business data. Use placeholders such as `<project>` and `<command>` when necessary.

## Steps

1. **Generalize**: state the facts, trigger conditions, and counterexamples of the experience.
2. **Abstract**: rewrite concrete practices as judgment criteria and verification methods.
3. **Deduplicate**: search existing seeds; merge synonyms and mark the supersession relationship on conflict.
4. **Trial instantiation**: use two hypothetical project profiles with different technology stacks to verify the seed is actionable.
5. **Human confirmation**: write to `seeds/en/` only after user confirmation.
6. **Back-reference**: keep a pointer in the source project; do not copy the full text.

## Prohibited

- Escalating a one-off problem directly into a general rule.
- Writing project-specific commands, release checklists, or private boundaries into seeds.
- Automatically modifying `seeds/en/` without user confirmation.
