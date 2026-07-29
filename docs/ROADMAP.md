# Implementation Roadmap

Phased plan to build Nomad Alarm from zero to release. Each phase has clear deliverables and acceptance criteria.

**Status (2026-07-29):** Phases 0–7 implemented. v1.5.2 polish complete in code. Play Store publish and device QA sign-off remain your decision when ready.

---

## Phase 0 - Project Foundation

**Goal:** Runnable Flutter skeleton with architecture in place.

### Tasks
- [ ] Create Flutter project (`com.nomad.alarm`)
- [ ] Add dependencies (Riverpod, go_router, Isar, geolocator, etc.)
- [ ] Set up folder structure per [Architecture](ARCHITECTURE.md)
- [ ] Configure Material 3 theme (light, dark, dynamic color)
- [ ] Implement `app_router.dart` with bottom nav shell
- [ ] Placeholder screens for all routes
- [ ] Set up GitHub Actions (analyze + test)

### Acceptance Criteria
* App launches to Splash → Home
* Bottom navigation works across 4 tabs
* `flutter analyze` passes with zero issues

---

## Phase 1 - Core Data & Settings (v1.0 foundation)

**Goal:** Local persistence and app settings working.

### Tasks
- [ ] Define Isar models (see [Database](DATABASE.md))
- [ ] Implement `SettingsService` + settings screen sections
- [ ] Implement `PermissionService` + permission center UI
- [ ] Welcome + permissions onboarding flow
- [ ] Store units, theme, language preferences

### Acceptance Criteria
* Settings persist across app restarts
* First launch shows Welcome → Permissions
* Permission status visible in Permission Center

---

## Phase 2 - Location & Maps (v1.0)

**Goal:** User can see location and pick a destination.

### Tasks
- [ ] Implement `LocationService` (foreground + stream)
- [ ] MapLibre integration with OSM tiles
- [ ] Map screen: current location, zoom, compass, drop pin
- [ ] Implement `SearchService` (Nominatim default)
- [ ] Search screen with suggestions, recent, favorites
- [ ] Save favorites and recent searches to Isar

### Acceptance Criteria
* Map shows accurate current location
* Search returns stations/landmarks offline-degraded (cache recent)
* User can drop pin and save as favorite

---

## Phase 3 - Alarm Engine (v1.0 core)

**Goal:** Reliable location alarm that triggers before destination.

### Tasks
- [ ] Alarm config screen (distance, voice, vibration, repeat)
- [ ] Implement `AlarmService` (create, start, pause, cancel, evaluate)
- [ ] Haversine distance calculation
- [ ] Trigger logic: distance threshold, geofence enter
- [ ] Active alarm screen (live distance, ETA, speed, accuracy)
- [ ] Smart detection: GPS lost, destination passed, low battery warnings

### Acceptance Criteria
* Alarm triggers within configured distance of destination
* Active alarm updates distance in real time
* User can cancel/pause from notification and screen

---

## Phase 4 - Background & Notifications (v1.0 critical)

**Goal:** Alarm works with screen off and app in background.

### Tasks
- [ ] Android foreground service setup
- [ ] Persistent notification with distance/ETA
- [ ] `NotificationService` channels (tracking, alarm, alerts)
- [ ] Alarm ring screen (full screen intent)
- [ ] TTS voice alerts (`SpeechService`)
- [ ] Vibration + flashlight on trigger
- [ ] Exact alarm permission (Android 12+)
- [ ] Boot receiver (optional restart - off by default)

See [Permissions](PERMISSIONS.md).

### Acceptance Criteria
* Tracking continues for 30+ minutes with screen off
* Alarm ring wakes device reliably
* Foreground notification always visible during active alarm

---

## Phase 5 - History & Trips (v1.0)

**Goal:** Record completed and missed alarms.

### Tasks
- [ ] Trip model + auto trip logging during active alarm
- [ ] History screen: completed, missed, filters
- [ ] Trips tab: list with distance, duration, destination
- [ ] Persist history to Isar

### Acceptance Criteria
* Completed alarm appears in history with timestamp and distance
* Missed/dismissed alarms logged correctly

---

## Phase 6 - Polish & Release (v1.0)

