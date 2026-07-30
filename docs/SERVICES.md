---
layout: default
title: Services
parent: Developer
nav_order: 16
permalink: /SERVICES/
---
# Services Specification

Each service is a singleton registered via Riverpod `Provider`. Services encapsulate platform and business logic; they do not depend on Flutter widgets.

---

## LocationService

**File:** `lib/services/location_service.dart`

### Responsibilities
* Request and check location permissions
* Provide one-shot current position
* Stream position updates with configurable accuracy and distance filter
* Adapt update frequency based on distance to destination (battery-aware)
* Detect GPS signal loss and recovery

### Public API

```dart
abstract class LocationService {
  Future<Position> getCurrentPosition();
  Stream<Position> watchPosition({LocationAccuracy accuracy, int distanceFilterMeters});
  Future<bool> isLocationEnabled();
  Stream<ServiceStatus> get serviceStatusStream;
}
```

### Configuration by Battery Profile

| Profile | Accuracy | Min interval | Distance filter |
|---------|----------|--------------|-----------------|
| Balanced | high | 5 s | 10 m |
| Aggressive | best | 2 s | 5 m |
| Saver | medium | 15 s | 25 m |

When within trigger zone (2× trigger distance), temporarily switch to Aggressive.

### Dependencies
* `geolocator`
* `PermissionService`

---

## AlarmService

**File:** `lib/services/alarm_service.dart`

### Responsibilities
* CRUD alarms in Isar
* Start/stop/pause active alarm monitoring
* Evaluate trigger conditions on each position update
* Trigger alarm (notify, TTS, vibration, flashlight)
* Smart detection: tunnel, passed destination, train stopped heuristic

### Public API

```dart
abstract class AlarmService {
  Future<Alarm> createAlarm(AlarmDraft draft);
  Future<void> startAlarm(int alarmId);
  Future<void> pauseAlarm(int alarmId);
  Future<void> cancelAlarm(int alarmId);
  Future<void> dismissAlarm(int alarmId, {bool snooze = false});
  void evaluate(Alarm alarm, Position position);
  Stream<AlarmRuntimeState> watchActiveAlarm(int alarmId);
}
```

### Trigger Logic

**Distance alarm (default):**
```
distance_to_dest <= triggerDistanceMeters → TRIGGER
```

**Geofence:**
```
entered radiusMeters circle → TRIGGER
```

**Destination passed:**
```
was_approaching && distance increasing for N consecutive updates → WARN then optional TRIGGER
```

**GPS lost:**
```
no fix for > 60 s → show warning notification, keep last known position
```

### Dependencies
* Isar (Alarm, Trip, HistoryEntry)
* `LocationService`
* `NotificationService`
* `SpeechService`
* `RouteService` (optional ETA)

---

## NotificationService

**File:** `lib/services/notification_service.dart`

### Responsibilities
* Create Android notification channels
* Show persistent tracking notification
* Show alarm trigger notification (full screen intent)
* Update notification with live distance/ETA
* Handle notification action buttons (Cancel, Pause, Dismiss, Snooze)

### Channels

| Channel ID | Name | Importance | Use |
|------------|------|------------|-----|
| `tracking` | Active Alarm | Low | Persistent foreground |
| `alarm` | Alarm Ring | Max | Trigger alert |
| `alerts` | Warnings | High | GPS lost, battery low |

### Public API

```dart
abstract class NotificationService {
  Future<void> initialize();
  Future<void> showTrackingNotification(AlarmRuntimeState state);
  Future<void> updateTrackingNotification(AlarmRuntimeState state);
  Future<void> showAlarmRingNotification(int alarmId);
  Future<void> cancelAll();
}
```

### Dependencies
* `flutter_local_notifications`

---

## SpeechService

**File:** `lib/services/speech_service.dart`

### Responsibilities
* Text-to-speech for alarm voice alerts
* Support English, Hindi, auto language from system locale
* Speak custom user message or default template

### Default Messages
* EN: "Your stop is approaching. Destination in {distance}."
* HI: "आपका स्टॉप नज़दीक है। गंतव्य {distance} दूर है।"

### Dependencies
* `flutter_tts`
* `SettingsService` (language)

---

## BatteryService

**File:** `lib/services/battery_service.dart`

### Responsibilities
* Monitor battery level and charging state
* Warn user when battery low during active alarm
* Suggest battery saver profile switch
* Request ignore battery optimization (optional, user-initiated)

### Dependencies
* Platform battery APIs / `battery_plus` (optional)

---

## PermissionService

**File:** `lib/services/permission_service.dart`

### Responsibilities
* Check and request all required permissions
* Expose unified permission status model
* Open system settings for denied-permanently cases
* Guide user through onboarding permission flow

See [Permissions](PERMISSIONS.md).

---

## MapService / MapProvider

**Legacy file:** `lib/services/map_service.dart` (tile URL helpers)

**Providers:** `lib/providers/map/` - `OsmMapProvider`, `GoogleMapProvider`, `MapboxMapProvider`, `HereMapProvider`

### Responsibilities
* Provide map tile config via selected `MapProvider`
* Switch between `flutter_map` (OSM/Mapbox/HERE) and native `GoogleMap`
* Center on user location, handle pin drop
* Optional offline tiles via `OfflineTileService` + FMTC store

### Dependencies
* `flutter_map` (default OSM/Mapbox/HERE)
* `google_maps_flutter` (Google native)
* `flutter_map_tile_caching` (offline regions)

---

## SearchService / SearchProvider

**Legacy file:** `lib/services/search_service.dart` (Nominatim wrapper)

