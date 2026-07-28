# Repository Layer

The repository layer sits between **controllers** and **services/infrastructure**. It is the single data access boundary for each domain area.

See [Architecture](ARCHITECTURE.md) for the full layer diagram.

---

## Why Repositories?

| Benefit | Description |
|---------|-------------|
| **Testability** | Mock `AlarmRepository` in controller tests - no GPS or Isar needed |
| **Swappable implementations** | Swap local-only for cloud-sync later without touching UI |
| **Cohesive operations** | `createAndStart()` combines DB write + service start atomically |
| **Thin controllers** | Controllers orchestrate UI state; repositories handle data |

---

## Layer Rules

```
✅ Controller → Repository → Service → Platform/DB
❌ Controller → Service (direct)
❌ Controller → Isar (direct)
❌ Repository → Widget (never)
```

---

## Repository Catalog

| Repository | File | Responsibilities |
|------------|------|------------------|
| `AlarmRepository` | `alarm_repository.dart` | Alarm CRUD, start/stop/pause, active alarm stream |
| `TripRepository` | `trip_repository.dart` | Trip logging, list, detail |
| `SearchRepository` | `search_repository.dart` | Search, recent, reverse geocode |
| `FavoriteRepository` | `favorite_repository.dart` | Favorites CRUD, reorder |
| `HistoryRepository` | `history_repository.dart` | History queries, delete |
| `SettingsRepository` | `settings_repository.dart` | App settings read/write |
| `BackupRepository` | `backup_repository.dart` | Export/import JSON |

---

## AlarmRepository (Primary)

```dart
abstract class AlarmRepository {
  // CRUD
  Future<Alarm> create(AlarmDraft draft);
  Future<Alarm> update(Alarm alarm);
  Future<void> delete(int id);
  Future<Alarm?> getById(int id);
  Future<List<Alarm>> getAll();
  Future<Alarm?> getActiveAlarm();

  // Lifecycle
  Future<Alarm> createAndStart(AlarmDraft draft);
  Future<void> start(int id);
  Future<void> pause(int id);
  Future<void> resume(int id);
  Future<void> cancel(int id, {String? reason});
  Future<void> dismiss(int id);
  Future<void> snooze(int id, Duration duration);

  // Runtime
  Stream<AlarmRuntimeState> watchActiveAlarm(int id);
  Stream<AlarmRuntimeState?> watchCurrentActiveAlarm();
  Future<void> onPositionUpdate(Position position);

  // Queries
  Future<List<Alarm>> getByStatus(AlarmStatus status);
}
```

### Implementation delegates to:

| Operation | Delegates to |
|-----------|--------------|
| Persist alarm | `AlarmService` → Isar |
| Start monitoring | `AlarmService` + `LocationService` |
| Notifications | `NotificationService` |
| Trigger evaluation | `AlarmService.evaluate()` |
| Log history | `HistoryRepository` (on complete/miss) |
| Log events | `EventLogger` |

---

## SearchRepository

```dart
abstract class SearchRepository {
  Future<List<SearchResult>> search(String query, {GeoBias? bias});
  Future<SearchResult?> reverseGeocode(double lat, double lng);
  Future<List<RecentSearch>> getRecent();
  Future<void> saveRecent(SearchResult result);
  Future<void> clearRecent();
}
```

Delegates to `SearchProvider` (Nominatim default) + Isar for cache.

---

## TripRepository

```dart
abstract class TripRepository {
  Future<Trip> startTrip(int alarmId);
  Future<Trip> endTrip(int tripId, TripOutcome outcome);
  Future<List<Trip>> getAll({int? limit, int? offset});
  Future<Trip?> getById(int id);
  Future<Trip?> getActiveTrip();
}
```

---

## SettingsRepository

```dart
abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Stream<AppSettings> watchSettings();
  Future<void> updateSettings(AppSettings settings);
  Future<void> updateField<T>(String key, T value);
}
```

Delegates to `SettingsService` → Isar singleton.

---

## Riverpod Registration

```dart
// repositories
final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepositoryImpl(
    alarmService: ref.watch(alarmServiceProvider),
    locationService: ref.watch(locationServiceProvider),
    notificationService: ref.watch(notificationServiceProvider),
    historyRepository: ref.watch(historyRepositoryProvider),
    eventLogger: ref.watch(eventLoggerProvider),
  );
});

// controllers depend on repository
final alarmControllerProvider =
    NotifierProvider<AlarmController, AlarmUiState>(
  () => AlarmController(),
);

class AlarmController extends Notifier<AlarmUiState> {
  AlarmRepository get _repo => ref.read(alarmRepositoryProvider);

  Future<void> createAndStart(AlarmDraft draft) async {
    state = const AlarmUiState.loading();
    try {
      final alarm = await _repo.createAndStart(draft);
      state = AlarmUiState.ready(AlarmData.from(alarm));
    } on AppException catch (e) {
      state = AlarmUiState.error(e);
    }
  }
}
```

---

## Testing with Mocks

```dart
class MockAlarmRepository extends Mock implements AlarmRepository {}

test('createAndStart shows ready state', () async {
  when(() => mockRepo.createAndStart(any()))
      .thenAnswer((_) async => fakeAlarm);

  await controller.createAndStart(draft);

  expect(controller.state, isA<AlarmUiStateReady>());
});
```

---

## Future: Cloud Sync (v3.0)

Repository interface stays the same; add `SyncAlarmRepository` decorator:

```dart
class SyncAlarmRepository implements AlarmRepository {
  final AlarmRepository local;
  final CloudSyncService sync; // optional, user opt-in

  @override
  Future<Alarm> create(AlarmDraft draft) async {
    final alarm = await local.create(draft);
    if (sync.isEnabled) await sync.pushAlarm(alarm);
    return alarm;
  }
}
```

UI and controllers unchanged.

---

## Related Docs

* [Architecture](ARCHITECTURE.md)
* [Services](SERVICES.md)
* [Database](DATABASE.md)
* [Testing](TESTING.md)
* [Diagrams](DIAGRAMS.md)
