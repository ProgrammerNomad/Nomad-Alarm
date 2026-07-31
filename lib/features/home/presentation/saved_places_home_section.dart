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
    final colorScheme = Theme.of(context).colorScheme;
    final preview = FavoriteCategoryUtils.pickHomePreviewPlaces(places);
    final hasMore = places.length > preview.length;
    final isEmpty = places.isEmpty;

    return Material(
      color: colorScheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, size: 18, color: Colors.amber.shade700),
                const SizedBox(width: 6),
                Text(
                  l10n.savedPlaces,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push(
                    isEmpty ? '/saved-places/new' : '/saved-places',
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    isEmpty
                        ? '${l10n.savedPlacesAddAction} >'
                        : '${l10n.savedPlacesManage} >',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isEmpty)
              Text(
                l10n.savedPlacesEmptyTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                      ActionChip(
                        avatar: Text(
                          FavoriteCategoryUtils.emoji(preview[i].category),
                          style: const TextStyle(fontSize: 14),
                        ),
                        label: Text(preview[i].name),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => _openPlace(context, preview[i]),
                      ),
                    ],
                    if (hasMore) ...[
                      const SizedBox(width: 8),
                      ActionChip(
                        label: Text(l10n.savedPlacesMore),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => context.push('/saved-places'),
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
