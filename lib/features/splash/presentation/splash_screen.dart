import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/isar_service.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/deep_link_service.dart';
import 'package:nomad_alarm/services/widget_service.dart';
import 'package:nomad_alarm/services/background_alarm_service.dart';
import 'package:nomad_alarm/shared/widgets/nomad_logo.dart';
import 'package:nomad_alarm/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (mounted) {
      setState(() => _errorMessage = null);
    }
    try {
      await ref.read(bootstrapProvider.future);
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.toString());
      }
      return;
    }
    if (!mounted) {
      return;
    }
    await Future<void>.delayed(
      const Duration(milliseconds: 600),
    );
    if (!mounted) {
      return;
    }
    final settings = await ref.read(settingsRepositoryProvider).getSettings();
    if (!mounted) {
      return;
    }
    if (!settings.hasCompletedWelcome) {
      context.go('/welcome');
      return;
    }
    if (!settings.hasCompletedPermissions) {
      context.go('/permissions');
      return;
    }

    final launchPayload =
        await ref.read(notificationServiceProvider).getLaunchPayload();
    if (!mounted) {
      return;
    }
    if (launchPayload != null) {
      if (launchPayload.startsWith('ring:')) {
        final id = int.tryParse(launchPayload.split(':').last);
        if (id != null) {
          context.go('/alarm/ring/$id');
          return;
        }
      } else if (launchPayload.startsWith('active:')) {
        final id = int.tryParse(launchPayload.split(':').last);
        if (id != null) {
          context.go('/alarm/active/$id');
          return;
        }
      }
    }

    final widgetUri = await WidgetService.getLaunchUri();
    if (!mounted) {
      return;
    }
    final widgetRoute = _routeFromWidgetUri(widgetUri);
    if (widgetRoute != null) {
      if (widgetRoute.startsWith('/tile/cancel/')) {
        final id = int.tryParse(widgetRoute.split('/').last);
        if (id != null) {
          await ref.read(alarmServiceProvider).cancelAlarm(id);
        }
        if (!mounted) {
          return;
        }
        context.go('/home');
        return;
      }
      context.go(widgetRoute);
      return;
    }

    final deepLinkArgs = DeepLinkService.consumePendingDestination();
    if (!mounted) {
      return;
    }
    if (deepLinkArgs != null) {
      context.go('/alarm/new', extra: deepLinkArgs);
      return;
    }

    final running = await ref.read(alarmRepositoryProvider).getRunning();
    if (!mounted) {
      return;
    }
    if (running.isNotEmpty &&
        !await BackgroundAlarmService.hasLocationPermissionForForegroundService()) {
      await ref.read(alarmServiceProvider).suspendActiveAlarmsIfLocationDenied();
      if (!mounted) {
        return;
      }
      context.go('/permissions');
      return;
    }
    if (running.isNotEmpty) {
      if (!mounted) {
        return;
      }
      await ref.read(alarmServiceProvider).resumeMonitoringForRunningAlarms();
      if (!mounted) {
        return;
      }
      final triggered = running.where((a) => a.status == AlarmStatus.triggered).toList();
      if (triggered.isNotEmpty) {
        context.go('/alarm/ring/${triggered.first.id}');
        return;
      }
      context.go('/home');
      return;
    }
    if (!mounted) {
      return;
    }
    context.go('/home');
  }

  void _retryBootstrap() {
    ref.invalidate(isarServiceProvider);
    ref.invalidate(bootstrapProvider);
    _bootstrap();
  }

  String? _routeFromWidgetUri(Uri? uri) {
    if (uri == null) {
      return null;
    }
    final route = uri.queryParameters['route'];
    if (route != null && route.startsWith('/')) {
      return route;
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: _errorMessage == null
            ? FadeTransition(
                opacity: _fade,
                child: const NomadLogo(size: 160),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to start Nomad Alarm',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.onSurfaceDark,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _retryBootstrap,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
