# Security Policy

Nomad Alarm is designed with privacy and local-only data storage as core principles.

---

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | TBD (after first release) |
| < 1.0   | Documentation / pre-release only |

---

## Reporting a Vulnerability

**Please do not report security vulnerabilities in public GitHub issues.**

Report privately by:
1. Opening a **GitHub Security Advisory** (Preferred) on the repository, or
2. Contacting the maintainer via GitHub profile: [ProgrammerNomad](https://github.com/ProgrammerNomad)

Include:
* Description of the vulnerability
* Steps to reproduce
* Potential impact
* Suggested fix (if any)

We aim to acknowledge reports within **7 days** and provide a fix timeline when confirmed.

---

## Security Design

| Area | Approach |
|------|----------|
| User data | Stored locally in Isar on device |
| Location | Never sent to our servers (no backend) |
| API keys | User-provided, encrypted via Android Keystore |
| Network | Only optional third-party map/search/route APIs |
| Telemetry | None - no analytics or crash SDKs with location |
| Ads | None |
| Authentication | None - no accounts |

---

## Out of Scope

The following are **not** vulnerabilities in Nomad Alarm's threat model:

* User voluntarily sharing a backup JSON file
* User entering API keys on a compromised device
* OS-level location access by other installed apps
* Physical access to an unlocked device

---

## Secure Development

Contributors must:
* Never commit API keys, keystores, or `.env` secrets
* Not add analytics, ads, or tracking SDKs without explicit project approval
* Use parameterized queries / validated input for any future network APIs
* Follow [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) security section

---

## Dependency Updates

Keep Flutter and dependencies updated. Review changelogs for security patches before releases.

---

## Disclosure Policy

* Confirmed issues will be fixed before public disclosure when possible
* Credit will be given to reporters unless they prefer anonymity
* Security fixes will be noted in [CHANGELOG.md](CHANGELOG.md)
