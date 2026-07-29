# Changelog

All notable changes to Nomad Alarm are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

### Fixed
* Android splash hang on x86 emulators - pin `path_provider_android` to 2.2.23 (pre-JNI); show retry UI if bootstrap fails
* Isar `libisar.so` not found on emulator - import `isar_flutter_libs` in `main.dart`; repair pub cache if `jniLibs` missing, then `flutter clean` rebuild

---

## [1.5.2] - 2026-07-29

### Added
* **Debug screen l10n** (en + hi) - all tiles, buttons, and snapshot copy
* **Runtime language sync** - Settings language change updates notifications, widgets, and tile without restart
* **Boot receiver (opt-in)** - `resumeAlarmAfterBoot` setting relaunches app after reboot to resume active alarms
* Widget tests: Search, History, Trips (en + hi empty states)
* Unit test: `deep_link_service_test`; integration test: `app_launch_test`

### Changed
* About screen uses localized version label; active alarm uses localized speed/accuracy units
* Background foreground service startup notification localized
* Version bumped to 1.5.2+4
* Docs and QA matrix synced for v1.5.2

---

## [1.5.1] - 2026-07-29

### Added
* **Full en/hi localization** for Search, Map, History, Trips, notifications, and home screen widgets
* **Deep link / share import** - geo URIs, Google Maps URLs, raw coordinates; clipboard import on Search; splash routing to alarm config
* **Quick Settings tile** - live distance when alarm active; tap opens active alarm screen
* **Favorite trips** - save completed trip as reusable favorite; create alarm from trip detail
* **Widget polish** - medium widget approach progress bar; large (4×3) widget with distance, speed, and progress
* **Accessibility** - Semantics on search, map pin actions, history delete, trips, deep-link import
* Unit tests: `deep_link_parser_test`, `favorite_trip_test`

### Changed
* Feature flags enabled: `deepLinkImport`, `quickSettingsTile`
* Version bumped to 1.5.1+3
* Docs synced (ROADMAP, SETUP, ARCHITECTURE, SERVICES, TESTING)

> **Note:** Play Store publish remains pending until [RELEASE_QA_SIGNOFF.md](docs/RELEASE_QA_SIGNOFF.md) is completed on device.

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

[Unreleased]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.5.2...HEAD
[1.5.2]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.5.1...v1.5.2
[1.5.1]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.0.0...v1.5.0
[1.0.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/releases/tag/v0.1.0
