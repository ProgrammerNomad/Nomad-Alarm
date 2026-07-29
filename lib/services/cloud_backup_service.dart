import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/services/backup_service.dart';

/// Optional upload of backup JSON to a user-provided HTTPS endpoint.
class CloudBackupService {
  CloudBackupService(this._backupService, {http.Client? client})
      : _client = client ?? http.Client(),
        _ownsClient = client == null;

  final BackupService _backupService;
  final http.Client _client;
  final bool _ownsClient;

  Future<bool> uploadToUrl(String uploadUrl) async {
    if (!FeatureFlags.cloudBackup) {
      return false;
    }
    final uri = Uri.tryParse(uploadUrl.trim());
    if (uri == null || uri.scheme != 'https') {
      return false;
    }
    final json = await _backupService.exportToMap();
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(json),
    );
    return response.statusCode >= 200 && response.statusCode < 300;
  }

  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
