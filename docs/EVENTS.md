---
layout: default
title: Events
parent: Reference
nav_order: 4
permalink: /EVENTS/
---
# Internal Events

Local-only event logging for debugging and development. **Nothing is uploaded.** No Google Analytics, Firebase, or third-party telemetry.

Events are written to the local `LogEntry` Isar collection (when debug logging is enabled) and to the `logger` package output in debug builds.

---

## Principles

1. **Local only** - events never leave the device
2. **Opt-in in release** - disabled by default; user can enable in Settings → Debug
3. **No PII** - never log exact coordinates, addresses, or API keys
4. **Structured** - consistent name + optional params for filtering
5. **Useful for QA** - reproduce alarm failures from event timeline

---

## Event Format

```dart
class AppEvent {
  final String name;
  final DateTime timestamp;
  final Map<String, Object?> params;
  final EventLevel level; // debug, info, warning, error
}
```

Example log line:

```
[INFO] alarm_started { alarmId: 42, travelMode: train, triggerMeters: 500 }
```

---

## Event Catalog

### App Lifecycle

| Event | Params | When |
|-------|--------|------|
| `app_launched` | `coldStart: bool` | App open |
| `app_resumed` | - | Foreground |
| `app_paused` | - | Background |
| `app_first_launch` | - | Welcome shown |

### Permissions

| Event | Params | When |
|-------|--------|------|
| `permission_requested` | `type: string` | Dialog shown |
| `permission_granted` | `type: string` | User granted |
| `permission_denied` | `type: string` | User denied |
| `permission_permanently_denied` | `type: string` | Must open settings |

### Alarms

| Event | Params | When |
|-------|--------|------|
| `alarm_created` | `alarmId, travelMode, triggerMeters` | Saved to DB |
| `alarm_started` | `alarmId` | Monitoring began |
| `alarm_paused` | `alarmId` | User paused |
| `alarm_resumed` | `alarmId` | User resumed |
| `alarm_cancelled` | `alarmId, reason` | User or system cancel |
| `alarm_triggered` | `alarmId, distanceMeters` | Threshold reached |
| `alarm_dismissed` | `alarmId` | User dismissed ring |
| `alarm_snoozed` | `alarmId, snoozeMinutes` | Snooze selected |
| `alarm_missed` | `alarmId, reason` | Timeout / passed / killed |
| `alarm_completed` | `alarmId, durationSec` | Successful completion |

### Location

| Event | Params | When |
|-------|--------|------|
| `gps_fix_acquired` | `accuracyMeters` | First fix |
| `gps_fix_lost` | `durationSec` | No fix timeout |
| `gps_recovered` | `outageSec` | Fix restored |
| `destination_passed_warning` | `alarmId` | Moving away detected |

### Search & Map

| Event | Params | When |
|-------|--------|------|
| `search_performed` | `queryLength, resultCount, provider` | Search completed |
| `search_failed` | `provider, errorCode` | Search error |
| `destination_selected` | `source: search\|map\|favorite\|deeplink` | Picked destination |
| `map_provider_changed` | `provider` | Settings change |

### Notifications & Background

| Event | Params | When |
|-------|--------|------|
| `foreground_service_started` | `alarmId` | FGS launched |
| `foreground_service_stopped` | `alarmId, reason` | FGS ended |
| `foreground_service_killed` | `alarmId` | OEM killed service |
| `notification_action` | `action: pause\|cancel\|dismiss` | From notification |

### Settings & Backup

| Event | Params | When |
|-------|--------|------|
| `settings_changed` | `key` | Setting updated |
| `battery_profile_changed` | `profile` | balanced/aggressive/saver |
| `backup_exported` | `alarmCount, favoriteCount` | Export success |
| `backup_imported` | `alarmCount, version` | Import success |
| `backup_import_failed` | `reason` | Import error |

### Errors

| Event | Params | When |
|-------|--------|------|
| `error_location` | `code` | LocationException |
| `error_network` | `endpoint, code` | NetworkException |
| `error_storage` | `operation` | StorageException |
| `error_unhandled` | `type` | Catch-all (debug only) |

---

## Implementation

```dart
abstract class EventLogger {
  void log(String name, {Map<String, Object?>? params, EventLevel level});
}

class LocalEventLogger implements EventLogger {
  final Isar isar;
  final Logger logger;
  final SettingsService settings;

  @override
  void log(String name, {Map<String, Object?>? params, EventLevel level = EventLevel.info}) {
    if (!kDebugMode && !settings.debugLoggingEnabled) return;
    logger.log(_mapLevel(level), name, params);
    _persistToIsar(name, params, level);
  }
}
```

Register via Riverpod:

```dart
final eventLoggerProvider = Provider<EventLogger>((ref) => LocalEventLogger(...));
```

---

## Debug Screen Timeline

Debug screen reads `LogEntry` collection filtered by:
* Last 24 hours
* Level >= warning
* Tag prefix `alarm_*`

Export debug log: share as text file (debug builds only).

---

## Privacy Rules

**Never log:**
* Latitude / longitude
* Full addresses
* API keys
* Device identifiers
* User names or contacts

**Safe to log:**
* Alarm IDs (internal integers)
* Enum values (travel mode, status)
* Counts and durations
* Error codes
* Provider names

---

## Related Docs

* [Error Handling](ERROR_HANDLING.md)
* [Testing](TESTING.md)
* [Security](../SECURITY.md)