**Goal:** Production-ready v1.0 on Android.

### Tasks
- [ ] About, Privacy, Debug screens
- [ ] Accessibility: TalkBack labels, large text support
- [ ] Performance pass (startup, memory, battery)
- [ ] Manual test matrix (see [Testing](TESTING.md))
- [ ] App icon, splash screen, store listing assets
- [ ] Signed APK/AAB build via CI
- [ ] GitHub Release v1.0.0

### v1.0 Feature Checklist
* Core location alarms
* Map search (Nominatim)
* Background tracking
* Notifications + voice
* History
* Settings

---

## Phase 7 - v1.5 Enhancements ✅ (implemented in v1.5.0–v1.5.1)

**Goal:** Convenience features without compromising reliability.

### Tasks
- [x] Home screen widgets (small, medium, large)
- [x] Quick Settings tile (live distance; tap opens active alarm)
- [x] Favorite trips (save route + destination combo)
- [x] Share/import destination (geo URI, Google Maps links)
- [x] Backup/restore JSON export/import
- [x] Full en/hi UI + notification localization (v1.5.1)
- [x] Medium widget progress bar + large widget (v1.5.1)

### Acceptance Criteria
* Widget shows active alarm distance ✅
* Backup file restores alarms and favorites on new device ✅
* Share Google Maps link → alarm config prefilled ✅
* Hindi toggles Search, Map, History, Trips ✅

---

## Phase 7.5 - v1.5.2 Polish ✅

**Goal:** Close remaining l10n gaps, runtime language sync, boot resume, and test coverage.

### Tasks
- [x] Debug, About version, active-alarm units, FGS startup l10n
- [x] Runtime notification/widget/tile language sync on Settings change
- [x] Boot receiver + `resumeAlarmAfterBoot` setting (default off)
- [x] Widget tests (Search, History, Trips) + deep_link_service_test + app_launch integration test
- [x] RELEASE_QA_SIGNOFF and docs synced for v1.5.2

### Acceptance Criteria
* Hindi toggles Debug and About version line ✅
* Language change updates notification actions mid-session ✅
* Boot resume opt-in relaunches app after reboot ✅
* 55+ automated tests ✅

---

## Phase 8 - v2.0 Multi-Provider

**Goal:** Optional premium map/search providers via BYO API keys.

### Tasks
- [ ] Provider abstraction layer (Map, Search, Route)
- [ ] Google Maps / Places / Directions (user API keys)
- [ ] HERE, Mapbox optional providers
- [ ] Encrypted API key storage
- [ ] Map settings screen (provider, layer, style)
- [ ] Offline map tile download (basic region cache)

### Acceptance Criteria
* User can switch map provider in settings
* Google Maps works with user-supplied key only
* App functions fully without any API keys

---

## Phase 9 - v3.0 Advanced

**Goal:** Smart features and ecosystem expansion.

### Tasks
- [ ] AI/smart ETA prediction (on-device heuristics first)
- [ ] Group travel (share alarm config locally)
- [ ] Wear OS companion
- [ ] Android Auto minimal UI
- [ ] iOS port (future platform)

---

## Priority Matrix

| Priority | Feature | Version |
|----------|---------|---------|
| P0 | Distance alarm + background GPS | v1.0 |
| P0 | Foreground service + notification | v1.0 |
| P0 | Alarm ring (voice + vibration) | v1.0 |
| P1 | Search + map pin drop | v1.0 |
| P1 | History + trips | v1.0 |
| P2 | Widgets + quick tile | v1.5 |
| P2 | Backup/restore | v1.5 |
| P3 | Google Maps BYO | v2.0 |
| P3 | Offline maps | v2.0 |
| P4 | Wear OS, group travel | v3.0 |

---

## Definition of Done (every feature)

1. Code follows architecture layers (no UI → DB direct access)
2. Unit tests for business logic
3. Widget test for primary screen states
4. Manual test on physical Android device
5. No new analytics or tracking SDKs
6. Documented in CHANGELOG

---

## Related Docs

* [Master Blueprint](MASTER_BLUEPRINT.md)
* [Architecture](ARCHITECTURE.md)
* [Screens](SCREENS.md)
* [Testing](TESTING.md)
