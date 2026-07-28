# GitHub Labels

Recommended labels for the Nomad Alarm repository. Create these in **Settings → Labels** on GitHub.

---

## Type Labels

| Label | Color | Description |
|-------|-------|-------------|
| `bug` | `#D73A4A` | Something isn't working |
| `feature` | `#A2EEEF` | New feature or request |
| `question` | `#D876E3` | Question or discussion |
| `documentation` | `#0075CA` | Documentation improvements |

---

## Priority & Status

| Label | Color | Description |
|-------|-------|-------------|
| `good first issue` | `#7057FF` | Good for newcomers |
| `help wanted` | `#008672` | Extra attention needed |
| `needs testing` | `#FBCA04` | Needs manual/device testing |
| `blocked` | `#B60205` | Blocked by external dependency |
| `wontfix` | `#FFFFFF` | Will not be addressed |

---

## Area Labels

| Label | Color | Description |
|-------|-------|-------------|
| `UI` | `#F9D0C4` | User interface / design |
| `GPS` | `#C5DEF5` | Location tracking |
| `Battery` | `#BFDADC` | Battery optimization |
| `Performance` | `#E99695` | Performance issues |
| `Permissions` | `#D4C5F9` | Android permissions |
| `Maps` | `#C2E0C6` | Map providers |
| `Alarm Engine` | `#FEF2C0` | Core alarm logic |
| `Background Service` | `#BFD4F2` | Foreground service |
| `Widgets` | `#F9D0C4` | Home screen widgets |
| `CI/CD` | `#EDEDED` | Build and automation |

---

## Version Labels

| Label | Color | Description |
|-------|-------|-------------|
| `v1.0` | `#1D76DB` | Target v1.0 release |
| `v1.5` | `#5319E7` | Target v1.5 release |
| `v2.0` | `#006B75` | Target v2.0 release |
| `v3.0` | `#0052CC` | Target v3.0 release |

---

## Usage Guidelines

* Every issue should have **one type** label (`bug`, `feature`, `question`)
* Add **area** labels when applicable (can have multiple)
* Add **version** label for feature planning
* PRs inherit labels from linked issues

Issue templates auto-apply: `bug` + `needs testing`, `feature`, `question`.

---

## Quick Setup (GitHub CLI)

If `gh` is available:

```bash
gh label create "bug" --color "D73A4A" --description "Something isn't working"
gh label create "feature" --color "A2EEEF" --description "New feature or request"
gh label create "good first issue" --color "7057FF" --description "Good for newcomers"
gh label create "needs testing" --color "FBCA04" --description "Needs manual testing"
gh label create "UI" --color "F9D0C4" --description "User interface"
gh label create "GPS" --color "C5DEF5" --description "Location tracking"
gh label create "Battery" --color "BFDADC" --description "Battery optimization"
gh label create "Performance" --color "E99695" --description "Performance"
gh label create "documentation" --color "0075CA" --description "Documentation"
```
