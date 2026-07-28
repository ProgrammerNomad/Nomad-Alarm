import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

/// Open-source dependency licenses (Play Store requirement).
class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});

  static const _packages = [
    ('Flutter SDK', 'BSD-3-Clause', 'https://flutter.dev'),
    ('Riverpod', 'MIT', 'https://pub.dev/packages/flutter_riverpod'),
    ('go_router', 'BSD-3-Clause', 'https://pub.dev/packages/go_router'),
    ('Isar', 'Apache-2.0', 'https://pub.dev/packages/isar'),
    ('geolocator', 'MIT', 'https://pub.dev/packages/geolocator'),
    ('flutter_map', 'BSD-3-Clause', 'https://pub.dev/packages/flutter_map'),
    ('flutter_local_notifications', 'BSD-3-Clause',
        'https://pub.dev/packages/flutter_local_notifications'),
    ('flutter_background_service', 'MIT',
        'https://pub.dev/packages/flutter_background_service'),
    ('flutter_tts', 'MIT', 'https://pub.dev/packages/flutter_tts'),
    ('home_widget', 'BSD-3-Clause', 'https://pub.dev/packages/home_widget'),
    ('OpenStreetMap', 'ODbL', 'https://www.openstreetmap.org/copyright'),
  ];

  @override
  Widget build(BuildContext context) {
    return NomadScaffold(
      title: context.l10n.licensesTitle,
      showBackButton: true,
      body: ListView.separated(
        itemCount: _packages.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final (name, license, _) = _packages[index];
          return ListTile(
            title: Text(name),
            subtitle: Text(license),
          );
        },
      ),
    );
  }
}
