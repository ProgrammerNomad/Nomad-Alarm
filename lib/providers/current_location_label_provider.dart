import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nomad_alarm/providers/location_providers.dart';
import 'package:nomad_alarm/providers/search_providers.dart';

/// Human-readable address for the user's current GPS position.
final currentLocationLabelProvider = FutureProvider<String?>((ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  if (position == null) {
    return null;
  }
  final repo = await ref.watch(searchRepositoryProvider.future);
  final result = await repo.reverseGeocode(
    position.latitude,
    position.longitude,
  );
  return result?.displayAddress;
});
