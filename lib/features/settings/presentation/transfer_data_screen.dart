import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/errors/app_exception.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/backup_repository.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class TransferDataScreen extends ConsumerStatefulWidget {
  const TransferDataScreen({super.key});

  @override
  ConsumerState<TransferDataScreen> createState() => _TransferDataScreenState();
}

class _TransferDataScreenState extends ConsumerState<TransferDataScreen> {
  bool _busy = false;

  Future<void> _recordBackupSuccess() async {
    final settings = ref.read(settingsControllerProvider).valueOrNull;
    if (settings == null) {
      return;
    }
    await ref.read(settingsControllerProvider.notifier).saveSettings(
          settings..lastBackupAt = DateTime.now(),
        );
  }

  Future<void> _exportBackup() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final repo = ref.read(backupRepositoryProvider);
      final json = await repo.exportBackup();
      await repo.shareBackup(json);
      await _recordBackupSuccess();
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
      if (ok) {
        await _recordBackupSuccess();
      }
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

  String _formatLastBackup(DateTime? at) {
    if (at == null) {
      return context.l10n.lastBackupNever;
    }
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).add_jm().format(at);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsControllerProvider).valueOrNull;

    return NomadScaffold(
      title: l10n.transferDataTitle,
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              l10n.transferDataIntro,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Semantics(
            label: l10n.semExportBackup,
            button: true,
            child: ListTile(
              leading: const Icon(Icons.upload_file_outlined),
              title: Text(l10n.exportBackup),
              subtitle: Text(l10n.exportBackupDescription),
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
              subtitle: Text(l10n.importBackupDescription),
              enabled: !_busy,
              onTap: _importBackup,
            ),
          ),
          if (FeatureFlags.cloudBackup)
            ListTile(
              leading: const Icon(Icons.cloud_upload_outlined),
              title: Text(l10n.uploadBackupViaHttps),
              subtitle: Text(l10n.uploadBackupDescription),
              enabled: !_busy,
              onTap: _uploadCloudBackup,
            ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            ),
          const Divider(height: 32),
          SwitchListTile(
            secondary: const Icon(Icons.schedule_outlined),
            title: Text(l10n.autoBackup),
            subtitle: Text(l10n.autoBackupComingSoon),
            value: settings?.autoBackupEnabled ?? false,
            onChanged: null,
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: Text(l10n.lastBackup),
            subtitle: Text(_formatLastBackup(settings?.lastBackupAt)),
          ),
        ],
      ),
    );
  }
}
