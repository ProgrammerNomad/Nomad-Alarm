# Local build (no CI)

Nomad Alarm uses **local builds only**. GitHub Actions workflow was removed.

## Prerequisites

- Flutter SDK (see `pubspec.yaml` SDK constraint)
- Android SDK / `key.properties` for signed release (see `android/key.properties.example`)

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
