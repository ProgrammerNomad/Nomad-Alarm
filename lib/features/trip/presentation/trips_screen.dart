import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/trip.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/shared/widgets/nomad_empty_state.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsProvider);
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;

    return NomadScaffold(
      title: 'Trips',
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (trips) {
          if (trips.isEmpty) {
            return const NomadEmptyState(
              title: 'No trips yet',
              message: 'Your completed journeys will appear here.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final trip = trips[index];
              return _TripListTile(
                trip: trip,
                useMetric: useMetric,
                onTap: () => _showTripDetail(context, trip, useMetric),
              );
            },
          );
        },
      ),
    );
  }

  void _showTripDetail(BuildContext context, Trip trip, bool useMetric) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip.destinationName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _TripOutcomeBadge(outcome: trip.outcome),
            const SizedBox(height: 16),
            _DetailRow(
              label: 'Started',
              value: DateFormat.yMMMd().add_jm().format(trip.startedAt),
            ),
            if (trip.endedAt != null)
              _DetailRow(
                label: 'Ended',
                value: DateFormat.yMMMd().add_jm().format(trip.endedAt!),
              ),
            if (trip.durationSeconds != null)
              _DetailRow(
                label: 'Duration',
                value: _formatDuration(trip.durationSeconds!),
              ),
            if (trip.totalDistanceMeters != null)
              _DetailRow(
                label: 'Distance',
                value: formatDistance(
                  trip.totalDistanceMeters!,
                  useMetric: useMetric,
                ),
              ),
            if (trip.maxSpeedKmh != null)
              _DetailRow(
                label: 'Max speed',
                value: '${trip.maxSpeedKmh!.toStringAsFixed(0)} km/h',
              ),
            if (trip.avgSpeedKmh != null)
              _DetailRow(
                label: 'Avg speed',
                value: '${trip.avgSpeedKmh!.toStringAsFixed(0)} km/h',
              ),
            _DetailRow(label: 'Alarm ID', value: '${trip.alarmId}'),
          ],
        ),
      ),
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

class _TripListTile extends StatelessWidget {
  const _TripListTile({
    required this.trip,
    required this.useMetric,
    required this.onTap,
  });

  final Trip trip;
  final bool useMetric;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.MMMd().add_jm().format(trip.startedAt);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Icon(_iconForOutcome(trip.outcome)),
        ),
        title: Text(trip.destinationName),
        subtitle: Text(
          [
            date,
            if (trip.durationSeconds != null)
              _formatDurationShort(trip.durationSeconds!),
          ].join(' · '),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TripOutcomeBadge(outcome: trip.outcome, compact: true),
            if (trip.totalDistanceMeters != null) ...[
              const SizedBox(height: 4),
              Text(
                formatDistance(trip.totalDistanceMeters!, useMetric: useMetric),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _iconForOutcome(TripOutcome outcome) {
    return switch (outcome) {
      TripOutcome.completed => Icons.check_circle_outline,
      TripOutcome.cancelled => Icons.cancel_outlined,
      TripOutcome.missed => Icons.warning_amber_outlined,
      TripOutcome.passed => Icons.directions_run,
    };
  }

  String _formatDurationShort(int seconds) {
    final minutes = Duration(seconds: seconds).inMinutes;
    if (minutes >= 60) {
      return '${minutes ~/ 60}h ${minutes % 60}m';
    }
    return '${minutes}m';
  }
}

class _TripOutcomeBadge extends StatelessWidget {
  const _TripOutcomeBadge({required this.outcome, this.compact = false});

  final TripOutcome outcome;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (outcome) {
      TripOutcome.completed => ('Completed', Colors.green.shade700),
      TripOutcome.cancelled => ('Cancelled', Colors.blueGrey.shade700),
      TripOutcome.missed => ('Missed', Colors.orange.shade800),
      TripOutcome.passed => ('Passed', Colors.deepOrange.shade700),
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
