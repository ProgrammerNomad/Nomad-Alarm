# Contributing to Nomad Alarm

Thank you for helping build a reliable, privacy-first location alarm. Contributions are welcome.

---

## Before You Start

1. Read the [Master Blueprint](docs/MASTER_BLUEPRINT.md)
2. Read [Architecture](docs/ARCHITECTURE.md) and [Roadmap](docs/ROADMAP.md)
3. Check open issues or discussions before starting large work

---

## How to Contribute

### Bug Reports

Include:
* Device model and Android version
* App version
* Steps to reproduce
* Expected vs actual behavior
* Whether alarm was active in background

Do **not** include precise home addresses or personal location data in public issues.

### Feature Requests

Explain:
* User problem being solved
* How it fits the guiding principle (reliability, privacy, offline)
* Whether it can be optional/opt-in

Features that require accounts, ads, analytics, or a backend are out of scope unless explicitly approved.

### Pull Requests

1. Fork the repository
2. Create a branch: `feature/short-description` or `fix/short-description`
3. Follow the architecture in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
4. Add tests for business logic changes
5. Run `flutter analyze` and `flutter test`
6. Update [CHANGELOG.md](CHANGELOG.md) under `[Unreleased]`
7. Open a PR with a clear description and test plan

---

## Code Standards

* **Dart style:** follow `flutter_lints` and existing patterns
* **Layers:** UI → Controller → **Repository** → Service → DB/API (see [docs/REPOSITORIES.md](docs/REPOSITORIES.md))
* Controllers must not access Isar or services directly
* **Privacy:** no analytics SDKs, no tracking, no hardcoded API keys
* **Comments:** only for non-obvious logic
* **Commits:** use conventional commits (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`)

---

## Project Setup

See [docs/SETUP.md](docs/SETUP.md) for environment setup and dependencies.

---

## Translation Contributions

Nomad Alarm supports multiple languages. Translation files will live under `lib/l10n/`.

* Keep strings concise (UI space is limited)
* Test with TalkBack / large text where possible
* Submit translations as PRs with language code noted

---

## Code of Conduct

This project follows the [Code of Conduct](CODE_OF_CONDUCT.md). Be respectful and constructive.

---

## Questions

Use GitHub Discussions for questions. Use Issues for bugs and feature tracking.
