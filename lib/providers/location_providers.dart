import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/services/isar_service.dart';
import 'package:nomad_alarm/services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(
    permissionService: ref.watch(permissionServiceProvider),
  );
});

/// Safe location fetch for UI - never throws; returns null when unavailable.
final currentPositionProvider = FutureProvider<Position?>((ref) async {
  await ref.watch(isarServiceProvider.future);
  final service = ref.watch(locationServiceProvider);
  return service.getCurrentPositionSafe();
});

final positionStreamProvider = StreamProvider<Position>((ref) async* {
  await ref.watch(isarServiceProvider.future);
  final service = ref.watch(locationServiceProvider);
  if (!await service.hasLocationPermission()) {
    return;
  }
  yield* service.watchPosition();
});
