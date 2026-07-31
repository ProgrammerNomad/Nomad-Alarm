---
layout: default
title: Settings Guide
parent: Reference
nav_order: 7
permalink: /settings-guide/
---

# Settings Guide

Nomad Alarm works **fully free** with OpenStreetMap, Nominatim search, and OSRM routing - no account or API key required. Optional paid providers (Google, Mapbox, HERE, GraphHopper) use **Bring Your Own Key (BYO)**: you create keys in the provider's console and paste them in the app.

---

## App settings overview

Open **Settings** from the bottom navigation bar.

| Screen | Path | What it controls |
|--------|------|------------------|
| **Appearance** | Settings | Theme (light / dark / system), units (km / mi), language |
| **Map** | Settings → Map | Map, search, and route providers (bundled); inline API key setup when selecting Google/Mapbox/HERE; map layer; offline tile cache |
| **Permissions** | Settings → Permissions | Location, notifications, background location, battery |
| **Alarm defaults** | Settings → Alarm | Default trigger distance, voice, vibration |
| **Battery** | Settings → Battery | GPS profile (balanced / aggressive / saver) |
| **Backup** | Settings → Transfer Data | Export / import JSON backup, optional HTTPS upload, last-backup metadata |

Keys are stored **encrypted on device** and are **not** included in JSON backups.

---

## Google Cloud setup (single API key) {#google-cloud-setup}

One Google Cloud API key can power **Maps**, **Places search**, and **Directions routing** in Nomad Alarm. Enable all required APIs on the same key.

### 1. Create a Google Cloud project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click the project dropdown → **New Project**
3. Name it (e.g. `Nomad Alarm`) → **Create**
4. Select the new project

### 2. Enable billing

Google Maps Platform requires a billing account. Google provides **$200 USD free credit per month** for Maps, Routes, and Places - typical personal use stays within the free tier.

1. **Billing** → link or create a billing account
2. Set a **budget alert** (recommended): Billing → Budgets & alerts → Create budget

### 3. Enable required APIs

Open **APIs & Services → Library** and enable:

| API | Required for |
|-----|----------------|
| **Maps SDK for Android** | Native Google map tiles in the app |
| **Places API** (New or Legacy) | Search autocomplete |
| **Directions API** | Route polylines and ETA |

Distance Matrix API is **not required** by Nomad Alarm today.

Search each name → click **Enable**.

### 4. Create an API key

1. **APIs & Services → Credentials**
2. **+ Create credentials → API key**
3. Copy the key (starts with `AIza…`)

### 5. Restrict the key (recommended)

1. Click the key name → **Application restrictions**
2. Choose **Android apps**
3. Add:

| Field | Value |
|-------|-------|
| Package name | `com.nomad.alarm` |
| SHA-1 certificate fingerprint | See below |

4. **API restrictions** → **Restrict key** → select only:
   - Maps SDK for Android
   - Places API
   - Directions API
5. **Save**

#### Get your SHA-1 fingerprint

**Debug** (emulator / `flutter run`):

```powershell
cd android
.\gradlew signingReport
```

Look for `Variant: debug` → `SHA1` under `Task :app:signingReport`.

**Release** (Play Store builds): use the SHA-1 from your upload keystore or Play App Signing certificate in Play Console → Setup → App signing.

### 6. Configure Nomad Alarm

1. Open **Settings → Map**
2. Select **Google Maps** - an inline credential sheet appears
3. Enter your **standard Google API key** (the same key from step 4)
4. Tap **Test** - confirm Maps, Places, and Directions status for that key
5. Tap **Save & Use Google Maps**
6. Open the **Map** screen - tiles should load (not a grey blank map)

Optional: long-press a configured provider in the picker, or use the overflow menu on the Map provider row, to **Edit**, **Test**, or **Remove** credentials.

Tap **Setup guide** in the credential sheet to open this page.

---

## Troubleshooting Google Maps

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Grey / blank map | No key saved, or Maps SDK not enabled | Save key in app; enable Maps SDK for Android |
| Map works, search fails | Places API not enabled | Enable Places API on the same key |
| No route / ETA | Directions API not enabled | Enable Directions API on the same key |
| `API key not valid` | Wrong SHA-1 restriction or billing off | Re-run `signingReport`; verify billing |
| `This API project is not authorized` | API not enabled in Cloud Console | Enable the missing API from step 3 |
| Test passes but map blank | Saved key after app start without reopening map | Go back to Map screen after Save (key applies immediately on Android) |

---

## Other providers (optional)

### Mapbox

1. Create account at [mapbox.com](https://www.mapbox.com/)
2. Copy **Default public token** (`pk.…`)
3. **Settings → Map** → select **Mapbox** → enter token → **Test** → **Save & Use Mapbox**

### HERE

1. [developer.here.com](https://developer.here.com/) → create project → REST API key
2. **Settings → Map** → select **HERE** → enter key → **Test** → **Save & Use HERE**

### GraphHopper

1. [graphhopper.com](https://www.graphhopper.com/) → Dashboard → API keys
2. **Settings → Map** → enable **Override route provider** → select **GraphHopper** → tap **Save** (inline credential sheet)

---

## Privacy note

When you enable a third-party provider, map/search/route requests go **directly from your device** to that provider using your key. Nomad Alarm does not proxy or store requests on our servers. See [Privacy Policy]({{ '/privacy-policy/' | relative_url }}).

---

## Related docs

- [API Integration]({{ '/API_INTEGRATION/' | relative_url }}) - technical provider details
- [Map Settings screen]({{ '/SCREENS/' | relative_url }}) - UI reference
- [Setup Guide]({{ '/SETUP/' | relative_url }}) - developer build instructions
