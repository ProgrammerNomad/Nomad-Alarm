import 'package:flutter/material.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';

/// Wraps a widget under test with app localizations (English default).
Widget buildL10nTestApp(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}
