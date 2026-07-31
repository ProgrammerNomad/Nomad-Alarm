import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/favorite_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/services/isar_service.dart';
import 'package:nomad_alarm/services/smart_place_service.dart';
import 'package:nomad_alarm/services/travel_detection_service.dart';

final travelDetectionServiceProvider = Provider<TravelDetectionService>((ref) {
  final service = TravelDetectionService();
  ref.onDispose(service.dispose);
  return service;
});

final smartPlaceServiceProvider = Provider<SmartPlaceService>((ref) {
  final service = SmartPlaceService(
    favoriteRepository: ref.watch(favoriteRepositoryProvider),
    alarmRepository: ref.watch(alarmRepositoryProvider),
    alarmService: ref.watch(alarmServiceProvider),
    notificationService: ref.watch(notificationServiceProvider),
    travelDetection: ref.watch(travelDetectionServiceProvider),
  );
  ref.onDispose(service.dispose);

  ref.read(notificationServiceProvider).onSmartAlarmAction =
      (action, alarmId, placeId) async {
    if (action == 'smart_stop') {
      await service.handleSmartAlarmStop(alarmId, placeId);
    }
  };

  return service;
});

final smartPlaceBootstrapProvider = FutureProvider<void>((ref) async {
  if (!FeatureFlags.smartPlaces) {
    return;
  }
  await ref.watch(isarServiceProvider.future);
  final settings = await ref.read(settingsControllerProvider.future);
  final smart = ref.read(smartPlaceServiceProvider);
  await smart.setEnabled(settings.smartPlacesEnabled);
});
