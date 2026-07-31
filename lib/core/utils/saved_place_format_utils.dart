import 'package:intl/intl.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';

class SavedPlaceFormatUtils {
  SavedPlaceFormatUtils._();

  static String formatLastUsed(AppLocalizations l10n, DateTime? at, String locale) {
    if (at == null) {
      return l10n.lastUsedNever;
    }
    final now = DateTime.now();
    final local = at.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final diff = today.difference(day).inDays;

    final time = DateFormat.jm(locale).format(local);
    final when = switch (diff) {
      0 => 'Today · $time',
      1 => 'Yesterday · $time',
      _ => '${DateFormat.MMMd(locale).format(local)} · $time',
    };
    return l10n.lastUsedFormatted(when);
  }
}
