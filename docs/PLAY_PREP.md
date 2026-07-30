---
layout: default
title: Play Prep
parent: Release
nav_order: 5
permalink: /PLAY_PREP/
---

# Play Store prep (after docs site)

Complete these steps once [GitHub Pages](https://programmernomad.github.io/Nomad-Alarm/) is live.

## Enable GitHub Pages

1. Repository **Settings → Pages**
2. Source: **GitHub Actions** (deploys via `.github/workflows/pages.yml`)
3. Verify legal URLs load (privacy, terms, data safety)

## Pre-upload checklist

| Step | Doc |
|------|-----|
| Manual QA on physical Android device | [QA Sign-off]({{ '/RELEASE_QA_SIGNOFF/' | relative_url }}) |
| Store screenshots (min 4) + feature graphic 1024×500 | [Store Assets]({{ '/play-store/ASSETS_README/' | relative_url }}) |
| Background location demo video (30s, YouTube unlisted) | [Play Store]({{ '/PLAY_STORE/' | relative_url }}) |
| Data Safety form matches [Data Safety]({{ '/data-safety/' | relative_url }}) page | Play Console |
| Privacy policy URL in Play Console | `https://programmernomad.github.io/Nomad-Alarm/privacy-policy/` |
| Signed AAB | [Local Build]({{ '/LOCAL_BUILD/' | relative_url }}) |

## Release tracks

1. **Internal testing** - team devices, ~1 week
2. **Closed testing** - 10+ testers, ~2 weeks
3. **Production** - staged rollout 10% → 50% → 100%

## Post-launch

- Monitor Play Console vitals (crashes, ANRs)
- Update [CHANGELOG](https://github.com/ProgrammerNomad/Nomad-Alarm/blob/main/CHANGELOG.md)
- Tag GitHub release matching store version

---

See also: [Release Checklist](https://github.com/ProgrammerNomad/Nomad-Alarm/blob/main/RELEASE_CHECKLIST.md)
