# Release QA Sign-off (v1.5.0)

Manual verification matrix from [TESTING.md](TESTING.md). Run on a **physical Android device** before Play Store submission.

Build locally per [LOCAL_BUILD.md](LOCAL_BUILD.md) - no CI required.

**Device:** _________________________  
**Android version:** _________________________  
**App version:** 1.5.0+2  
**Tester:** _________________________  
**Date:** _________________________  

## Automated checks (local)

| Check | Command | Pass |
|-------|---------|------|
| Clean build | `flutter clean && flutter pub get` | [x] |
| Codegen | `dart run build_runner build --delete-conflicting-outputs` | [x] |
| L10n | `flutter gen-l10n` | [x] |
| Analyze | `flutter analyze` (zero issues) | [x] |
| Unit + widget tests | `flutter test` (43 tests) | [x] |
| Release AAB | `flutter build appbundle --release` | [ ] |

## Manual scenarios

| # | Scenario | Pass |
|---|----------|------|
| 1 | Fresh install → welcome → permissions → home | [ ] |
| 2 | Search destination → create alarm → start | [ ] |
| 3 | Active alarm shows distance + ETA | [ ] |
| 4 | Background GPS 30+ min (screen off) | [ ] |
| 5 | Notification pause / resume | [ ] |
| 6 | Notification cancel | [ ] |
| 7 | Alarm rings (TTS + vibration + optional flashlight) | [ ] |
| 8 | Dismiss / snooze from ring screen | [ ] |
| 9 | Low battery warning | [ ] |
| 10 | Offline active alarm (airplane mode) | [ ] |
| 11 | History + trip logged after completion | [ ] |
| 12 | Permission revoke / re-grant flows | [ ] |
| 13 | Settings → Hindi → UI shows Hindi on Home, Settings, Welcome | [ ] |

## v1.5.0 add-ons

| # | Scenario | Pass |
|---|----------|------|
| 14 | Export backup → share JSON | [ ] |
| 15 | Import backup on clean install | [ ] |
| 16 | Small + medium home widgets show live distance | [ ] |
| 17 | Widget tap opens active alarm / home | [ ] |

## Play Store assets

| Item | Path | Pass |
|------|------|------|
| 4–8 screenshots | `docs/play-store/screenshots/` | [ ] |
| Feature graphic 1024×500 | `docs/play-store/feature_graphic.png` | [ ] |

## Sign-off

- [ ] All manual scenarios passed on physical device
- [ ] Play Store assets captured
- [ ] Signed AAB uploaded to Play Console (internal track minimum)

**Signed:** _________________________ **Date:** _________________________
