---
layout: default
title: Permissions
parent: Developer
nav_order: 18
permalink: /PERMISSIONS/
---
# Permissions & Android Configuration

Complete guide for Android permissions, foreground service, and manifest setup.

---

## Required Permissions

| Permission | Purpose | When to Request |
|------------|---------|-----------------|
| `ACCESS_FINE_LOCATION` | GPS for distance calculation | Onboarding + before first alarm |
| `ACCESS_COARSE_LOCATION` | Fallback location | With fine location |
| `ACCESS_BACKGROUND_LOCATION` | Track while app closed | After foreground location granted |
| `POST_NOTIFICATIONS` | Tracking + alarm alerts | Onboarding (Android 13+) |
| `SCHEDULE_EXACT_ALARM` | Reliable alarm timing | Before first alarm (Android 12+) |
| `USE_EXACT_ALARM` | Alternative on some devices | Manifest only |
| `FOREGROUND_SERVICE` | Background location service | Manifest |
| `FOREGROUND_SERVICE_LOCATION` | Location-type FGS | Manifest (Android 14+) |
| `WAKE_LOCK` | Keep CPU during alarm ring | Manifest |
| `VIBRATE` | Vibration alert | Manifest |
| `FLASHLIGHT` | Flash alert | Manifest |
| `RECEIVE_BOOT_COMPLETED` | Optional alarm restore | Manifest |
| `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` | Optional, user-initiated | Settings screen |

---

## AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Location -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

    <!-- Notifications & alarms -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.VIBRATE" />

    <!-- Foreground service -->
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <!-- Optional -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />
    <uses-permission android:name="android.permission.FLASHLIGHT" />

    <uses-feature android:name="android.hardware.location.gps" android:required="true" />

    <application ...>

        <!-- Foreground service -->
        <service
            android:name="id.flutter.flutter_background_service.BackgroundService"
            android:foregroundServiceType="location"
            android:exported="false" />

        <!-- Boot receiver (optional) -->
        <receiver
            android:name=".BootReceiver"
            android:enabled="false"
            android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
            </intent-filter>
        </receiver>

    </application>
</manifest>
```

---

## Permission Request Flow

Do **not** request all permissions at once on first launch.

```
Welcome Screen
      │
      ▼
Step 1: Location (while in use)
      │  "We need your location to calculate distance to your stop."
      ▼
Step 2: Notifications
      │  "We'll show a small notification while your alarm is active."
      ▼
Step 3: Background Location (after Step 1 granted)
      │  "Allow all the time so the alarm works while you sleep."
      ▼
Step 4: Exact Alarm (when user creates first alarm)
      │  "Ensures your alarm rings at the right moment."
      ▼
Step 5: Battery Optimization (optional, in Settings)
         "Prevent the system from stopping background tracking."
```

Use `permission_handler` and check `isPermanentlyDenied` → open app settings.

---

## Foreground Service Requirements

Android requires a **visible persistent notification** while tracking location in background.

Notification must include:
* App name
* Destination name
* Current distance or "Tracking active"
* Action buttons: Pause, Cancel

Service type: `location` (Android 10+)

On Android 14+, declare `foregroundServiceType="location"` and hold `FOREGROUND_SERVICE_LOCATION`.

---

## Exact Alarm (Android 12+)

Use `SCHEDULE_EXACT_ALARM` for snooze and scheduled one-time alarms.

Check capability:

```dart
// via platform channel or alarm package
canScheduleExactAlarms()
```

If denied, show in-app explanation and link to `ACTION_REQUEST_SCHEDULE_EXACT_ALARM`.

---

## Background Location Policy

Google Play requires justification for background location.

**Nomad Alarm justification:** Core functionality is a location-based alarm that must monitor GPS while the user is traveling and may have the screen off (e.g., sleeping on a train).

Prepare Play Store declaration:
* Describe feature in listing
* Show in-app disclosure before background location request
* Provide video demo of feature

---

## Battery Optimization

Do not force battery optimization exemption on first launch.

In Settings → Battery:
* Explain trade-off clearly
* Button: "Open Battery Settings"
* App works without it but may be killed on aggressive OEM ROMs

---

## Notification Channels

Create on first app launch:

```dart
// Tracking - low importance, ongoing
// Alarm - max importance, full screen intent
// Alerts - high importance, GPS/battery warnings
```

User can mute tracking channel without affecting alarm channel.

---

## OEM-Specific Notes

| OEM | Issue | Mitigation |
|-----|-------|------------|
| Samsung | Aggressive battery kill | Guide to disable battery limits for app |
| Xiaomi | Autostart disabled | Prompt user to enable autostart |
| Huawei | Background restricted | Battery optimization guide |

Include OEM tips in Permission Center (link to dontkillmyapp.com).

---

## Testing Permissions

Manual test matrix:

1. Grant all → alarm works backgrounded
2. Deny background location → show limited mode warning
3. Deny notifications → block alarm start with explanation
4. Revoke mid-alarm → graceful stop + user alert
5. Permanently deny → deep link to settings works

---

## Related Docs

* [Services](SERVICES.md)
* [Screens](SCREENS.md)
* [Setup](SETUP.md)
