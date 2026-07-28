# Play Store Checklist

Google Play submission requirements for Nomad Alarm v1.0.

---

## Pre-Submission

### App Quality
- [ ] `flutter analyze` - zero issues
- [ ] `flutter test` - all pass
- [ ] Manual test matrix complete ([Testing](TESTING.md))
- [ ] Tested on Android 10, 12, 14 physical devices
- [ ] Background alarm works 30+ min screen off
- [ ] No crashes in 30-min session
- [ ] APK size < 30 MB

### Legal & Policy
- [ ] [Privacy Policy URL](../SECURITY.md) hosted publicly (GitHub Pages or site)
- [ ] MIT [LICENSE](../LICENSE) included
- [ ] Open source dependencies licenses in About screen
- [ ] No ads SDK
- [ ] No analytics SDK
- [ ] Data Safety form completed (see below)

---

## Store Listing Assets

### App Icon
- [ ] 512×512 PNG, 32-bit, no transparency
- [ ] Matches adaptive icon design

### Feature Graphic
- [ ] 1024×500 PNG/JPG
- [ ] Shows: app name, tagline, phone mockup with distance UI

### Screenshots (Phone)
Minimum 4, recommended 8:

| # | Screen | Caption |
|---|--------|---------|
| 1 | Home | Set your destination in seconds |
| 2 | Search | Search stations, landmarks, coordinates |
| 3 | Alarm Config | Choose how far before arrival to alert |
| 4 | Active Alarm | Live distance and ETA while you travel |
| 5 | Alarm Ring | Never miss your stop |
| 6 | Map | Pick destination on map |
| 7 | History | Track completed and missed alarms |
| 8 | Settings | Private, offline, customizable |

Size: 1080×1920 or 1440×2560 (16:9 phone).

### Short Description (80 chars max)

```
Location alarm for trains, buses & travel. Private, free, works offline.
```

### Full Description (4000 chars max)

```
Nomad Alarm wakes you before you reach your destination - perfect for train passengers, bus commuters, and travelers who don't want to miss their stop.

SET A DESTINATION ALARM
Search for a station, drop a pin on the map, or pick from favorites. Choose how far before arrival you want to be alerted - 500 meters, 1 km, or more.

WORKS IN THE BACKGROUND
Keep using your phone or sleep peacefully. Nomad Alarm tracks your location with a persistent notification and rings with voice, vibration, and optional flashlight when you're approaching.

PRIVACY FIRST
• No account required
• No ads
• No tracking or analytics
• All data stored locally on your device
• Open source

OFFLINE READY
Active alarms work without internet. Search and maps use open data (OpenStreetMap) by default.

FEATURES
• Unlimited location alarms
• Voice alerts in English and Hindi
• Live distance and ETA
• Trip history
• Dark mode and Material You
• Battery-aware tracking profiles

Free forever. Built for commuters, by commuters.
```

---

## Data Safety Form

Declare accurately:

| Data type | Collected? | Shared? | Purpose |
|-----------|------------|---------|---------|
| Location (precise) | Yes | No | Core alarm functionality |
| Location (background) | Yes | No | Alarm while app closed |
| Personal info | No | No | - |
| Financial info | No | No | - |
| Photos/videos | No | No | - |
| App activity | No | No | - |
| Device IDs | No | No | - |

**Data handling:**
* Encrypted in transit: N/A (no server)
* Encrypted at rest: Yes (local DB)
* User can request deletion: Yes (clear app data)
* Data is optional: No (location required for core feature)

---

## Background Location Declaration

Required for Play Store review.

### In-App Disclosure (before background permission)

Show prominent disclosure screen:

> Nomad Alarm needs background location to monitor your distance to your destination while the app is closed or your screen is off - for example, while you sleep on a train.
>
> Your location is never sent to our servers. It stays on your device.

User must tap **Allow** before system background location dialog.

### Video for Play Console

Record 30-second demo showing:
1. Create alarm
2. Start tracking
3. App backgrounded / screen off
4. Notification updating
5. Alarm ringing near destination

Upload to YouTube (unlisted) and link in Play Console.

---

## Permissions Justification

| Permission | Justification text |
|------------|---------------------|
| Fine location | Calculate distance to destination |
| Background location | Alarm while screen off during travel |
| Notifications | Show tracking status and alarm alerts |
| Exact alarm | Reliable snooze and scheduled alarms |
| Foreground service | Continuous GPS during active alarm |
| Vibrate | Alarm alert |
| Flashlight | Visual alarm alert |

Remove any unused permissions before submission.

---

## Content Rating

Complete IARC questionnaire:
* Violence: None
* User-generated content: None
* Location sharing: No (not shared)
* Expected rating: **Everyone**

---

## Target Audience

* Not designed for children under 13
* Target: general commuters, all ages

---

## Release Track

1. **Internal testing** - team devices, 1 week
2. **Closed testing** - 10+ testers, 2 weeks
3. **Open testing** (optional) - wider feedback
4. **Production** - staged rollout 10% → 50% → 100%

---

## Signing

- [ ] Upload key generated and backed up securely
- [ ] Play App Signing enabled
- [ ] AAB uploaded (not APK for production)

```bash
flutter build appbundle --release
```

---

## Post-Launch

- [ ] Monitor Play Console vitals (crashes, ANRs)
- [ ] Respond to reviews within 7 days
- [ ] Tag GitHub release matching store version
- [ ] Update [CHANGELOG](../CHANGELOG.md)

---

## Related Docs

* [Permissions](PERMISSIONS.md)
* [Release Checklist](../RELEASE_CHECKLIST.md)
* [Privacy](../SECURITY.md)
* [Assets](ASSETS.md)
