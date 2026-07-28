import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
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
    await ref.read(bootstrapProvider.future);
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
    context.go('/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinBlue,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: const NomadLogo(size: 160),
        ),
      ),
    );
  }
}
