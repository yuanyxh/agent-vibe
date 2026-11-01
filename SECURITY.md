# Security policy

## Supported versions

The latest minor release of the seed repository is supported. Security fixes are made on `main` and released as a new patch or minor version.

| Version | Supported |
| --- | --- |
| 1.1.x | Yes |
| < 1.1 | No |

## Reporting a vulnerability

Do not open a public issue, discussion, or pull request for a vulnerability.

Report it privately through GitHub Security Advisories:

<https://github.com/yuanyxh/agent-vibe/security/advisories/new>

Please include:

- The affected file or seed and the version (`SEEDS_VERSION`).
- A description of the issue and the impact on a generated project.
- Reproduction steps or a minimal example.
- Any suggested fix or mitigation.

You can expect an initial response within seven days. We will confirm the report, agree on a disclosure timeline, and credit you in the advisory unless you prefer to remain anonymous.

## Scope

This repository contains documentation, seeds, shell scripts, and CI configuration. Relevant reports include:

- A seed that instructs an agent to write secrets, bypass authorization, or execute untrusted content.
- A validation script that can be tricked into accepting an unsafe project baseline.
- A documented platform mapping that places generated content in a dangerous location.

Reports about a vulnerability in a generated project's own dependencies are out of scope unless the seed or protocol caused it.
