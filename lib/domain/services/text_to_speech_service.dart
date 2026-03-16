import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';

/// Service for Text-to-Speech functionality
class TextToSpeechService extends GetxService {
  late FlutterTts _flutterTts;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize TTS service
  Future<TextToSpeechService> init() async {
    _flutterTts = FlutterTts();

    try {
      // Configure TTS for children-friendly speech
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(AppConstants.speechRate);
      await _flutterTts.setPitch(AppConstants.speechPitch);
      await _flutterTts.setVolume(AppConstants.speechVolume);

      // Set voice (try to use a child-friendly voice if available)
      final voices = await _flutterTts.getVoices;
      if (voices != null && voices.isNotEmpty) {
        // Try to find a female voice which is often more child-friendly
        dynamic femaleVoice;
        try {
          femaleVoice = voices.firstWhere(
            (voice) => voice['name'].toString().toLowerCase().contains('female'),
          );
        } catch (e) {
          // No female voice found, use default
          femaleVoice = null;
        }
        
        if (femaleVoice != null) {
          await _flutterTts.setVoice({
            "name": femaleVoice['name'],
            "locale": femaleVoice['locale'],
          });
        }
      }

      _isInitialized = true;
      print('✅ Text-to-Speech initialized successfully');
    } catch (e) {
      print('❌ Error initializing TTS: $e');
      _isInitialized = false;
    }

    return this;
  }

  /// Speak the given text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      print('TTS not initialized');
      return;
    }

    try {
      // Stop any ongoing speech
      await stop();

      // Speak the text
      await _flutterTts.speak(text);
      print('🔊 Speaking: $text');
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.stop();
    } catch (e) {
      print('Error stopping TTS: $e');
    }
  }

  /// Pause speaking
  Future<void> pause() async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.pause();
    } catch (e) {
      print('Error pausing TTS: $e');
    }
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      print('Error setting speech rate: $e');
    }
  }

  /// Set pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    if (!_isInitialized) return;

    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      print('Error setting pitch: $e');
    }
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
