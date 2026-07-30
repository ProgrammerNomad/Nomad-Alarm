---
layout: default
title: Screens
parent: Developer
nav_order: 17
permalink: /SCREENS/
---
# Screen Specifications

Detailed UI specs for every screen in Nomad Alarm.

Navigation uses **go_router** with a bottom nav shell for Home, Trips, History, and Settings.

---

## Global UI Rules

* Material 3 components throughout
* Support light, dark, and dynamic color
* Minimum touch target: 48×48 dp
* All screens support system font scaling (accessibility)
* Loading states use skeleton/shimmer where appropriate
* Error states show actionable retry button

---

## Splash

**Route:** `/`

| Element | Behavior |
|---------|----------|
| App logo | Centered, fade-in animation |
| Loading | Initialize Isar, services, read settings |
| Redirect | Welcome (first launch) → Permissions (if needed) → Home or Active Alarm |

**Duration:** Max 2 seconds; skip animation if ready sooner.

---

## Welcome

**Route:** `/welcome` (first launch only)

| Element | Behavior |
|---------|----------|
| Hero illustration | Train/bus commuter theme |
| Title | "Never miss your stop again" |
| Bullet points | Privacy, offline, free |
| CTA | "Get Started" → Permissions |

---

## Permissions

**Route:** `/permissions`

Guided step-by-step flow (not one scary dialog):

1. Location (while in use) - explain why
2. Background location - explain alarm while sleeping
3. Notifications - explain tracking + alarm alerts
4. Exact alarm (Android 12+) - explain reliable wake
5. Battery optimization - optional skip with warning

Each step: icon, plain-language explanation, Grant / Skip / Open Settings.

**CTA:** "Continue to Home" when minimum permissions granted (location + notifications).

---

## Home

**Route:** `/home` (bottom nav)

| Section | Content |
|---------|---------|
| App bar | "Nomad Alarm", settings shortcut |
| Current location | Address or coordinates chip, tap → Map |
| Search bar | Tap → Search screen |
| Active alarm card | If running: destination, distance, ETA, tap → Active Alarm |
| Favorites row | Horizontal chips: Home, Office, + custom |
| Recent | Last 3 destinations |
| FAB | "Create Alarm" → Alarm Config |

**Empty state:** Illustration + "Set your first destination alarm"

---

## Search

**Route:** `/search`

| Element | Behavior |
|---------|----------|
| Search field | Autofocus, debounce 300 ms |
| Voice button | `speech_to_text` mic when `FeatureFlags.voiceSearch` (v3.1) |
| Suggestions | Live results from SearchService |
| Recent | Below suggestions when query empty |
| Favorites | Quick pick section |
| Result tap | Select destination → Alarm Config with pre-filled destination |
| Map button | Open map with search bias |

Supports: place names, stations, airports, coordinates, Plus Codes.

---

## Map

**Route:** `/map`

| Element | Behavior |
|---------|----------|
| Map view | Full screen, user location dot |
| Layers button | Standard / satellite / terrain / dark |
| Compass | Rotate map to heading |
| Zoom controls | +/- or pinch |
| Center button | Animate to current location |
| Drop pin | Long press → draggable pin |
| Bottom sheet | Pin address, "Set Alarm", "Save Favorite" |

**Args:** Optional `lat`, `lng`, `zoom` query params.

---

## Alarm Config

**Route:** `/alarm/new` or `/alarm/edit/:id`

| Section | Fields |
|---------|--------|
| Destination | Name, address, map preview |
| Trigger | Distance slider (100 m – 5 km), type selector |
| Travel mode | Train, bus, metro, car, walking, cycling, auto |
| Alert | Voice toggle + custom message, vibration, flashlight |
| Repeat | One-time / repeat toggle |
| Advanced | ETA-based trigger, geofence radius (collapsible) |
| Actions | Save, Save & Start |

**Validation:**
* Destination required
* triggerDistanceMeters > 0
* Show inline errors

---

## Active Alarm

**Route:** `/alarm/active/:id`

