---
layout: default
title: Open Source
nav_order: 5
permalink: /open-source/
---

# Open Source

Nomad Alarm is free and open source.

## License

**MIT License** - see [LICENSE](https://github.com/ProgrammerNomad/Nomad-Alarm/blob/main/LICENSE) in the repository.

You may use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the software subject to the license terms.

## Source code

[github.com/ProgrammerNomad/Nomad-Alarm](https://github.com/ProgrammerNomad/Nomad-Alarm)

## Contributing

See [CONTRIBUTING.md](https://github.com/ProgrammerNomad/Nomad-Alarm/blob/main/CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](https://github.com/ProgrammerNomad/Nomad-Alarm/blob/main/CODE_OF_CONDUCT.md).

## Dependencies

The app uses open-source Flutter packages and native libraries (Riverpod, Isar, geolocator, flutter_map, etc.). Third-party licenses are listed in the in-app **About → Open source licenses** screen (from `flutter pub deps` / package licenses).

Key stacks:

| Area | Libraries |
|------|-----------|
| UI / state | Flutter, Riverpod, go_router, Material 3 |
| Storage | Isar |
| Location | geolocator |
| Maps | flutter_map, google_maps_flutter, apple_maps_flutter (iOS) |
| Background | flutter_background_service |
| Notifications | flutter_local_notifications |

## No tracking SDKs

Nomad Alarm does **not** include advertising, analytics, or crash-reporting SDKs that send personal data to third parties.

## Security

Report security concerns via [GitHub Security](https://github.com/ProgrammerNomad/Nomad-Alarm/security) or [SECURITY.md](https://github.com/ProgrammerNomad/Nomad-Alarm/blob/main/SECURITY.md).

---

See also: [Privacy Policy]({{ '/privacy-policy/' | relative_url }}) · [Terms of Service]({{ '/terms/' | relative_url }})
