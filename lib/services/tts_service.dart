import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();

  TTSService._internal() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-IN");
      await _flutterTts.setSpeechRate(0.6);
      await _flutterTts.setPitch(1.3);        // Higher pitch = more feminine tone
      await _flutterTts.setVolume(1.0);       // Full clarity
      
      if (!kIsWeb) {
        // iOS/Android specific configurations can go here
        await _flutterTts.awaitSpeakCompletion(true);
      }
    } catch (e) {
      debugPrint("TTS Initialization error: $e");
    }
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.stop(); // Stop any ongoing speech
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Speech error: $e");
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
