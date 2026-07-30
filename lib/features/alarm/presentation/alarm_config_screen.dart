import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/constants/alarm_constants.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/l10n/l10n_extensions.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/group_travel_service.dart';

class AlarmConfigScreen extends ConsumerStatefulWidget {
  const AlarmConfigScreen({
    super.key,
    this.destination,
    this.importedDraft,
  });

  final DestinationArgs? destination;
  final AlarmDraft? importedDraft;
  @override
  ConsumerState<AlarmConfigScreen> createState() => _AlarmConfigScreenState();
}

class _AlarmConfigScreenState extends ConsumerState<AlarmConfigScreen> {
  late double _triggerDistanceMeters;
  late bool _voiceEnabled;
  late bool _vibrationEnabled;
  late bool _flashlightEnabled;
  AlarmType _alarmType = AlarmType.distance;
  TravelMode _travelMode = TravelMode.autoDetect;
  double? _speedThresholdKmh;
  String? _ringtoneUri;
  bool _saving = false;
  final _groupTravel = const GroupTravelService();

  @override
  void initState() {
    super.initState();
    _triggerDistanceMeters = AlarmConstants.defaultTriggerDistanceM;
    _voiceEnabled = true;
    _vibrationEnabled = true;
    _flashlightEnabled = false;
    final imported = widget.importedDraft;
    if (imported != null) {
      _triggerDistanceMeters = imported.triggerDistanceMeters;
      _alarmType = imported.type;
      _travelMode = imported.travelMode;
      _speedThresholdKmh = imported.speedThresholdKmh;
      _voiceEnabled = imported.voiceEnabled;
      _vibrationEnabled = imported.vibrationEnabled;
      _flashlightEnabled = imported.flashlightEnabled;
      _ringtoneUri = imported.ringtoneUri;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {      final settings = ref.read(settingsControllerProvider).valueOrNull;
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
    final result = destination.toSearchResult();
    return AlarmDraft(
      name: result.name,
      destLatitude: result.latitude,
      destLongitude: result.longitude,
      address: result.address,
      placeId: result.placeId,
      triggerDistanceMeters: _triggerDistanceMeters,
      type: _alarmType,
      travelMode: _travelMode,
      speedThresholdKmh: _speedThresholdKmh,
      voiceEnabled: _voiceEnabled,
      vibrationEnabled: _vibrationEnabled,
      flashlightEnabled: _flashlightEnabled,
      ringtoneUri: _ringtoneUri,
    );
  }

  Future<void> _pickRingtone() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    final path = result?.files.single.path;
    if (path == null) {
      return;
    }
    setState(() => _ringtoneUri = path);
  }

  Future<void> _shareConfig() async {
    final l10n = context.l10n;
    final draft = await _buildDraft();
    if (draft == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectDestinationFirst)),
      );
      return;
    }
    await _groupTravel.copyToClipboardFromDraft(draft);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.shareAlarmConfigSuccess)),
    );
  }
  Future<void> _save({required bool start}) async {
    final l10n = context.l10n;
    final draft = await _buildDraft();
    if (draft == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectDestinationFirst)),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.alarmCreatedSuccess)),
        );
        context.go('/home');
        return;
      }

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.alarmSaved)),
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
    final l10n = context.l10n;
    final destination = widget.destination;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createAlarmTitle),
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
                    Text(l10n.noDestinationSelected),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.push('/search'),
                      child: Text(l10n.searchDestination),
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
                  l10n.alarmTypeLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                DropdownButtonFormField<AlarmType>(
                  key: ValueKey(_alarmType),
                  initialValue: _alarmType,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: AlarmType.values
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(_alarmTypeLabel(l10n, t)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _alarmType = v);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.travelModeLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                DropdownButtonFormField<TravelMode>(
                  key: ValueKey(_travelMode),
                  initialValue: _travelMode,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: TravelMode.values
                      .map(
                        (m) => DropdownMenuItem(
                          value: m,
                          child: Text(_travelModeLabel(l10n, m)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => _travelMode = v);
                    }
                  },
                ),
                if (_alarmType == AlarmType.speed) ...[
                  const SizedBox(height: 16),
                  Text(l10n.speedThresholdLabel),
                  Slider(
                    value: _speedThresholdKmh ?? 30,
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: '${(_speedThresholdKmh ?? 30).round()} km/h',
                    onChanged: (v) => setState(() => _speedThresholdKmh = v),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  _alarmType == AlarmType.eta
                      ? l10n.etaTriggerMinutes
                      : l10n.alertDistance,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _alarmType == AlarmType.eta
                      ? '${_triggerDistanceMeters.round()} min'
                      : formatDistance(_triggerDistanceMeters),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Slider(
                  value: _triggerDistanceMeters,
                  min: _alarmType == AlarmType.eta
                      ? 1
                      : AlarmConstants.minTriggerDistanceM,
                  max: _alarmType == AlarmType.eta
                      ? 120
                      : AlarmConstants.maxTriggerDistanceM,
                  divisions: _alarmType == AlarmType.eta ? 119 : 49,
                  label: _alarmType == AlarmType.eta
                      ? '${_triggerDistanceMeters.round()} min'
                      : formatDistance(_triggerDistanceMeters),
                  onChanged: (value) {
                    setState(() => _triggerDistanceMeters = value);
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.voiceAlert),
                  subtitle: Text(l10n.voiceAlertSubtitle),
                  value: _voiceEnabled,
                  onChanged: (v) => setState(() => _voiceEnabled = v),
                ),
                SwitchListTile(
                  title: Text(l10n.vibration),
                  value: _vibrationEnabled,
                  onChanged: (v) => setState(() => _vibrationEnabled = v),
                ),
                SwitchListTile(
                  title: Text(l10n.flashlight),
                  subtitle: Text(l10n.flashlightSubtitle),
                  value: _flashlightEnabled,
                  onChanged: (v) => setState(() => _flashlightEnabled = v),
                ),
                ListTile(
                  title: Text(l10n.customRingtone),
                  subtitle: Text(
                    _ringtoneUri != null
                        ? _ringtoneUri!.split(RegExp(r'[/\\]')).last
                        : l10n.pickRingtone,
                  ),
                  trailing: _ringtoneUri != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _ringtoneUri = null),
                        )
                      : null,
                  onTap: _pickRingtone,
                ),
                if (FeatureFlags.groupTravel) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _shareConfig,
                    icon: const Icon(Icons.share_outlined),
                    label: Text(l10n.shareAlarmConfig),
                  ),
                ],
                const SizedBox(height: 24),                FilledButton(
                  onPressed: _saving ? null : () => _save(start: true),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.saveAndStart),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _saving ? null : () => _save(start: false),
                  child: Text(l10n.saveOnly),
                ),
              ],
            ),
    );
  }

  String _alarmTypeLabel(dynamic l10n, AlarmType type) {
    return switch (type) {
      AlarmType.distance => l10n.alarmTypeDistance,
      AlarmType.arrival => l10n.alarmTypeArrival,
      AlarmType.departure => l10n.alarmTypeDeparture,
      AlarmType.radius => l10n.alarmTypeRadius,
      AlarmType.eta => l10n.alarmTypeEta,
      AlarmType.speed => l10n.alarmTypeSpeed,
      AlarmType.geofence => l10n.alarmTypeGeofence,
    };
  }

  String _travelModeLabel(dynamic l10n, TravelMode mode) {
    return switch (mode) {
      TravelMode.train => l10n.travelModeTrain,
      TravelMode.bus => l10n.travelModeBus,
      TravelMode.metro => l10n.travelModeMetro,
      TravelMode.car => l10n.travelModeCar,
      TravelMode.walking => l10n.travelModeWalking,
      TravelMode.cycling => l10n.travelModeCycling,
      TravelMode.autoDetect => l10n.travelModeAuto,
    };
  }
}
