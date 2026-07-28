# Widgets & System UI

Android home screen widgets, lock screen, and Quick Settings tile specifications.

**Version:** v1.5 (enabled in v1.5.0 - small + medium widgets implemented)

See [Feature Flags](FEATURE_FLAGS.md) and [Design System](DESIGN_SYSTEM.md).

---

## Home Screen Widgets

### Small Widget (2×1)

| Property | Value |
|----------|-------|
| Min size | 110×40 dp |
| Update interval | Every 5 min (or on alarm state change) |

**Content:**
* Destination name (truncated)
* Distance remaining (large text)

**Tap action:** Open Active Alarm screen (or Home if no active alarm)

**No active alarm state:**
* "No active alarm"
* Tap → Home

---

### Medium Widget (4×2)

| Property | Value |
|----------|-------|
| Min size | 250×110 dp |

**Content:**
* Destination name
* Distance (display size)
* ETA chip
* Linear progress bar (approach progress)

**Actions:**
* Tap body → Active Alarm
* Tap ✕ → Cancel alarm (with confirm dialog in app)

---

### Large Widget (4×3)

| Property | Value |
|----------|-------|
| Min size | 250×180 dp |

**Content:**
* Static map thumbnail (last cached region) OR gradient background
* Destination pin overlay
* Distance + ETA + speed
* Cancel button

**Update:** Every GPS update while active (via WorkManager fallback max 15 min)

---

## Widget Implementation

Package: `home_widget` or native Android AppWidgetProvider + platform channel.

```text
android/app/src/main/kotlin/.../NomadAlarmWidgetProvider.kt
lib/services/widget_service.dart
```

Data passed via shared preferences / home_widget storage:

```json
{
  "active": true,
  "destination": "Central Station",
  "distanceMeters": 850,
  "etaMinutes": 4,
  "alarmId": 42
}
```

---

## Lock Screen

Not a separate widget - uses **notification** on lock screen.

| Element | Source |
|---------|--------|
| Destination | Tracking notification title |
| Distance / ETA | Notification body (live update) |
| Dismiss | Notification action (opens Alarm Ring) |
| Map | Optional expanded notification style (v1.5) |

Requires `lockScreenInfoEnabled` in settings.

Use `NotificationCompat.BigTextStyle` or custom layout.

Full-screen alarm uses `fullScreenIntent` on alarm channel.

---

## Quick Settings Tile

**Version:** v1.5

| State | Label | Action |
|-------|-------|--------|
| No active alarm | "Nomad Alarm" | Tap → Home |
| Active alarm | "Alarm: {distance}" | Tap → Active Alarm |
| Long press | - | Open app settings |

Secondary tile (optional):

| Label | Action |
|-------|--------|
| "Cancel Alarm" | Cancel active alarm (confirm in app) |

Implement via `TileService` (Android native) or Flutter plugin.

---

## Widget Design Tokens

Match [Design System](DESIGN_SYSTEM.md):

| Token | Widget value |
|-------|--------------|
| Background | `surfaceContainer` |
| Primary text | `onSurface` |
| Distance text | `primary` color, bold |
| Corner radius | 16 dp |
| Font | System sans (widgets can't bundle Inter easily) |

Dark/light: follow system theme via widget layout variants or dynamic colors (Android 12+).

---

## Update Strategy

| Trigger | Update widget |
|---------|---------------|
| Alarm started | Immediate |
| GPS distance change (> 50 m) | Immediate |
| Alarm cancelled/completed | Immediate |
| Periodic (backup) | Every 15 min via WorkManager |

Avoid updating more than once per 30 sec to save battery (except Large widget during active alarm).

---

## Testing Checklist

- [ ] Small widget shows correct distance
- [ ] Medium widget progress bar accurate
- [ ] Large widget cancel opens app confirm
- [ ] Widget survives app kill (shows last state + stale indicator)
- [ ] Tap opens correct deep link
- [ ] Dark/light theme correct
- [ ] No active alarm empty state
- [ ] Quick Settings tile toggles correctly

---

## Related Docs

* [Design System](DESIGN_SYSTEM.md)
* [Screens](SCREENS.md)
* [Feature Flags](FEATURE_FLAGS.md)
* [Battery](BATTERY.md)
