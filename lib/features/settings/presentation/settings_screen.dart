import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    return NomadScaffold(
      title: 'Settings',
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) => ListView(
          children: [
            const _SectionHeader(title: 'Appearance'),
            ListTile(
              title: const Text('Theme'),
              subtitle: Text(_themeLabel(settings.themeMode)),
              trailing: DropdownButton<AppThemeMode>(
                value: settings.themeMode,
                underline: const SizedBox.shrink(),
                items: AppThemeMode.values
                    .map(
                      (mode) => DropdownMenuItem(
                        value: mode,
                        child: Text(_themeLabel(mode)),
                      ),
                    )
                    .toList(),
                onChanged: (mode) {
                  if (mode == null) {
                    return;
                  }
                  ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..themeMode = mode,
                      );
                },
              ),
            ),
            const _SectionHeader(title: 'Units'),
            SwitchListTile(
              title: const Text('Use metric units'),
              subtitle: Text(settings.useMetric ? 'Kilometers' : 'Miles'),
              value: settings.useMetric,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..useMetric = value,
                    );
              },
            ),
            const _SectionHeader(title: 'Language'),
            ListTile(
              title: const Text('Language'),
              trailing: DropdownButton<String>(
                value: settings.languageCode,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                ],
                onChanged: (code) {
                  if (code == null) {
                    return;
                  }
                  ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..languageCode = code,
                      );
                },
              ),
            ),
            const _SectionHeader(title: 'More'),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Permissions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/permissions'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/privacy'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/about'),
            ),
          ],
        ),
      ),
    );
  }

  String _themeLabel(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.system => 'System',
      AppThemeMode.light => 'Light',
      AppThemeMode.dark => 'Dark',
    };
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
