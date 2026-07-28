import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
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
            const _SectionHeader(title: 'Alarm defaults'),
            ListTile(
              title: const Text('Default alert distance'),
              subtitle: Text(formatDistance(settings.defaultTriggerDistanceMeters)),
            ),
            Slider(
              value: settings.defaultTriggerDistanceMeters.clamp(
                AlarmConstants.minTriggerDistanceM,
                AlarmConstants.maxTriggerDistanceM,
              ),
              min: AlarmConstants.minTriggerDistanceM,
              max: AlarmConstants.maxTriggerDistanceM,
              divisions: 49,
              label: formatDistance(settings.defaultTriggerDistanceMeters),
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultTriggerDistanceMeters = value,
                    );
              },
            ),
            SwitchListTile(
              title: const Text('Voice alert'),
              value: settings.defaultVoiceEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultVoiceEnabled = value,
                    );
              },
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: settings.defaultVibrationEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultVibrationEnabled = value,
                    );
              },
            ),
            SwitchListTile(
              title: const Text('Flashlight'),
              subtitle: const Text('LED strobe when alarm rings'),
              value: settings.defaultFlashlightEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultFlashlightEnabled = value,
                    );
              },
            ),
            const _SectionHeader(title: 'Battery'),
            ListTile(
              title: const Text('GPS profile'),
              subtitle: Text(_batteryProfileDescription(settings.batteryProfile)),
              trailing: DropdownButton<BatteryProfile>(
                value: settings.batteryProfile,
                underline: const SizedBox.shrink(),
                items: BatteryProfile.values
                    .map(
                      (profile) => DropdownMenuItem(
                        value: profile,
                        child: Text(_batteryProfileLabel(profile)),
                      ),
                    )
                    .toList(),
                onChanged: (profile) {
                  if (profile == null) {
                    return;
                  }
                  ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..batteryProfile = profile,
                      );
                  ref.invalidate(alarmServiceProvider);
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
            if (FeatureFlags.debugScreen && kDebugMode)
              ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: const Text('Debug'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/debug'),
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

  String _batteryProfileLabel(BatteryProfile profile) {
    return switch (profile) {
      BatteryProfile.balanced => 'Balanced',
      BatteryProfile.aggressive => 'Aggressive',
      BatteryProfile.saver => 'Saver',
    };
  }

  String _batteryProfileDescription(BatteryProfile profile) {
    return switch (profile) {
      BatteryProfile.balanced =>
        'Best for daily commutes - updates every ~10 m',
      BatteryProfile.aggressive =>
        'Maximum reliability - more battery use near destination',
      BatteryProfile.saver =>
        'Minimum GPS use - may reduce accuracy',
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
