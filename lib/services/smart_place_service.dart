import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';
import 'package:nomad_alarm/core/utils/place_confidence_engine.dart';
import 'package:nomad_alarm/core/utils/smart_place_confirmation_buffer.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/models/favorite.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/repositories/favorite_repository.dart';
import 'package:nomad_alarm/services/alarm_service.dart';
import 'package:nomad_alarm/services/notification_service.dart';
import 'package:nomad_alarm/services/travel_detection_service.dart';

class SmartPlaceEvaluationSnapshot {
  SmartPlaceEvaluationSnapshot({
    required this.results,
    required this.leadingPlaceId,
    required this.confirmationTicks,
  });

  final List<PlaceConfidenceResult> results;
  final int? leadingPlaceId;
  final int confirmationTicks;
}

class SmartPlaceService {
  SmartPlaceService({
    required FavoriteRepository favoriteRepository,
    required AlarmRepository alarmRepository,
    required AlarmService alarmService,
    required NotificationService notificationService,
    required TravelDetectionService travelDetection,
  })  : _favoriteRepository = favoriteRepository,
        _alarmRepository = alarmRepository,
        _alarmService = alarmService,
        _notificationService = notificationService,
        _travelDetection = travelDetection;

  final FavoriteRepository _favoriteRepository;
  final AlarmRepository _alarmRepository;
  final AlarmService _alarmService;
  final NotificationService _notificationService;
  final TravelDetectionService _travelDetection;
  final PlaceConfidenceEngine _engine = PlaceConfidenceEngine();
  final Battery _battery = Battery();

  StreamSubscription<TravelSnapshot>? _subscription;
  bool _smartPlacesEnabled = true;

  final SmartPlaceConfirmationBuffer _confirmationBuffer =
      SmartPlaceConfirmationBuffer();
  SmartPlaceEvaluationSnapshot? _lastSnapshot;

  SmartPlaceEvaluationSnapshot? get lastSnapshot => _lastSnapshot;

  Future<void> setEnabled(bool enabled) async {
    _smartPlacesEnabled = enabled;
    if (enabled) {
      await start();
    } else {
      await stop();
    }
  }

  Future<void> start() async {
    if (_subscription != null) {
      return;
    }
    await _travelDetection.start();
    _subscription = _travelDetection.snapshots.listen(_onTravelSnapshot);
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    await _travelDetection.stop();
    _resetBuffer();
  }

  Future<void> dispose() async {
    await stop();
    await _travelDetection.dispose();
  }

  Future<void> handleSmartAlarmStop(int alarmId, int placeId) async {
    await _alarmService.cancelAlarm(alarmId);
    await _favoriteRepository.recordStopDismissed(placeId);
    _resetBuffer();
  }

  void _resetBuffer() {
    _confirmationBuffer.reset();
  }

  Future<void> _onTravelSnapshot(TravelSnapshot snapshot) async {
    if (!_smartPlacesEnabled || snapshot.isStill || snapshot.position == null) {
      _resetBuffer();
      return;
    }

    final places = await _favoriteRepository.getAll();
    final automatic = places
        .where((p) => p.smartAlarmMode == SmartAlarmMode.automatic)
        .toList();
    if (automatic.isEmpty) {
      return;
    }

    if (await _isBatterySaverOn()) {
      return;
    }

    final position = snapshot.position!;
    final results = PlaceConfidenceEngine.rankCandidates(
      places: automatic,
      inputFor: (place) {
        final distance = haversineMeters(
          position.latitude,
          position.longitude,
          place.latitude,
          place.longitude,
        );
        return PlaceConfidenceInput(
          place: place,
          currentLatitude: position.latitude,
          currentLongitude: position.longitude,
          currentHeadingDegrees: position.heading,
          distanceTraveledMeters: snapshot.distanceTraveledMeters,
          isInVehicle: snapshot.activity == TravelActivity.inVehicle,
          isMoving: snapshot.isMoving,
          insideDestination: distance <= place.triggerDistanceMeters,
          recentlyTriggered: _isOnCooldown(place),
        );
      },
    );

    final leading = results.isNotEmpty ? results.first : null;
    _lastSnapshot = SmartPlaceEvaluationSnapshot(
      results: results,
      leadingPlaceId: leading?.placeId,
      confirmationTicks: _confirmationBuffer.ticks,
    );

    if (leading == null || !leading.meetsThreshold) {
      _resetBuffer();
      return;
    }

    if (!_confirmationBuffer.recordLeadingPlace(leading.placeId)) {
      return;
    }

    final place = automatic.firstWhere((p) => p.id == leading.placeId);
    if (!await _passesHardGuardrails(place, position.latitude, position.longitude)) {
      _resetBuffer();
      return;
    }

    await _createAndStartAlarm(place);
    _resetBuffer();
  }

  bool _isOnCooldown(Favorite place) {
    final last = place.lastAutoCreatedAt;
    if (last == null) {
      return false;
    }
    return DateTime.now().difference(last) < const Duration(hours: 12);
  }

  Future<bool> _isBatterySaverOn() async {
    try {
      return await _battery.isInBatterySaveMode;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _passesHardGuardrails(
    Favorite place,
    double lat,
    double lng,
  ) async {
    if (_isOnCooldown(place)) {
      return false;
    }

    final dismissed = place.lastDismissedAt;
    if (dismissed != null &&
        DateTime.now().difference(dismissed) < const Duration(hours: 1)) {
      return false;
    }

    final distance = haversineMeters(lat, lng, place.latitude, place.longitude);
    if (distance <= place.triggerDistanceMeters) {
      return false;
    }

    final running = await _alarmRepository.getRunning();
    for (final alarm in running) {
      if (alarm.sourcePlaceId == place.id) {
        return false;
      }
      final sameDest = haversineMeters(
            lat,
            lng,
            alarm.destLatitude,
            alarm.destLongitude,
          ) <
          100;
      if (sameDest || alarm.name == place.name) {
        return false;
      }
    }

    return true;
  }

  Future<void> _createAndStartAlarm(Favorite place) async {
    final draft = AlarmDraft(
      name: place.name,
      destLatitude: place.latitude,
      destLongitude: place.longitude,
      address: place.address,
      placeId: place.providerPlaceId,
      triggerDistanceMeters: place.triggerDistanceMeters,
      sourcePlaceId: place.id,
      createdBy: AlarmCreatedBy.smart,
    );

    final alarm = await _alarmRepository.create(draft);
    await _alarmService.startAlarm(alarm.id);
    await _favoriteRepository.markAutoCreated(place.id);
    await _notificationService.showSmartAlarmStartedNotification(
      alarmId: alarm.id,
      placeId: place.id,
      placeName: place.name,
      triggerDistanceMeters: place.triggerDistanceMeters,
    );
  }
}
