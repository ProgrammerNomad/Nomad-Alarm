import 'package:flutter/material.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';

/// Icon and accent color for rendering a Saved Place category consistently.
class SavedPlaceVisual {
  const SavedPlaceVisual({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  /// ~10% opacity tint for chips and avatars.
  Color backgroundFor(ColorScheme scheme) => color.withValues(alpha: 0.10);
}

/// User-facing category labels and icons for Saved Places.
class FavoriteCategoryUtils {
  FavoriteCategoryUtils._();

  static const _pickerCategories = [
    FavoriteCategory.home,
    FavoriteCategory.office,
    FavoriteCategory.school,
    FavoriteCategory.station,
    FavoriteCategory.busStop,
    FavoriteCategory.metro,
    FavoriteCategory.airport,
    FavoriteCategory.hospital,
    FavoriteCategory.custom,
  ];

  static List<FavoriteCategory> get pickerCategories => _pickerCategories;

  static FavoriteCategory normalize(FavoriteCategory category) {
    return switch (category) {
      FavoriteCategory.college => FavoriteCategory.school,
      FavoriteCategory.gym ||
      FavoriteCategory.hotel ||
      FavoriteCategory.trip =>
        FavoriteCategory.custom,
      _ => category,
    };
  }

  static SavedPlaceVisual visual(FavoriteCategory category) {
    return switch (normalize(category)) {
      FavoriteCategory.home => SavedPlaceVisual(
          icon: Icons.home_rounded,
          color: Colors.orange.shade700,
        ),
      FavoriteCategory.office => SavedPlaceVisual(
          icon: Icons.work_rounded,
          color: Colors.blue.shade700,
        ),
      FavoriteCategory.school => SavedPlaceVisual(
          icon: Icons.school_rounded,
          color: Colors.purple.shade700,
        ),
      FavoriteCategory.station => SavedPlaceVisual(
          icon: Icons.train_rounded,
          color: Colors.green.shade700,
        ),
      FavoriteCategory.busStop => SavedPlaceVisual(
          icon: Icons.directions_bus_rounded,
          color: Colors.teal.shade700,
        ),
      FavoriteCategory.metro => SavedPlaceVisual(
          icon: Icons.subway_rounded,
          color: Colors.teal.shade700,
        ),
      FavoriteCategory.airport => SavedPlaceVisual(
          icon: Icons.flight_rounded,
          color: Colors.indigo.shade700,
        ),
      FavoriteCategory.hospital => SavedPlaceVisual(
          icon: Icons.local_hospital_rounded,
          color: Colors.red.shade700,
        ),
      FavoriteCategory.custom => SavedPlaceVisual(
          icon: Icons.bookmark_rounded,
          color: Colors.blueGrey.shade600,
        ),
      _ => SavedPlaceVisual(
          icon: Icons.place_rounded,
          color: Colors.blueGrey.shade600,
        ),
    };
  }

  static SavedPlaceVisual visualFor(Favorite favorite) =>
      visual(normalize(favorite.category));

  static IconData icon(FavoriteCategory category) => visual(category).icon;

  static String label(AppLocalizations l10n, FavoriteCategory category) {
    return switch (normalize(category)) {
      FavoriteCategory.home => l10n.savedPlaceCategoryHome,
      FavoriteCategory.office => l10n.savedPlaceCategoryOffice,
      FavoriteCategory.school => l10n.savedPlaceCategorySchool,
      FavoriteCategory.station => l10n.savedPlaceCategoryStation,
      FavoriteCategory.busStop => l10n.savedPlaceCategoryBusStop,
      FavoriteCategory.metro => l10n.savedPlaceCategoryMetro,
      FavoriteCategory.airport => l10n.savedPlaceCategoryAirport,
      FavoriteCategory.hospital => l10n.savedPlaceCategoryHospital,
      FavoriteCategory.custom => l10n.savedPlaceCategoryCustom,
      _ => l10n.savedPlaceCategoryCustom,
    };
  }

  static String smartAlarmModeLabel(
    AppLocalizations l10n,
    SmartAlarmMode mode,
  ) {
    return switch (mode) {
      SmartAlarmMode.off => l10n.smartAlarmOff,
      SmartAlarmMode.suggest => l10n.smartAlarmSuggest,
      SmartAlarmMode.automatic => l10n.smartAlarmAutomatic,
    };
  }

  static int homePreviewPriority(FavoriteCategory category) {
    return switch (normalize(category)) {
      FavoriteCategory.home => 0,
      FavoriteCategory.office => 1,
      FavoriteCategory.station => 2,
      FavoriteCategory.busStop => 3,
      FavoriteCategory.metro => 4,
      FavoriteCategory.airport => 5,
      FavoriteCategory.school => 6,
      FavoriteCategory.hospital => 7,
      FavoriteCategory.custom => 8,
      _ => 9,
    };
  }

  static List<Favorite> pickHomePreviewPlaces(List<Favorite> all, {int limit = 3}) {
    final sorted = [...all]
      ..sort((a, b) {
        final priority = homePreviewPriority(a.category)
            .compareTo(homePreviewPriority(b.category));
        if (priority != 0) {
          return priority;
        }
        return a.sortOrder.compareTo(b.sortOrder);
      });
    return sorted.take(limit).toList();
  }
}
