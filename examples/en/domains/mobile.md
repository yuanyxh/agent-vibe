---
id: example/domain/mobile
kind: domain
summary: Mobile applications and cross-platform applications
applies_when: { project.domain: mobile }
core_concerns:
  - Lifecycle and foreground/background transitions
  - Offline, weak network, and retries
  - Permission requests and denial degradation
  - Package size and startup performance
  - Device and OS version coverage
  - Store compliance and privacy notices
questions:
  - Target platforms and minimum OS versions
  - Whether offline capability is required
  - Which system permissions are needed
  - Distribution channels and review requirements
research:
  - Current permission and privacy requirements of target platforms
  - Common rejection reasons in store review
  - Performance baselines on low-end devices
generates:
  - type: config
    examples: [permission declarations, offline cache, crash reporting, build variants]
  - type: test
    examples: [weak-network tests, background-recovery tests, low-end device tests]
verify:
  - Features degrade when permissions are denied
  - Weak-network and offline behavior is explicit
  - Startup time and package size meet the declared budget
pitfalls:
  - Assuming the network is always available
  - No guidance after permission denial
  - Losing state on recovery from the background
---

# Mobile Applications

## Goal

Remain usable on unstable networks and constrained devices while meeting platform review requirements.

## Generation Principles

- Network requests may fail by default; offline and retry are the norm.
- Explain the purpose before requesting a permission, and provide a degradation path after denial.
- Optimize the startup path and package size against the device baseline.
- Keep privacy notices consistent with actual data collection.

## Verification

Run core flows under weak network, offline, permission denial, background recovery, and on the minimum supported device.