| Element | Behavior |
|---------|----------|
| Destination header | Name + address |
| Live distance | Large primary text, updates every GPS tick |
| ETA | From RouteService or estimate |
| Speed | Current speed km/h |
| GPS accuracy | Meters, color-coded (green/yellow/red) |
| Mini map | Route line + user dot + destination pin |
| Actions | Pause, Cancel, Open full Map |
| Warnings | Banner for GPS lost, low battery, passed destination |

Must remain functional from notification tap when app is backgrounded.

---

## Alarm Ring

**Route:** `/alarm/ring/:id`

Full-screen, high priority, shown on lock screen.

| Element | Behavior |
|---------|----------|
| Alert animation | Pulsing icon |
| Message | Destination name + voice playing |
| Flashlight | Toggle if enabled |
| Dismiss | Stop alarm, mark completed |
| Snooze | Re-trigger in 2 min (configurable) |
| Emergency | Optional shortcut (call/contact - future) |

Back button disabled; must explicitly dismiss or snooze.

---

## Navigation (Optional v1.0)

**Route:** `/navigation/:id`

Turn-by-turn lite: heading arrow, distance remaining, no full navigation engine in v1.0. Can defer to v1.5.

---

## History

**Route:** `/history` (bottom nav)

| Element | Behavior |
|---------|----------|
| Tabs | All, Completed, Missed |
| List item | Destination, date, outcome badge, distance |
| Tap | Detail bottom sheet |
| Swipe | Delete entry (with confirm) |

---

## Trips

**Route:** `/trips` (bottom nav)

| Element | Behavior |
|---------|----------|
| List | Trips sorted by date desc |
| Item | Destination, duration, distance, outcome |
| Tap | Trip detail: map polyline, stats, linked alarm |

---

## Saved Places / Favorites

**Route:** `/favorites`

Grid or list of favorites with category icons. Add, edit, delete, reorder. Tap → Alarm Config or Map.

---

## Recent

**Route:** `/recent`

Full recent search list with clear-all option.

---

## Settings

**Route:** `/settings` (bottom nav)

| Section | Items |
|---------|-------|
| Appearance | Theme, accent color, font |
| Maps | Provider, default layer |
| Alarm | Default distance, voice, vibration |
| Battery | Profile: balanced / aggressive / saver |
| Permissions | Link → Permission Center |
| Privacy | Link → Privacy screen |
| About | Version, licenses, GitHub |
| Debug | Visible in debug builds only |

---

## Map Settings

**Route:** `/settings/map`

Provider picker, layer default, cache clear, optional API key entry.

---

## Google API

**Route:** `/settings/google-api`

Fields for Maps, Places, Directions API keys. Stored encrypted. Test connection button.

---

## Alarm Settings

**Route:** `/settings/alarm`

Default ringtone picker, snooze duration, repeat behavior, full volume override toggle.

---

## Battery

**Route:** `/settings/battery`

Battery profile, ignore optimization guide, estimated drain info.

---

## Permission Center

**Route:** `/settings/permissions`

Table of all permissions with status (granted/denied) and fix button.

---

## Privacy

**Route:** `/privacy`

Static content: no login, no ads, no analytics, local-only data, open source link.

---

## About

**Route:** `/about`

App version, developer, license, GitHub, contributors, rate app link.

---

## Debug

**Route:** `/debug` (debug builds)

GPS coords stream, mock location toggle, service status, log viewer, crash test buttons.

---

## Widgets (v1.5)

**Not a screen** - Android home screen widgets:

| Size | Content |
|------|---------|
| Small | Distance to destination |
| Medium | Distance + ETA + destination name |
| Large | Map thumbnail + stats + cancel button |

---

## Bottom Navigation

| Tab | Icon | Route |
|-----|------|-------|
| Home | home | `/home` |
| Trips | route | `/trips` |
| History | history | `/history` |
| Settings | settings | `/settings` |

Use `NavigationBar` (Material 3). Hide bottom nav on full-screen flows (Alarm Ring, Permissions wizard).

---

## Related Docs

* [Architecture](ARCHITECTURE.md)
* [Roadmap](ROADMAP.md)
* [Permissions](PERMISSIONS.md)
