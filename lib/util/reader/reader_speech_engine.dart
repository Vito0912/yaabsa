import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show WidgetBuilder;
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yaabsa/util/reader/reader_speech_audio.dart';

typedef ReaderSpeechProgress = void Function(int start, int end);
typedef ReaderSpeechEngineFactory = ReaderSpeechEngine Function();

class ReaderSpeechRequest {
  const ReaderSpeechRequest({
    required this.text,
    required this.language,
    required this.voice,
    required this.rate,
    this.previousText,
    this.nextText,
    this.nextNextText,
    this.onProgress,
  });

  final String text;
  final String language;
  final String voice;
  final double rate;
  final String? previousText;
  final String? nextText;
  final String? nextNextText;
  final ReaderSpeechProgress? onProgress;
}

abstract interface class ReaderSpeechEngine {
  Future<void> speak(ReaderSpeechRequest request);
  Future<void> stop();
  Future<void> dispose();
  Future<List<String>> languages();
  Future<List<Map<String, String>>> voices();
}

abstract interface class ReaderSpeechVolumeControl {
  Future<void> setVolume(double volume);
}

class ReaderSpeechEngineRegistration {
  const ReaderSpeechEngineRegistration({
    required this.id,
    required this.label,
    required this.create,
    this.settingsBuilder,
    this.showStandardVoiceSettings = true,
    this.voiceSettingKey = SettingKeys.readerTtsVoice,
    this.languageSettingKey = SettingKeys.readerTtsLanguage,
    this.playbackSettingKeys = const [],
    this.createAudioGenerator,
  });

  final String id;
  final String label;
  final ReaderSpeechEngineFactory create;
  final WidgetBuilder? settingsBuilder;
  final bool showStandardVoiceSettings;
  final String voiceSettingKey;
  final String languageSettingKey;
  final List<String> playbackSettingKeys;
  final ReaderSpeechAudioGenerator Function()? createAudioGenerator;
}

class ReaderSpeechEngines {
  static final _engines = <String, ReaderSpeechEngineRegistration>{
    'system': ReaderSpeechEngineRegistration(
      id: 'system',
      label: 'Device voices',
      create: SystemReaderSpeechEngine.new,
    ),
  };

  static final _instances = <String, ReaderSpeechEngine>{};

  static List<ReaderSpeechEngineRegistration> get available => List.unmodifiable(_engines.values);

  static void register(ReaderSpeechEngineRegistration engine) {
    if (engine.id.isEmpty || engine.id == 'system') {
      throw ArgumentError.value(engine.id, 'id');
    }

    _engines[engine.id] = engine;
  }

  static ReaderSpeechEngineRegistration registration(String id) {
    final engine = _engines[id];

    if (engine == null) {
      throw StateError('The selected speech provider is unavailable');
    }

    return engine;
  }

  static ReaderSpeechEngine create(String id) {
    final engine = registration(id);

    return _instances.putIfAbsent(id, engine.create);
  }
}

class SystemReaderSpeechEngine implements ReaderSpeechEngine, ReaderSpeechVolumeControl {
  final FlutterTts _tts = FlutterTts();
  Future<void>? _initialization;
  Completer<void>? _cancellation;
  ReaderSpeechRequest? _activeRequest;
  (String, String, double)? _configuration;
  int _generation = 0;
  final Map<String, String> _voiceLocales = {};

  Future<void> _initialize() => _initialization ??= _initializePlatform();

  Future<void> _initializePlatform() async {
    await _tts.awaitSpeakCompletion(true);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      ], IosTextToSpeechAudioMode.defaultMode);
    }

    _tts.setProgressHandler((text, start, end, word) {
      final request = _activeRequest;

      if (request?.text == text) {
        request?.onProgress?.call(start, end);
      }
    });
  }

  @override
  Future<void> speak(ReaderSpeechRequest request) async {
    final generation = _generation;

    await _initialize();

    if (generation != _generation) {
      return;
    }

    final configuration = (request.language, request.voice, request.rate);

    if (_configuration != configuration) {
      await _tts.setLanguage(request.language);

      if (generation != _generation) {
        return;
      }

      await _tts.setSpeechRate((request.rate * 0.5).clamp(0.05, 1.0));

      if (generation != _generation) {
        return;
      }

      if (request.voice.isNotEmpty) {
        if (!_voiceLocales.containsKey(request.voice)) {
          try {
            await voices();
          } catch (_) {}
        }

        if (generation != _generation) {
          return;
        }

        await _tts.setVoice({'name': request.voice, 'locale': _voiceLocales[request.voice] ?? request.language});
      }

      if (generation != _generation) {
        return;
      }

      _configuration = configuration;
    }

    if (generation != _generation) {
      return;
    }

    final cancellation = Completer<void>();

    _cancellation = cancellation;
    _activeRequest = request;

    try {
      await Future.any<void>([
        _tts.speak(request.text).then((result) {
          if (result == 0) {
            throw StateError('The device could not start speech');
          }
        }),
        cancellation.future,
      ]);
    } finally {
      if (identical(_cancellation, cancellation)) {
        _activeRequest = null;
        _cancellation = null;
      }
    }
  }

  @override
  Future<void> stop() async {
    _generation++;
    _activeRequest = null;

    final cancellation = _cancellation;

    _cancellation = null;

    if (cancellation != null && !cancellation.isCompleted) {
      cancellation.complete();
    }

    await _tts.stop();
  }

  @override
  Future<void> dispose() => stop();

  @override
  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume.clamp(0.0, 1.0));
  }

  @override
  Future<List<String>> languages() async {
    final values = await _tts.getLanguages;

    return values is List ? values.map((value) => value.toString()).toSet().toList() : const [];
  }

  @override
  Future<List<Map<String, String>>> voices() async {
    final values = await _tts.getVoices;

    if (values is! List) {
      return const [];
    }

    final voices = values
        .whereType<Map>()
        .where((voice) => voice['name'] != null && voice['locale'] != null)
        .map((voice) => {'name': voice['name'].toString(), 'locale': voice['locale'].toString()})
        .toList();

    _voiceLocales.addEntries(voices.map((voice) => MapEntry(voice['name']!, voice['locale']!)));

    return voices;
  }
}
