import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/backup_repository.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settingsAsync = ref.watch(settingsControllerProvider);

    return NomadScaffold(
      title: l10n.settingsTitle,
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorPrefix(e.toString()))),
        data: (settings) => ListView(
          children: [
            _SectionHeader(title: l10n.appearance),
            ListTile(
              title: Text(l10n.theme),
              subtitle: Text(_themeLabel(l10n, settings.themeMode)),
              trailing: DropdownButton<AppThemeMode>(
                value: settings.themeMode,
                underline: const SizedBox.shrink(),
                items: AppThemeMode.values
                    .map(
                      (mode) => DropdownMenuItem(
                        value: mode,
                        child: Text(_themeLabel(l10n, mode)),
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
            _SectionHeader(title: l10n.units),
            SwitchListTile(
              title: Text(l10n.useMetricUnits),
              subtitle: Text(settings.useMetric ? l10n.kilometers : l10n.miles),
              value: settings.useMetric,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..useMetric = value,
                    );
              },
            ),
            _SectionHeader(title: l10n.language),
            ListTile(
              title: Text(l10n.language),
              trailing: DropdownButton<String>(
                value: settings.languageCode,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                  DropdownMenuItem(value: 'hi', child: Text(l10n.hindi)),
                ],
                onChanged: (code) async {
                  if (code == null) {
                    return;
                  }
                  await ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..languageCode = code,
                      );
                  await ref.read(notificationServiceProvider).setLanguageCode(code);
                  await BackgroundAlarmService.updateLanguageCode(code);
                  await ref.read(alarmServiceProvider).updateLanguageCode(code);
                },
              ),
            ),
            _SectionHeader(title: l10n.alarmDefaults),
            ListTile(
              title: Text(l10n.defaultAlertDistance),
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
              title: Text(l10n.voiceAlert),
              value: settings.defaultVoiceEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultVoiceEnabled = value,
                    );
              },
            ),
            SwitchListTile(
              title: Text(l10n.vibration),
              value: settings.defaultVibrationEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultVibrationEnabled = value,
                    );
              },
            ),
            SwitchListTile(
              title: Text(l10n.flashlight),
              subtitle: Text(l10n.flashlightSubtitle),
              value: settings.defaultFlashlightEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultFlashlightEnabled = value,
                    );
              },
            ),
            _SectionHeader(title: l10n.battery),
            ListTile(
              title: Text(l10n.gpsProfile),
              subtitle: Text(_batteryProfileDescription(l10n, settings.batteryProfile)),
              trailing: DropdownButton<BatteryProfile>(
                value: settings.batteryProfile,
                underline: const SizedBox.shrink(),
                items: BatteryProfile.values
                    .map(
                      (profile) => DropdownMenuItem(
                        value: profile,
                        child: Text(_batteryProfileLabel(l10n, profile)),
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
            SwitchListTile(
              title: Text(l10n.resumeAlarmAfterBoot),
              subtitle: Text(l10n.resumeAlarmAfterBootSubtitle),
              value: settings.resumeAlarmAfterBoot,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..resumeAlarmAfterBoot = value,
                    );
              },
            ),
            if (FeatureFlags.backupRestore) ...[
              _SectionHeader(title: l10n.data),
              const _BackupDataSection(),
            ],
            _SectionHeader(title: l10n.more),
            ListTile(
              leading: const Icon(Icons.security),
              title: Text(l10n.permissionsMenu),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/permissions'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(l10n.privacyMenu),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/privacy'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aboutMenu),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/about'),
            ),
            if (FeatureFlags.debugScreen && kDebugMode)
              ListTile(
                leading: const Icon(Icons.bug_report_outlined),
                title: Text(l10n.debugMenu),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/debug'),
              ),
          ],
        ),
      ),
    );
  }

  String _themeLabel(AppLocalizations l10n, AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.system => l10n.themeSystem,
      AppThemeMode.light => l10n.themeLight,
      AppThemeMode.dark => l10n.themeDark,
    };
  }

  String _batteryProfileLabel(AppLocalizations l10n, BatteryProfile profile) {
    return switch (profile) {
      BatteryProfile.balanced => l10n.batteryBalanced,
      BatteryProfile.aggressive => l10n.batteryAggressive,
      BatteryProfile.saver => l10n.batterySaver,
    };
  }

  String _batteryProfileDescription(AppLocalizations l10n, BatteryProfile profile) {
    return switch (profile) {
      BatteryProfile.balanced => l10n.batteryBalancedDesc,
      BatteryProfile.aggressive => l10n.batteryAggressiveDesc,
      BatteryProfile.saver => l10n.batterySaverDesc,
    };
  }
}

class _BackupDataSection extends ConsumerStatefulWidget {
  const _BackupDataSection();

  @override
  ConsumerState<_BackupDataSection> createState() => _BackupDataSectionState();
}

class _BackupDataSectionState extends ConsumerState<_BackupDataSection> {
  bool _busy = false;

  Future<void> _exportBackup() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final repo = ref.read(backupRepositoryProvider);
      final json = await repo.exportBackup();
      await repo.shareBackup(json);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.backupReady)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPrefix(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _importBackup() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importBackupTitle),
        content: Text(l10n.importBackupBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.import),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _busy = true);
    try {
      final result = await ref.read(backupRepositoryProvider).importBackup();
      ref.invalidate(settingsControllerProvider);
      ref.invalidate(alarmServiceProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.importedSummary(
                result.alarmsImported,
                result.favoritesImported,
                result.historyImported,
                result.settingsImported ? l10n.importedSettingsSuffix : '',
              ),
            ),
          ),
        );
      }
    } on BackupCancelledException {
      // User cancelled file picker.
    } on StorageException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.userMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPrefix(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Semantics(
          label: l10n.semExportBackup,
          button: true,
          child: ListTile(
            leading: const Icon(Icons.upload_file_outlined),
            title: Text(l10n.exportBackup),
            subtitle: Text(l10n.exportBackupSubtitle),
            enabled: !_busy,
            onTap: _exportBackup,
          ),
        ),
        Semantics(
          label: l10n.semImportBackup,
          button: true,
          child: ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.importBackup),
            subtitle: Text(l10n.importBackupSubtitle),
            enabled: !_busy,
            onTap: _importBackup,
          ),
        ),
        if (_busy)
          const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(),
          ),
      ],
    );
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
