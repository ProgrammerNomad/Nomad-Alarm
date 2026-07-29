import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/trip.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/shared/widgets/nomad_empty_state.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';
import 'package:nomad_alarm/shared/widgets/trip_route_map.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tripsAsync = ref.watch(tripsProvider);
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;

    return NomadScaffold(
      title: l10n.tripsTitle,
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(l10n.errorPrefix(error.toString()))),
        data: (trips) {
          if (trips.isEmpty) {
            return NomadEmptyState(
              title: l10n.noTripsTitle,
              message: l10n.noTripsMessage,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Semantics(
                label: trip.destinationName,
                button: true,
                child: _TripListTile(
                  trip: trip,
                  useMetric: useMetric,
                  onTap: () => _showTripDetail(context, ref, trip, useMetric),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showTripDetail(
    BuildContext context,
    WidgetRef ref,
    Trip trip,
    bool useMetric,
  ) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              trip.destinationName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _TripOutcomeBadge(outcome: trip.outcome),
            const SizedBox(height: 16),
            _DetailRow(
              label: l10n.startedLabel,
              value: DateFormat.yMMMd().add_jm().format(trip.startedAt),
            ),
            if (trip.endedAt != null)
              _DetailRow(
                label: l10n.endedLabel,
                value: DateFormat.yMMMd().add_jm().format(trip.endedAt!),
              ),
            if (trip.durationSeconds != null)
              _DetailRow(
                label: l10n.durationLabel,
                value: _formatDuration(trip.durationSeconds!),
              ),
            if (trip.totalDistanceMeters != null)
              _DetailRow(
                label: l10n.distanceLabel,
                value: formatDistance(
                  trip.totalDistanceMeters!,
                  useMetric: useMetric,
                ),
              ),
            if (trip.routePolyline != null) ...[
              const SizedBox(height: 12),
              TripRouteMap(
                destLatitude: trip.destLatitude,
                destLongitude: trip.destLongitude,
                routePolyline: trip.routePolyline,
              ),
            ],
            if (trip.maxSpeedKmh != null)
              _DetailRow(
                label: l10n.maxSpeedLabel,
                value: '${trip.maxSpeedKmh!.toStringAsFixed(0)} ${l10n.kmhUnit}',
              ),
            if (trip.avgSpeedKmh != null)
              _DetailRow(
                label: l10n.avgSpeedLabel,
                value: '${trip.avgSpeedKmh!.toStringAsFixed(0)} ${l10n.kmhUnit}',
              ),
            _DetailRow(label: l10n.alarmIdLabel, value: '${trip.alarmId}'),
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
                      name: trip.destinationName,
                      latitude: trip.destLatitude,
                      longitude: trip.destLongitude,
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
                  await ref.read(favoriteRepositoryProvider).saveFromTrip(trip);
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
    final l10n = context.l10n;
    final (label, color) = switch (outcome) {
      TripOutcome.completed => (l10n.outcomeCompleted, Colors.green.shade700),
      TripOutcome.cancelled =>
        (l10n.tripOutcomeCancelled, Colors.blueGrey.shade700),
      TripOutcome.missed => (l10n.outcomeMissed, Colors.orange.shade800),
      TripOutcome.passed => (l10n.tripOutcomePassed, Colors.deepOrange.shade700),
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
