import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/isar_service.dart';

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepositoryImpl(ref.watch(isarProvider));
});

final alarmsProvider = FutureProvider<List<Alarm>>((ref) async {
  await ref.watch(isarServiceProvider.future);
  return ref.watch(alarmRepositoryProvider).getAll();
});

final activeAlarmsProvider = FutureProvider<List<Alarm>>((ref) async {
  await ref.watch(isarServiceProvider.future);
  return ref.watch(alarmRepositoryProvider).getRunning();
});

final draftAlarmsProvider = FutureProvider<List<Alarm>>((ref) async {
  await ref.watch(isarServiceProvider.future);
  final drafts = await ref.watch(alarmRepositoryProvider).getDrafts();
  drafts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return drafts;
});
