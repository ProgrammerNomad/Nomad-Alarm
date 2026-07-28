# Database Schema

Nomad Alarm uses **Isar** as the local database. All data stays on device.

---

## Collections Overview

| Collection | Purpose |
|------------|---------|
| `Alarm` | Alarm definitions and runtime state |
| `Trip` | Recorded journeys linked to alarms |
| `Favorite` | Saved places (Home, Office, custom) |
| `HistoryEntry` | Completed/missed alarm log |
| `AppSettings` | Singleton app configuration |
| `RecentSearch` | Recent search queries/results |
| `LogEntry` | Debug logs (debug builds or opt-in) |

---

## Alarm

Primary entity for location alarms.

```dart
@collection
class Alarm {
  Id id = Isar.autoIncrement;

  // Destination
  late String name;
  late double destLatitude;
  late double destLongitude;
  String? address;
  String? placeId;           // provider-specific id

  // Trigger config
  @enumerated
  late AlarmType type;       // distance, radius, eta, speed, geofence
  late double triggerDistanceMeters;  // e.g. 500m before station
  double? radiusMeters;      // for geofence
  double? speedThresholdKmh; // for speed alarm

  // Behavior
  @enumerated
  late TravelMode travelMode;
  late bool repeat;
  DateTime? scheduledAt;     // one-time scheduled
  late bool voiceEnabled;
  late String? voiceMessage;
  late bool vibrationEnabled;
  late bool flashlightEnabled;
  String? ringtoneUri;

  // Runtime state
  @enumerated
  late AlarmStatus status;   // draft, active, paused, triggered, completed, cancelled
  DateTime? startedAt;
  DateTime? triggeredAt;
  DateTime? completedAt;

  // Metadata
  late DateTime createdAt;
  late DateTime updatedAt;
}
```

### Indexes
* `status` - query active alarms quickly
* `createdAt` - sort history

### Enums

```dart
enum AlarmType { distance, arrival, departure, radius, eta, speed, geofence }
enum AlarmStatus { draft, active, paused, triggered, completed, cancelled, missed }
enum TravelMode { train, bus, metro, car, walking, cycling, autoDetect }
```

---

## Trip

Auto-created when alarm starts; closed when alarm completes or cancels.

```dart
@collection
class Trip {
  Id id = Isar.autoIncrement;

  late int alarmId;          // FK to Alarm.id
  late String destinationName;
  late double destLatitude;
  late double destLongitude;

  late DateTime startedAt;
  DateTime? endedAt;

  double? totalDistanceMeters;
  int? durationSeconds;
  double? maxSpeedKmh;
  double? avgSpeedKmh;

  @enumerated
  late TripOutcome outcome;  // completed, cancelled, missed, passed

  // Optional route snapshot (JSON string)
  String? routePolyline;
}
```

### Indexes
* `alarmId`
* `startedAt`

---

## Favorite

```dart
@collection
class Favorite {
  Id id = Isar.autoIncrement;

  late String name;
  @enumerated
  late FavoriteCategory category;  // home, office, college, gym, airport, hotel, custom

  late double latitude;
  late double longitude;
  String? address;
  String? icon;              // optional icon key

  late DateTime createdAt;
  int sortOrder = 0;
}
```

```dart
enum FavoriteCategory { home, office, college, gym, airport, hotel, custom }
```

---

## HistoryEntry

Denormalized log for fast history screen queries.

```dart
@collection
class HistoryEntry {
  Id id = Isar.autoIncrement;

  late int? alarmId;
  late int? tripId;

  late String destinationName;
  late double destLatitude;
  late double destLongitude;

  @enumerated
  late HistoryType type;     // completed, missed, dismissed, snoozed

  late DateTime occurredAt;
  double? triggerDistanceMeters;
  int? snoozeCount;
  String? notes;
}
```

---

## AppSettings (Singleton)

Single row, `id = 0` fixed.

```dart
@collection
class AppSettings {
  Id id = 0;                 // singleton

  // Appearance
  @enumerated
  late ThemeMode themeMode;  // system, light, dark
  late String accentColor;   // blue, green, orange, purple, red
  late String fontFamily;    // inter, manrope, roboto

  // Maps & providers
  @enumerated
  late MapProviderType mapProvider;
  @enumerated
  late SearchProviderType searchProvider;
  @enumerated
  late RouteProviderType routeProvider;

  // Units & locale
  late bool useMetric;       // km vs miles
  late String languageCode;  // en, hi, etc.

  // Alarm defaults
  late double defaultTriggerDistanceMeters;
  late bool defaultVoiceEnabled;
  late bool defaultVibrationEnabled;

  // Battery
  @enumerated
  late BatteryProfile batteryProfile;  // balanced, aggressive, saver

  // Onboarding
  late bool hasCompletedWelcome;
  late bool hasCompletedPermissions;

  // Privacy
  late bool debugLoggingEnabled;

  // Notifications
  late bool persistentNotificationEnabled;
  late bool lockScreenInfoEnabled;
}
```

---

## RecentSearch

```dart
@collection
class RecentSearch {
  Id id = Isar.autoIncrement;

  late String query;
  late String resultName;
  late double latitude;
  late double longitude;
  String? address;

  late DateTime searchedAt;
}
```

Keep max **20** entries; delete oldest on insert.

---

## LogEntry (Optional)

```dart
@collection
class LogEntry {
  Id id = Isar.autoIncrement;

  late DateTime timestamp;
  @enumerated
  late LogLevel level;
  late String tag;
  late String message;
}
```

Rotate logs: max 1000 entries or 7 days. Disabled in release unless user opts in.

---

## Relationships

```
Alarm 1 ──→ 0..1 Trip        (active trip while alarm running)
Alarm 1 ──→ 0..* HistoryEntry
Trip  1 ──→ 0..* HistoryEntry
Favorite (standalone)
RecentSearch (standalone)
AppSettings (singleton)
```

No formal Isar links - use `alarmId` / `tripId` int references for simplicity.

---

## Migration Strategy

1. Start with schema version in `AppSettings` or separate metadata collection
2. On schema change, bump version and run Isar migration callback
3. Never delete user alarms silently - migrate or export first
4. Backup JSON format versioned separately (see [API Integration](API_INTEGRATION.md#backup-format))

---

## Backup JSON Format (v1)

```json
{
  "version": 1,
  "exportedAt": "2026-07-28T12:00:00Z",
  "alarms": [],
  "favorites": [],
  "settings": {},
  "history": []
}
```

---

## Related Docs

* [Architecture](ARCHITECTURE.md)
* [Services](SERVICES.md)
