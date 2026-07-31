---
layout: default
title: Architecture
parent: Developer
nav_order: 11
permalink: /ARCHITECTURE/
---
# Architecture

Detailed technical architecture for Nomad Alarm.

---

## Overview

Nomad Alarm is a Flutter app using a **feature-first folder structure** with shared core layers. State is managed with **Riverpod**. Data is stored locally in **Isar**. Background location monitoring runs in an **Android foreground service** via `flutter_background_service`.

There is **no backend**. All logic, storage, and optional API keys live on the device.

```
┌─────────────────────────────────────────────────────────┐
│                      Presentation                        │
│  Screens (features/*) + shared/widgets + theme           │
└──────────────────────────┬──────────────────────────────┘
                           │ Riverpod providers
┌──────────────────────────▼──────────────────────────────┐
│                   Application Layer                      │
│  Controllers / Notifiers per feature                     │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────┐
│                   Repository Layer                       │
│  repositories/ - Alarm, Trip, Search, Settings, etc.     │
│  Abstracts data access; mockable for tests               │
└───────────────┬──────────────────────────┬──────────────┘
                │                          │
┌───────────────▼────────────┐  ┌──────────▼──────────────┐
│        Domain Layer        │  │   Infrastructure        │
│  models/ - entities, enums │  │  services/ - platform   │
└────────────────────────────┘  │  providers/ - Map/Search│
                                │  Isar DB + external APIs│
                                └─────────────────────────┘
```

**Data flow:** UI → Controller → **Repository** → Services / Providers → Database / APIs

Controllers never call Isar or HTTP directly.

---

## Folder Structure

```text
lib/
├── main.dart
├── app.dart                          # MaterialApp, router, theme
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── router/
│       └── app_router.dart           # go_router config
├── features/
│   ├── splash/
│   ├── welcome/
│   ├── permission/
│   ├── home/
│   ├── search/
│   ├── map/
│   ├── alarm/
│   ├── history/
│   ├── trip/
│   ├── settings/
│   ├── privacy/
│   └── about/
├── models/
│   ├── alarm.dart
│   ├── location.dart
│   ├── favorite.dart
│   ├── trip.dart
│   ├── history.dart
│   ├── settings.dart
│   ├── route.dart
│   ├── search_result.dart
│   └── map_provider.dart
├── repositories/
│   ├── alarm_repository.dart
│   ├── trip_repository.dart
│   ├── search_repository.dart
│   ├── favorite_repository.dart
│   ├── history_repository.dart
│   ├── settings_repository.dart
│   └── backup_repository.dart
├── services/
│   ├── location_service.dart
│   ├── alarm_service.dart
│   ├── notification_service.dart
│   ├── speech_service.dart
│   ├── battery_service.dart
│   ├── permission_service.dart
│   ├── map_service.dart
│   ├── search_service.dart
│   ├── route_service.dart
│   ├── settings_service.dart
│   ├── backup_service.dart
│   ├── wear_os_service.dart
│   ├── android_auto_service.dart
│   ├── group_travel_service.dart
│   ├── cloud_backup_service.dart
│   ├── ringtone_service.dart
│   └── widget_service.dart
├── providers/
│   ├── app_providers.dart
│   ├── alarm_providers.dart
│   ├── location_providers.dart
│   └── settings_providers.dart
├── shared/
│   └── widgets/
└── theme/
    ├── app_theme.dart
    ├── app_colors.dart
    └── app_typography.dart
```

Each feature module follows:

```text
features/<name>/
├── presentation/
│   ├── <name>_screen.dart
│   └── widgets/
├── application/
│   └── <name>_controller.dart      # Riverpod Notifier
└── (optional) domain/
```

---

## Platform modules (v3.1)

| Module | Path | Role |
|--------|------|------|
| Wear OS | `android/wear/` | Complication + Data Layer (phone runs alarm logic) |
| Android Auto | `android/app/.../auto/` | Car App read-only navigation template |
| iOS scaffold | `ios/Runner/` | Location + notification setup; App Store deferred |

Dart: `WearOsService`, `AndroidAutoService` → MethodChannels in `MainActivity.kt`.

---

## Layer Responsibilities

### Presentation
* Renders UI only
* Reads state from Riverpod providers
* Dispatches user actions to controllers/notifiers
* No direct database or GPS access

### Application (Controllers / Notifiers)
* Orchestrates use cases (create alarm, start tracking, dismiss alarm)
* Calls **repositories** only - never services or Isar directly
* Exposes `AsyncValue` / immutable UI state to widgets

### Repository Layer
* Single entry point for each domain area (alarms, trips, search, settings)
* Combines services + local DB into cohesive operations
* Easy to mock in tests (`MockAlarmRepository`)
* Future-proof for optional cloud sync without UI changes

See [Repositories](REPOSITORIES.md).

### Domain (Models)
* Pure Dart data classes / Isar entities
* Enums: `AlarmType`, `TravelMode`, `AlarmStatus`, `MapProviderType`
* Validation rules (e.g., radius > 0, distance threshold valid)

### Infrastructure (Services & Providers)
* **Services:** Platform APIs - GPS, notifications, TTS, background service
* **Providers:** Swappable Map, Search, Route implementations
* Persistence via Isar (accessed by repositories, not controllers)

---

## Core Data Flow: Active Alarm

