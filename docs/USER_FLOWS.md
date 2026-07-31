---
layout: default
title: User Flows
parent: Design
nav_order: 2
permalink: /USER_FLOWS/
---
# User Flows

End-to-end UX flows for Nomad Alarm. Use with [Screens](SCREENS.md) and [Design System](DESIGN_SYSTEM.md).

---

## Flow 1: First Launch

```
Open App (Splash)
       │
       ▼
  First launch? ──No──► Active alarm exists? ──Yes──► Active Alarm Screen
       │                        │
      Yes                       No
       │                        │
       ▼                        ▼
   Welcome Screen            Home Screen
       │
       ▼
 Permissions Wizard
 (Location → Notifications → Background Location)
       │
       ▼
   Home Screen
```

---

## Flow 2: Create & Start Alarm (Happy Path)

```
Home
  │
  ├── Tap Search ──► Search Screen
  │                        │
  │                   Enter query / pick Favorite
  │                        │
  │                   Select destination
  │                        │
  └── Tap FAB ─────────────┘
       │
       ▼
 Alarm Config Screen
 (distance, voice, vibration, travel mode)
       │
       ├── Save only ──► History (All filter, draft row with Saved badge)
       │
       └── Save & Start
              │
              ▼
        Alarms tab (active alarm card + notification)
              │
              ▼
        [User travels toward destination]
              │
              ▼
        Distance ≤ trigger threshold
              │
              ▼
        Alarm Ring Screen
        (voice + vibration + flashlight)
              │
              ├── Dismiss ──► History (completed)
              │
              └── Snooze ──► Active Alarm (re-trigger later)
```

---

## Flow 3: Create Alarm from Map

```
Home
  │
  ▼
Map Screen
  │
  ├── Long press ──► Drop pin
  │
  ▼
Bottom sheet: address, "Set Alarm", "Save Favorite"
  │
  ▼
Alarm Config (destination pre-filled)
  │
  ▼
Save & Start ──► Active Alarm
```

---

## Flow 4: Active Alarm While Backgrounded

```
Active Alarm running
       │
       ▼
User presses Home / locks screen
       │
       ▼
Foreground service continues GPS
       │
       ▼
Notification updates (distance / ETA)
       │
       ├── Tap notification ──► Active Alarm Screen
       ├── Tap Pause ──► Alarm paused, notification updated
       └── Tap Cancel ──► Alarm cancelled, service stopped
```

---

## Flow 5: Permission Denied Recovery

```
User tries to start alarm
       │
       ▼
Permission check fails
       │
       ├── Location denied ──► Dialog: "Location required"
       │         │
       │         ├── Grant ──► System permission dialog
       │         └── Open Settings ──► Permission Center
       │
       ├── Background denied ──► Limited mode warning
       │         (alarm works foreground only)
       │
       └── Notifications denied ──► Block start + explain
```

See [Error Handling](ERROR_HANDLING.md).

---

## Flow 6: Offline Usage

```
User opens app (no internet)
       │
       ▼
Home / Active Alarm ──► Works (GPS only)
       │
Search ──► Recent + Favorites only (cached)
       │
Map ──► Cached tiles or pin + coordinates
       │
ETA ──► Straight-line estimate from speed
```

---

## Flow 7: Import Shared Destination

```
Receive link (Google Maps / geo: URI)
       │
       ▼
Open with Nomad Alarm (deep link)
       │
       ▼
Parse coordinates + label
       │
       ▼
Alarm Config (pre-filled)
       │
       ▼
Save & Start
```

---

## Flow 8: View History

```
History Tab
       │
       ├── All / Completed / Missed filters
       │
       ▼
Tap entry ──► Detail bottom sheet
       (destination, time, distance, outcome)
       │
       └── Swipe delete ──► Confirm ──► Removed
```

---

## Flow 9: Settings & Customization

```
Settings Tab
       │
       ├── Appearance ──► Theme, accent, font
       ├── Maps ──► Provider, layers
       ├── Alarm ──► Defaults, ringtone, snooze
       ├── Battery ──► Profile selection
       ├── Permissions ──► Permission Center
       ├── Privacy ──► Privacy policy screen
       └── About ──► Version, licenses, GitHub
```

---

## Flow 10: Backup & Restore (v1.5)

```
Settings ──► Backup ──► Transfer Data
       │
       ├── Export ──► JSON file (share/save) ──► updates Last Backup
       │
       ├── Import ──► Pick file ──► Validate ──► Merge/Replace
       │
       └── Upload (HTTPS) ──► User URL ──► updates Last Backup
```

---

## Navigation Map

```
                    ┌─────────────┐
                    │   Splash    │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
         Welcome    Active Alarm    Home (tabs)
              │                         │
              ▼            ┌────────────┼────────────┐
        Permissions        ▼            ▼            ▼
              │          Home        Trips       History
              └────► Home            │            Settings
                           │         │
                    Search │ Map     │
                           ▼         │
                    Alarm Config     │
                           │         │
                           ▼         │
                    Active Alarm ◄───┘
                           │
                           ▼
                    Alarm Ring
```

---

## Edge Case Flows

| Scenario | Flow |
|----------|------|
| GPS lost in tunnel | Active Alarm → warning banner → resume when fix returns |
| Destination passed | Warning → optional auto-trigger based on settings |
| Low battery | Warning banner → suggest saver profile |
| App killed by OEM | Service stops → notification gone → user reopens app |
| Exact alarm denied | Snooze uses approximate timing + in-app warning |

---

## Related Docs

* [Screens](SCREENS.md)
* [Diagrams](DIAGRAMS.md)
* [Error Handling](ERROR_HANDLING.md)
* [Permissions](PERMISSIONS.md)
