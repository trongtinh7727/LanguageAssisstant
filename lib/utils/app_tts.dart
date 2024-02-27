import 'package:flutter_tts/flutter_tts.dart';

class AppTTS {
  static final FlutterTts _flutterTts = FlutterTts();

  static Future<void> setLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }

  static Future<void> setSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  static Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }

  static Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }

  static Future<void> speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(text);
  }

  static Future<void> pause() async {
    await _flutterTts.pause();
  }

  static Future<void> stop() async {
    await _flutterTts.stop();
  }
}
