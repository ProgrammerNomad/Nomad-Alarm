---
layout: default
title: QA Sign-off
parent: Release
nav_order: 2
nav_exclude: true
permalink: /RELEASE_QA_SIGNOFF/
---
# Release QA Sign-off (v3.1.0)

Manual verification matrix from [TESTING.md](TESTING.md). Run on a **physical Android device** before Play Store submission.

**Device:** _________________________  
**Android version:** _________________________  
**App version:** 3.1.1+8  
**Tester:** _________________________  
**Date:** _________________________  

## Automated checks (local)

| Check | Command | Pass |
|-------|---------|------|
| Clean build | `flutter clean && flutter pub get` | [ ] |
| Codegen | `dart run build_runner build --delete-conflicting-outputs` | [ ] |
| L10n | `flutter gen-l10n` | [ ] |
| Analyze | `flutter analyze` (zero issues) | [ ] |
| Unit + widget tests | `flutter test` (96+ tests) | [ ] |
| Integration smoke | `flutter test integration_test/` | [ ] |
| Release AAB | `flutter build appbundle --release` | [ ] |

## Manual scenarios (v1 core)

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

## v2/v3 add-ons

| # | Scenario | Pass |
|---|----------|------|
| 13 | Switch map/search/route providers in Settings | [ ] |
| 14 | Offline tile download from map viewport | [ ] |
| 15 | Trip detail shows route polyline map | [ ] |
| 16 | Extended alarm types (geofence, ETA, speed) | [ ] |
| 17 | Group travel / family bundle share + import | [ ] |
| 18 | Lock screen info toggle hides notification details | [ ] |
| 19 | Internet-lost alert during active alarm | [ ] |
| 20 | Voice search mic on Search screen | [ ] |
| 21 | Quick Settings tile: inactive → search, active → cancel | [ ] |
| 22 | Wear complication shows distance/ETA (optional) | [ ] |
| 23 | Android Auto navigation template (DHU) | [ ] |
| 24 | Arabic/Hebrew RTL layout smoke test | [ ] |
| 25 | iOS background alarm on physical iPhone | [ ] |

## Sign-off

- [ ] All manual scenarios passed on physical device

**Signed:** _________________________ **Date:** _________________________
