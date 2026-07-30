---
layout: default
title: Privacy Policy
nav_order: 2
permalink: /privacy-policy/
---

# Privacy Policy

**Nomad Alarm** (`com.nomad.alarm`)  
**Last updated:** July 30, 2026

## Summary

Nomad Alarm is a privacy-first location alarm. We do not collect, store, or share your personal data on our servers because **we do not operate any servers for this app**.

## Data stored on your device

The app stores the following locally on your phone:

- Alarm destinations and settings
- Trip and history records
- Favorites and recent searches
- App preferences (theme, units, battery profile, accessibility options)
- Optional encrypted API keys you enter for third-party map/search providers

This data never leaves your device unless **you** choose to export a backup file or upload a backup to a URL you provide.

## Location

Location is used only to:

- Calculate distance to your alarm destination
- Run background tracking while an alarm is active

Location is **not** uploaded to Nomad Alarm or any analytics service by this app.

## Network use

The app may contact:

- **OpenStreetMap / Nominatim / OSRM** for map tiles, place search, and routing (see [OpenStreetMap privacy policy](https://wiki.osmfoundation.org/wiki/Privacy_Policy))
- **Optional providers** (Google Maps, Mapbox, HERE, GraphHopper, Photon, etc.) if you enable them and supply your own API keys
- **A user-specified HTTPS URL** if you use optional cloud backup upload - the app POSTs a backup JSON file only to the URL you enter

No account is required.

## Sharing features (local only)

- **Export backup** creates a JSON file on your device; you control where it is saved or shared.
- **Family / group alarm bundles** are shared via clipboard or the system share sheet - no Nomad Alarm server is involved.
- **Group travel** alarm config export/import is local file/clipboard only.

## Wear OS and Android Auto

- **Wear OS complication:** Your phone syncs active alarm distance/ETA to a paired watch via Google Wearable Data Layer. Alarm logic runs on the phone only.
- **Android Auto:** When connected, the app may show destination name and distance on a read-only in-car screen using data already on your phone. No additional data is sent to Nomad Alarm.

## Permissions

| Permission | Why |
|------------|-----|
| Location | Distance to destination |
| Background location | Alarm while screen is off |
| Notifications | Tracking and alarm alerts |
| Foreground service | Reliable GPS on Android |
| Microphone | Optional voice search (only when you tap the mic) |
| Flashlight | Optional visual alert |

## Optional API keys

If you enter API keys for map, search, or routing providers, they are stored **encrypted on device** and are **not included** in backup exports.

## Backup files

If you use Export backup, a JSON file is created on your device. If you use cloud backup upload, the file is sent only to the HTTPS endpoint you specify.

## Children

Nomad Alarm is not directed at children under 13.

## Languages

The app supports English, Hindi, Arabic, and Hebrew. All strings are bundled in the app; no personal data is sent for translation.

## Changes

We may update this policy. The in-app link points to this page on GitHub Pages.

## Contact

Open an issue on [GitHub](https://github.com/ProgrammerNomad/Nomad-Alarm/issues) for privacy questions.

---

See also: [Data Safety]({{ '/data-safety/' | relative_url }}) · [Terms of Service]({{ '/terms/' | relative_url }})
