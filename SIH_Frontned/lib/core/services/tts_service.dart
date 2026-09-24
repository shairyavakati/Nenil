import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  FlutterTts? _flutterTts;
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setSpeechRate(0.45); // Calm, gentle cadence for seniors
      await _flutterTts?.setPitch(1.0);
      await _flutterTts?.setLanguage('en-US');

      _flutterTts?.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts?.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts?.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('TTS Error: $msg');
      });
    } catch (e) {
      debugPrint('TTS init failed: $e');
    }
  }

  Future<void> speak(String text) async {
    if (_isSpeaking) {
      await stop();
      return;
    }
    try {
      if (_flutterTts == null) await init();
      _isSpeaking = true;
      await _flutterTts?.speak(text);
    } catch (e) {
      _isSpeaking = false;
      debugPrint('TTS speak failed: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
    } catch (e) {
      debugPrint('TTS stop failed: $e');
    } finally {
      _isSpeaking = false;
    }
  }
}
