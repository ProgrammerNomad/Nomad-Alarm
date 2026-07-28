import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';

class AlarmConfigScreen extends ConsumerStatefulWidget {
  const AlarmConfigScreen({
    super.key,
    this.destination,
  });

  final DestinationArgs? destination;

  @override
  ConsumerState<AlarmConfigScreen> createState() => _AlarmConfigScreenState();
}

class _AlarmConfigScreenState extends ConsumerState<AlarmConfigScreen> {
  late double _triggerDistanceMeters;
  late bool _voiceEnabled;
  late bool _vibrationEnabled;
  late bool _flashlightEnabled;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _triggerDistanceMeters = AlarmConstants.defaultTriggerDistanceM;
    _voiceEnabled = true;
    _vibrationEnabled = true;
    _flashlightEnabled = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsControllerProvider).valueOrNull;
      if (settings != null && mounted) {
        setState(() {
          _triggerDistanceMeters = settings.defaultTriggerDistanceMeters;
          _voiceEnabled = settings.defaultVoiceEnabled;
          _vibrationEnabled = settings.defaultVibrationEnabled;
          _flashlightEnabled = settings.defaultFlashlightEnabled;
        });
      }
    });
  }

  Future<AlarmDraft?> _buildDraft() async {
    final destination = widget.destination;
    if (destination == null) {
      return null;
    }
    return AlarmDraft.fromSearchResult(
      destination.toSearchResult(),
      triggerDistanceMeters: _triggerDistanceMeters,
      voiceEnabled: _voiceEnabled,
      vibrationEnabled: _vibrationEnabled,
      flashlightEnabled: _flashlightEnabled,
    );
  }

  Future<void> _save({required bool start}) async {
    final draft = await _buildDraft();
    if (draft == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination first')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final alarm = await ref.read(alarmRepositoryProvider).create(draft);
      ref.invalidate(alarmsProvider);
      ref.invalidate(activeAlarmsProvider);

      if (start) {
        await ref.read(alarmServiceProvider).startAlarm(alarm.id);
        if (!mounted) {
          return;
        }
        context.go('/alarm/active/${alarm.id}');
        return;
      }

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alarm saved')),
      );
      context.go('/home');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Alarm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: destination == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No destination selected'),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.push('/search'),
                      child: const Text('Search destination'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.place),
                    title: Text(destination.name),
                    subtitle: destination.address != null
                        ? Text(destination.address!)
                        : Text(
                            '${destination.latitude.toStringAsFixed(5)}, '
                            '${destination.longitude.toStringAsFixed(5)}',
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Alert distance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  formatDistance(_triggerDistanceMeters),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Slider(
                  value: _triggerDistanceMeters,
                  min: AlarmConstants.minTriggerDistanceM,
                  max: AlarmConstants.maxTriggerDistanceM,
                  divisions: 49,
                  label: formatDistance(_triggerDistanceMeters),
                  onChanged: (value) {
                    setState(() => _triggerDistanceMeters = value);
                  },
                ),
                SwitchListTile(
                  title: const Text('Voice alert'),
                  subtitle: const Text('Spoken alert when triggered'),
                  value: _voiceEnabled,
                  onChanged: (v) => setState(() => _voiceEnabled = v),
                ),
                SwitchListTile(
                  title: const Text('Vibration'),
                  value: _vibrationEnabled,
                  onChanged: (v) => setState(() => _vibrationEnabled = v),
                ),
                SwitchListTile(
                  title: const Text('Flashlight'),
                  subtitle: const Text('LED strobe when alarm rings'),
                  value: _flashlightEnabled,
                  onChanged: (v) => setState(() => _flashlightEnabled = v),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : () => _save(start: true),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save & Start'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _saving ? null : () => _save(start: false),
                  child: const Text('Save only'),
                ),
              ],
            ),
    );
  }
}
