import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  Completer<void>? _speakCompleter;

  TTSService._internal() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-IN");
      await _flutterTts.setSpeechRate(0.6);
      await _flutterTts.setPitch(1.3);
      await _flutterTts.setVolume(1.0);       // Full clarity
      
      if (!kIsWeb) {
        // iOS/Android specific configurations can go here
        await _flutterTts.awaitSpeakCompletion(true);
      }
      
      _flutterTts.setCompletionHandler(() {
        if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
          _speakCompleter!.complete();
        }
      });
      
      _flutterTts.setErrorHandler((msg) {
        if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
          _speakCompleter!.complete();
        }
      });
    } catch (e) {
      debugPrint("TTS Initialization error: $e");
    }
  }

  Future<void> setLanguageConfig(String lang) async {
    try {
      if (lang == 'hindi') {
        await _flutterTts.setLanguage("hi-IN");
      } else {
        await _flutterTts.setLanguage("en-IN");
      }
    } catch (e) {
      debugPrint("TTS Set Language error: $e");
    }
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.stop(); // Stop any ongoing speech
      _speakCompleter = Completer<void>();
      await _flutterTts.speak(text);
      await _speakCompleter!.future; // Strictly wait for the handler
    } catch (e) {
      debugPrint("TTS Speech error: $e");
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
      _speakCompleter!.complete();
    }
  }
}
