# Release Roadmap

High-level release timeline for Nomad Alarm. For the full phased implementation plan, see [docs/ROADMAP.md](docs/ROADMAP.md).

---

## v1.0 - Core Location Alarm (MVP)

**Target:** First public Android release

**Includes:**
* Distance-based location alarms
* Map with OpenStreetMap (flutter_map)
* Place search (Nominatim)
* Background GPS tracking (foreground service)
* Persistent notification with live distance
* Alarm ring: voice, vibration, flashlight
* Active alarm screen
* History and trips
* Settings (theme, units, language, battery profile)
* Permission onboarding flow
* Privacy-first: no login, no ads, no analytics

**Success criteria:**
* Alarm triggers reliably with screen off for 30+ minutes
* App works without internet for active alarm
* Play Store ready APK/AAB

---

## v1.5 - Convenience

**Includes:**
* Home screen widgets (small, medium, large)
* Quick Settings tile
* Favorite trips
* Share/import destinations (Google Maps, geo URI)
* Backup and restore (JSON)
* Route import from shared links

---

## v2.0 - Multi-Provider

**Includes:**
* Swappable map, search, and routing providers
* Bring Your Own Google API keys (Maps, Places, Directions)
* HERE and Mapbox optional support
* Map settings screen
* Basic offline tile caching
* Wear OS complication (bundled module)

---

## v3.0 - Smart & Social (shipped)

**Includes:**
* On-device smart ETA improvements
* Group travel (local alarm sharing)
* Extended alarm types, custom ringtone, cloud backup upload

---

## v3.1 - Ecosystem & docs (shipped)

**Includes:**
* Wear OS complication module + Data Layer
* Android Auto read-only navigation template
* Voice search, family alarm bundles, high contrast theme
* Arabic and Hebrew full UI
* Jekyll docs site + Play Console legal pages

**Next:** Play Store submission - see [docs/PLAY_PREP.md](docs/PLAY_PREP.md)

---

## Guiding Principle

Every version must improve **alarm reliability** first. Features that compromise battery life, privacy, or background stability are deferred or made opt-in.

---

## Documentation

| Version | Doc Updates Required |
|---------|---------------------|
| Each release | CHANGELOG.md |
| New features | Relevant docs/ files |
| Breaking changes | Migration notes in CHANGELOG + DATABASE.md |
