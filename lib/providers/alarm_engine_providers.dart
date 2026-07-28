import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/models/alarm_runtime_state.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/location_providers.dart';
import 'package:nomad_alarm/services/alarm_service.dart';

final alarmServiceProvider = Provider<AlarmService>((ref) {
  final service = AlarmService(
    alarmRepository: ref.watch(alarmRepositoryProvider),
    locationService: ref.watch(locationServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final activeAlarmStateProvider =
    StreamProvider.family<AlarmRuntimeState, int>((ref, alarmId) {
  final alarmService = ref.watch(alarmServiceProvider);
  return alarmService.watchActiveAlarm(alarmId);
});

final monitoringAlarmIdProvider = Provider<int?>((ref) {
  return ref.watch(alarmServiceProvider).activeAlarmId;
});
