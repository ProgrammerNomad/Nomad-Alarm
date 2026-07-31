import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/alarm_config_args.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/shared_alarm_payload.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/shared_alarm_codec.dart';
import 'package:nomad_alarm/services/shared_alarm_share_service.dart';

class ImportAlarmPreviewScreen extends ConsumerStatefulWidget {
  const ImportAlarmPreviewScreen({
    required this.payloads,
    super.key,
  });

  final List<SharedAlarmPayload> payloads;

  @override
  ConsumerState<ImportAlarmPreviewScreen> createState() =>
      _ImportAlarmPreviewScreenState();
}

class _ImportAlarmPreviewScreenState
    extends ConsumerState<ImportAlarmPreviewScreen> {
  late int _index;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _index = 0;
  }

  SharedAlarmPayload get _payload => widget.payloads[_index];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.importPreviewTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.payloads.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                l10n.importPreviewProgress(_index + 1, widget.payloads.length),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          _DetailRow(label: l10n.importPreviewDestination, value: _payload.destinationName),
          _DetailRow(
            label: l10n.importPreviewCoordinates,
            value: '${_payload.lat.toStringAsFixed(4)}, ${_payload.lng.toStringAsFixed(4)}',
          ),
          _DetailRow(
            label: l10n.alertDistance,
            value: formatDistance(_payload.triggerDistanceMeters, useMetric: useMetric),
          ),
          _DetailRow(
            label: l10n.voiceAlert,
            value: _payload.voice ? l10n.enabledLabel : l10n.disabledLabel,
          ),
          _DetailRow(
            label: l10n.vibration,
            value: _payload.vibration ? l10n.enabledLabel : l10n.disabledLabel,
          ),
          _DetailRow(
            label: l10n.flashlight,
            value: _payload.flashlight ? l10n.enabledLabel : l10n.disabledLabel,
          ),
          if (_payload.notes != null && _payload.notes!.isNotEmpty)
            _DetailRow(label: l10n.notesLabel, value: _payload.notes!),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _import,
            child: Text(l10n.import),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _busy ? null : _editBeforeSaving,
            child: Text(l10n.importEditBeforeSaving),
          ),
          TextButton(
            onPressed: _busy ? null : () => context.pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _editBeforeSaving() async {
    final draft = SharedAlarmCodec.toDraft(_payload);
    context.push(
      '/alarm/new',
      extra: AlarmConfigArgs(
        destination: DestinationArgs(
          name: draft.name,
          latitude: draft.destLatitude,
          longitude: draft.destLongitude,
          address: draft.address,
        ),
        importedDraft: draft,
      ),
    );
  }

  Future<void> _import() async {
    setState(() => _busy = true);
    try {
      final repo = ref.read(alarmRepositoryProvider);
      final existing = await repo.getAll();
      final matcher = const SharedAlarmDuplicateMatcher();
      final duplicate = matcher.findMatch(existing, _payload);

      DuplicateAction? action;
      if (duplicate != null && mounted) {
        action = await showDialog<DuplicateAction>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.importDuplicateTitle),
            content: Text(context.l10n.importDuplicateBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, DuplicateAction.cancel),
                child: Text(context.l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, DuplicateAction.createCopy),
                child: Text(context.l10n.importDuplicateCreateCopy),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, DuplicateAction.updateExisting),
                child: Text(context.l10n.importDuplicateUpdate),
              ),
            ],
          ),
        );
        if (action == DuplicateAction.cancel || action == null) {
          return;
        }
      }

      Alarm alarm;
      if (duplicate != null && action == DuplicateAction.updateExisting) {
        await updateAlarmFromPayload(duplicate, _payload, repo);
        alarm = duplicate;
      } else {
        var draft = SharedAlarmCodec.toDraft(_payload);
        if (duplicate != null && action == DuplicateAction.createCopy) {
          draft = AlarmDraft(
            name: copyNameForDuplicate(draft.name),
            destLatitude: draft.destLatitude,
            destLongitude: draft.destLongitude,
            address: draft.address,
            placeId: draft.placeId,
            triggerDistanceMeters: draft.triggerDistanceMeters,
            travelMode: draft.travelMode,
            type: draft.type,
            speedThresholdKmh: draft.speedThresholdKmh,
            voiceEnabled: draft.voiceEnabled,
            vibrationEnabled: draft.vibrationEnabled,
            flashlightEnabled: draft.flashlightEnabled,
            ringtoneUri: draft.ringtoneUri,
            notes: draft.notes,
          );
        }
        alarm = await repo.create(draft);
      }

      ref.invalidate(alarmsProvider);
      ref.invalidate(activeAlarmsProvider);
      ref.invalidate(draftAlarmsProvider);

      if (!mounted) {
        return;
      }

      if (_index + 1 < widget.payloads.length) {
        setState(() => _index++);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.importProgressSaved(_index, widget.payloads.length))),
        );
        return;
      }

      await _showSuccessSheet(alarm.id);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _showSuccessSheet(int alarmId) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.importSuccessTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ref.read(alarmServiceProvider).startAlarm(alarmId);
                  ref.invalidate(activeAlarmsProvider);
                  if (context.mounted) {
                    context.go('/alarms');
                  }
                },
                child: Text(l10n.importStartNow),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/alarm/new', extra: AlarmConfigArgs(
                    destination: DestinationArgs(
                      name: _payload.destinationName,
                      latitude: _payload.lat,
                      longitude: _payload.lng,
                      address: _payload.address,
                    ),
                    importedDraft: SharedAlarmCodec.toDraft(_payload),
                  ));
                },
                child: Text(l10n.importSuccessEdit),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/history');
                },
                child: Text(l10n.importSuccessBack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DuplicateAction { updateExisting, createCopy, cancel }

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
