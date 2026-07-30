---
layout: default
title: Store Assets
parent: Release
nav_order: 4
permalink: /play-store/ASSETS_README/
---
# Play Store assets

Capture on a **phone** (1080×1920 or similar). Store PNGs in `docs/play-store/screenshots/`.

## Required screenshots (4–8)

| File | Screen |
|------|--------|
| `01_home.png` | Home with active alarm card (or empty + FAB) |
| `02_search.png` | Search with results |
| `03_alarm_config.png` | Alarm configuration |
| `04_active_eta.png` | Active alarm with distance + ETA |
| `05_ring.png` | Ring screen |
| `06_map.png` | Map view |
| `07_history.png` | History list |
| `08_settings.png` | Settings (include Data section for v1.5+) |

## Feature graphic

- Size: **1024 × 500** px
- Save as `docs/play-store/feature_graphic.png`
- Include app name, tagline: *Wake before you arrive*

## Listing copy

See [PLAY_STORE.md](PLAY_STORE.md) for short/full description templates.

## Data safety form

- Location: used for alarm distance (not collected/shared)
- Notifications: alarm alerts
- No account, no analytics, no data sold

## Signed release build

1. Copy `android/key.properties.example` → `android/key.properties` (gitignored).
2. Set `storeFile` to your keystore path, plus `keyAlias`, `storePassword`, and `keyPassword`.
3. Build:

```powershell
flutter build apk --release
flutter build appbundle --release
```

Outputs:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

Upload AAB to **Internal testing** first, then promote after QA sign-off in [RELEASE_QA_SIGNOFF.md](RELEASE_QA_SIGNOFF.md).