**Providers:** `lib/providers/search/` - Nominatim, Google Places, Photon, Pelias, HERE

### Responsibilities
* Forward geocoding search via `SearchProvider` from settings
* Reverse geocoding for coordinates
* Offline fallback: recent searches + favorites when network fails

### Default Provider: Nominatim
* Rate limit: max 1 req/s (`RequestThrottler`)
* Include User-Agent header per OSM policy

---

## RouteService

**File:** `lib/services/route_service.dart`

**Providers:** `lib/providers/route/` - OSRM, Google Directions, GraphHopper, Valhalla

### Responsibilities
* Fetch route polyline between two points
* Compute route-based ETA (refreshed ~60s in foreground `AlarmService`)
* Fallback to straight-line ETA when offline or routing unavailable
* Store route polyline on active trip at alarm start

### Default Provider: OSRM
* Public instance for dev; self-hosted or alternative for production scale

---

## ProviderFactory

**File:** `lib/services/provider_factory.dart`

Resolves `MapProvider`, `SearchProvider`, and `RouteProvider` from `AppSettings` + `FeatureFlags` + `ApiKeyStore`. Falls back to OSM/Nominatim/OSRM when keys are missing.

---

## ApiKeyStore

**File:** `lib/services/api_key_store.dart`

Encrypted BYO key storage via `flutter_secure_storage` (Android Keystore). Keys: Google Maps/Places/Directions, Mapbox, HERE, GraphHopper. **Excluded from JSON backup.**

---

## OfflineTileService

**File:** `lib/services/offline_tile_service.dart`

Wraps `flutter_map_tile_caching` - initialize store, download bounding-box regions, report cache size, clear cache.

---

## SettingsService

**File:** `lib/services/settings_service.dart`

### Responsibilities
* Load/save `AppSettings` singleton
* Apply theme, locale, units at runtime
* Provider selection (map, search, route)

---

## WidgetService

**File:** `lib/services/widget_service.dart`

### Responsibilities
* Sync active alarm state to Android home screen widgets (small, medium, large)
* Pass localized strings, distance, ETA, approach progress, and speed via `home_widget` shared prefs
* Clear widget state when alarm ends

---

## TileService

**File:** `lib/services/widget_service.dart` (`TileService` class)

**Native:** `android/.../NomadAlarmTileService.kt`

### Responsibilities
* Mirror active alarm distance/subtitle on Quick Settings tile
* Request native tile refresh via MethodChannel when alarm state changes
* Tile tap opens active alarm or home screen

---

## DeepLinkService

**File:** `lib/services/deep_link_service.dart`

**Parser:** `lib/core/utils/deep_link_parser.dart`

### Responsibilities
* Handle cold/warm start geo and Google Maps URIs (`app_links`)
* Parse clipboard text on Search screen
* Normalize to `DestinationArgs` for alarm config routing

Supported formats: `geo:`, `https://maps.google.com/...`, `https://www.google.com/maps/@...`, raw `lat,lng`.

---

## BackupService

**File:** `lib/services/backup_service.dart`

### Responsibilities
* Export alarms, favorites, settings, history to JSON file
* Import from JSON with version validation
* Optional Google Drive upload (v1.5+, user-initiated)

### Security
* Export excludes API keys (user re-enters)
* Validate import schema before writing to Isar

---

## Background Service Integration

**File:** `lib/services/background_alarm_service.dart`

Wraps `flutter_background_service` to run alarm evaluation in background isolate.

```
Main isolate                    Background isolate
     │                                │
     ├── startService(alarmId) ──────►│
     │                                ├── LocationService.watchPosition
     │                                ├── AlarmService.evaluate
     │◄── onTrigger callback ────────┤
     │                                │
     └── UI updates via port/isolate  │
```

Communication: `ReceivePort` / service invoke methods.

---

## WearOsService (v3.1)

**File:** `lib/services/wear_os_service.dart`  
**Native:** `android/wear/` complication + Data Layer listener; phone sync via `MainActivity.kt` wear channel.

Pushes active alarm JSON (destination, distance, ETA) to paired watch. Alarm logic stays on phone.

---

## AndroidAutoService (v3.1)

**File:** `lib/services/android_auto_service.dart`  
**Native:** `NomadAlarmCarAppService`, `NomadAlarmNavigationScreen` - read-only `NavigationTemplate` / `MessageInfo`.

Writes destination and distance to HomeWidget shared prefs via MethodChannel.

---

## GroupTravelService (v3.1)

**File:** `lib/services/group_travel_service.dart`

Export/import single alarm config (`nomad_alarm_config`) or multi-alarm bundle (`nomad_alarm_bundle`) via clipboard/share sheet.

---

## CloudBackupService (v3.0)

**File:** `lib/services/cloud_backup_service.dart`

Optional HTTPS POST of backup JSON to user-provided URL.

---

## RingtoneService (v3.0)

**File:** `lib/services/ringtone_service.dart`

Custom alarm ringtone playback via `audioplayers`.

---

## WidgetService (v1.5+)

**File:** `lib/services/widget_service.dart`

Updates home screen widgets, Quick Settings tile prefs, and delegates to `AndroidAutoService` / `WearOsService`.

---

## Service Dependency Graph

```
PermissionService
       │
LocationService ──► AlarmService ──► NotificationService
       │                  │                  │
       │                  ├── SpeechService  │
       │                  ├── RouteService   │
       │                  └── BatteryService │
       │                                     │
MapService ◄── SettingsService ──► SearchService
                      │
               BackupService
```

---

## Related Docs

* [Architecture](ARCHITECTURE.md)
* [Database](DATABASE.md)
* [Permissions](PERMISSIONS.md)
