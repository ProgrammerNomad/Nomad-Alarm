import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/repositories/alarm_repository.dart';

/// Route payload for alarm config with optional imported draft settings.
class AlarmConfigArgs {
  const AlarmConfigArgs({
    required this.destination,
    this.importedDraft,
  });

  final DestinationArgs destination;
  final AlarmDraft? importedDraft;
}
