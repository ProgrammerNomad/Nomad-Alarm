# Changelog

All notable changes to Nomad Alarm are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

### Added
* Flutter app scaffold (Phase 0 + Phase 1)
* Material 3 theme, go_router bottom nav, Splash/Welcome/Permissions onboarding
* Isar database with all collections and SettingsRepository
* Settings screen, Permission Center, logo on splash/welcome/about/app icon
* GitHub Actions CI and unit/widget tests
* Design System (`docs/DESIGN_SYSTEM.md`) - colors, typography, spacing, M3 tokens, components
* User Flows (`docs/USER_FLOWS.md`) - end-to-end UX paths
* Diagrams (`docs/DIAGRAMS.md`) - Mermaid architecture, sequence, state, ER diagrams
* Repository layer spec (`docs/REPOSITORIES.md`) - data access between controllers and services
* Error Handling guide (`docs/ERROR_HANDLING.md`)
* Internal Events catalog (`docs/EVENTS.md`) - local-only, no analytics
* Feature Flags (`docs/FEATURE_FLAGS.md`)
* Constants reference (`docs/CONSTANTS.md`)
* Battery strategy (`docs/BATTERY.md`)
* Internationalization guide (`docs/L10N.md`)
* Assets inventory (`docs/ASSETS.md`)
* Sound specification (`docs/SOUNDS.md`)
* Widgets spec (`docs/WIDGETS.md`)
* Play Store checklist (`docs/PLAY_STORE.md`)
* Release Checklist (`RELEASE_CHECKLIST.md`)
* Versioning guide (`VERSIONING.md`)
* GitHub issue templates (bug, feature, question)
* GitHub labels and discussions guides (`.github/`)
* Updated Architecture with repository layer

### Changed
* Architecture docs now use Controller → Repository → Service → DB flow
* Documentation index expanded with reading order and categories

---

## [0.1.0] - 2026-07-28

### Added
* Initial repository with README and project documentation
* Master Blueprint defining vision, features, and technology stack

---

[Unreleased]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/releases/tag/v0.1.0
