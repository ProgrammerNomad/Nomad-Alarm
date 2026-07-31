import 'package:flutter/widgets.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';

/// Notification copy without BuildContext (uses cached AppLocalizations).
class NotificationL10n {
  NotificationL10n(this._l10n);

  final AppLocalizations _l10n;

  static Future<NotificationL10n> load(String languageCode) async {
    final locale = languageCode.startsWith('hi')
        ? const Locale('hi')
        : const Locale('en');
    final l10n = await AppLocalizations.delegate.load(locale);
    return NotificationL10n(l10n);
  }

  String get trackingChannelName => _l10n.notifTrackingChannel;
  String get trackingChannelDesc => _l10n.notifTrackingChannelDesc;
  String get alarmChannelName => _l10n.notifAlarmChannel;
  String get alarmChannelDesc => _l10n.notifAlarmChannelDesc;
  String get warningsChannelName => _l10n.notifWarningsChannel;
  String get stopApproaching => _l10n.stopApproaching;
  String get gpsLostTitle => _l10n.notifGpsLostTitle;
  String get gpsLostBody => _l10n.notifGpsLostBody;
  String get lowBatteryTitle => _l10n.notifLowBatteryTitle;
  String get lowBatteryBody => _l10n.notifLowBatteryBody;
  String get internetLostTitle => _l10n.notifInternetLostTitle;
  String get internetLostBody => _l10n.notifInternetLostBody;
  String toDestination(String distance) => _l10n.notifToDestination(distance);
  String get pause => _l10n.pause;
  String get cancel => _l10n.cancel;
  String smartAlarmActiveTitle(String place) =>
      _l10n.notifSmartAlarmActiveTitle(place);
  String smartAlarmActiveBody(String distance) =>
      _l10n.notifSmartAlarmActiveBody(distance);
  String get smartAlarmStop => _l10n.notifSmartAlarmStop;
  String get smartAlarmOpen => _l10n.notifSmartAlarmOpen;
  String get widgetNoActiveAlarm => _l10n.widgetNoActiveAlarm;
  String get widgetTracking => _l10n.widgetTracking;
  String get widgetTapToOpen => _l10n.widgetTapToOpen;
  String get tileLabel => _l10n.appTitle;
  String tileActive(String distance) => _l10n.tileActiveDistance(distance);
  String get fgsStartingTitle => _l10n.fgsStartingTitle;
  String get fgsStartingContent => _l10n.fgsStartingContent;
}
