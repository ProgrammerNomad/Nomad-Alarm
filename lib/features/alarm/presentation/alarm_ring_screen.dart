import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:vibration/vibration.dart';

class AlarmRingScreen extends ConsumerStatefulWidget {
  const AlarmRingScreen({
    required this.alarmId,
    super.key,
  });

  final int alarmId;

  @override
  ConsumerState<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends ConsumerState<AlarmRingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  Timer? _hapticTimer;
  Alarm? _alarm;
  var _alertsStarted = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.85,
      upperBound: 1.15,
    )..repeat(reverse: true);

    _loadAlarm();
  }

  Future<void> _loadAlarm() async {
    final alarm =
        await ref.read(alarmRepositoryProvider).getById(widget.alarmId);
    if (!mounted) {
      return;
    }
    setState(() => _alarm = alarm);
    if (alarm != null) {
      await _startAlerts(alarm);
    }
  }

  Future<void> _startAlerts(Alarm alarm) async {
    if (_alertsStarted) {
      return;
    }
    _alertsStarted = true;

    final settings = ref.read(appSettingsProvider).valueOrNull;
    final languageCode = settings?.languageCode ?? 'en';
    final state = await ref
        .read(alarmServiceProvider)
        .getRuntimeState(widget.alarmId);

    if (alarm.voiceEnabled) {
      await ref.read(speechServiceProvider).speakApproaching(
            destinationName: alarm.name,
            distanceMeters: state?.distanceMeters ?? alarm.triggerDistanceMeters,
            languageCode: languageCode,
          );
    }

    if (alarm.vibrationEnabled) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(
          pattern: [0, 800, 400, 800, 400, 800],
          repeat: 0,
        );
      } else {
        _hapticTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          HapticFeedback.heavyImpact();
        });
      }
    } else {
      _hapticTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        HapticFeedback.heavyImpact();
      });
    }
  }

  Future<void> _stopAlerts() async {
    _hapticTimer?.cancel();
    await Vibration.cancel();
    await ref.read(speechServiceProvider).stop();
  }

  @override
  void dispose() {
    _hapticTimer?.cancel();
    Vibration.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _dismiss({required bool snooze}) async {
    await _stopAlerts();
    await ref
        .read(alarmServiceProvider)
        .dismissAlarm(widget.alarmId, snooze: snooze);
    ref.invalidate(activeAlarmsProvider);
    ref.invalidate(alarmsProvider);
    if (!mounted) {
      return;
    }
    if (snooze) {
      context.go('/alarm/active/${widget.alarmId}');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final alarm = _alarm;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        body: SafeArea(
          child: alarm == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Spacer(),
                      ScaleTransition(
                        scale: _pulseController,
                        child: Icon(
                          Icons.notifications_active,
                          size: 96,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Stop approaching!',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alarm.name,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      if (alarm.address != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          alarm.address!,
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () => _dismiss(snooze: false),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        icon: const Icon(Icons.check),
                        label: const Text('Dismiss'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _dismiss(snooze: true),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        icon: const Icon(Icons.snooze),
                        label: const Text('Snooze 2 min'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
