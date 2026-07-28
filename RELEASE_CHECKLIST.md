# Release Checklist

Step-by-step checklist for every Nomad Alarm release.

See [Versioning](VERSIONING.md) and [Play Store](docs/PLAY_STORE.md).

---

## Pre-Release

### Code Quality
- [ ] All feature flags for this version set correctly ([Feature Flags](docs/FEATURE_FLAGS.md))
- [ ] `flutter analyze` - zero issues
- [ ] `flutter test` - all pass
- [ ] No `TODO` blockers in release code path
- [ ] Debug-only code guarded by `kDebugMode` or feature flags

### Testing
- [ ] Manual test matrix passed ([Testing](docs/TESTING.md))
- [ ] Background alarm tested on physical device (30+ min)
- [ ] Permission flows tested (grant, deny, revoke)
- [ ] Offline mode tested
- [ ] Battery drain documented for release notes if changed

### Documentation
- [ ] [CHANGELOG.md](CHANGELOG.md) updated with version section
- [ ] Version bumped in `pubspec.yaml`
- [ ] [ROADMAP.md](ROADMAP.md) milestones marked if applicable
- [ ] New features documented in relevant `docs/` files

---

## Build

Local builds only - see [docs/LOCAL_BUILD.md](docs/LOCAL_BUILD.md). No GitHub Actions required.

- [ ] AAB builds successfully
- [ ] APK builds successfully (for GitHub Release)
- [ ] APK size checked (`--analyze-size` if needed)
- [ ] Version name and code correct in build output

---

## Version & Tag

- [ ] `pubspec.yaml` version matches release (e.g., `1.0.0+1`)
- [ ] Git tag created: `v1.0.0`

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

See [VERSIONING.md](VERSIONING.md).

---

## GitHub Release

- [ ] Create GitHub Release from tag
- [ ] Attach APK to release (AAB to Play Store only)
- [ ] Copy CHANGELOG section to release notes
- [ ] Include known issues if any

---

## Play Store (Android)

- [ ] Upload AAB to Play Console
- [ ] Store listing updated if needed
- [ ] Screenshots current
- [ ] Data Safety form accurate
- [ ] Background location declaration current
- [ ] Release notes written
- [ ] Staged rollout started (recommended)

Full checklist: [docs/PLAY_STORE.md](docs/PLAY_STORE.md)

---

## Post-Release

- [ ] Verify install from Play Store (production track)
- [ ] Smoke test: create alarm, background, trigger
- [ ] Monitor crash reports (Play Console vitals)
- [ ] Announce in GitHub Discussions (optional)
- [ ] Close milestone issues on GitHub

---

## Hotfix Process

For critical bugs (alarm not triggering, crash on launch):

1. Branch from tag: `hotfix/1.0.1`
2. Fix + test (focused manual matrix)
3. Bump patch version: `1.0.1+2`
4. Fast-track Play Store review
5. Merge hotfix to `main`
6. Update CHANGELOG

---

## Release Sign-Off

| Role | Name | Date | OK |
|------|------|------|-----|
| Developer | | | [ ] |
| QA (manual test) | | | [ ] |
| Store listing | | | [ ] |

---

## Related Docs

* [VERSIONING.md](VERSIONING.md)
* [docs/PLAY_STORE.md](docs/PLAY_STORE.md)
* [docs/TESTING.md](docs/TESTING.md)
* [CHANGELOG.md](CHANGELOG.md)
