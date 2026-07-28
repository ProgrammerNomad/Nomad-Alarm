# API Integration

Nomad Alarm works **fully offline and free** with open providers. Optional paid APIs use a **Bring Your Own Key (BYO)** model - keys are entered by the user and stored encrypted on device. **No server-side key storage.**

---

## Provider Strategy

| Capability | Default (Free) | Optional |
|------------|----------------|----------|
| Map tiles | OpenStreetMap via MapLibre | Google Maps, Mapbox, HERE |
| Search | Nominatim | Google Places, Photon, Pelias, HERE |
| Routing/ETA | OSRM | Google Directions, GraphHopper, Valhalla |

Switch providers in **Settings → Maps** without reinstalling.

---

## Default Stack (No API Key)

### MapLibre + OpenStreetMap

* Vector/raster tiles from OSM tile servers
* Respect [OSM Tile Usage Policy](https://operations.osmfoundation.org/policies/tiles/)
* For production scale, use self-hosted tile server or commercial tile CDN

### Nominatim Search

* Endpoint: `https://nominatim.openstreetmap.org/search`
* Required: custom `User-Agent` identifying app (e.g., `NomadAlarm/1.0 (contact@email)`)
* Rate limit: **1 request per second**
* Cache results locally in `RecentSearch` collection
* Reverse geocoding: `/reverse?lat=&lon=&format=json`

### OSRM Routing

* Public demo: `https://router.project-osrm.org` (dev/testing only)
* Production: self-host OSRM or use a dedicated instance
* Profile: `car`, `foot`, `bike` - map TravelMode to profile

---

## Optional: Google APIs (BYO)

User provides keys in **Settings → Google API**.

| API | Key Type | Used For |
|-----|----------|----------|
| Maps SDK for Android | Restricted Android key | Map display, traffic layer |
| Places API | API key | Search autocomplete |
| Directions API | API key | Route polyline + ETA |

### Key Storage

```dart
// flutter_secure_storage
await secureStorage.write(key: 'google_maps_key', value: userKey);
```

* Keys encrypted via Android Keystore
* Never logged, never included in backup export
* Never committed to git

### Key Restrictions (User Instructions)

Show in-app guide:
1. Create project in Google Cloud Console
2. Enable required APIs
3. Restrict key to Android app + package `com.nomad.alarm` + SHA-1
4. Set billing alerts

---

## Optional: HERE Maps

* Map, search, routing via HERE REST APIs
* User supplies API key
* Same secure storage pattern as Google

---

## Optional: Mapbox

* Map tiles and geocoding
* Access token stored securely
* Attribution required in map UI

---

## Provider Interface

```dart
enum MapProviderType { osm, google, mapbox, here }
enum SearchProviderType { nominatim, googlePlaces, photon, pelias, here }
enum RouteProviderType { osrm, googleDirections, graphHopper, valhalla }

abstract class MapProvider {
  MapProviderType get type;
  Widget buildMap(MapController controller);
}

abstract class SearchProvider {
  SearchProviderType get type;
  Future<List<SearchResult>> search(String query, {GeoBias? bias});
  Future<SearchResult?> reverseGeocode(double lat, double lng);
}

abstract class RouteProvider {
  RouteProviderType get type;
  Future<RouteResult> getRoute(LatLng from, LatLng to, TravelMode mode);
}
```

Factory resolves implementation from `AppSettings`.

---

## Offline Behavior

| Feature | Offline Behavior |
|---------|------------------|
| Active alarm | Works (GPS only) |
| Search | Show cached/recent/favorites only |
| ETA | Straight-line estimate from speed |
| Map | Show cached tiles if available; else pin + coords |
| New route | Unavailable until online |

---

## Share & Import

Support importing destinations from:

| Source | Format |
|--------|--------|
| Google Maps | `https://maps.google.com/?q=lat,lng` |
| geo URI | `geo:lat,lng?q=label` |
| Organic Maps | `om://` links |
| Plain coords | `28.6139, 77.2090` |
| Plus Code | `XXXX+XX City` |

Parser in `lib/core/utils/deep_link_parser.dart`.

---

## Backup Format

Export file: `nomad_alarm_backup_v1.json`

```json
{
  "version": 1,
  "exportedAt": "2026-07-28T12:00:00Z",
  "appVersion": "1.0.0",
  "alarms": [
    {
      "name": "Central Station",
      "destLatitude": 28.6139,
      "destLongitude": 77.2090,
      "triggerDistanceMeters": 500,
      "travelMode": "train",
      "voiceEnabled": true
    }
  ],
  "favorites": [],
  "settings": {
    "themeMode": "system",
    "useMetric": true,
    "languageCode": "en"
  },
  "history": []
}
```

**Excluded from backup:** API keys, debug logs, raw trip polylines (optional include in v1.5).

Import validates schema version; rejects unknown versions with clear error.

---

## Rate Limiting & Error Handling

* Implement client-side throttle for Nominatim (1 req/s)
* Exponential backoff on HTTP failures
* Show "Search unavailable offline" instead of crash
* Fallback chain: primary provider → cache → coordinates-only

---

## Attribution Requirements

Display in map/settings:
* © OpenStreetMap contributors (OSM)
* Google logo when using Google Maps
* Mapbox attribution when using Mapbox

---

## Related Docs

* [Architecture](ARCHITECTURE.md)
* [Services](SERVICES.md)
* [Database](DATABASE.md)
