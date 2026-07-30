import 'dart:ui';

const supportedAppLanguageCodes = {'en', 'hi', 'ar', 'he'};
const systemLanguageCode = 'system';

Locale resolveAppLocale(String languageCode) {
  if (languageCode == systemLanguageCode) {
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    if (supportedAppLanguageCodes.contains(deviceCode)) {
      return Locale(deviceCode);
    }
    return const Locale('en');
  }
  return Locale(languageCode);
}

String resolveNotificationLanguageCode(String languageCode) {
  if (languageCode == systemLanguageCode) {
    return resolveAppLocale(languageCode).languageCode;
  }
  return languageCode;
}
