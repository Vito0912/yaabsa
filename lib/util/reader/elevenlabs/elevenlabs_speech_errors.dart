import 'package:dio/dio.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/util/l10n.dart';

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
  final l10n = currentAppLocalizations();

  if (code == 'invalid_api_key' ||
      code == 'missing_api_key' ||
      code == 'expired_api_key' ||
      code == 'api_key_expired' ||
      code == 'invalid_authorization_header') {
    message = l10n.errorElevenLabsApiKeyRejected;
  } else if (const {
        'missing_permissions',
        'missing_permission',
        'insufficient_permissions',
        'insufficient_scope',
        'permission_denied',
      }.contains(code) ||
      type == 'authorization_error') {
    message = switch (permission) {
      'models_read' => l10n.errorElevenLabsModelsReadPermission,
      'voices_read' => l10n.errorElevenLabsVoicesReadPermission,
      _ => l10n.errorElevenLabsSpeechPermission,
    };
  } else {
    message = switch ((status, code)) {
      (_, 'quota_exceeded') => l10n.errorElevenLabsNoCredits,
      (_, 'payment_issue' || 'payment_required') || (402, _) => l10n.errorElevenLabsBillingIssue,
      (_, 'voice_not_found' || 'model_not_found') || (404, _) => l10n.errorElevenLabsVoiceOrModelNotFound,
      (_, 'max_character_limit_exceeded') => l10n.errorElevenLabsCharacterLimit,
      (_, 'paid_plan_required' || 'subscription_required') => l10n.errorElevenLabsPlanRequired,
      (401, _) => l10n.errorElevenLabsUnauthorized,
      (403, _) => l10n.errorElevenLabsNotAllowed,
      (429, _) => l10n.errorElevenLabsRateLimited,
      (400 || 422, _) => l10n.errorElevenLabsSpeechSettingsRejected,
      _ => l10n.errorElevenLabsUnavailable,
    };
  }

  return ElevenLabsSpeechException(message);
}
