---
layout: default
title: Testing
parent: Developer
nav_order: 19
permalink: /TESTING/
---
# Testing Guide

Testing strategy for Nomad Alarm - focused on reliability of the core alarm flow.

---

## Test Pyramid

```
        ┌─────────────┐
        │ Integration │  Few - full alarm flow
        ├─────────────┤
        │   Widget    │  Key screens & states
        ├─────────────┤
        │    Unit     │  Business logic (most tests)
        └─────────────┘
```

---

## Unit Tests

**Priority: highest.** Fast, no device required.

### AlarmService

| Test | Description |
|------|-------------|
| `trigger_when_within_distance` | Triggers when distance <= threshold |
| `no_trigger_when_far` | Does not trigger beyond threshold |
| `detect_destination_passed` | Warns when moving away after approach |
| `pause_stops_evaluation` | Paused alarm never triggers |
| `cancel_clears_active_state` | Status → cancelled |

### Distance Utils

| Test | Description |
|------|-------------|
| `haversine_known_distance` | Verify against known lat/lng pairs |
| `eta_estimate` | Straight-line ETA math |

### Deep Link Parser

| Test | Description |
|------|-------------|
| `parse_google_maps_url` | Extract lat/lng |
| `parse_geo_uri` | Extract coords and label |
| `parse_raw_coordinates` | `28.6139, 77.2090` |

### Favorite Trips

| Test | Description |
|------|-------------|
| `saveFromTrip persists trip metadata` | Round-trip save + load favorite trip fields |

### BackupService

| Test | Description |
|------|-------------|
| `export_import_roundtrip` | Data survives export → import |
| `reject_invalid_version` | Unknown version throws clear error |

Run:

```bash
flutter test test/unit/
```

---

## Widget Tests

Test primary UI states without real GPS.

### Home Screen
* Empty state renders
* Active alarm card shows distance
* FAB navigates to alarm config

### Alarm Config
* Validation errors for missing destination
* Save button disabled when invalid

### Active Alarm
* Displays distance from mocked stream
* Cancel button calls controller

Use `ProviderScope` overrides to inject mock services.

Run:

```bash
flutter test test/widget/
```

---

## Integration Tests

Run on physical device or emulator with location simulation.

### Core Flow: Create → Track → Trigger

1. Launch app, grant permissions (use integration test driver)
2. Create alarm with destination near simulated location
3. Simulate movement toward destination (GPS mock)
4. Assert alarm ring screen appears
5. Dismiss alarm
6. Assert history entry created

Run:

```bash
flutter test integration_test/
```

---

## Manual Testing

Required before every release. Use a **physical Android device**.

### GPS Simulation

| Method | Use |
|--------|-----|
| Android Studio Extended Controls → Location | Route playback |
| `adb emu geo fix lng lat` | Emulator quick fix |
| Fake GPS app (debug only) | Physical device route simulation |

### Manual Test Matrix

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Create alarm, stay far | No trigger |
| 2 | Move within trigger distance | Alarm rings |
| 3 | Screen off for 10 min while moving | Alarm still triggers |
| 4 | Kill app from recents | Foreground service continues |
| 5 | Deny background location | Clear warning, limited mode |
| 6 | GPS lost in tunnel | Warning notification, recovers after |
| 7 | Cancel from notification | Alarm stops, service ends |
| 8 | Snooze | Re-triggers after interval |
| 9 | Low battery (< 15%) | Warning shown |
| 10 | Reboot device | Alarm does not restart (default) |
| 11 | Airplane mode | Alarm still works on GPS |
| 12 | Hindi voice setting | TTS speaks Hindi message |

---

## Battery Tests

| Test | Target |
|------|--------|
| 1 hr idle monitoring | < 1% drain |
| 2 hr active tracking | Document % drain per profile |
| Compare balanced vs saver | Saver uses less, slightly less accuracy |

Use Android Battery Historian or Settings → Battery → App usage.

---

## Performance Tests

| Metric | How to Measure | Target |
|--------|----------------|--------|
| Cold start | `flutter run --trace-startup` | < 2 s |
| APK size | `flutter build apk --analyze-size` | < 30 MB |
| RAM | Android Studio Profiler | < 150 MB active |
| Frame rate | Performance overlay | 60 FPS on UI screens |

---

## CI Pipeline

GitHub Actions deploys the docs site only (`.github/workflows/pages.yml`) on `docs/**` changes.

Flutter checks (`flutter gen-l10n`, `flutter analyze`, `flutter test`) run **locally** before release - see [Local Build](LOCAL_BUILD.md) and [QA Sign-off](RELEASE_QA_SIGNOFF.md). Integration tests also run locally (`flutter test integration_test/`).

---

## Test File Structure

```text
test/
├── unit/
│   ├── alarm_service_test.dart
│   ├── distance_utils_test.dart
│   ├── deep_link_parser_test.dart
│   └── backup_service_test.dart
├── widget/
│   ├── home_screen_test.dart
│   ├── alarm_config_screen_test.dart
│   └── active_alarm_screen_test.dart
└── mocks/
    ├── mock_location_service.dart
    └── mock_alarm_service.dart

integration_test/
├── alarm_flow_test.dart
├── group_travel_import_test.dart
└── provider_switch_test.dart
```

---

## Definition of Test Done

* All unit tests pass
* Widget tests pass for screens touched in PR
* Manual matrix items relevant to change verified on device
* No regression in battery/background behavior for alarm changes

---

## Related Docs

* [Roadmap](ROADMAP.md)
* [Services](SERVICES.md)
* [Setup](SETUP.md)
