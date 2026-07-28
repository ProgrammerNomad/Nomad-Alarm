import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:nomad_alarm/services/backup_service.dart';
import 'package:nomad_alarm/services/isar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract class BackupRepository {
  Future<String> exportBackup();
  Future<BackupImportResult> importBackup();
  Future<void> shareBackup(String jsonContent);
}

class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl(this._isarService);

  final IsarService _isarService;

  BackupService get _service => BackupService(_isarService.isar);

  @override
  Future<String> exportBackup() => _service.exportToJson();

  @override
  Future<BackupImportResult> importBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      throw const BackupCancelledException();
    }

    final file = result.files.first;
    final content = file.bytes != null
        ? String.fromCharCodes(file.bytes!)
        : file.path != null
            ? await File(file.path!).readAsString()
            : null;

    if (content == null) {
      throw const BackupException('Could not read backup file.');
    }

    return _service.importFromJson(content);
  }

  @override
  Future<void> shareBackup(String jsonContent) async {
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().toUtc().toIso8601String().split('T').first;
    final file = File('${dir.path}/nomad_alarm_backup_$timestamp.json');
    await file.writeAsString(jsonContent);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'Nomad Alarm backup',
    );
  }
}

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;
}

class BackupCancelledException implements Exception {
  const BackupCancelledException();
}
