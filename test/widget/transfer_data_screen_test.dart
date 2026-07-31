import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nomad_alarm/features/settings/presentation/transfer_data_screen.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/providers/app_providers.dart';
import 'package:nomad_alarm/providers/settings_providers.dart';
import 'package:nomad_alarm/repositories/backup_repository.dart';
import 'package:nomad_alarm/l10n/app_localizations.dart';
import '../helpers/l10n_test_helper.dart';

class _TrackingSettingsController extends SettingsController {
  _TrackingSettingsController([AppSettings? initial])
      : _settings = initial ?? AppSettings.defaults();

  AppSettings _settings;
  int saveCount = 0;

  @override
  Future<AppSettings> build() async => _settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    saveCount++;
    state = AsyncData(settings);
  }
}

class _MockBackupRepository extends Mock implements BackupRepository {}

void main() {
  late _MockBackupRepository backupRepository;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    backupRepository = _MockBackupRepository();
    when(() => backupRepository.exportBackup())
        .thenAnswer((_) async => '{"version":1}');
    when(() => backupRepository.shareBackup(any())).thenAnswer((_) async {});
  });

  Widget buildApp({
    AppSettings? initial,
    _TrackingSettingsController? controller,
  }) {
    final settingsController =
        controller ?? _TrackingSettingsController(initial);
    return ProviderScope(
      overrides: [
        settingsControllerProvider.overrideWith(() => settingsController),
        backupRepositoryProvider.overrideWithValue(backupRepository),
      ],
      child: buildL10nTestApp(
        Navigator(
          onGenerateRoute: (settings) => MaterialPageRoute<void>(
            builder: (context) => const TransferDataScreen(),
          ),
        ),
      ),
    );
  }

  testWidgets('Transfer Data screen shows backup actions and metadata',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Transfer Data'), findsOneWidget);
    expect(find.text('Manage your backups and transfer your data.'),
        findsOneWidget);
    expect(find.text('Export backup'), findsOneWidget);
    expect(find.text('Import backup'), findsOneWidget);
    expect(find.text('Auto Backup'), findsOneWidget);
    expect(find.text('Last Backup'), findsOneWidget);
    expect(find.text('Never'), findsOneWidget);
  });

  testWidgets('Export backup updates lastBackupAt', (tester) async {
    final controller = _TrackingSettingsController();
    await tester.pumpWidget(buildApp(controller: controller));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Export backup'));
    await tester.pumpAndSettle();

    verify(() => backupRepository.exportBackup()).called(1);
    verify(() => backupRepository.shareBackup(any())).called(1);
    expect(controller.saveCount, 1);
    expect(controller.state.valueOrNull?.lastBackupAt, isNotNull);
  });

  testWidgets('Back navigation pops the screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsControllerProvider.overrideWith(
            () => _TrackingSettingsController(),
          ),
          backupRepositoryProvider.overrideWithValue(backupRepository),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const TransferDataScreen(),
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Transfer Data'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
    expect(find.text('Transfer Data'), findsNothing);
  });
}
