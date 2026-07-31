import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/core/utils/favorite_category_utils.dart';
import 'package:nomad_alarm/models/enums.dart';

void main() {
  group('FavoriteCategoryUtils.visual', () {
    for (final category in FavoriteCategoryUtils.pickerCategories) {
      test('returns icon and color for $category', () {
        final visual = FavoriteCategoryUtils.visual(category);

        expect(visual.icon, isNotNull);
        expect(visual.color.alpha, greaterThan(0));
        expect(visual.backgroundFor(const ColorScheme.light()).alpha, greaterThan(0));
      });
    }

    test('normalizes legacy categories', () {
      expect(
        FavoriteCategoryUtils.visual(FavoriteCategory.college).icon,
        FavoriteCategoryUtils.visual(FavoriteCategory.school).icon,
      );
      expect(
        FavoriteCategoryUtils.visual(FavoriteCategory.gym).icon,
        FavoriteCategoryUtils.visual(FavoriteCategory.custom).icon,
      );
    });

    test('icon() delegates to visual()', () {
      for (final category in FavoriteCategoryUtils.pickerCategories) {
        expect(
          FavoriteCategoryUtils.icon(category),
          FavoriteCategoryUtils.visual(category).icon,
        );
      }
    });
  });
}
