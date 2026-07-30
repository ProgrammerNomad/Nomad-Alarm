# Nomad Alarm Documentation

This folder is the **Jekyll source** for the public docs site and developer documentation.

**Live site:** [programmernomad.github.io/Nomad-Alarm](https://programmernomad.github.io/Nomad-Alarm/)

**Play Console URLs:**
- [Privacy Policy](https://programmernomad.github.io/Nomad-Alarm/privacy-policy/)
- [Terms of Service](https://programmernomad.github.io/Nomad-Alarm/terms/)
- [Data Safety](https://programmernomad.github.io/Nomad-Alarm/data-safety/)

Local preview: `cd docs && bundle install && bundle exec jekyll serve --baseurl ""`

Start here if you are new to the project.

---

## Reading Order (Build the App)

1. [Master Blueprint](MASTER_BLUEPRINT.md) - vision, features, high-level overview
2. [Architecture](ARCHITECTURE.md) - layers, repository pattern, data flow
3. [Repositories](REPOSITORIES.md) - data access layer (controllers → repositories → services)
4. [Design System](DESIGN_SYSTEM.md) - colors, typography, spacing, components
5. [User Flows](USER_FLOWS.md) - end-to-end UX paths
6. [Diagrams](DIAGRAMS.md) - architecture, sequence, and state diagrams
7. [Setup Guide](SETUP.md) - environment, dependencies, first run
8. [Roadmap](ROADMAP.md) - phased implementation plan with milestones
9. [Database Schema](DATABASE.md) - Isar collections and relationships
10. [Services](SERVICES.md) - platform and business logic services
11. [Screens](SCREENS.md) - UI specs for every screen
12. [Permissions](PERMISSIONS.md) - Android permissions and foreground service
13. [Constants](CONSTANTS.md) - magic numbers and defaults
14. [Feature Flags](FEATURE_FLAGS.md) - compile-time and runtime flags
15. [Error Handling](ERROR_HANDLING.md) - failure modes and recovery UX
16. [Events](EVENTS.md) - local-only debug events (no analytics)
17. [Battery](BATTERY.md) - battery profiles and OEM strategies
18. [API Integration](API_INTEGRATION.md) - map, search, routing providers
19. [Testing](TESTING.md) - unit, widget, integration, manual tests

---

## Design & UX

| Document | Purpose |
|----------|---------|
| [Design System](DESIGN_SYSTEM.md) | Colors, typography, spacing, M3 tokens, components |
| [User Flows](USER_FLOWS.md) | First launch, create alarm, offline, permissions |
| [Diagrams](DIAGRAMS.md) | Mermaid architecture, sequence, state, ER diagrams |
| [Assets](ASSETS.md) | Logo, fonts, illustrations, sounds |
| [Sounds](SOUNDS.md) | Alarm sounds, TTS, vibration, flashlight patterns |
| [L10N](L10N.md) | Languages, ARB files, RTL, units |
| [Widgets](WIDGETS.md) | Home screen widgets, lock screen, Quick Settings |

---

## Release & Operations

| Document | Purpose |
|----------|---------|
| [Play Store](PLAY_STORE.md) | Store listing, Data Safety, background location |
| [../RELEASE_CHECKLIST.md](../RELEASE_CHECKLIST.md) | Pre-release and post-release steps |
| [../VERSIONING.md](../VERSIONING.md) | Semantic versioning rules |

---

## Repository Docs

| Document | Purpose |
|----------|---------|
| [../README.md](../README.md) | Project overview and quick links |
| [../ROADMAP.md](../ROADMAP.md) | Release timeline (v1.0 → v3.1) |
| [../ARCHITECTURE.md](../ARCHITECTURE.md) | Architecture summary (see also [Architecture](ARCHITECTURE.md)) |
| [../CONTRIBUTING.md](../CONTRIBUTING.md) | How to contribute |
| [../CHANGELOG.md](../CHANGELOG.md) | Version history |
| [../SECURITY.md](../SECURITY.md) | Security policy |
| [../CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md) | Community standards |
| [../LICENSE](../LICENSE) | MIT License |
| [../.github/LABELS.md](../.github/LABELS.md) | GitHub issue labels |
| [../.github/DISCUSSIONS.md](../.github/DISCUSSIONS.md) | Discussion categories |

---

## Guiding Principle

Build the **most reliable location alarm**, not the app with the most features. Every document and implementation decision should support:

* Privacy (no accounts, no tracking, no backend)
* Offline-first reliability
* Battery efficiency
* Fast, clear UX

**Ready to code?** Start with [Setup](SETUP.md) → Phase 0 in [Roadmap](ROADMAP.md).
