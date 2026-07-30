---
layout: default
title: Data Safety
nav_order: 4
permalink: /data-safety/
---

# Data Safety (Google Play)

Reference for completing the **Data Safety** section in Google Play Console for Nomad Alarm v3.1.

**Privacy policy URL:** [Privacy Policy]({{ '/privacy-policy/' | relative_url }})

---

## Data collected

| Data type | Collected? | Shared with third parties? | Purpose |
|-----------|------------|------------------------------|---------|
| Location (precise) | Yes | No | Core alarm - distance to destination |
| Location (background) | Yes | No | Alarm while app closed / screen off |
| Personal info (name, email, etc.) | No | No | - |
| Financial info | No | No | - |
| Photos / videos | No | No | - |
| App activity / analytics | No | No | - |
| Device or other IDs | No | No | - |

## Data handling

| Question | Answer |
|----------|--------|
| Encrypted in transit | N/A - no Nomad Alarm server |
| Encrypted at rest | Yes - local database on device |
| User can request deletion | Yes - clear app data or uninstall |
| Data optional | Location required for core feature |
| Data sold | No |
| Data used for advertising | No |

## Third-party services (user-initiated)

If the user enables optional providers or cloud backup:

- Map/search/routing requests go directly from the device to the chosen provider (OSM, Google, Mapbox, etc.)
- Cloud backup upload sends a JSON file only to a user-entered HTTPS URL

Nomad Alarm does not receive this data.

## Background location

Background location is used **only while an active alarm is running** to calculate distance to the destination. See [Permissions]({{ '/PERMISSIONS/' | relative_url }}) and [Play Store checklist]({{ '/PLAY_STORE/' | relative_url }}) for disclosure and demo video requirements.

## Children

Not designed for children under 13.

---

See also: [Privacy Policy]({{ '/privacy-policy/' | relative_url }}) · [Play Store]({{ '/PLAY_STORE/' | relative_url }})
