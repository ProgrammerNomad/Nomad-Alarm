import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/utils/favorite_category_utils.dart';
import 'package:nomad_alarm/core/utils/saved_place_format_utils.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/shared/widgets/nomad_scaffold.dart';

class SavedPlacesListScreen extends ConsumerWidget {
  const SavedPlacesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final favoritesAsync = ref.watch(favoritesProvider);
    final locale = Localizations.localeOf(context).toString();

    return NomadScaffold(
      title: l10n.savedPlaces,
      showBackButton: true,
      floatingActionButton: FeatureFlags.smartPlaces
          ? FloatingActionButton(
              onPressed: () => context.push('/saved-places/new'),
              child: const Icon(Icons.add),
            )
          : null,
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorPrefix(e.toString()))),
        data: (places) {
          if (places.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 56,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.savedPlacesEmptyTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.savedPlacesEmptyBody,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.push('/saved-places/new'),
                      child: Text(l10n.savedPlacesAdd),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: places.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final place = places[index];
              final visual = FavoriteCategoryUtils.visual(place.category);
              final colorScheme = Theme.of(context).colorScheme;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: visual.backgroundFor(colorScheme),
                  child: Icon(
                    visual.icon,
                    size: 20,
                    color: visual.color,
                  ),
                ),
                title: Text(place.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.smartAlarmModeSummary(
                        FavoriteCategoryUtils.smartAlarmModeLabel(
                          l10n,
                          place.smartAlarmMode,
                        ),
                      ),
                    ),
                    Text(
                      SavedPlaceFormatUtils.formatLastUsed(
                        l10n,
                        place.lastUsedAt,
                        locale,
                      ),
                    ),
                    if (place.autoStartedCount > 0)
                      Text(l10n.autoStartedCount(place.autoStartedCount)),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/saved-places/${place.id}/edit'),
              );
            },
          );
        },
      ),
    );
  }
}