```
User sets destination + trigger distance
        │
        ▼
AlarmController.createAlarm()
        │
        ▼
AlarmRepository.createAndStart(draft)
        │
        ├── Save Alarm to Isar (via AlarmService)
        ├── Start LocationService (foreground)
        ├── Show persistent notification
        └── Return active Alarm
                │
                ▼
        Navigate to ActiveAlarmScreen
                │
                ▼
LocationService emits position stream
        │
        ▼
AlarmRepository.onPositionUpdate(position)
        └── AlarmService.evaluate(alarm, position)
        │
        ├── Compute haversine distance to destination
        ├── Compute ETA (optional OSRM route)
        ├── Detect: tunnel, GPS lost, passed destination
        └── If trigger condition met → AlarmService.trigger()
                        │
                        ├── Notification (full screen intent)
                        ├── TTS voice message
                        ├── Vibration / flashlight
                        └── Navigate to AlarmRingScreen
```

---

## State Management (Riverpod)

| Provider Type | Use Case |
|---------------|----------|
| `Provider` | Stateless services (singletons) |
| `FutureProvider` | One-time async load (settings, favorites) |
| `StreamProvider` | GPS position, active alarm distance |
| `NotifierProvider` | Mutable feature state (search query, alarm form) |
| `AsyncNotifierProvider` | Async CRUD (alarm list, history) |

**Rules:**
* Services and repositories registered once via `Provider`
* Controllers depend on repositories, not services
* Screens watch only the providers they need
* Background isolate communicates via service callbacks → updates main isolate providers

---

## Routing (go_router)

Bottom navigation shell with nested routes:

| Route | Path | Notes |
|-------|------|-------|
| Splash | `/` | Auth-free bootstrap |
| Welcome | `/welcome` | First launch only |
| Permissions | `/permissions` | Guided permission flow |
| Alarms | `/alarms` | Bottom nav tab (`/home` redirects here) |
| History | `/history` | Bottom nav tab; unified past alarms + journey detail |
| Settings | `/settings` | Bottom nav tab |
| Search | `/search` | Full screen |
| Map | `/map` | Full screen, optional pin drop |
| Alarm Config | `/alarm/new` | Create / edit |
| Active Alarm | `/alarm/active/:id` | Live tracking |
| Alarm Ring | `/alarm/ring/:id` | Full screen, high priority |

Use `redirect` guard for:
* First launch → Welcome
* Missing critical permissions → Permission Center
* Active alarm → allow deep link back to Active Alarm

---

## Background Execution (Android)

**Foreground Service** is required for reliable location while screen is off.

Components:
1. `flutter_background_service` - keeps Dart isolate alive
2. `geolocator` - position stream with configurable accuracy/distance filter
3. `flutter_local_notifications` - persistent tracking notification (legal requirement)
4. Boot receiver - optionally restart last active alarm after reboot (user setting)

Battery strategy:
* Lower GPS frequency when far from destination
* Increase frequency inside trigger zone (geofence approach)
* Pause updates when device is stationary (optional, v1.5+)

See [Permissions](PERMISSIONS.md) for manifest and runtime setup.

---

## Map & Search Abstraction

Use **strategy pattern** so providers are swappable without rewriting UI.

```dart
abstract class MapProvider {
  Widget buildMap(MapOptions options);
}

abstract class SearchProvider {
  Future<List<SearchResult>> search(String query, LatLng? bias);
}

abstract class RouteProvider {
  Future<RouteResult> getRoute(LatLng from, LatLng to, TravelMode mode);
}
```

Default implementations:
* Map: flutter_map + OSM tiles
* Search: Nominatim
* Route: OSRM

User settings select provider; API keys stored encrypted locally.

See [API Integration](API_INTEGRATION.md).

---

## Security Architecture

| Asset | Protection |
|-------|------------|
| Alarms, trips, history | Isar (optionally encrypted collection) |
| Google/HERE API keys | Android Keystore via `flutter_secure_storage` |
| User location | Never leaves device except optional routing API calls |
| Logs | Local only, rotatable, no PII in release builds |

**Never include:**
* Analytics SDKs
* Crash reporting that sends location
* Hardcoded API keys in source

---

## Error Handling

Central `AppException` hierarchy:

* `LocationException` - permission denied, GPS off, timeout
* `AlarmException` - invalid config, already active
* `NetworkException` - search/route failed (graceful offline fallback)
* `StorageException` - DB read/write failure

UI shows user-friendly messages; debug screen shows stack traces (debug builds only).

See [Error Handling](ERROR_HANDLING.md).

---

## Diagrams

Visual diagrams for architecture, sequences, and state machines: [Diagrams](DIAGRAMS.md).

---

## Performance Targets

| Metric | Target |
|--------|--------|
| Cold start | < 2 s |
| Active tracking RAM | < 150 MB |
| APK size | < 30 MB (no offline tiles) |
| Idle drain (monitoring) | < 1% / hour |
| UI | 60 FPS on mid-range devices |

---

## Related Docs

* [Repositories](REPOSITORIES.md)
* [Database Schema](DATABASE.md)
* [Services](SERVICES.md)
* [Screens](SCREENS.md)
* [Diagrams](DIAGRAMS.md)
* [Setup Guide](SETUP.md)
* [Testing](TESTING.md)
