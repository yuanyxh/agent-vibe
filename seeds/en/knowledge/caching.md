---
id: knowledge/caching
kind: knowledge
summary: Cache layering, invalidation, and consistency
applies_when: { project.domain: "web-app|backend" }
triggers: [performance bottlenecks, introducing caching, data inconsistency]
sources: [User design document "Cache Design"]
version: 1
updated: 2026-10-23
review_by: 2027-01-23
status: active
load: on-demand
---

# Caching

## Problem

Return data faster at lower cost while avoiding stale or incorrect results.

## Patterns

- **Layering**: browser, CDN, application memory, distributed cache, database; each layer has its own invalidation strategy.
- **Key design**: include tenant, user, language, and data version to avoid cross-context data leaks.
- **Invalidation**: invalidate actively after writes; when precise invalidation is impossible, use short TTLs and version numbers.
- **Penetration and avalanche**: cache empty results, merge requests, and add random jitter to expiry times.
- **Permission data**: permission changes must invalidate related caches, otherwise privilege escalation or false denials occur.

## Trade-offs

| Strategy | Suitable for | Cost |
| --- | --- | --- |
| Short TTL | Briefly stale results acceptable | Lower hit rate |
| Active invalidation | Strong consistency requirements | Requires reliable events or transactions |
| Version number | Bulk invalidation | Requires a unified version source |

## Verification

- Read-after-write is consistent within an acceptable time.
- Cache hits and misses return the same result.
- Old caches stop taking effect after permission changes.
- The system degrades rather than errors when the cache is unavailable.

## Counterexamples

- Cache keys missing tenant or user dimensions.
- Setting only a TTL without active invalidation, leaving critical data stale for a long time.
- Treating the cache as the only data source.
- Cache failures directly causing request failures.

## Sources

User "Cache Design"; read invalidation and consistency together with `consistency.md`.
