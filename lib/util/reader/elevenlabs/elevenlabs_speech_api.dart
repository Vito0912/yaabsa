import 'package:dio/dio.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/util/reader/reader_speech_engine.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_errors.dart';

export 'elevenlabs_speech_errors.dart' show ElevenLabsSpeechException;

class ElevenLabsSpeechModel {
  const ElevenLabsSpeechModel({required this.id, required this.name, this.languages = const {}});

  final String id;
  final String name;
  final Map<String, String> languages;

  bool get supportsLanguageCode => id != 'eleven_multilingual_v2';
}

bool isAllowedElevenLabsModel(String id) => RegExp(r'_v(?:2|4)(?:_|$)').hasMatch(id);

const defaultElevenLabsModels = [
  ElevenLabsSpeechModel(id: 'eleven_flash_v2_5', name: 'Flash v2.5'),
  ElevenLabsSpeechModel(id: 'eleven_multilingual_v2', name: 'Multilingual v2'),
  ElevenLabsSpeechModel(id: 'eleven_turbo_v2_5', name: 'Turbo v2.5'),
  ElevenLabsSpeechModel(id: 'eleven_v4', name: 'Eleven v4'),
];

class ElevenLabsSpeechApi {
  ElevenLabsSpeechApi({required this.readApiKey, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.elevenlabs.io',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 90),
              sendTimeout: const Duration(seconds: 30),
            ),
          );

  final Future<String?> Function() readApiKey;
  final Dio _dio;

  Future<String> requireApiKey() async {
    String key;

    try {
      key = (await readApiKey())?.trim() ?? '';
    } catch (_) {
      throw const ElevenLabsSpeechException('Could not access secure storage. Unlock your keyring and try again');
    }

    if (key.isEmpty) {
      throw const ElevenLabsSpeechException('Add your ElevenLabs API key in Read aloud settings');
    }

    return key;
  }

  Future<Response<dynamic>> _request(
    String path, {
    required String apiKey,
    required String permission,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.request<dynamic>(
        path,
        queryParameters: query,
        data: body,
        cancelToken: cancelToken,
        options: Options(
          method: body == null ? 'GET' : 'POST',
          responseType: ResponseType.json,
          headers: {'xi-api-key': apiKey},
          followRedirects: false,
        ),
      );
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        rethrow;
      }

      throw elevenLabsRequestException(error, permission: permission);
    }
  }

  Future<List<ElevenLabsSpeechModel>> models({CancelToken? cancelToken}) async {
    final key = await requireApiKey();
    final response = await _request('/v1/models', apiKey: key, permission: 'models_read', cancelToken: cancelToken);

    if (response.data is! List) {
      throw const ElevenLabsSpeechException('ElevenLabs returned an invalid model list');
    }

    return (response.data as List)
        .whereType<Map>()
        .where((value) {
          return jsonBoolRequiredFromDynamic(value['can_do_text_to_speech']) &&
              isAllowedElevenLabsModel(jsonStringFromDynamic(value['model_id']) ?? '');
        })
        .map((value) {
          final languages = value['languages'];

          return ElevenLabsSpeechModel(
            id: jsonStringFromDynamic(value['model_id'])!,
            name: jsonStringFromDynamic(value['name']) ?? jsonStringFromDynamic(value['model_id'])!,
            languages: {
              if (languages is List)
                for (final language in languages.whereType<Map>())
                  if (language['language_id'] != null)
                    jsonStringFromDynamic(language['language_id'])!:
                        jsonStringFromDynamic(language['name']) ?? jsonStringFromDynamic(language['language_id'])!,
            },
          );
        })
        .toList();
  }

  Future<List<Map<String, String>>> voices({CancelToken? cancelToken}) async {
    final key = await requireApiKey();

    final voices = <String, Map<String, String>>{};
    final seenTokens = <String>{};
    String? pageToken;

    do {
      final response = await _request(
        '/v2/voices',
        apiKey: key,
        permission: 'voices_read',
        query: {'page_size': 100, 'include_total_count': false, 'next_page_token': ?pageToken},
        cancelToken: cancelToken,
      );

      final data = response.data;

      if (data is! Map || data['voices'] is! List) {
        throw const ElevenLabsSpeechException('ElevenLabs returned an invalid voice list');
      }

      for (final voice in (data['voices'] as List).whereType<Map>()) {
        final id = jsonStringFromDynamic(voice['voice_id']);

        if (id == null || id.isEmpty) {
          continue;
        }

        voices[id] = {'id': id, 'name': jsonStringFromDynamic(voice['name']) ?? id, 'locale': ''};
      }

      if (!jsonBoolRequiredFromDynamic(data['has_more'])) {
        break;
      }

      pageToken = jsonStringFromDynamic(data['next_page_token']);

      if (pageToken == null || pageToken.isEmpty || !seenTokens.add(pageToken)) {
        throw const ElevenLabsSpeechException('ElevenLabs returned invalid voice pagination');
      }
    } while (true);

    return voices.values.toList();
  }

  Future<Response<dynamic>> synthesize({
    required ReaderSpeechRequest request,
    required String apiKey,
    required String model,
    required List<String> previousRequestIds,
    required CancelToken cancelToken,
  }) {
    if (!isAllowedElevenLabsModel(model)) {
      throw const ElevenLabsSpeechException('Choose a v2 or v4 ElevenLabs model');
    }
    if (request.voice.trim().isEmpty) {
      throw const ElevenLabsSpeechException('Choose an ElevenLabs voice or enter its voice ID in Read aloud settings');
    }

    final language = request.language.trim().replaceAll('_', '-').split('-').first.toLowerCase();

    if (language.isNotEmpty && !RegExp(r'^[a-z]{2,3}$').hasMatch(language)) {
      throw const ElevenLabsSpeechException('Enter a valid preferred language code in Read aloud settings');
    }

    return _request(
      '/v1/text-to-speech/${Uri.encodeComponent(request.voice.trim())}/with-timestamps',
      apiKey: apiKey,
      permission: 'text_to_speech',
      query: {'output_format': 'mp3_44100_128'},
      cancelToken: cancelToken,
      body: {
        'text': request.text,
        'model_id': model,
        if (language.isNotEmpty && model != 'eleven_multilingual_v2') 'language_code': language,
        if (previousRequestIds.isNotEmpty) 'previous_request_ids': previousRequestIds,
        if (previousRequestIds.isEmpty && request.previousText?.isNotEmpty == true)
          'previous_text': request.previousText,
        if (request.nextText?.isNotEmpty == true) 'next_text': request.nextText,
      },
    );
  }
}
