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
    final preview = FavoriteCategoryUtils.pickHomePreviewPlaces(places);
    final hasMore = places.length > preview.length;
    final isEmpty = places.isEmpty;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
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
                  onPressed: () => context.push('/saved-places'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('${l10n.savedPlacesManage} >'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (isEmpty)
              InkWell(
                onTap: () => context.push('/saved-places/new'),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(l10n.savedPlacesAddFirst, style: textStyle),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < preview.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      _PlaceQuickPick(
                        label:
                            '${FavoriteCategoryUtils.emoji(preview[i].category)} ${preview[i].name}',
                        onTap: () => _openPlace(context, preview[i]),
                      ),
                    ],
                    if (hasMore) ...[
                      const SizedBox(width: 16),
                      _PlaceQuickPick(
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

class _PlaceQuickPick extends StatelessWidget {
  const _PlaceQuickPick({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
