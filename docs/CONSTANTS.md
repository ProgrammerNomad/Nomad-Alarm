---
layout: default
title: Constants
parent: Reference
nav_order: 1
permalink: /CONSTANTS/
---
# Constants

Central constants for Nomad Alarm. Implement in `lib/core/constants/`.

Single source of truth - do not duplicate magic numbers in services or UI.

---

## App Metadata

| Constant | Value |
|----------|-------|
| `APP_NAME` | `Nomad Alarm` |
| `PACKAGE_NAME` | `com.nomad.alarm` |
| `SUPPORT_EMAIL` | TBD |
| `GITHUB_URL` | `https://github.com/ProgrammerNomad/Nomad-Alarm` |

---

## GPS & Location

| Constant | Value | Description |
|----------|-------|-------------|
| `GPS_INTERVAL_BALANCED_SEC` | `5` | Position update interval (balanced) |
| `GPS_INTERVAL_AGGRESSIVE_SEC` | `2` | Position update interval (aggressive) |
| `GPS_INTERVAL_SAVER_SEC` | `15` | Position update interval (saver) |
| `GPS_DISTANCE_FILTER_BALANCED_M` | `10` | Min movement before update |
| `GPS_DISTANCE_FILTER_AGGRESSIVE_M` | `5` | Min movement (aggressive) |
| `GPS_DISTANCE_FILTER_SAVER_M` | `25` | Min movement (saver) |
| `GPS_TIMEOUT_SEC` | `15` | One-shot position timeout |
| `GPS_LOST_THRESHOLD_SEC` | `60` | No fix → GPS lost warning |
| `GPS_LOST_EXTENDED_SEC` | `600` | Extended outage warning (10 min) |
| `GPS_ACCURACY_WARN_M` | `100` | Show accuracy warning above this |
| `APPROACH_ZONE_MULTIPLIER` | `2.0` | Switch to aggressive inside 2× trigger distance |

---

## Alarm Defaults

| Constant | Value | Description |
|----------|-------|-------------|
| `DEFAULT_TRIGGER_DISTANCE_M` | `500` | Default alarm distance |
| `MIN_TRIGGER_DISTANCE_M` | `100` | Slider minimum |
| `MAX_TRIGGER_DISTANCE_M` | `5000` | Slider maximum |
| `DEFAULT_RADIUS_M` | `300` | Geofence default radius |
| `SNOOZE_DURATION_MIN` | `2` | Default snooze minutes |
| `ALARM_MISSED_TIMEOUT_MIN` | `5` | Ring timeout → missed |
| `PASSED_DESTINATION_SAMPLES` | `3` | Consecutive readings moving away |

---

## Search & Cache

| Constant | Value | Description |
|----------|-------|-------------|
| `MAX_RECENT_SEARCHES` | `20` | Recent search limit |
| `SEARCH_DEBOUNCE_MS` | `300` | Search input debounce |
| `NOMINATIM_RATE_LIMIT_MS` | `1000` | Min interval between requests |
| `SEARCH_TIMEOUT_SEC` | `10` | HTTP timeout |
| `SEARCH_RETRY_MAX` | `3` | Max retries on failure |

---

## History & Logs

| Constant | Value | Description |
|----------|-------|-------------|
| `MAX_HISTORY_ENTRIES` | `1000` | History cap (delete oldest) |
| `MAX_LOG_ENTRIES` | `1000` | Debug log cap |
| `LOG_RETENTION_DAYS` | `7` | Auto-delete old logs |

---

## Network & Routing

| Constant | Value | Description |
|----------|-------|-------------|
| `HTTP_TIMEOUT_SEC` | `15` | Default HTTP timeout |
| `OSRM_TIMEOUT_SEC` | `10` | Route request timeout |
| `ROUTE_REFRESH_INTERVAL_SEC` | `60` | Re-fetch ETA while moving |

---

## UI & Animation

| Constant | Value | Description |
|----------|-------|-------------|
| `SPLASH_MAX_DURATION_MS` | `2000` | Max splash time |
| `ANIMATION_FAST_MS` | `200` | Fast transitions |
| `ANIMATION_NORMAL_MS` | `300` | Standard transitions |
| `SCREEN_PADDING_DP` | `16` | Horizontal screen padding |
| `MIN_TOUCH_TARGET_DP` | `48` | Minimum tap target |
| `CARD_RADIUS_DP` | `16` | Default card radius |

---

## Notifications

| Constant | Value | Description |
|----------|-------|-------------|
| `NOTIFICATION_ID_TRACKING` | `1001` | Foreground tracking |
| `NOTIFICATION_ID_ALARM` | `1002` | Alarm ring |
| `NOTIFICATION_ID_WARNING` | `1003` | GPS/battery warnings |
| `NOTIFICATION_UPDATE_MIN_SEC` | `2` | Min interval between updates |

---

## Backup

| Constant | Value | Description |
|----------|-------|-------------|
| `BACKUP_FORMAT_VERSION` | `1` | JSON schema version |
| `BACKUP_FILENAME` | `nomad_alarm_backup.json` | Default export name |

---

## Performance Targets

| Constant | Value | Description |
|----------|-------|-------------|
| `TARGET_COLD_START_MS` | `2000` | Max cold start |
| `TARGET_APK_SIZE_MB` | `30` | Max APK without offline maps |
| `TARGET_RAM_ACTIVE_MB` | `150` | Max RAM during tracking |
| `TARGET_IDLE_DRAIN_PCT_HR` | `1` | Max battery drain per hour |

---

## File Structure

```text
lib/core/constants/
├── app_constants.dart
├── gps_constants.dart
├── alarm_constants.dart
├── ui_constants.dart
├── notification_constants.dart
└── feature_flags.dart
```

---

## Related Docs

* [Battery](BATTERY.md)
* [Feature Flags](FEATURE_FLAGS.md)
* [Design System](DESIGN_SYSTEM.md)
