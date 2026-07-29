import 'package:flutter/material.dart';
import 'package:nomad_alarm/core/constants/ui_constants.dart';
import 'package:nomad_alarm/theme/app_colors.dart';

abstract class AppTheme {
  static ThemeData light({bool highContrast = false}) =>
      _build(_lightScheme, highContrast: highContrast);

  static ThemeData dark({bool highContrast = false}) =>
      _build(_darkScheme, highContrast: highContrast);

  static ThemeData lightHighContrast() => light(highContrast: true);

  static ThemeData darkHighContrast() => dark(highContrast: true);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.bellWhite,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.onSurfaceLight,
    onSurfaceVariant: AppColors.onSurfaceVariantLight,
    outline: AppColors.outlineLight,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: AppColors.onSurfaceLight,
    onInverseSurface: AppColors.surfaceLight,
    inversePrimary: AppColors.primaryContainer,
    surfaceTint: AppColors.primary,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.onPrimaryDark,
    primaryContainer: AppColors.primaryContainerDark,
    onPrimaryContainer: AppColors.onPrimaryContainerDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: Color(0xFF1B3D38),
    onSecondaryContainer: AppColors.secondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.bellWhite,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: Color(0xFF5C1010),
    onErrorContainer: AppColors.errorContainer,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
    onSurfaceVariant: AppColors.onSurfaceVariantDark,
    outline: AppColors.outlineDark,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: AppColors.onSurfaceDark,
    onInverseSurface: AppColors.surfaceDark,
    inversePrimary: AppColors.primary,
    surfaceTint: AppColors.primaryDark,
  );

  static ThemeData _build(ColorScheme scheme, {bool highContrast = false}) {
    final effectiveScheme = highContrast
        ? scheme.copyWith(
            primary: scheme.primary.withValues(alpha: 1),
            onSurface: scheme.brightness == Brightness.light
                ? const Color(0xFF000000)
                : const Color(0xFFFFFFFF),
            outline: scheme.brightness == Brightness.light
                ? const Color(0xFF000000)
                : const Color(0xFFFFFFFF),
          )
        : scheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: effectiveScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: effectiveScheme.surface,
        foregroundColor: effectiveScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: effectiveScheme.primary,
        foregroundColor: effectiveScheme.onPrimary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: effectiveScheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: effectiveScheme.primary);
          }
          return IconThemeData(color: effectiveScheme.onSurfaceVariant);
        }),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: effectiveScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConstants.cardRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: effectiveScheme.primary,
          foregroundColor: effectiveScheme.onPrimary,
          minimumSize: const Size(
            UiConstants.minTouchTarget,
            UiConstants.minTouchTarget,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiConstants.buttonRadius),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: effectiveScheme.primary,
      ),
    );
  }
}
