# Versioning

Nomad Alarm follows [Semantic Versioning 2.0.0](https://semver.org/).

---

## Format

```
MAJOR.MINOR.PATCH+BUILD
```

Example in `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

| Part | Meaning | When to bump |
|------|---------|--------------|
| **MAJOR** | Breaking changes | Database migration user must re-import, incompatible backup format, removed feature |
| **MINOR** | New features (backward compatible) | New screen, widgets, provider support |
| **PATCH** | Bug fixes | Alarm trigger fix, crash fix, typo |
| **BUILD** (+N) | Internal build number | Every store upload; must monotonically increase |

---

## Examples

| Version | Scenario |
|---------|----------|
| `1.0.0+1` | First public release |
| `1.0.1+2` | Hotfix: alarm not triggering on Android 14 |
| `1.1.0+3` | New: home screen widgets |
| `2.0.0+4` | New: Google Maps BYO + backup format v2 |

---

## Git Tags

Tag every release:

```bash
git tag -a v1.0.0 -m "Release v1.0.0 - Core location alarms"
git push origin v1.0.0
```

Tag format: `v` + semver (no build number).

---

## CHANGELOG

Follow [Keep a Changelog](https://keepachangelog.com/):

```markdown
## [1.1.0] - 2026-09-01

### Added
- Home screen widgets

### Fixed
- GPS accuracy display on Samsung devices
```

Categories: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`

---

## Roadmap Mapping

| App Version | Roadmap |
|-------------|---------|
| 1.0.x | [v1.0 - Core](docs/ROADMAP.md#phase-6--polish--release-v10) |
| 1.5.x | [v1.5 - Convenience](ROADMAP.md#v15--convenience) |
| 2.0.x | [v2.0 - Multi-Provider](ROADMAP.md#v20--multi-provider) |
| 3.0.x | [v3.0 - Advanced](ROADMAP.md#v30--smart--social) |

---

## Database & Backup Versioning

Separate from app semver:

| Schema | App version | Notes |
|--------|-------------|-------|
| Backup v1 | 1.0.x – 1.5.x | Initial JSON format |
| Backup v2 | 2.0.x | TBD if schema changes |

Isar schema migrations bump internal `schemaVersion` - document in [DATABASE.md](docs/DATABASE.md).

---

## Pre-Release Versions

During development:

| Label | Use |
|-------|-----|
| `1.0.0-dev` | Active development on main |
| `1.0.0-beta.1` | Closed testing |
| `1.0.0-rc.1` | Release candidate |

Do not upload `-dev` builds to Play Store production.

---

## Related Docs

* [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)
* [CHANGELOG.md](CHANGELOG.md)
* [Roadmap](ROADMAP.md)
