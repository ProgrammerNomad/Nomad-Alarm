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

## MapService

**File:** `lib/services/map_service.dart`

### Responsibilities
* Provide map widget via selected `MapProvider`
* Manage map layers (standard, satellite, terrain, dark)
* Center on user location, animate to destination
* Handle pin drop and coordinate reverse geocoding

### Dependencies
* MapLibre (default)
* Optional Google Maps implementation

---

## SearchService

**File:** `lib/services/search_service.dart`

### Responsibilities
* Forward geocoding search
* Reverse geocoding for coordinates
* Parse Plus Codes and lat/lng input
* Cache recent results in Isar

### Default Provider: Nominatim
* Rate limit: max 1 req/s
* Include User-Agent header per OSM policy
* Offline: return cached/recent only

---

## RouteService

**File:** `lib/services/route_service.dart`

### Responsibilities
* Fetch route polyline between two points
* Compute ETA based on travel mode
* Fallback to straight-line ETA when offline

### Default Provider: OSRM
* Public instance for dev; self-hosted or alternative for production scale

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
