import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/models/recent_search.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/location_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionAsync = ref.watch(currentPositionProvider);
    final favoritesAsync = ref.watch(favoritesProvider);
    final recentAsync = ref.watch(recentSearchesProvider);
    final activeAlarmsAsync = ref.watch(activeAlarmsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nomad Alarm'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/alarm/new'),
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Create Alarm'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LocationChip(
            positionAsync: positionAsync,
            onTap: () => context.push('/map'),
          ),
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
                    Text(
                      'Search destination…',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          activeAlarmsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, stackTrace) => const SizedBox.shrink(),
            data: (alarms) {
              if (alarms.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active alarms',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...alarms.map(
                    (alarm) => _ActiveAlarmCard(alarm: alarm),
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
                    'Favorites',
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
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          recentAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error loading recent: $e'),
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
                          'Set your first destination alarm',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Search for a place or drop a pin on the map.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context.push('/search'),
                          child: const Text('Search destination'),
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
                    'Recent',
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
                ],
              );
            },
          ),
        ],
      ),
    );
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

class _ActiveAlarmCard extends ConsumerWidget {
  const _ActiveAlarmCard({required this.alarm});

  final Alarm alarm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(activeAlarmStateProvider(alarm.id));

    final subtitle = stateAsync.when(
      loading: () => alarm.address ?? 'Active alarm',
      error: (_, stackTrace) => alarm.address ?? 'Active alarm',
      data: (state) {
        if (state.status == AlarmStatus.triggered) {
          return 'Alarm ringing - ${formatDistance(state.distanceMeters)} away';
        }
        return '${formatDistance(state.distanceMeters)} away';
      },
    );

    return Card(
      child: ListTile(
        leading: Icon(
          alarm.status == AlarmStatus.triggered
              ? Icons.notifications_active
              : Icons.alarm,
        ),
        title: Text(alarm.name),
        subtitle: Text(subtitle),
        onTap: () {
          if (alarm.status == AlarmStatus.triggered) {
            context.push('/alarm/ring/${alarm.id}');
          } else {
            context.push('/alarm/active/${alarm.id}');
          }
        },
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip({
    required this.positionAsync,
    required this.onTap,
  });

  final AsyncValue<Position?> positionAsync;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = positionAsync.when(
      loading: () => 'Getting location…',
      error: (_, stackTrace) => 'Location unavailable - tap to open map',
      data: (position) {
        if (position == null) {
          return 'Location unavailable - tap to open map';
        }
        return '${position.latitude.toStringAsFixed(4)}, '
            '${position.longitude.toStringAsFixed(4)}';
      },
    );

    return ActionChip(
      avatar: const Icon(Icons.my_location, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
