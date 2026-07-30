# Nomad Alarm

[![Docs](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://programmernomad.github.io/Nomad-Alarm/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A privacy-first location alarm that wakes you before reaching your destination.

Nomad Alarm is a free, open-source, offline-first Flutter app for commuters and travelers. Set a destination, choose how far before arrival you want to be alerted, and the app monitors GPS in the background - even with the screen off - so you never miss your stop.

**No ads. No subscriptions. No login. No tracking.**

---

## Documentation

**Public site:** [programmernomad.github.io/Nomad-Alarm](https://programmernomad.github.io/Nomad-Alarm/) - privacy policy, terms, developer docs

**Developer index:** [docs/README.md](docs/README.md) (recommended reading order)

### Core

| Document | Description |
|----------|-------------|
| [Master Blueprint](docs/MASTER_BLUEPRINT.md) | Vision, features, tech stack |
| [Architecture](docs/ARCHITECTURE.md) | Layers, repository pattern, data flow |
| [Repositories](docs/REPOSITORIES.md) | Data access layer spec |
| [Diagrams](docs/DIAGRAMS.md) | Sequence, state, ER diagrams (Mermaid) |
| [Roadmap](docs/ROADMAP.md) | Phase-by-phase build plan |
| [Setup Guide](docs/SETUP.md) | Dev environment and dependencies |

### Design & UX

| Document | Description |
|----------|-------------|
| [Design System](docs/DESIGN_SYSTEM.md) | Colors, typography, spacing, components |
| [User Flows](docs/USER_FLOWS.md) | End-to-end UX paths |
| [Screens](docs/SCREENS.md) | UI spec for every screen |
| [Assets](docs/ASSETS.md) | Logo, fonts, illustrations |
| [Sounds](docs/SOUNDS.md) | Alarm, voice, vibration, flashlight |
| [L10N](docs/L10N.md) | Languages, RTL, units |

### Implementation

| Document | Description |
|----------|-------------|
| [Database](docs/DATABASE.md) | Isar schema |
| [Services](docs/SERVICES.md) | Location, alarm, notification services |
| [Constants](docs/CONSTANTS.md) | GPS intervals, defaults, limits |
| [Feature Flags](docs/FEATURE_FLAGS.md) | Version-gated features |
| [Error Handling](docs/ERROR_HANDLING.md) | Failure recovery UX |
| [Events](docs/EVENTS.md) | Local debug events (no analytics) |
| [Battery](docs/BATTERY.md) | Profiles and OEM strategies |
| [Permissions](docs/PERMISSIONS.md) | Android FGS and manifest |
| [API Integration](docs/API_INTEGRATION.md) | OSM, Nominatim, BYO Google |
| [Testing](docs/TESTING.md) | Test matrix |
| [Widgets](docs/WIDGETS.md) | Home screen widgets (v1.5) |

### Release

| Document | Description |
|----------|-------------|
| [Play Store](docs/PLAY_STORE.md) | Store submission checklist |
| [Release Checklist](RELEASE_CHECKLIST.md) | Pre/post release steps |
| [Versioning](VERSIONING.md) | Semver rules |
| [ROADMAP](ROADMAP.md) | v1.0 → v3.0 timeline |

### Community

| Document | Description |
|----------|-------------|
| [Contributing](CONTRIBUTING.md) | How to contribute |
| [Security](SECURITY.md) | Security policy |
| [Changelog](CHANGELOG.md) | Version history |

---

## Quick Start (When Code Is Scaffolded)

```bash
git clone https://github.com/ProgrammerNomad/Nomad-Alarm.git
cd Nomad-Alarm
flutter pub get
flutter run
```

---

## Tech Stack

Flutter · Riverpod · go_router · Isar · geolocator · flutter_map · OpenStreetMap · Nominatim · OSRM

Package: `com.nomad.alarm`

---

## Architecture

```
UI → Controller → Repository → Service → Isar / APIs
```

No backend. See [Architecture](docs/ARCHITECTURE.md).

---

## Guiding Principle

Build the **most reliable location alarm** - not the app with the most features.

---

## License

MIT License - see [LICENSE](LICENSE). Developed by **ProgrammerNomad**.
