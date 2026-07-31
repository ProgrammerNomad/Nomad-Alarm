import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/features/alarm/presentation/share_alarm_bottom_sheet.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/history_entry.dart';
import 'package:nomad_alarm/models/trip.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/shared/widgets/trip_route_map.dart';

Future<void> showAlarmJourneyDetailSheet({
  required BuildContext context,
  required WidgetRef ref,
  required HistoryEntry entry,
  required bool useMetric,
}) async {
  Trip? trip;
  if (entry.tripId != null) {
    trip = await ref.read(tripRepositoryProvider).getById(entry.tripId!);
  }

  if (!context.mounted) {
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: trip != null ? 0.75 : 0.45,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: AlarmJourneyDetailContent(
          entry: entry,
          trip: trip,
          useMetric: useMetric,
        ),
      ),
    ),
  );
}

class AlarmJourneyDetailContent extends ConsumerWidget {
  const AlarmJourneyDetailContent({
    required this.entry,
    required this.trip,
    required this.useMetric,
    super.key,
  });

  final HistoryEntry entry;
  final Trip? trip;
  final bool useMetric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          entry.destinationName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        HistoryOutcomeBadge(type: entry.type),
        const SizedBox(height: 16),
        _DetailRow(
          label: l10n.dateLabel,
          value: DateFormat.yMMMd().add_jm().format(entry.occurredAt),
        ),
        if (entry.triggerDistanceMeters != null)
          _DetailRow(
            label: l10n.triggerDistanceLabel,
            value: formatDistance(
              entry.triggerDistanceMeters!,
              useMetric: useMetric,
            ),
          ),
        if (entry.snoozeCount != null && entry.snoozeCount! > 0)
          _DetailRow(
            label: l10n.snoozesLabel,
            value: '${entry.snoozeCount}',
          ),
            if (entry.notes != null && entry.notes!.isNotEmpty)
              _DetailRow(label: l10n.notesLabel, value: entry.notes!),
            if (FeatureFlags.groupTravel) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showShareAlarmSheetFromDestination(
                    context,
                    name: entry.destinationName,
                    lat: entry.destLatitude,
                    lng: entry.destLongitude,
                    triggerDistanceMeters: entry.triggerDistanceMeters ?? 500,
                  );
                },
                icon: const Icon(Icons.share_outlined),
                label: Text(l10n.shareAlarmConfig),
              ),
            ],
            if (trip != null) ...[
          const Divider(height: 32),
          Text(
            l10n.journeyDetailsTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          _DetailRow(
            label: l10n.startedLabel,
            value: DateFormat.yMMMd().add_jm().format(trip!.startedAt),
          ),
          if (trip!.endedAt != null)
            _DetailRow(
              label: l10n.endedLabel,
              value: DateFormat.yMMMd().add_jm().format(trip!.endedAt!),
            ),
          if (trip!.durationSeconds != null)
            _DetailRow(
              label: l10n.durationLabel,
              value: _formatDuration(trip!.durationSeconds!),
            ),
          if (trip!.totalDistanceMeters != null)
            _DetailRow(
              label: l10n.distanceLabel,
              value: formatDistance(
                trip!.totalDistanceMeters!,
                useMetric: useMetric,
              ),
            ),
          if (trip!.routePolyline != null) ...[
            const SizedBox(height: 12),
            TripRouteMap(
              destLatitude: trip!.destLatitude,
              destLongitude: trip!.destLongitude,
              routePolyline: trip!.routePolyline,
            ),
          ],
          if (trip!.maxSpeedKmh != null)
            _DetailRow(
              label: l10n.maxSpeedLabel,
              value: '${trip!.maxSpeedKmh!.toStringAsFixed(0)} ${l10n.kmhUnit}',
            ),
          if (trip!.avgSpeedKmh != null)
            _DetailRow(
              label: l10n.avgSpeedLabel,
              value: '${trip!.avgSpeedKmh!.toStringAsFixed(0)} ${l10n.kmhUnit}',
            ),
          const SizedBox(height: 16),
          Semantics(
            label: l10n.semCreateAlarmFromTrip,
            button: true,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push(
                  '/alarm/new',
                  extra: DestinationArgs(
                    name: trip!.destinationName,
                    latitude: trip!.destLatitude,
                    longitude: trip!.destLongitude,
                  ),
                );
              },
              icon: const Icon(Icons.alarm_add),
              label: Text(l10n.createAlarmFromTrip),
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            label: l10n.semSaveFavoriteTrip,
            button: true,
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(favoriteRepositoryProvider).saveFromTrip(trip!);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.favoriteTripSaved)),
                  );
                }
              },
              icon: const Icon(Icons.favorite_border),
              label: Text(l10n.saveFavoriteTrip),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    if (minutes > 0) {
      return '${minutes}m';
    }
    return '${duration.inSeconds}s';
  }
}

class HistoryOutcomeBadge extends StatelessWidget {
  const HistoryOutcomeBadge({required this.type, this.compact = false, super.key});

  final HistoryType type;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, color) = switch (type) {
      HistoryType.completed => (l10n.outcomeCompleted, Colors.green.shade700),
      HistoryType.missed => (l10n.outcomeMissed, Colors.orange.shade800),
      HistoryType.dismissed => (l10n.outcomeDismissed, Colors.blueGrey.shade700),
      HistoryType.snoozed => (l10n.outcomeSnoozed, Colors.blue.shade700),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
