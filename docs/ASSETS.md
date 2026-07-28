# Assets

Asset inventory and organization for Nomad Alarm.

All assets live under `assets/` and are declared in `pubspec.yaml`.

---

## Directory Structure

```text
assets/
├── images/
│   ├── logo/
│   │   ├── logo.svg
│   │   ├── logo_monochrome.svg
│   │   └── logo_foreground.png      # Adaptive icon foreground
│   ├── onboarding/
│   │   ├── welcome_hero.png
│   │   └── permissions_hero.png
│   ├── empty_states/
│   │   ├── no_alarms.svg
│   │   ├── no_history.svg
│   │   └── offline.svg
│   └── illustrations/
│       └── alarm_ring_hero.svg
├── icons/
│   └── app_icon/                    # Source for flutter_launcher_icons
├── fonts/
│   ├── Inter/
│   │   ├── Inter-Regular.ttf
│   │   ├── Inter-Medium.ttf
│   │   └── Inter-SemiBold.ttf
│   └── Manrope/
│       ├── Manrope-Regular.ttf
│       └── Manrope-SemiBold.ttf
├── sounds/
│   ├── alarm_default.mp3
│   ├── alarm_gentle.mp3
│   └── alarm_urgent.mp3
└── animations/
    └── (optional Lottie - v1.5)
        ├── splash.json
        └── success.json
```

---

## Logo

| Asset | Size | Use |
|-------|------|-----|
| `logo.svg` | Vector | In-app About, splash |
| `logo_monochrome.svg` | Vector | Notification icon tint |
| `logo_foreground.png` | 432×432 | Adaptive icon foreground |
| Play Store icon | 512×512 | Store listing |

Design: location pin + alarm bell motif, primary blue `#2962FF`.

Generate launcher icons:

```yaml
# pubspec.yaml
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/icons/app_icon/icon.png"
  adaptive_icon_background: "#2962FF"
  adaptive_icon_foreground: "assets/images/logo/logo_foreground.png"
```

---

## Icons

| Source | Use |
|--------|-----|
| Material Symbols (bundled via Flutter) | All in-app UI icons |
| Huge Icons (optional) | Alternative set if size permits |
| Custom notification icon | Monochrome white, 24 dp |

Notification icon must be **white silhouette on transparent** (Android requirement).

---

## Fonts

| Family | Weights | License |
|--------|---------|---------|
| Inter | 400, 500, 600 | SIL OFL |
| Manrope | 400, 600 | SIL OFL |
| Roboto | System fallback | Apache 2.0 |

```yaml
fonts:
  - family: Inter
    fonts:
      - asset: assets/fonts/Inter/Inter-Regular.ttf
      - asset: assets/fonts/Inter/Inter-SemiBold.ttf
        weight: 600
```

---

## Illustrations

| Asset | Screen |
|-------|--------|
| `welcome_hero.png` | Welcome |
| `permissions_hero.png` | Permissions |
| `no_alarms.svg` | Home empty state |
| `no_history.svg` | History empty state |
| `offline.svg` | Offline banner / empty search |
| `alarm_ring_hero.svg` | Alarm ring (optional) |

Prefer SVG for empty states (scalable, small size). PNG for complex onboarding art.

---

## Sounds

See [Sounds](SOUNDS.md) for full specification.

| File | Duration | Size target |
|------|----------|-------------|
| `alarm_default.mp3` | 15–30 sec loop | < 200 KB |
| `alarm_gentle.mp3` | 15–30 sec loop | < 200 KB |
| `alarm_urgent.mp3` | 10–20 sec loop | < 150 KB |

Format: MP3 or OGG, 44.1 kHz, mono for size.

---

## Animations (Optional - v1.5)

Lottie JSON for:
* Splash logo animation
* Success check after alarm saved
* Empty state subtle motion

Keep each file **< 100 KB**. Disable when `MediaQuery.disableAnimations` is true.

---

## pubspec.yaml Registration

```yaml
flutter:
  assets:
    - assets/images/logo/
    - assets/images/onboarding/
    - assets/images/empty_states/
    - assets/sounds/

  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter/Inter-Regular.ttf
        - asset: assets/fonts/Inter/Inter-SemiBold.ttf
          weight: 600
```

---

## Size Budget

| Category | Target |
|----------|--------|
| Fonts | < 500 KB total |
| Sounds | < 600 KB total |
| Images/illustrations | < 1 MB total |
| Lottie (if used) | < 200 KB total |

Total assets contribution to APK: **< 2 MB** (excluding app icon mipmaps).

---

## License & Attribution

Document third-party asset licenses in `About → Licenses` screen (Flutter `LicenseRegistry` + custom entries for Inter/Manrope).

---

## Related Docs

* [Design System](DESIGN_SYSTEM.md)
* [Sounds](SOUNDS.md)
* [Play Store](PLAY_STORE.md)
