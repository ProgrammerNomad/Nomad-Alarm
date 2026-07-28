import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/constants/app_constants.dart';
import 'package:nomad_alarm/core/router/app_router.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/theme/app_theme.dart';

class NomadAlarmApp extends ConsumerWidget {
  const NomadAlarmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
