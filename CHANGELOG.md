# Changelog

All notable changes to Nomad Alarm are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

---

## [3.1.2] - 2026-07-30

### Fixed
* Gate location foreground service on runtime permission (prevents launch crash when resuming stale alarms)
* Suspend active alarms and redirect to permissions when location is revoked
* Defer widget, tile, and offline-map init off splash critical path (reduces emulator ANR)
* `DropdownButtonFormField` deprecations in alarm config screen

### Changed
* Removed Flutter CI workflow; docs deploy via GitHub Pages only
* Developer docs: local-only analyze/test, Windows cross-drive Kotlin cache notes
* Version bumped to 3.1.2+9

---

## [3.1.1] - 2026-07-30

### Added
* Jekyll documentation site (GitHub Pages) with privacy policy, terms, data safety, open-source pages
* Play prep checklist (`docs/PLAY_PREP.md`)

### Changed
* Developer docs synced to v3.1.0+7 code reality
* In-app privacy policy URL points to GitHub Pages (`programmernomad.github.io/Nomad-Alarm/privacy-policy/`)
* Version bumped to 3.1.1+8

---

## [3.1.0] - 2026-07-29

### Added
* Lock screen info toggle wired to notification visibility
* Internet-lost smart detection + alert notification
* Family sharing multi-alarm bundle export/import
* Map terrain layer, compass reset, Google traffic overlay
* Apple Maps provider (iOS)
* Voice search on Search screen
* Quick Settings tile create (search) / cancel actions
* Bundled Wear OS complication module + Data Layer sync
* Android Auto minimal navigation template
* iOS notification authorization scaffold
* High contrast accessibility theme
* Arabic/Hebrew l10n keys expanded

### Changed
* Version bumped to 3.1.0+7
* Docs synced: FEATURE_FLAGS, RELEASE_QA v3.1

---

## [3.0.0] - 2026-07-29

### Added
* **v2.1 polish** - background route ETA, map viewport offline download, trip polyline map, map layers, TravelMode routing profiles
* **Smart ETA** - on-device speed/route blending (`EtaPredictor`); tunnel/train-stop heuristics
* **Extended alarm types** - geofence, radius, ETA, speed, departure in evaluator + config UI
* **Group travel** - share/import alarm JSON via `GroupTravelService`
* **Ecosystem hooks** - Wear OS + Android Auto MethodChannels; iOS location background keys
* **Custom ringtone** - `RingtoneService` via `audioplayers`
* **Plus Codes** - parse stub in `DeepLinkParser`
* **Cloud backup upload** - optional HTTPS endpoint (`CloudBackupService`)
* **CI** - GitHub Actions analyze + test workflow

### Changed
* Version bumped to 3.0.0+6
* Feature flags enabled: `aiEtaPrediction`, `groupTravel`, `wearOs`, `androidAuto`, `cloudBackup`, `familySharing`
* Tracking notifications use public lock-screen visibility

---

## [2.0.0] - 2026-07-28

### Added
* **Multi-provider maps** - OSM (default), Google Maps native, Mapbox, HERE via Settings → Map - Nominatim (default), Google Places, Photon, Pelias, HERE with offline fallback to recents/favorites
* **Route service** - OSRM (default), Google Directions, GraphHopper, Valhalla; optional route-based ETA when online
* **BYO API keys** - encrypted storage (`flutter_secure_storage`); Settings → API Keys with test connection
* **Offline map tiles** - region download and cache clear via `flutter_map_tile_caching`
* Provider abstractions (`MapProvider`, `SearchProvider`, `RouteProvider`) and `ProviderFactory`
* Map Settings and API Keys screens; l10n (en + hi) for provider names and attribution
* Unit tests: provider factory, API key store, OSRM/Nominatim/Photon parsers; widget test for Map Settings

### Changed
* Version bumped to 2.0.0+5
* Search repository uses `SearchProvider`; route polyline stored on active trip when route available
* Feature flags enabled: `googleMapsProvider`, `googlePlacesSearch`, `mapboxProvider`, `hereMapsProvider`, `offlineMapTiles`

### Fixed
* Android splash hang on x86 emulators - pin `path_provider_android` to 2.2.23; retry UI if bootstrap fails
* Isar `libisar.so` not found on emulator - import `isar_flutter_libs` in `main.dart`

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

[Unreleased]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v3.1.1...HEAD
[3.1.1]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v3.1.0...v3.1.1
[3.1.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.5.2...v2.0.0
[1.5.2]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.5.1...v1.5.2
[1.5.1]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v1.0.0...v1.5.0
[1.0.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/ProgrammerNomad/Nomad-Alarm/releases/tag/v0.1.0
