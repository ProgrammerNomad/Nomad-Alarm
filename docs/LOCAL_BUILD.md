---
layout: default
title: Local Build
parent: Developer
nav_order: 20
permalink: /LOCAL_BUILD/
---
# Local build

Nomad Alarm supports **local builds** on your machine. Run analyze, tests, and release builds locally before tagging or submitting to Play Console.

## Prerequisites

- Flutter SDK (see `pubspec.yaml` SDK constraint)
- Android SDK / `key.properties` for signed release (see `android/key.properties.example`)
- macOS + Xcode for iOS device builds (optional)

## Every build

```powershell
cd c:\xampp\htdocs\Nomad-Alarm
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
```

## Debug on device

```powershell
flutter run
```

## Signed release

Requires `android/key.properties` (gitignored):

```powershell
flutter build apk --release
flutter build appbundle --release
```

Outputs:
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/bundle/release/app-release.aab`

## Before Play Store upload

Complete [RELEASE_QA_SIGNOFF.md](RELEASE_QA_SIGNOFF.md) on a physical device and add screenshots per [play-store/ASSETS_README.md](play-store/ASSETS_README.md).

## iOS (device, no App Store prep)

On macOS with Xcode installed:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build ios --no-codesign
open ios/Runner.xcworkspace
```

In Xcode: select your Team, enable **Background Modes → Location updates**, run on a physical iPhone. Grant **Always** location when prompted during an active alarm. Verify tracking continues 30+ minutes with screen off.

## Documentation site (Jekyll)

Public site deploys to GitHub Pages on push to `main` when `docs/**` changes.

Local preview:

```powershell
cd docs
bundle install
bundle exec jekyll serve --baseurl "" --livereload
```

Open http://localhost:4000 - legal pages at `/privacy-policy/`, `/terms/`, etc.

## Windows troubleshooting

### Kotlin "different roots" cache warnings (C: vs D:)

If the project is on `D:` but Pub cache is on `C:`, Gradle may log Kotlin incremental cache errors. The APK often still builds. Fixes:

1. Move the repo to the same drive as `%LOCALAPPDATA%\Pub\Cache`, **or**
2. Set `PUB_CACHE=D:\pub-cache` and run `flutter pub get`, **or**
3. `flutter clean`, `cd android && .\gradlew --stop`, rebuild

Optional: add `kotlin.incremental=false` to `android/gradle.properties` for slower but quieter builds.

### Emulator install storage

`INSTALL_FAILED_INSUFFICIENT_STORAGE` - wipe emulator data or uninstall old APK builds.

### Launch crash after reinstall

If the app crashes on splash with FGS SecurityException, clear app storage (stale running alarm + missing runtime location). Fixed in v3.1.2+ by permission gating - pull latest and retest.
