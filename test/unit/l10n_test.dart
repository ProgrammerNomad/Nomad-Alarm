import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';

void main() {
  test('English localizations load', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(l10n.appTitle, 'Nomad Alarm');
    expect(l10n.createAlarm, 'Create Alarm');
  });

  test('Hindi localizations load', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('hi'));
    expect(l10n.appTitle, 'नोमैड अलार्म');
    expect(l10n.createAlarm, 'अलार्म बनाएँ');
    expect(l10n.settingsTitle, 'सेटिंग्स');
  });

  test('Phase 7 tab and screen strings localized', () async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    final hi = await AppLocalizations.delegate.load(const Locale('hi'));
    expect(en.mapTitle, 'Map');
    expect(hi.mapTitle, 'मानचित्र');
    expect(en.navAlarms, 'Alarms');
    expect(hi.navAlarms, 'अलार्म');
    expect(en.alarmsTitle, 'Alarms');
    expect(en.settingsSubtitle, isNotEmpty);
    expect(en.notifTrackingChannel, 'Active Alarm');
    expect(hi.notifTrackingChannel, 'सक्रिय अलार्म');
  });
}
