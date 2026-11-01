# Changelog

The seed repository is versioned by `SEEDS_VERSION` using semantic versioning. Generated projects record `seed_version` in `.agent/profile.yaml` and upgrade per `protocols/en/upgrade-seeds.md`.

## 1.1.0 - 2026-11-01

- Restructure documentation into `en/` and `zh/` trees under `seeds/`, `protocols/`, `adapters/`, `examples/`, and `packs/`.
- Make English the authoritative documentation language and add a complete Chinese mirror.
- Add `LICENSE` (MIT), `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, issue templates, and an expanded `.gitignore`.
- Extend `scripts/verify-seeds.sh` to validate both language trees, their platform matrices, adapters, and cross-document links.
- Translate user-facing script output to English.
- Add bilingual README, CAPABILITIES, AGENTS, and CHANGELOG.

## 1.0.0 - 2026-10-29

- First versioned release: add `SEEDS_VERSION`, this changelog, and `protocols/upgrade-seeds.md`.
- Add the Codex adapter; `generic` now covers generic platforms only.
- Add five high-frequency domain reference definitions: web-app, backend, cli, web-marketing, desktop.
- Add entry numbering, capacity archival, and external entry references to the memory protocol.
- Add instantiation checks and a golden fixture; extend semantic checks in the seed verifier.
- Add CI so seed checks run on every push and pull request.
