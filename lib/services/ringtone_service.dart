import 'package:audioplayers/audioplayers.dart';

/// Plays optional custom ringtone URI on alarm trigger.
class RingtoneService {
  RingtoneService({AudioPlayer? player}) : _player = player;

  AudioPlayer? _player;

  AudioPlayer get _activePlayer => _player ??= AudioPlayer();

  Future<void> play(String? ringtoneUri) async {
    if (ringtoneUri == null || ringtoneUri.isEmpty) {
      return;
    }
    await _activePlayer.stop();
    if (ringtoneUri.startsWith('http')) {
      await _activePlayer.play(UrlSource(ringtoneUri));
    } else {
      await _activePlayer.play(DeviceFileSource(ringtoneUri));
    }
  }

  Future<void> stop() async {
    await _player?.stop();
  }

  void dispose() {
    _player?.dispose();
    _player = null;
  }
}
