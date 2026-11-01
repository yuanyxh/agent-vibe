## Change

<!-- Describe which seeds, protocols, or adapters changed and the impact -->

## Checks

- [ ] `scripts/check-format.sh`
- [ ] `scripts/verify-seeds.sh --strict`
- [ ] `scripts/test-fixtures.sh`
- [ ] Updated `SEEDS_VERSION` and `CHANGELOG.md` when the change affects seeds
- [ ] New rules can be verified by a command or check
- [ ] Updated the `en` and `zh` trees together

## Review checklist

- [ ] Seeds contain no concrete project, stack, personal path, or credential
- [ ] Rules have a trigger, a loading mechanism, and a verification method
- [ ] Adapters match the platform matrix in `protocols/en/loading.md`
- [ ] Document references and links resolve
- [ ] The golden fixture result did not degrade

## Related

<!-- Decision record, migration impact, or rollback plan -->
