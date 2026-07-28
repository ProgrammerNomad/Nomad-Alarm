# Changelog

All notable changes to Nomad Alarm are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

### Added
* English + Hindi UI localization (`lib/l10n/`, gen-l10n) wired through Settings language
* TalkBack semantics on create alarm, cancel, dismiss, snooze, backup actions
* Local-only build guide ([LOCAL_BUILD.md](docs/LOCAL_BUILD.md))

### Changed
* Removed GitHub Actions workflow (local builds only)
* Repo cleanup: debug artifacts, orphan `placeholder_screen.dart`, stale `.github` templates
* Docs synced with code (feature flags, widgets, privacy URL, MapLibre → flutter_map)

> **Note:** `[1.0.0]` and `[1.5.0]` below are **not published** until [RELEASE_QA_SIGNOFF.md](docs/RELEASE_QA_SIGNOFF.md) is completed on a physical device and Play Store assets are captured.

---

## [1.5.0] - 2026-07-28

### Added
* **JSON backup & restore** - export/import alarms, favorites, settings, and history via Settings → Data
* **Home screen widgets** - small (2×1) and medium (4×2) Android widgets with live distance and ETA
* Dynamic app version on About screen (`package_info_plus`)
* Open source licenses screen (Play Store requirement)
* Hosted privacy policy link (`docs/PRIVACY.md`)

### Changed
* Feature flags enabled: `backupRestore`, `homeScreenWidgets`
* Version bumped to 1.5.0+2

---

## [1.0.0] - 2026-07-28

### Added
* **Location & maps** - OSM map, Nominatim search, favorites, recent destinations
* **Alarm engine** - distance-based triggers, active alarm screen, ring screen with TTS and vibration
* **Background tracking** - Android foreground service, persistent notification with live distance and ETA
* **History & trips** - auto-logged journeys, completed/missed/dismissed history
* **Settings** - theme, units, language, alarm defaults (distance, voice, vibration, flashlight), battery GPS profile
* **Permissions** - 5-step onboarding (location, notifications, background, exact alarm, battery optimization)
* **Phase 6 polish** - straight-line ETA, flashlight strobe on ring, low-battery warnings, debug screen
* Straight-line ETA on active alarm, home card, and tracking notification
* Flashlight alert option on alarm config and ring
* Low battery detection with notification and in-app banner
* Debug screen (debug builds) with GPS/service/battery snapshot
* Expanded unit, widget, and integration test coverage

### Changed
* Background GPS respects battery profile (Balanced / Aggressive / Saver) with auto-aggressive near destination
* Alarm defaults configurable from Settings and applied to new alarms

### Documentation
* Design System, User Flows, Diagrams, Repository layer, Error Handling, Events, Feature Flags
* Battery strategy, L10N guide, Play Store checklist, Release checklist, Versioning guide

---

## [0.1.0] - 2026-07-28

### Added
* Initial repository with README and project documentation
* Master Blueprint defining vision, features, and technology stack
* Flutter app scaffold (Phase 0 + Phase 1 foundation)

---

[Unreleased]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.5.0...HEAD
[1.5.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.0.0...v1.5.0
[1.0.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/releases/tag/v0.1.0
