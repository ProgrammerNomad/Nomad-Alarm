---
layout: default
title: Screens
parent: Developer
nav_order: 17
permalink: /SCREENS/
---
# Screen Specifications

Detailed UI specs for every screen in Nomad Alarm.

Navigation uses **go_router** with a 3-tab bottom nav shell: **Alarms**, History, and Settings.

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
| Redirect | Welcome (first launch) → Permissions (if needed) → Alarms or Active Alarm |

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

**CTA:** "Continue to Alarms" when minimum permissions granted (location + notifications).

---

## Alarms

**Route:** `/alarms` (bottom nav) - **multi-alarm dashboard** (`/home` redirects here)

| Section | Content |
|---------|---------|
| App bar | "Alarms" |
| Search bar | Tap → Search screen (primary entry) |
| Saved Places card | Under search: star header, **Manage >**, quick chips (Home/Office/…), **+ More**; hidden when empty |
| Active alarms | Top **5** nearest shown; **View all active in History** when more; live cards with pause/resume/cancel; overflow **Share**; **AUTO** chip on smart-started alarms |
| Recent searches | Last 3 search destinations (first-alarm empty card has no CTA button) |
| FAB | Sole **+** create action → bottom sheet: **New Alarm**, **Import Alarm**, **Saved Places**, Cancel |

Settings → Language picker shows each option in **native script** (e.g. हिन्दी, العربية). Settings sections use icons for faster scanning.

**After Save & Start:** returns here with "Alarm created successfully" snackbar.

**After Save only:** navigates to History (All filter) - draft appears there, not on Alarms tab.

**Tap alarm card:** opens Alarm details (`/alarm/active/:id`), not a trapped tracking screen.

---

## Saved Places

**Routes:** `/saved-places`, `/saved-places/new`, `/saved-places/:id/edit`

List shows Smart Alarm mode, last used, auto-started count (no prediction %). Add/edit: category icons, Smart Alarm Off/Suggest/Automatic, alert distance. First Home save shows onboarding sheet.

---

## Alarm details (Active Alarm)

**Route:** `/alarm/active/:id`

Detail page for one alarm: destination, distance, ETA, speed, accuracy, map link, **Share**, pause/cancel. Back returns to Alarms. Ring screen still opens automatically when triggered.

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
| Stats header | Active, **Saved**, completed, missed counts; success rate |
| Filters | Horizontally scrollable chips: All, **Active**, **Saved**, Completed, Missed, Cancelled, Snoozed |
| List item | **Active rows:** destination, started time, live distance/ETA, tap → active alarm screen. **Saved (draft) rows:** destination, saved time, grey Saved badge, Start + Delete actions. **Past rows:** destination, date, outcome badge, distance |
| Tap | Active → `/alarm/active/:id`; draft → edit via alarm config (optional); past → detail bottom sheet with journey map when trip linked |
| Swipe | Delete entry (with confirm) - past entries only |

**Saved filter:** shows draft alarms only (alarms saved without starting). Empty state when none.

**All filter:** merges active + saved drafts + past history (active first, then drafts by created date, then past).

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

Subtitle: *Manage app behavior, maps, notifications, and privacy.*

| Section | Items |
|---------|-------|
| Appearance | Theme picker tile → bottom sheet (system / light / dark) |
| Units | km / mi segmented control |
| Language | Picker tile → bottom sheet (Follow system, en, hi, ar, he with native endonyms) |
| Alarm | Default alarm distance picker, voice announcements, vibration, flashlight, lock screen |
| Accessibility | High contrast toggle |
| Power & Battery | GPS Profile picker tile → bottom sheet (Balanced recommended); helper text under selection; resume after reboot |
| Smart Places | Enable Smart Alarm master toggle only (no Saved Places link) |
| Backup | **Transfer Data** → dedicated screen (export, import, HTTPS upload, last-backup metadata) |
| Maps & routing | Link → Map settings |
| System | Permissions, Privacy, About, Debug (debug builds) |

---

## Transfer Data

**Route:** `/settings/transfer-data`

| Section | Content |
|---------|---------|
| Actions | Export backup (share JSON), Import backup (confirm + merge), Upload via HTTPS (when enabled) |
| Metadata | Auto Backup switch (disabled, coming soon); Last Backup timestamp or **Never** |

---

## Map Settings

**Route:** `/settings/map`

| Section | Content |
|---------|---------|
| Providers | Map provider row → bottom sheet with badges and **Configured** label; inline credential sheet when selecting a key-based provider; overflow menu (Edit / Test / Remove) on configured provider |
| Advanced | Override search/route toggles + picker tiles when enabled |
| Map layer | Picker tile → bottom sheet (standard / dark / satellite / terrain) |
| Offline tiles | Cache size, download sample region, clear (when enabled) |

Map provider changes persist **immediately** (OSM with no prompt; Google/Mapbox/HERE via inline bottom sheet with Test and **Save & Use**). Map layer and override changes are staged until **Save**.

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
| Alarms | notifications_active | `/alarms` |
| History | history | `/history` |
| Settings | settings | `/settings` |

Legacy `/home` redirects to `/alarms`.

Use `NavigationBar` (Material 3). Hide bottom nav on full-screen flows (Alarm Ring, Permissions wizard).

---

## Related Docs

* [Architecture](ARCHITECTURE.md)
* [Roadmap](ROADMAP.md)
* [Permissions](PERMISSIONS.md)
