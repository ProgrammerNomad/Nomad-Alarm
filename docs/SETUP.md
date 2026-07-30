---
layout: default
title: Setup Guide
parent: Developer
nav_order: 13
permalink: /SETUP/
---
# Development Setup

Guide to set up the Nomad Alarm development environment from scratch.

---

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | 3.11+ (stable; see `pubspec.yaml`) |
| Dart SDK | ^3.11.4 (bundled with Flutter) |
| Android Studio | Latest |
| Android SDK | API 34+ (compile), min SDK 24 |
| JDK | 17 |
| Git | Latest |

Optional:
* VS Code + Flutter/Dart extensions
* Physical Android device (required for GPS/background testing)

Verify installation:

```bash
flutter doctor -v
```

All Android toolchain checks should pass.

---

## Clone & Run

```bash
git clone https://github.com/ProgrammerNomad/Nomad-Alarm.git
cd Nomad-Alarm
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

Package name: `com.nomad.alarm`

Maps use **flutter_map** with OpenStreetMap tiles (not MapLibre).

---

## Recommended `pubspec.yaml` Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State & routing
  flutter_riverpod: ^2.6.1
  go_router: ^14.6.2

  # Database
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1

  # Location & permissions
  geolocator: ^13.0.2
  permission_handler: ^11.3.1

  # Background & notifications
  flutter_background_service: ^5.0.10
  flutter_local_notifications: ^18.0.1

  # Maps
  flutter_map: ^7.0.0
  latlong2: ^0.9.1

  # Voice & storage
  flutter_tts: ^4.2.0
  shared_preferences: ^2.3.3
  flutter_secure_storage: ^9.2.2

  # Utilities
  logger: ^2.5.0
  intl: ^0.19.0
  url_launcher: ^6.3.1
  share_plus: ^10.1.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.13
  isar_generator: ^3.1.0+1
  mocktail: ^1.0.4
```

Run after adding:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

## Android Configuration

### `android/app/build.gradle`

```gradle
android {
    namespace "com.nomad.alarm"
    compileSdk 34

    defaultConfig {
        applicationId "com.nomad.alarm"
        minSdk 24
        targetSdk 34
    }
}
```

### Key manifest permissions

See full list in [Permissions](PERMISSIONS.md).

---

## Environment Variables

No `.env` file required for core app. Optional API keys are entered in **Settings → API keys** and stored via `flutter_secure_storage`.

For Google Maps on Android, the app applies the saved key at runtime - end users do not edit AndroidManifest. Developers may optionally set `google_maps_api_key` in `android/app/src/main/res/values/strings.xml` for CI builds without secure storage.

See [Settings Guide](SETTINGS_GUIDE.md) for Google Cloud Console setup (2026 steps).

For CI builds, no secrets needed for default OSM/Nominatim/OSRM stack.

---

## Project Bootstrap Checklist

1. [ ] Run `flutter create` with correct org/package
2. [ ] Create folder structure per [Architecture](ARCHITECTURE.md)
3. [ ] Add dependencies and run `pub get`
4. [ ] Configure Isar models + code generation
5. [ ] Set up `app_router.dart` with placeholder screens
6. [ ] Apply Material 3 theme
7. [ ] Configure Android manifest permissions
8. [ ] Run on device: `flutter run`

---

## Build Commands

```bash
# Debug on connected device
flutter run

# Release APK
flutter build apk --release

# Release App Bundle (Play Store)
flutter build appbundle --release

# Analyze
flutter analyze

# Tests
flutter test
```

---

## Code Generation

Isar models require code generation after schema changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Watch mode during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Assets

```text
assets/
├── images/
│   ├── logo.png
│   └── onboarding/
├── fonts/
│   ├── Inter/
│   └── Manrope/
└── sounds/
    └── default_alarm.mp3
```

Register in `pubspec.yaml` under `flutter: assets:` and `fonts:`.

---

## Git Workflow

* `main` - stable, release-ready
* `develop` - integration branch (optional)
* `feature/*` - feature branches
* Conventional commits: `feat:`, `fix:`, `docs:`, `test:`

See [CONTRIBUTING.md](../CONTRIBUTING.md).

---

## IDE Settings

Recommended analysis options in `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    avoid_print: true
    require_trailing_commas: true
```

---

## Related Docs

* [Architecture](ARCHITECTURE.md)
* [Permissions](PERMISSIONS.md)
* [Testing](TESTING.md)
* [Roadmap](ROADMAP.md)
