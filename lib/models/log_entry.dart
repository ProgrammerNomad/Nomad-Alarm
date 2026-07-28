import 'package:isar/isar.dart';
import 'package:nomad_alarm/models/enums.dart';

part 'log_entry.g.dart';

@collection
class LogEntry {
  Id id = Isar.autoIncrement;

  late DateTime timestamp;

  @enumerated
  late LogLevel level;

  late String tag;
  late String message;
}
