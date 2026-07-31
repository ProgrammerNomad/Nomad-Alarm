import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/shared_alarm_payload.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/shared_alarm_codec.dart';
import 'package:nomad_alarm/services/shared_alarm_share_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum ShareAlarmMode {
  package,
  destinationOnly,
  qrCode,
  copyCoordinates,
}

Future<void> showShareAlarmSheet(
  BuildContext context, {
  Alarm? alarm,
  AlarmDraft? draft,
  bool useMetric = true,
}) async {
  if (!FeatureFlags.groupTravel) {
    return;
  }
  SharedAlarmPayload payload;
  if (alarm != null) {
    payload = SharedAlarmCodec.fromAlarm(alarm);
  } else if (draft != null) {
    payload = SharedAlarmCodec.fromDraft(draft);
  } else {
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _ShareAlarmSheetBody(
      payload: payload,
      useMetric: useMetric,
    ),
  );
}

class _ShareAlarmSheetBody extends ConsumerWidget {
  const _ShareAlarmSheetBody({
    required this.payload,
    required this.useMetric,
  });

  final SharedAlarmPayload payload;
  final bool useMetric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final metric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? useMetric;
    final shareService = const SharedAlarmShareService();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.shareAlarmTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.shareAlarmSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            _ShareOptionTile(
              icon: Icons.inventory_2_outlined,
              title: l10n.shareModePackageTitle,
              subtitle: l10n.shareModePackageSubtitle,
              recommended: true,
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await _showPackagePreview(context, payload, metric);
                if (confirmed == true) {
                  await shareService.shareAlarmPackage(payload);
                }
              },
            ),
            _ShareOptionTile(
              icon: Icons.place_outlined,
              title: l10n.shareModeDestinationTitle,
              subtitle: l10n.shareModeDestinationSubtitle,
              onTap: () async {
                Navigator.pop(context);
                await shareService.shareDestinationOnly(payload);
              },
            ),
            _ShareOptionTile(
              icon: Icons.qr_code_2_outlined,
              title: l10n.shareModeQrTitle,
              subtitle: l10n.shareModeQrSubtitle,
              onTap: () {
                Navigator.pop(context);
                _showQrDialog(context, payload);
              },
            ),
            _ShareOptionTile(
              icon: Icons.copy_outlined,
              title: l10n.shareModeCopyCoordsTitle,
              subtitle: '${payload.lat.toStringAsFixed(4)}, ${payload.lng.toStringAsFixed(4)}',
              onTap: () async {
                Navigator.pop(context);
                await shareService.copyCoordinates(payload);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.shareCoordsCopied)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showPackagePreview(
    BuildContext context,
    SharedAlarmPayload payload,
    bool useMetric,
  ) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sharePreviewTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.importPreviewDestination}: ${payload.destinationName}'),
            Text(
              '${l10n.alertDistance}: ${formatDistance(payload.triggerDistanceMeters, useMetric: useMetric)}',
            ),
            Text('${l10n.voiceAlert}: ${payload.voice ? l10n.enabledLabel : l10n.disabledLabel}'),
            Text('${l10n.vibration}: ${payload.vibration ? l10n.enabledLabel : l10n.disabledLabel}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.shareAlarmConfig),
          ),
        ],
      ),
    );
  }

  void _showQrDialog(BuildContext context, SharedAlarmPayload payload) {
    final l10n = context.l10n;
    final data = SharedAlarmCodec.encode(payload);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.shareModeQrTitle),
        content: SizedBox(
          width: 240,
          height: 240,
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.dismiss),
          ),
        ],
      ),
    );
  }
}

class _ShareOptionTile extends StatelessWidget {
  const _ShareOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.recommended = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool recommended;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Row(
        children: [
          Expanded(child: Text(title)),
          if (recommended)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                l10n.recommendedLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
        ],
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}

/// Share from history entry coordinates (no full alarm record).
Future<void> showShareAlarmSheetFromDestination(
  BuildContext context, {
  required String name,
  required double lat,
  required double lng,
  String? address,
  double triggerDistanceMeters = 500,
}) {
  return showShareAlarmSheet(
    context,
    draft: AlarmDraft(
      name: name,
      destLatitude: lat,
      destLongitude: lng,
      address: address,
      triggerDistanceMeters: triggerDistanceMeters,
    ),
  );
}
