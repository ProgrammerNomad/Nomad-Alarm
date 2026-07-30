---
layout: default
title: Feature Flags
parent: Reference
nav_order: 2
permalink: /FEATURE_FLAGS/
---
# Feature Flags

Local feature flags for gradual rollout and future features. All flags stored in `AppSettings` or compile-time constants - **no remote config server**.

See [Constants](CONSTANTS.md) for default values.

---

## Flag Types

| Type | Storage | Use |
|------|---------|-----|
| **Compile-time** | `lib/core/constants/feature_flags.dart` | Kill switch for unfinished features in release |
| **Runtime** | `AppSettings` | User-visible toggles (e.g., debug logging, lock screen info) |
| **Version-gated** | Roadmap version check | Enable feature when app version >= threshold |

---

## Compile-Time Flags (v3.1 defaults)

```dart
abstract class FeatureFlags {
  /// Core - always true
  static const bool locationAlarms = true;
  static const bool backgroundTracking = true;
  static const bool nominatimSearch = true;
  static const bool osmMaps = true;

  /// v1.5
  static const bool homeScreenWidgets = true;
  static const bool quickSettingsTile = true;
  static const bool backupRestore = true;
  static const bool deepLinkImport = true;

  /// v2.0
  static const bool googleMapsProvider = true;
  static const bool googlePlacesSearch = true;
  static const bool hereMapsProvider = true;
  static const bool mapboxProvider = true;
  static const bool offlineMapTiles = true;

  /// v3.0+
  static const bool wearOs = true;
  static const bool androidAuto = true;
  static const bool aiEtaPrediction = true;
  static const bool groupTravel = true;
  static const bool familySharing = true;
  static const bool cloudBackup = true;
  static const bool voiceSearch = true;

  /// Debug only
  static const bool debugScreen = kDebugMode;
  static const bool mockLocation = kDebugMode;
}
```

---

## Flag Reference

| Flag | Default | Version | Description |
|------|---------|---------|-------------|
| `locationAlarms` | `true` | v1.0 | Core alarm functionality |
| `backgroundTracking` | `true` | v1.0 | Foreground service GPS |
| `homeScreenWidgets` | `true` | v1.5 | Android widgets |
| `quickSettingsTile` | `true` | v1.5 | Quick Settings tile |
| `backupRestore` | `true` | v1.5 | JSON export/import |
| `deepLinkImport` | `true` | v1.5 | geo: / Google Maps links |
| `googleMapsProvider` | `true` | v2.0 | BYO Google Maps |
| `googlePlacesSearch` | `true` | v2.0 | BYO Places API |
| `hereMapsProvider` | `true` | v2.0 | HERE integration |
| `mapboxProvider` | `true` | v2.0 | Mapbox integration |
| `offlineMapTiles` | `true` | v2.0 | Download map regions |
| `wearOs` | `true` | v3.1 | Wear OS complication (bundled module) |
| `androidAuto` | `true` | v3.1 | Android Auto navigation template |
| `aiEtaPrediction` | `true` | v3.0 | Smart ETA heuristics |
| `groupTravel` | `true` | v3.0 | Share single alarm locally |
| `familySharing` | `true` | v3.1 | Multi-alarm bundle share/import |
| `cloudBackup` | `true` | v3.0 | Optional HTTPS backup upload |
| `voiceSearch` | `true` | v3.1 | Speech-to-text on Search screen |

---

## Runtime toggles (`AppSettings`)

Stored in Isar; included in backup/restore:

| Field | Default | Description |
|-------|---------|-------------|
| `lockScreenInfoEnabled` | `true` | Show distance/ETA on lock screen notifications (`NotificationVisibility.public`) |
| `accessibilityHighContrast` | `false` | High contrast light/dark theme |
| `resumeAlarmAfterBoot` | `false` | Relaunch tracking after device reboot |

---

## Usage Pattern

```dart
if (FeatureFlags.voiceSearch) {
  IconButton(icon: Icon(Icons.mic), onPressed: _startVoiceSearch);
}
```

---

## Related Docs

* [Constants](CONSTANTS.md)
* [Roadmap](ROADMAP.md)
* [Architecture](ARCHITECTURE.md)
