import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/utils/locale_resolution.dart';
import 'package:nomad_alarm/core/router/app_router.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/smart_place_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/theme/app_theme.dart';

class NomadAlarmApp extends ConsumerWidget {
  const NomadAlarmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(deferredInitProvider);
    ref.watch(smartPlaceBootstrapProvider);
    final router = ref.watch(routerProvider);
    final settingsAsync = ref.watch(appSettingsProvider);

    final themeMode = settingsAsync.when(
      data: (settings) => switch (settings.themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      },
      loading: () => ThemeMode.system,
      error: (_, _) => ThemeMode.system,
    );

    final locale = settingsAsync.when(
      data: (settings) => resolveAppLocale(settings.languageCode),
      loading: () => const Locale('en'),
      error: (_, _) => const Locale('en'),
    );

    final highContrast = settingsAsync.when(
      data: (settings) => settings.accessibilityHighContrast,
      loading: () => false,
      error: (_, _) => false,
    );

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: highContrast ? AppTheme.lightHighContrast() : AppTheme.light(),
      darkTheme: highContrast ? AppTheme.darkHighContrast() : AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
