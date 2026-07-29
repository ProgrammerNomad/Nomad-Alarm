# Feature Flags

Local feature flags for gradual rollout and future features. All flags stored in `AppSettings` or compile-time constants - **no remote config server**.

See [Constants](CONSTANTS.md) for default values.

---

## Flag Types

| Type | Storage | Use |
|------|---------|-----|
| **Compile-time** | `lib/core/constants/feature_flags.dart` | Kill switch for unfinished features in release |
| **Runtime** | `AppSettings` | User-visible toggles (e.g., debug logging) |
| **Version-gated** | Roadmap version check | Enable feature when app version >= threshold |

---

## Compile-Time Flags (v1.0 defaults)

```dart
abstract class FeatureFlags {
  /// Core - always true in v1.0 release
  static const bool locationAlarms = true;
  static const bool backgroundTracking = true;
  static const bool nominatimSearch = true;
  static const bool osmMaps = true;

  /// v1.5 - enabled in v1.5.0
  static const bool homeScreenWidgets = true;
  static const bool quickSettingsTile = true;
  static const bool backupRestore = true;
  static const bool deepLinkImport = true;

  /// v2.0 - false until ready
  static const bool googleMapsProvider = false;
  static const bool googlePlacesSearch = false;
  static const bool hereMapsProvider = false;
  static const bool mapboxProvider = false;
  static const bool offlineMapTiles = false;

  /// v3.0 - false until ready
  static const bool wearOs = false;
  static const bool androidAuto = false;
  static const bool aiEtaPrediction = false;
  static const bool groupTravel = false;
  static const bool familySharing = false;
  static const bool cloudBackup = false;

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
| `homeScreenWidgets` | `true` | v1.5 | Android widgets (small + medium) |
| `quickSettingsTile` | `true` | v1.5 | Quick Settings tile |
| `backupRestore` | `true` | v1.5 | JSON export/import |
| `deepLinkImport` | `true` | v1.5 | geo: / Google Maps links |
| `googleMapsProvider` | `false` | v2.0 | BYO Google Maps |
| `googlePlacesSearch` | `false` | v2.0 | BYO Places API |
| `hereMapsProvider` | `false` | v2.0 | HERE integration |
| `mapboxProvider` | `false` | v2.0 | Mapbox integration |
| `offlineMapTiles` | `false` | v2.0 | Download map regions |
| `wearOs` | `false` | v2.0+ | Wear OS companion |
| `androidAuto` | `false` | v3.0 | Android Auto |
| `aiEtaPrediction` | `false` | v3.0 | Smart ETA |
| `groupTravel` | `false` | v3.0 | Share alarm locally |
| `familySharing` | `false` | v3.0 | Family sync (optional) |
| `cloudBackup` | `false` | v3.0 | Optional cloud backup |

---

## Usage Pattern

```dart
// Hide unfinished UI
if (FeatureFlags.homeScreenWidgets) {
  SettingsTile(title: 'Widgets', ...);
}

// Gate navigation routes
if (FeatureFlags.googleMapsProvider) {
  GoRoute(path: '/settings/google-api', ...);
}
```

For runtime user toggles (debug):

```dart
if (settings.debugLoggingEnabled) {
  // show debug screen route
}
```

---

## Enabling for Development

Developers can flip compile-time flags locally during development. **Do not enable v2/v3 flags in release builds until the feature passes the test matrix.**

Recommended: create `feature_flags_override.dart` (gitignored) for local dev:

```dart
// feature_flags_override.dart (gitignored)
const bool _devWidgets = true;
```

---

## Release Process

When a feature is ready:

1. Set flag to `true`
2. Update [Roadmap](ROADMAP.md) and [CHANGELOG](../CHANGELOG.md)
3. Add tests per [Testing](TESTING.md)
4. Remove "beta" label from UI if present

---

## Related Docs

* [Constants](CONSTANTS.md)
* [Roadmap](ROADMAP.md)
* [Architecture](ARCHITECTURE.md)
