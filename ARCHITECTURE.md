# Architecture Overview

Nomad Alarm is a Flutter app built for **reliable, privacy-first location alarms**.

For the full technical specification, see **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**.

---

## Quick Summary

| Layer | Technology |
|-------|------------|
| UI | Flutter, Material 3 |
| State | Riverpod |
| Routing | go_router |
| Data access | **Repository layer** |
| Database | Isar (local only) |
| Location | geolocator + foreground service |
| Maps | MapLibre + OSM (default) |
| Search | Nominatim (default) |
| Routing | OSRM (default) |

---

## Architecture Diagram

```
UI (Screens)
     ↓
Controllers / Notifiers
     ↓
Repositories          ← data access boundary (mockable)
     ↓
Services + Providers
     ↓
Isar DB + Platform APIs
```

**No backend.** Optional API keys stored encrypted on device.

---

## Key Design Decisions

1. **Feature-first folders** - each feature owns screens and controllers
2. **Repository layer** - controllers never touch Isar or HTTP directly
3. **Service layer** - all platform access through services
4. **Provider abstraction** - map/search/route swappable without UI changes
5. **Foreground service** - required for reliable background GPS on Android
6. **Offline first** - active alarm works with GPS only

---

## Detailed Documentation

* [Architecture (full)](docs/ARCHITECTURE.md)
* [Repositories](docs/REPOSITORIES.md)
* [Diagrams](docs/DIAGRAMS.md)
* [Database Schema](docs/DATABASE.md)
* [Services](docs/SERVICES.md)
* [Design System](docs/DESIGN_SYSTEM.md)
* [User Flows](docs/USER_FLOWS.md)
* [Error Handling](docs/ERROR_HANDLING.md)
* [Setup Guide](docs/SETUP.md)
