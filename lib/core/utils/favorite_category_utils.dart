import 'package:flutter/material.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';

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

  static String emoji(FavoriteCategory category) {
    return switch (normalize(category)) {
      FavoriteCategory.home => '🏠',
      FavoriteCategory.office => '🏢',
      FavoriteCategory.school => '🎓',
      FavoriteCategory.station => '🚉',
      FavoriteCategory.busStop => '🚌',
      FavoriteCategory.metro => '🚇',
      FavoriteCategory.airport => '✈',
      FavoriteCategory.hospital => '🏥',
      FavoriteCategory.custom => '⭐',
      _ => '⭐',
    };
  }

  static IconData icon(FavoriteCategory category) {
    return switch (normalize(category)) {
      FavoriteCategory.home => Icons.home_outlined,
      FavoriteCategory.office => Icons.work_outline,
      FavoriteCategory.school => Icons.school_outlined,
      FavoriteCategory.station => Icons.train_outlined,
      FavoriteCategory.busStop => Icons.directions_bus_outlined,
      FavoriteCategory.metro => Icons.subway_outlined,
      FavoriteCategory.airport => Icons.flight,
      FavoriteCategory.hospital => Icons.local_hospital_outlined,
      FavoriteCategory.custom => Icons.star_outline,
      _ => Icons.place_outlined,
    };
  }

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
