import 'package:flutter_tts/flutter_tts.dart';
import 'package:nomad_alarm/core/utils/distance_utils.dart';

class SpeechService {
  SpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;
  bool _initialized = false;

  Future<void> initialize({String languageCode = 'en'}) async {
    if (_initialized) {
      return;
    }
    await _tts.setLanguage(_mapLanguage(languageCode));
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1);
    _initialized = true;
  }

  Future<void> speakApproaching({
    required String destinationName,
    required double distanceMeters,
    String languageCode = 'en',
  }) async {
    await initialize(languageCode: languageCode);
    final distance = formatDistance(distanceMeters);
    final message = languageCode.startsWith('hi')
        ? 'आपका स्टॉप नज़दीक है। $destinationName $distance दूर है।'
        : 'Your stop is approaching. $destinationName in $distance.';
    await _tts.stop();
    await _tts.speak(message);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  String _mapLanguage(String code) {
    return switch (code) {
      'hi' => 'hi-IN',
      'es' => 'es-ES',
      'fr' => 'fr-FR',
      'de' => 'de-DE',
      _ => 'en-US',
    };
  }
}
