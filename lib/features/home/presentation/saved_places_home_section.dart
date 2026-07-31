import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/favorite_category_utils.dart';
import 'package:nomad_alarm/models/favorite.dart';

class SavedPlacesHomeSection extends StatelessWidget {
  const SavedPlacesHomeSection({
    required this.places,
    super.key,
  });

  final List<Favorite> places;

  @override
  Widget build(BuildContext context) {
    if (!FeatureFlags.smartPlaces) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final preview = FavoriteCategoryUtils.pickHomePreviewPlaces(places);
    final hasMore = places.length > preview.length;
    final isEmpty = places.isEmpty;
    final manageLinkStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurfaceVariant,
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, size: 18, color: Colors.amber.shade700),
                const SizedBox(width: 6),
                Text(
                  l10n.savedPlaces,
                  style: theme.textTheme.titleSmall,
                ),
                const Spacer(),
                InkWell(
                  onTap: () => context.push(
                    isEmpty ? '/saved-places/new' : '/saved-places',
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      isEmpty
                          ? '${l10n.savedPlacesAddAction} >'
                          : '${l10n.savedPlacesManage} >',
                      style: manageLinkStyle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (isEmpty)
              Text(
                l10n.savedPlacesEmptyTitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < preview.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      _PlaceChip(
                        emoji: FavoriteCategoryUtils.emoji(preview[i].category),
                        label: preview[i].name,
                        onTap: () => _openPlace(context, preview[i]),
                      ),
                    ],
                    if (hasMore) ...[
                      const SizedBox(width: 8),
                      _PlaceChip(
                        label: l10n.savedPlacesMore,
                        onTap: () => context.push('/saved-places'),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openPlace(BuildContext context, Favorite place) {
    context.push(
      '/alarm/new',
      extra: DestinationArgs(
        name: place.name,
        latitude: place.latitude,
        longitude: place.longitude,
        address: place.address,
      ),
    );
  }
}

class _PlaceChip extends StatelessWidget {
  const _PlaceChip({
    required this.label,
    required this.onTap,
    this.emoji,
  });

  final String? emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ActionChip(
      avatar: emoji != null
          ? Text(emoji!, style: const TextStyle(fontSize: 14))
          : null,
      label: Text(label),
      side: BorderSide.none,
      backgroundColor: colorScheme.surfaceContainerHigh,
      visualDensity: VisualDensity.compact,
      labelStyle: theme.textTheme.labelLarge,
      onPressed: onTap,
    );
  }
}
