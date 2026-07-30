import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/core/utils/language_display.dart';
import 'package:nomad_alarm/core/utils/locale_resolution.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/backup_repository.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/services/group_travel_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:nomad_alarm/shared/widgets/settings_controls.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';

enum _DistancePickerOption {
  m200,
  m500,
  m1000,
  m2000,
  custom,
}

_DistancePickerOption _distanceOptionFor(double meters) {
  return switch (meters) {
    200.0 => _DistancePickerOption.m200,
    500.0 => _DistancePickerOption.m500,
    1000.0 => _DistancePickerOption.m1000,
    2000.0 => _DistancePickerOption.m2000,
    _ => _DistancePickerOption.custom,
  };
}

double _metersForDistanceOption(_DistancePickerOption option) {
  return switch (option) {
    _DistancePickerOption.m200 => 200,
    _DistancePickerOption.m500 => 500,
    _DistancePickerOption.m1000 => 1000,
    _DistancePickerOption.m2000 => 2000,
    _DistancePickerOption.custom => 500,
  };
}

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
            _SettingsSectionHeader(
              icon: Icons.palette_outlined,
              title: l10n.appearance,
            ),
            SettingsPickerTile(
              leading: Icons.brightness_auto,
              title: l10n.theme,
              valueLabel: _themeLabel(l10n, settings.themeMode),
              onTap: () async {
                final mode = await showSettingsPickerSheet<AppThemeMode>(
                  context: context,
                  title: l10n.theme,
                  options: AppThemeMode.values,
                  value: settings.themeMode,
                  labelFor: (m) => _themeLabel(l10n, m),
                  cancelLabel: l10n.cancel,
                  iconFor: (m) => switch (m) {
                    AppThemeMode.system => Icons.brightness_auto,
                    AppThemeMode.light => Icons.light_mode_outlined,
                    AppThemeMode.dark => Icons.dark_mode_outlined,
                  },
                );
                if (mode != null && context.mounted) {
                  ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..themeMode = mode,
                      );
                }
              },
            ),
            _SettingsSectionHeader(
              icon: Icons.straighten,
              title: l10n.units,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(
                l10n.distanceUnitsLabel,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SettingsSegmentedControl<bool>(
              options: const [true, false],
              value: settings.useMetric,
              labelFor: (metric) => metric ? l10n.kilometers : l10n.miles,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..useMetric = value,
                    );
              },
            ),
            _SettingsSectionHeader(
              icon: Icons.translate,
              title: l10n.language,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(
                l10n.languageEndonymHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SettingsPickerTile(
              leading: Icons.language_outlined,
              title: l10n.language,
              valueLabel: settings.languageCode == systemLanguageCode
                  ? l10n.languageFollowSystem
                  : languageEndonym(settings.languageCode),
              onTap: () async {
                const codes = [
                  systemLanguageCode,
                  'en',
                  'hi',
                  'ar',
                  'he',
                ];
                final code = await showSettingsPickerSheet<String>(
                  context: context,
                  title: l10n.language,
                  options: codes,
                  value: settings.languageCode,
                  labelFor: (c) => c == systemLanguageCode
                      ? l10n.languageFollowSystem
                      : languageEndonym(c),
                  cancelLabel: l10n.cancel,
                  iconFor: (c) => c == systemLanguageCode
                      ? Icons.phone_android_outlined
                      : Icons.language_outlined,
                );
                if (code == null || !context.mounted) {
                  return;
                }
                await ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..languageCode = code,
                    );
                final resolved = resolveNotificationLanguageCode(code);
                await ref.read(notificationServiceProvider).setLanguageCode(resolved);
                await BackgroundAlarmService.updateLanguageCode(resolved);
                await ref.read(alarmServiceProvider).updateLanguageCode(resolved);
              },
            ),
            _SettingsSectionHeader(
              icon: Icons.notifications_active_outlined,
              title: l10n.alarmDefaults,
            ),
            _DefaultAlertDistanceSection(settings: settings),
            SwitchListTile(
              secondary: const Icon(Icons.record_voice_over_outlined),
              title: Text(l10n.voiceAlert),
              value: settings.defaultVoiceEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultVoiceEnabled = value,
                    );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.vibration_outlined),
              title: Text(l10n.vibration),
              value: settings.defaultVibrationEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultVibrationEnabled = value,
                    );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.flashlight_on_outlined),
              title: Text(l10n.flashlight),
              subtitle: Text(l10n.flashlightSubtitle),
              value: settings.defaultFlashlightEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..defaultFlashlightEnabled = value,
                    );
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.lock_outline),
              title: Text(l10n.lockScreenInfo),
              subtitle: Text(l10n.lockScreenInfoSubtitle),
              value: settings.lockScreenInfoEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..lockScreenInfoEnabled = value,
                    );
                ref.read(alarmServiceProvider).updateLockScreenInfoEnabled(value);
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.contrast_outlined),
              title: Text(l10n.highContrast),
              subtitle: Text(l10n.highContrastSubtitle),
              value: settings.accessibilityHighContrast,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..accessibilityHighContrast = value,
                    );
              },
            ),
            _SettingsSectionHeader(
              icon: Icons.battery_saver_outlined,
              title: l10n.battery,
            ),
            SettingsPickerTile(
              leading: Icons.battery_saver_outlined,
              title: l10n.gpsProfile,
              valueLabel: _batteryProfileLabel(l10n, settings.batteryProfile),
              onTap: () async {
                final profile = await showSettingsPickerSheet<BatteryProfile>(
                  context: context,
                  title: l10n.gpsProfile,
                  options: BatteryProfile.values,
                  value: settings.batteryProfile,
                  labelFor: (p) => _batteryProfileLabel(l10n, p),
                  cancelLabel: l10n.cancel,
                  iconFor: (p) => switch (p) {
                    BatteryProfile.saver => Icons.battery_2_bar,
                    BatteryProfile.balanced => Icons.battery_5_bar,
                    BatteryProfile.aggressive => Icons.battery_full,
                  },
                );
                if (profile != null && context.mounted) {
                  ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..batteryProfile = profile,
                      );
                  ref.invalidate(alarmServiceProvider);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _batteryProfileDescription(l10n, settings.batteryProfile),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.restart_alt_outlined),
              title: Text(l10n.resumeAlarmAfterBoot),
              subtitle: Text(l10n.resumeAlarmAfterBootBatteryWarning),
              value: settings.resumeAlarmAfterBoot,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).saveSettings(
                      settings..resumeAlarmAfterBoot = value,
                    );
              },
            ),
            if (FeatureFlags.backupRestore) ...[
              _SettingsSectionHeader(
                icon: Icons.storage_outlined,
                title: l10n.data,
              ),
              const _BackupDataSection(),
            ],
            _SettingsSectionHeader(
              icon: Icons.map_outlined,
              title: l10n.mapsSection,
            ),
            ListTile(
              leading: const Icon(Icons.map_outlined),
              title: Text(l10n.mapSettingsTitle),
              subtitle: Text(l10n.mapSettingsSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/map'),
            ),
            _SettingsSectionHeader(
              icon: Icons.tune,
              title: l10n.advancedSection,
            ),
            ListTile(
              leading: const Icon(Icons.vpn_key_outlined),
              title: Text(l10n.advancedApiKeys),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/api-keys'),
            ),
            _SettingsSectionHeader(
              icon: Icons.more_horiz,
              title: l10n.more,
            ),
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
      BatteryProfile.balanced => l10n.batteryBalancedRecommended,
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

class _DefaultAlertDistanceSection extends ConsumerStatefulWidget {
  const _DefaultAlertDistanceSection({required this.settings});

  final AppSettings settings;

  @override
  ConsumerState<_DefaultAlertDistanceSection> createState() =>
      _DefaultAlertDistanceSectionState();
}

class _DefaultAlertDistanceSectionState
    extends ConsumerState<_DefaultAlertDistanceSection> {
  bool _showCustomSlider = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = widget.settings;
    final distance = settings.defaultTriggerDistanceMeters;
    final currentOption = _distanceOptionFor(distance);
    final isCustom = currentOption == _DistancePickerOption.custom || _showCustomSlider;
    final valueLabel = isCustom && currentOption == _DistancePickerOption.custom
        ? formatDistance(distance, useMetric: settings.useMetric)
        : switch (currentOption) {
            _DistancePickerOption.m200 => formatDistance(200, useMetric: settings.useMetric),
            _DistancePickerOption.m500 => formatDistance(500, useMetric: settings.useMetric),
            _DistancePickerOption.m1000 => formatDistance(1000, useMetric: settings.useMetric),
            _DistancePickerOption.m2000 => formatDistance(2000, useMetric: settings.useMetric),
            _DistancePickerOption.custom => l10n.distancePresetCustom,
          };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsPickerTile(
          leading: Icons.notifications_active_outlined,
          title: l10n.defaultAlertDistance,
          valueLabel: valueLabel,
          onTap: () async {
            final options = _DistancePickerOption.values;
            final picked = await showSettingsPickerSheet<_DistancePickerOption>(
              context: context,
              title: l10n.defaultAlertDistance,
              options: options,
              value: isCustom ? _DistancePickerOption.custom : currentOption,
              labelFor: (option) => option == _DistancePickerOption.custom
                  ? l10n.distancePresetCustom
                  : formatDistance(
                      _metersForDistanceOption(option),
                      useMetric: settings.useMetric,
                    ),
              cancelLabel: l10n.cancel,
            );
            if (picked == null || !context.mounted) {
              return;
            }
            if (picked == _DistancePickerOption.custom) {
              setState(() => _showCustomSlider = true);
              return;
            }
            setState(() => _showCustomSlider = false);
            ref.read(settingsControllerProvider.notifier).saveSettings(
                  settings..defaultTriggerDistanceMeters =
                      _metersForDistanceOption(picked),
                );
          },
        ),
        if (isCustom)
          Column(
            children: [
              ListTile(
                dense: true,
                title: Text(
                  formatDistance(distance, useMetric: settings.useMetric),
                ),
              ),
              Slider(
                value: distance.clamp(
                  AlarmConstants.minTriggerDistanceM,
                  AlarmConstants.maxTriggerDistanceM,
                ),
                min: AlarmConstants.minTriggerDistanceM,
                max: AlarmConstants.maxTriggerDistanceM,
                divisions: 49,
                label: formatDistance(distance, useMetric: settings.useMetric),
                onChanged: (value) {
                  ref.read(settingsControllerProvider.notifier).saveSettings(
                        settings..defaultTriggerDistanceMeters = value,
                      );
                },
              ),
            ],
          ),
      ],
    );
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

  Future<void> _shareActiveAlarms() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final alarms = await ref.read(alarmRepositoryProvider).getActive();
      if (alarms.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.widgetNoActiveAlarm)),
          );
        }
        return;
      }
      await const GroupTravelService().shareBundle(alarms);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _importAlarmBundle() async {
    final l10n = context.l10n;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      return;
    }
    setState(() => _busy = true);
    try {
      const service = GroupTravelService();
      final drafts = service.parseBundle(text);
      if (drafts.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deepLinkInvalid)),
          );
        }
        return;
      }
      final repo = ref.read(alarmRepositoryProvider);
      for (final draft in drafts) {
        await repo.create(draft);
      }
      ref.invalidate(alarmsProvider);
      ref.invalidate(activeAlarmsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.alarmBundleImported(drafts.length))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _uploadCloudBackup() async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final url = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.uploadBackupViaHttps),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.cloudBackupUrlHint),
          keyboardType: TextInputType.url,
          autocorrect: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.uploadBackupViaHttps),
          ),
        ],
      ),
    );
    if (url == null || url.isEmpty || !mounted) {
      return;
    }

    setState(() => _busy = true);
    try {
      final ok = await ref.read(cloudBackupServiceProvider).uploadToUrl(url);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? l10n.cloudBackupSuccess : l10n.cloudBackupFailed),
        ),
      );
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
        if (FeatureFlags.cloudBackup)
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: Text(l10n.uploadBackupViaHttps),
            subtitle: Text(l10n.cloudBackupUrlHint),
            enabled: !_busy,
            onTap: _uploadCloudBackup,
          ),
        if (FeatureFlags.familySharing) ...[
          ListTile(
            leading: const Icon(Icons.group_outlined),
            title: Text(l10n.shareLiveTrip),
            enabled: !_busy,
            onTap: _shareActiveAlarms,
          ),
          ListTile(
            leading: const Icon(Icons.group_add_outlined),
            title: Text(l10n.importSharedAlarm),
            enabled: !_busy,
            onTap: _importAlarmBundle,
          ),
        ],
        if (_busy)
          const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  const _SettingsSectionHeader({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
