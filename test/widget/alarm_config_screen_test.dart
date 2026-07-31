import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/features/alarm/presentation/alarm_config_screen.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';
import 'package:nomad_alarm/models/alarm.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/alarm_engine_providers.dart';
import 'package:nomad_alarm/providers/alarm_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';
import 'package:nomad_alarm/services/alarm_service.dart';

class MockAlarmRepository extends Mock implements AlarmRepository {}

class MockAlarmService extends Mock implements AlarmService {}

class _FixedSettingsController extends SettingsController {
  @override
  Future<AppSettings> build() async => AppSettings.defaults();
}

Alarm _createdDraft() {
  return Alarm()
    ..id = 1
    ..name = 'Test Stop'
    ..destLatitude = 51.5074
    ..destLongitude = -0.1278
    ..type = AlarmType.distance
    ..triggerDistanceMeters = 500
    ..travelMode = TravelMode.train
    ..repeat = false
    ..voiceEnabled = true
    ..vibrationEnabled = true
    ..flashlightEnabled = false
    ..status = AlarmStatus.draft
    ..createdAt = DateTime.utc(2024, 1, 1)
    ..updatedAt = DateTime.utc(2024, 1, 1);
}

void main() {
  late MockAlarmRepository alarmRepository;
  late MockAlarmService alarmService;

  setUpAll(() {
    registerFallbackValue(
      AlarmDraft(
        name: 'Test Stop',
        destLatitude: 51.5074,
        destLongitude: -0.1278,
      ),
    );
  });

  setUp(() {
    alarmRepository = MockAlarmRepository();
    alarmService = MockAlarmService();
    when(() => alarmRepository.create(any())).thenAnswer((_) async {
      return _createdDraft();
    });
    when(() => alarmService.startAlarm(any())).thenAnswer((_) async {});
  });

  Widget buildRouterApp(GoRouter router) {
    return ProviderScope(
      overrides: [
        alarmRepositoryProvider.overrideWith((ref) => alarmRepository),
        alarmServiceProvider.overrideWith((ref) => alarmService),
        settingsControllerProvider.overrideWith(_FixedSettingsController.new),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  GoRouter buildTestRouter() {
    return GoRouter(
      initialLocation: '/config',
      routes: [
        GoRoute(
          path: '/config',
          builder: (context, state) => const AlarmConfigScreen(
            destination: DestinationArgs(
              name: 'Test Stop',
              latitude: 51.5074,
              longitude: -0.1278,
            ),
          ),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) =>
              const Scaffold(body: Text('History destination')),
        ),
        GoRoute(
          path: '/alarms',
          builder: (context, state) =>
              const Scaffold(body: Text('Alarms destination')),
        ),
      ],
    );
  }

  testWidgets('Alarm config shows destination required when empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsControllerProvider.overrideWith(_FixedSettingsController.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AlarmConfigScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No destination selected'), findsOneWidget);
    expect(find.text('Search destination'), findsOneWidget);
  });

  testWidgets('Save only navigates to history', (tester) async {
    await tester.pumpWidget(buildRouterApp(buildTestRouter()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Save only'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save only'));
    await tester.pumpAndSettle();

    expect(find.text('History destination'), findsOneWidget);
    verifyNever(() => alarmService.startAlarm(any()));
  });

  testWidgets('Save & Start navigates to alarms', (tester) async {
    await tester.pumpWidget(buildRouterApp(buildTestRouter()));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Save & Start'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save & Start'));
    await tester.pumpAndSettle();

    expect(find.text('Alarms destination'), findsOneWidget);
    verify(() => alarmService.startAlarm(1)).called(1);
  });
}
