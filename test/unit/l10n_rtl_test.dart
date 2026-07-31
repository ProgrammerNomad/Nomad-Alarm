import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';

void main() {
  test('Arabic localizations load with RTL locale', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('ar'));
    expect(l10n.navAlarms, 'المنبهات');
    expect(l10n.lockScreenInfo, 'عرض على شاشة القفل');
  });

  test('Hebrew localizations load', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('he'));
    expect(l10n.navAlarms, 'התראות');
    expect(l10n.highContrast, 'ניגודיות גבוהה');
  });
}
