---
layout: default
title: GitHub Release
parent: Release
nav_order: 3
permalink: /GITHUB_RELEASE/
---
# GitHub Release (v1.0.0)

Run after signed AAB is verified and [RELEASE_QA_SIGNOFF.md](RELEASE_QA_SIGNOFF.md) is complete.

## Tag

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

## GitHub Release

```bash
flutter build apk --release
gh release create v1.0.0 \
  build/app/outputs/flutter-apk/app-release.apk \
  --title "Nomad Alarm v1.0.0" \
  --notes-file CHANGELOG.md
```

Or create the release in the GitHub UI and attach `app-release.apk`.

## CI verification

Trigger **workflow_dispatch** → `release` job in `.github/workflows/flutter.yml` to confirm unsigned release builds pass.

## v1.5.0

After v1.5.0 QA:

```bash
git tag -a v1.5.0 -m "Release v1.5.0"
git push origin v1.5.0
```

Bump is in `pubspec.yaml` (`1.5.0+2`). See CHANGELOG `[1.5.0]` section for release notes.
