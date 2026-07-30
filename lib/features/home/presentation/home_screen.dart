import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/current_location_label_provider.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/location_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final useMetric =
        ref.watch(appSettingsProvider).valueOrNull?.useMetric ?? true;
    final favoritesAsync = ref.watch(favoritesProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    final activeAlarmsAsync = ref.watch(activeAlarmsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      floatingActionButton: Semantics(
        label: l10n.semCreateAlarm,
        button: true,
        child: FloatingActionButton(
          tooltip: l10n.newAlarm,
          onPressed: () => context.push('/alarm/new'),
          child: const Icon(Icons.add),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _CurrentLocationCard(),
          const SizedBox(height: 12),
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => context.push('/search'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.searchDestinationHint,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          activeAlarmsAsync.when(
            loading: () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.activeAlarms,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ],
            ),
            error: (_, stackTrace) => const SizedBox.shrink(),
            data: (alarms) {
              if (alarms.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.activeAlarms,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.activeAlarmsEmptyHint,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              final sorted = _sortAlarmsByDistance(ref, alarms);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.activeAlarmsCount(sorted.length),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...sorted.map(
                    (alarm) => _ActiveAlarmCard(
                      alarm: alarm,
                      useMetric: useMetric,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          recentAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(l10n.errorPrefix(e.toString())),
            data: (recent) {
              if (recent.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.firstAlarmTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.firstAlarmBody,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }
              final topRecent = recent.take(3).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.recent,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...topRecent.map(
                    (item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history),
                      title: Text(item.resultName),
                      subtitle: item.address != null ? Text(item.address!) : null,
                      onTap: () => _openRecent(context, item),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          favoritesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, stackTrace) => const SizedBox.shrink(),
            data: (favorites) {
              if (favorites.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.favorites,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: favorites.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final fav = favorites[index];
                        return ActionChip(
                          avatar: Icon(_favoriteIcon(fav)),
                          label: Text(fav.name),
                          onPressed: () => _openFavorite(context, fav),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<Alarm> _sortAlarmsByDistance(WidgetRef ref, List<Alarm> alarms) {
    double distanceFor(Alarm alarm) {
      final state = ref.watch(activeAlarmStateProvider(alarm.id)).valueOrNull;
      if (state == null) {
        return double.infinity;
      }
      return state.distanceMeters;
    }

    final sorted = [...alarms];
    sorted.sort((a, b) {
      final statusOrder = _statusSortOrder(a.status).compareTo(_statusSortOrder(b.status));
      if (statusOrder != 0) {
        return statusOrder;
      }
      return distanceFor(a).compareTo(distanceFor(b));
    });
    return sorted;
  }

  int _statusSortOrder(AlarmStatus status) {
    return switch (status) {
      AlarmStatus.active => 0,
      AlarmStatus.triggered => 1,
      AlarmStatus.paused => 2,
      _ => 3,
    };
  }

  void _openFavorite(BuildContext context, Favorite fav) {
    context.push(
      '/alarm/new',
      extra: DestinationArgs(
        name: fav.name,
        latitude: fav.latitude,
        longitude: fav.longitude,
        address: fav.address,
      ),
    );
  }

  void _openRecent(BuildContext context, RecentSearch recent) {
    context.push(
      '/alarm/new',
      extra: DestinationArgs(
        name: recent.resultName,
        latitude: recent.latitude,
        longitude: recent.longitude,
        address: recent.address,
      ),
    );
  }

  IconData _favoriteIcon(Favorite fav) {
    return switch (fav.category) {
      FavoriteCategory.home => Icons.home_outlined,
      FavoriteCategory.office => Icons.work_outline,
      FavoriteCategory.airport => Icons.flight,
      _ => Icons.star_outline,
    };
  }
}

class _CurrentLocationCard extends ConsumerWidget {
  const _CurrentLocationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final positionAsync = ref.watch(currentPositionProvider);
    final addressAsync = ref.watch(currentLocationLabelProvider);

    final subtitle = positionAsync.when(
      loading: () => l10n.gettingLocation,
      error: (_, stackTrace) => l10n.locationUnavailable,
      data: (position) {
        if (position == null) {
          return l10n.locationUnavailable;
        }
        return addressAsync.when(
          loading: () => _formatCoordinates(position),
          error: (_, stackTrace) => _formatCoordinates(position),
          data: (address) =>
              address != null && address.isNotEmpty
                  ? address
                  : _formatCoordinates(position),
        );
      },
    );

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          Icons.location_on_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(l10n.currentLocationLabel),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/map'),
      ),
    );
  }

  String _formatCoordinates(Position position) {
    return '${position.latitude.toStringAsFixed(4)}, '
        '${position.longitude.toStringAsFixed(4)}';
  }
}

class _ActiveAlarmCard extends ConsumerWidget {
  const _ActiveAlarmCard({
    required this.alarm,
    required this.useMetric,
  });

  final Alarm alarm;
  final bool useMetric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final stateAsync = ref.watch(activeAlarmStateProvider(alarm.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (alarm.status == AlarmStatus.triggered) {
            context.push('/alarm/ring/${alarm.id}');
          } else {
            context.push('/alarm/active/${alarm.id}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: stateAsync.when(
            loading: () => _AlarmCardBody(
              alarm: alarm,
              statusLabel: _statusLabel(l10n, alarm.status),
              statusColor: _statusColor(alarm.status),
              subtitle: alarm.address ?? l10n.activeAlarmFallback,
              useMetric: useMetric,
              onPause: null,
              onResume: null,
              onCancel: () => _cancel(ref, context),
            ),
            error: (_, stackTrace) => _AlarmCardBody(
              alarm: alarm,
              statusLabel: _statusLabel(l10n, alarm.status),
              statusColor: _statusColor(alarm.status),
              subtitle: alarm.address ?? l10n.activeAlarmFallback,
              useMetric: useMetric,
              onPause: null,
              onResume: null,
              onCancel: () => _cancel(ref, context),
            ),
            data: (state) => _AlarmCardBody(
              alarm: alarm,
              statusLabel: _statusLabel(l10n, state.status),
              statusColor: _statusColor(state.status),
              subtitle: _subtitle(l10n, state, useMetric),
              useMetric: useMetric,
              onPause: state.status == AlarmStatus.active
                  ? () => _pause(ref, context)
                  : null,
              onResume: state.status == AlarmStatus.paused
                  ? () => _resume(ref, context)
                  : null,
              onCancel: () => _cancel(ref, context),
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel(dynamic l10n, AlarmStatus status) {
    return switch (status) {
      AlarmStatus.paused => l10n.alarmStatusPaused,
      AlarmStatus.triggered => l10n.stopApproaching,
      _ => l10n.alarmStatusTracking,
    };
  }

  Color _statusColor(AlarmStatus status) {
    return switch (status) {
      AlarmStatus.paused => Colors.amber,
      AlarmStatus.triggered => Colors.red,
      _ => Colors.green,
    };
  }

  String _subtitle(dynamic l10n, AlarmRuntimeState state, bool useMetric) {
    final distance = formatDistance(state.distanceMeters, useMetric: useMetric);
    final eta = formatEta(state.etaMinutes);
    if (state.status == AlarmStatus.triggered) {
      return l10n.alarmRingingDistance(distance);
    }
    if (state.etaMinutes != null) {
      return '$distance · $eta';
    }
    return l10n.distanceAway(distance);
  }

  Future<void> _pause(WidgetRef ref, BuildContext context) async {
    await ref.read(alarmServiceProvider).pauseAlarm(alarm.id);
    ref.invalidate(activeAlarmsProvider);
  }

  Future<void> _resume(WidgetRef ref, BuildContext context) async {
    await ref.read(alarmServiceProvider).resumeAlarm(alarm.id);
    ref.invalidate(activeAlarmsProvider);
  }

  Future<void> _cancel(WidgetRef ref, BuildContext context) async {
    await ref.read(alarmServiceProvider).cancelAlarm(alarm.id);
    ref.invalidate(activeAlarmsProvider);
  }
}

class _AlarmCardBody extends StatelessWidget {
  const _AlarmCardBody({
    required this.alarm,
    required this.statusLabel,
    required this.statusColor,
    required this.subtitle,
    required this.useMetric,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
  });

  final Alarm alarm;
  final String statusLabel;
  final Color statusColor;
  final String subtitle;
  final bool useMetric;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 12, color: statusColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                alarm.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              l10n.alarmNumberLabel(alarm.id),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$statusLabel · $subtitle',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (onResume != null)
              TextButton(
                onPressed: onResume,
                child: Text(l10n.resume),
              ),
            if (onPause != null)
              TextButton(
                onPressed: onPause,
                child: Text(l10n.pause),
              ),
            const Spacer(),
            TextButton(
              onPressed: onCancel,
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ],
    );
  }
}
