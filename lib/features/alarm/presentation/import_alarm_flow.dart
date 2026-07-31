import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/alarm_config_args.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';
import 'package:nomad_alarm/services/deep_link_service.dart';
import 'package:nomad_alarm/models/shared_alarm_payload.dart';
import 'package:nomad_alarm/services/shared_alarm_codec.dart';

class ImportAlarmFlow {
  const ImportAlarmFlow._();

  static String parseErrorMessage(
    AppLocalizations l10n,
    SharedAlarmParseError e,
  ) {
    return switch (e) {
      SharedAlarmParseError.missingCoordinates =>
        l10n.importErrorMissingCoordinates,
      SharedAlarmParseError.unsupportedVersion =>
        l10n.importErrorUnsupportedVersion,
      SharedAlarmParseError.corruptedFile => l10n.importErrorCorruptedFile,
    };
  }

  static Future<void> showChooseSourceSheet(BuildContext context) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                l10n.importSharedAlarm,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open_outlined),
              title: Text(l10n.importSourceFile),
              onTap: () {
                Navigator.pop(context);
                pickFileAndPreview(context);
              },
            ),
            if (FeatureFlags.qrImport)
              ListTile(
                leading: const Icon(Icons.qr_code_scanner_outlined),
                title: Text(l10n.importSourceQr),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/alarm/import/qr');
                },
              ),
            ListTile(
              leading: const Icon(Icons.content_paste_outlined),
              title: Text(l10n.importSourceClipboard),
              onTap: () {
                Navigator.pop(context);
                pasteClipboardAndPreview(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Future<void> pickFileAndPreview(BuildContext context) async {
    final l10n = context.l10n;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['nomadalarm', 'json'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) {
      return;
    }
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      return;
    }
    final raw = String.fromCharCodes(bytes);
    await _decodeAndNavigate(context, raw, l10n);
  }

  static Future<void> pasteClipboardAndPreview(BuildContext context) async {
    final l10n = context.l10n;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.importErrorCorruptedFile)),
        );
      }
      return;
    }
    await _decodeAndNavigate(context, text, l10n);
  }

  static Future<void> decodeRawAndPreview(
    BuildContext context,
    String raw,
  ) async {
    await _decodeAndNavigate(context, raw, context.l10n);
  }

  static Future<void> _decodeAndNavigate(
    BuildContext context,
    String raw,
    AppLocalizations l10n,
  ) async {
    try {
      final payloads = SharedAlarmCodec.decodeBundle(raw);
      if (payloads.isEmpty) {
        throw const SharedAlarmParseException(SharedAlarmParseError.corruptedFile);
      }
      if (!context.mounted) {
        return;
      }
      if (payloads.length > 1) {
        final importAll = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.importBundleTitle(payloads.length)),
            content: Text(l10n.importBundleBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.importBundleFirstOnly),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.importBundleAll),
              ),
            ],
          ),
        );
        if (!context.mounted) {
          return;
        }
        if (importAll == true) {
          context.push('/alarm/import/preview', extra: payloads);
          return;
        }
      }
      context.push('/alarm/import/preview', extra: payloads.first);
    } on SharedAlarmParseException catch (e) {
      if (!context.mounted) {
        return;
      }
      final deepLink = DeepLinkService.parse(raw);
      if (deepLink != null) {
        context.push(
          '/alarm/new',
          extra: AlarmConfigArgs(destination: deepLink),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(parseErrorMessage(l10n, e.error))),
      );
    }
  }

  static Future<void> maybePromptClipboardImport(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!FeatureFlags.groupTravel) {
      return;
    }
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty || !context.mounted) {
      return;
    }
    try {
      SharedAlarmCodec.decode(text);
    } catch (_) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.importClipboardDetected),
        action: SnackBarAction(
          label: l10n.import,
          onPressed: () => decodeRawAndPreview(context, text),
        ),
      ),
    );
  }
}
