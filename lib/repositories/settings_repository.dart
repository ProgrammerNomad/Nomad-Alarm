import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/services/settings_service.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Stream<AppSettings> watchSettings();
  Future<void> updateSettings(AppSettings settings);
}

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._settingsService);

  final SettingsService _settingsService;

  @override
  Future<AppSettings> getSettings() => _settingsService.getSettings();

  @override
  Stream<AppSettings> watchSettings() => _settingsService.watchSettings();

  @override
  Future<void> updateSettings(AppSettings settings) =>
      _settingsService.updateSettings(settings);
}
