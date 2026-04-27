# Changelog

All notable changes to OS-Intelligence are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Tier 2 OSS files: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `CHANGELOG.md`, `AUTHORS.md`.

---

## [0.1.0] — 2026-04-29

Initial public release.

### Added
- 16 skills covering capture (`ctx-transcript`, `ctx-doc`, `ctx-note`, `ctx-chat`, `ctx-inspiration`), synthesis (`ctx-synthesise`, `ctx-timeline`), retrieval (`os-welcome`, `os-start`, `os-save`, `os-switch-project`), and scaffolding (`os-new-project`, `os-new-item`, `os-new-person`, `os-project-design`, `new-project`).
- 7 sub-agents for second-opinion review: `customer-voice`, `designer-reviewer`, `engineer-reviewer`, `executive-reviewer`, `legal-advisor`, `skeptic`, `uxr-analyst`.
- Context library with `file-conventions.md`, `writing-styles.md`, `writing-styles-global/` (5 audience-specific style guides), and stub configuration for `tone-of-voice.md` and `mcp-setup.md`.
- Tier 1 documentation: `README.md`, `CLAUDE.md`, `ARCHITECTURE.md`, `MIGRATION.md`, `projects.md`, `LICENSE` (Apache 2.0), `docs/addons.md`.
- Acme Corp example project demonstrating the full intelligence/ folder shape.
- Project + portfolio type system: portfolios use `TRACKER.md` and item-level memory.
- Two-layer people system: root `people/` for global identity, project-level `people/` for operational context.
- Tag taxonomy: `type/`, `project/`, `status/`, `theme/`, `item/` in YAML frontmatter.
- `current-state.md` as the live-read retrieval target loaded at `/os-start`.
