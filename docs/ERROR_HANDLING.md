---
layout: default
title: Error Handling
parent: Reference
nav_order: 3
permalink: /ERROR_HANDLING/
---
# Error Handling Guide

How Nomad Alarm handles failures gracefully. Goal: **never silently fail during an active alarm**.

See [Architecture](ARCHITECTURE.md) for exception types and [User Flows](USER_FLOWS.md) for UX paths.

---

## Principles

1. **Active alarm is sacred** - errors during tracking show warnings, not hard crashes
2. **Actionable messages** - every error offers Retry, Settings, or Dismiss
3. **Offline is normal** - degrade features, don't block core alarm
4. **No raw stack traces in production UI** - debug screen only
5. **Log locally** - use [Events](EVENTS.md) for debugging (never uploaded)

---

## Exception Hierarchy

```dart
sealed class AppException implements Exception {
  String get userMessage;
  String get debugMessage;
  bool get isRecoverable;
}

class LocationException extends AppException { ... }
class PermissionException extends AppException { ... }
class NetworkException extends AppException { ... }
class StorageException extends AppException { ... }
class AlarmException extends AppException { ... }
class MapException extends AppException { ... }
class ProviderException extends AppException { ... }
```

Controllers catch `AppException` and map to UI state: `ErrorState(message, action)`.

---

## Error Catalog

### GPS Off

```
Detect: Geolocator returns service disabled
        │
        ▼
Show dialog: "Location is turned off"
        │
        ├── Retry ──► Re-check after user enables GPS
        ├── Open Settings ──► Location settings intent
        └── Cancel ──► Return to previous screen

Active alarm: show high-priority warning banner + notification
              keep last known position, do NOT auto-cancel
```

### GPS Signal Lost (Tunnel / Indoor)

```
Detect: No fix for > 60 seconds
        │
        ▼
Active Alarm: warning banner "GPS signal lost"
Notification: update with "Waiting for GPS..."
        │
        ▼
On recovery: resume distance updates, dismiss warning
        │
        ▼
If lost > 10 min (configurable): suggest user check location settings
```

### No Internet

```
Detect: connectivity check fails or HTTP timeout
        │
        ▼
Search: show Recent + Favorites only
        "Search unavailable offline"
        │
Map tiles: show cached region or blank map with pin
        │
ETA: fallback to straight-line estimate
        │
Active alarm: NO impact - GPS works offline
```

### Permission Denied

```
Detect: permission_handler returns denied / permanentlyDenied
        │
        ▼
┌─────────────────┬──────────────────────────────┐
│ First denial    │ Rationale dialog + re-request │
│ Permanent deny  │ → Permission Center screen    │
│ Background deny │ Limited mode + start anyway?  │
└─────────────────┴──────────────────────────────┘
```

### Location Permission Revoked Mid-Alarm

```
Detect: permission revoked during watchPosition stream
        │
        ▼
Stop evaluation safely
Show notification: "Alarm paused - location permission revoked"
Set alarm status → Paused
Navigate user to Permission Center on next app open
```

### Notification Permission Denied

```
Block alarm start before service launch
Dialog: "Notifications required for background tracking"
→ Permission Center
```

### Exact Alarm Denied (Android 12+)

```
Allow alarm but warn about snooze reliability
Show banner in Alarm Settings
Link to system exact alarm settings
```

### Map Load Error

```
Detect: tile load failure / flutter_map init error
        │
        ▼
Show inline error on map area
        │
        ├── Retry load
        ├── Switch to fallback (if alternate provider configured)
        └── Continue with pin + coordinates only
```

### Search Provider Error

```
Detect: HTTP 429 / 503 / timeout
        │
        ▼
429 Rate limit → throttle + show cached results
503 Unavailable → "Search temporarily unavailable" + Retry
Timeout → Retry once, then show cache
Empty query → show Recent + Favorites (no error)
```

### API Rate Limit (Nominatim)

```
Enforce client-side 1 req/s throttle
On 429: exponential backoff (2s, 4s, 8s max)
Show: "Too many searches - try again in a moment"
Never retry more than 3 times per query
```

### Routing / ETA Failure

```
Detect: OSRM unreachable
        │
        ▼
Fallback: straight-line distance + speed-based ETA
Show subtle "Estimated" badge on ETA chip
Do NOT block alarm trigger
```

### Database Read/Write Failure

```
Detect: Isar throws on read/write
        │
        ▼
Retry once
If persists:
  Show: "Unable to save data"
  Log StorageException via Events
  For alarm save: keep in memory + warn user to restart app
  For history: skip write, don't crash active alarm
```

### Alarm Config Validation

```
Inline field errors (no dialog):
  - Missing destination
  - triggerDistance <= 0
  - Invalid coordinates
Save button disabled until valid
```

### Backup Import Error

```
Invalid JSON → "Invalid backup file"
Wrong version → "Backup from newer app version"
Partial corrupt → abort entire import (transactional)
```

### Background Service Killed (OEM)

```
Detect: service onDestroy without user action
        │
        ▼
Cannot recover automatically (by design - no auto-restart without consent)
On next app open: show "Alarm was stopped" + offer to restart
Log event: alarm_service_killed
```

---

## UI Error Patterns

| Pattern | When | Components |
|---------|------|------------|
| **Inline banner** | Recoverable, non-blocking | `NomadStatusBanner` |
| **Dialog** | Needs user decision | `AlertDialog` + actions |
| **Full-screen error** | Screen cannot load | `NomadEmptyState` + Retry |
| **Snackbar** | Transient failure | Short message, optional action |
| **Notification** | Background / screen off | High-priority warning channel |

---

## Controller Error State

```dart
@freezed
class AlarmUiState with _$AlarmUiState {
  const factory AlarmUiState.loading() = _Loading;
  const factory AlarmUiState.ready(AlarmData data) = _Ready;
  const factory AlarmUiState.error(AppException error) = _Error;
}
```

Widget pattern:

```dart
state.when(
  loading: () => NomadLoadingSkeleton(),
  ready: (data) => ActiveAlarmContent(data),
  error: (e) => NomadErrorView(
    message: e.userMessage,
    onRetry: controller.retry,
    onSettings: e is PermissionException ? openPermissionCenter : null,
  ),
);
```

---

## Retry Policy

| Error | Max Retries | Backoff |
|-------|-------------|---------|
| GPS one-shot | 3 | 2s fixed |
| Network search | 3 | exponential |
| Map tile load | 2 | 1s |
| DB write | 1 | immediate |
| Permission request | 1 | user-driven |

---

## Debug vs Release

| | Debug | Release |
|---|-------|---------|
| Stack traces | Debug screen | Logs only |
| Event logging | Verbose | Standard |
| Mock location | Allowed | Disabled |
| Error dialogs | Include error code | User message only |

---

## Related Docs

* [Events](EVENTS.md)
* [Permissions](PERMISSIONS.md)
* [API Integration](API_INTEGRATION.md)
* [Testing](TESTING.md)
