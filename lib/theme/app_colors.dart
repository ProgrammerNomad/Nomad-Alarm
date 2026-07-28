import 'package:flutter/material.dart';

/// Brand colors from the Nomad Alarm logo.
/// Pin: #1565C0 · Bell: #FFFFFF
abstract class AppColors {
  /// Logo map-pin blue
  static const Color pinBlue = Color(0xFF1565C0);

  /// Logo bell white
  static const Color bellWhite = Color(0xFFFFFFFF);

  /// Primary brand color (same as pin blue)
  static const Color primary = pinBlue;
  static const Color onPrimary = bellWhite;

  static const Color primaryContainer = Color(0xFFBBDEFB);
  static const Color onPrimaryContainer = Color(0xFF0D47A1);

  static const Color secondary = Color(0xFF00897B);
  static const Color onSecondary = bellWhite;
  static const Color secondaryContainer = Color(0xFFB2DFDB);
  static const Color onSecondaryContainer = Color(0xFF004D40);

  static const Color error = Color(0xFFD32F2F);
  static const Color onError = bellWhite;
  static const Color errorContainer = Color(0xFFFFCDD2);
  static const Color onErrorContainer = Color(0xFFB71C1C);

  static const Color warning = Color(0xFFF57C00);
  static const Color tertiary = Color(0xFF5C6BC0);

  // Light surfaces
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceContainerLight = Color(0xFFF5F5F5);
  static const Color onSurfaceLight = Color(0xFF1A1A1A);
  static const Color onSurfaceVariantLight = Color(0xFF616161);
  static const Color outlineLight = Color(0xFFBDBDBD);

  // Dark surfaces
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceContainerDark = Color(0xFF1E1E1E);
  static const Color onSurfaceDark = Color(0xFFE0E0E0);
  static const Color onSurfaceVariantDark = Color(0xFF9E9E9E);
  static const Color outlineDark = Color(0xFF616161);

  /// Dark theme primary - lighter pin-blue for contrast on dark surfaces
  static const Color primaryDark = Color(0xFF64B5F6);
  static const Color onPrimaryDark = Color(0xFF0D2F5C);
  static const Color primaryContainerDark = Color(0xFF0D47A1);
  static const Color onPrimaryContainerDark = Color(0xFFBBDEFB);
}
