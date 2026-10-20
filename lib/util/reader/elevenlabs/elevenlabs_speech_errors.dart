import 'package:dio/dio.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

class ElevenLabsSpeechException implements Exception {
  const ElevenLabsSpeechException(this.message);

  final String message;

  @override
  String toString() => message;
}

ElevenLabsSpeechException elevenLabsRequestException(DioException error, {required String permission}) {
  final data = error.response?.data;
  final detail = data is Map ? data['detail'] : null;
  final problem = detail is Map ? detail : data;
  final modernCode = problem is Map ? jsonStringFromDynamic(problem['code'])?.trim() : null;
  final legacyCode = problem is Map ? jsonStringFromDynamic(problem['status'])?.trim() : null;
  final type = problem is Map ? jsonStringFromDynamic(problem['type']) : null;
  final code = modernCode?.isNotEmpty == true ? modernCode : legacyCode;
  final status = error.response?.statusCode;

  String message;

  if (code == 'invalid_api_key' ||
      code == 'missing_api_key' ||
      code == 'expired_api_key' ||
      code == 'api_key_expired' ||
      code == 'invalid_authorization_header') {
    message = 'ElevenLabs rejected the API key. Check your key in Read aloud settings';
  } else if (const {
        'missing_permissions',
        'missing_permission',
        'insufficient_permissions',
        'insufficient_scope',
        'permission_denied',
      }.contains(code) ||
      type == 'authorization_error') {
    message = switch (permission) {
      'models_read' => 'This key cannot list models. Enable Models read permission or use the available model choices',
      'voices_read' => 'This key cannot list voices. Enable Voices read permission or enter a voice ID below',
      _ => 'Enable Text to speech permission for this ElevenLabs key',
    };
  } else {
    message = switch ((status, code)) {
      (_, 'quota_exceeded') => 'Your ElevenLabs account has no speech credits available',
      (_, 'payment_issue' || 'payment_required') ||
      (402, _) => 'Check your ElevenLabs billing and available speech credits',
      (_, 'voice_not_found' || 'model_not_found') || (404, _) => 'The selected ElevenLabs voice or model was not found',
      (_, 'max_character_limit_exceeded') => 'This text exceeds the selected ElevenLabs model character limit',
      (_, 'paid_plan_required' || 'subscription_required') =>
        'The selected ElevenLabs voice or model requires a different plan',
      (401, _) => 'ElevenLabs could not authorize this request. Check your API key and its permissions',
      (403, _) => 'Your ElevenLabs key or account does not allow this operation',
      (429, _) => 'ElevenLabs is busy or rate limited. Try again shortly',
      (400 || 422, _) => 'ElevenLabs rejected the speech settings. Check the model, language and voice ID',
      _ => 'Could not reach ElevenLabs. Check your connection and try again',
    };
  }

  return ElevenLabsSpeechException(message);
}
