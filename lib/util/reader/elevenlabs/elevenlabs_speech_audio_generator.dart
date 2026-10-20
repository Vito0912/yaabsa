import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_api.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_clip.dart';
import 'package:yaabsa/util/reader/reader_speech_audio.dart';
import 'package:yaabsa/util/reader/reader_speech_engine.dart';

class ElevenLabsSpeechAudioGenerator implements ReaderSpeechAudioGenerator {
  ElevenLabsSpeechAudioGenerator({required this.api, required this.readModel});

  final ElevenLabsSpeechApi api;
  final String Function() readModel;

  final List<({String id, DateTime created})> _previousIds = [];
  final Set<CancelToken> _requests = {};
  int _generation = 0;

  String? _previousText;
  (String, String, String, String)? _configuration;

  @override
  Future<ReaderSpeechAudio> generate(ReaderSpeechRequest request, File file) async {
    final generation = _generation;

    final key = await api.requireApiKey();

    if (generation != _generation) {
      throw const ElevenLabsSpeechException('Speech was cancelled');
    }

    final model = readModel();

    if (!isAllowedElevenLabsModel(model)) {
      throw const ElevenLabsSpeechException('Choose a v2 or v4 ElevenLabs model');
    }

    final configuration = (key, model, request.voice, request.language);

    if (_configuration != configuration || _previousText != request.previousText) {
      _previousIds.clear();
    }

    _configuration = configuration;
    _previousIds.removeWhere((entry) => DateTime.now().difference(entry.created) >= const Duration(hours: 2));

    final token = CancelToken();
    _requests.add(token);

    try {
      final response = await api.synthesize(
        request: request,
        apiKey: key,
        model: model,
        previousRequestIds: _previousIds.map((entry) => entry.id).toList(),
        cancelToken: token,
      );

      if (generation != _generation) {
        throw const ElevenLabsSpeechException('Speech was cancelled');
      }

      final clip = await ElevenLabsSpeechClip.fromResponse(response: response, text: request.text, file: file);

      if (generation != _generation) {
        throw const ElevenLabsSpeechException('Speech was cancelled');
      }

      _previousIds.add((id: clip.requestId, created: clip.createdAt));

      if (_previousIds.length > 3) {
        _previousIds.removeAt(0);
      }

      _previousText = request.text;

      return ReaderSpeechAudio(file: clip.file, timings: clip.timings);
    } finally {
      _requests.remove(token);
    }
  }

  @override
  Future<void> reset() async {
    _generation++;

    for (final request in _requests.toList()) {
      request.cancel();
    }

    _previousIds.clear();
    _previousText = null;
    _configuration = null;
  }
}
