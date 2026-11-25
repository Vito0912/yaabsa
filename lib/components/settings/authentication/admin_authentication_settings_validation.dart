import 'package:yaabsa/util/l10n.dart';

class AdminAuthenticationSettingsValidation {
  static final RegExp _redirectUriPattern = RegExp(r'^\w+://[\w\.-]+(/[\w\./-]*)*$', caseSensitive: false);
  static final RegExp _claimPattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9_-]*$', caseSensitive: false);

  static String? normalizeNullable(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String normalizeIssuerUrlForLookup(String value) {
    var normalized = value.trim();
    if (normalized.endsWith('/.well-known/openid-configuration')) {
      normalized = normalized.replaceAll('/.well-known/openid-configuration', '');
    }
    if (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  static List<String> normalizeRedirectUris(List<String> values) {
    final normalized = <String>[];
    final seen = <String>{};
    for (final value in values) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || seen.contains(trimmed)) {
        continue;
      }
      seen.add(trimmed);
      normalized.add(trimmed);
    }
    return normalized;
  }

  static String? validateRequired(String value, {required String label, required AppLocalizations localizations}) {
    if (value.trim().isEmpty) {
      return localizations.validationFieldRequired(label);
    }
    return null;
  }

  static String? validateRedirectUris(List<String> values, {required AppLocalizations localizations}) {
    final uris = normalizeRedirectUris(values);
    if (uris.contains('*') && uris.length > 1) {
      return localizations.validationWildcardMustBeOnlyRedirectUri;
    }

    for (final uri in uris) {
      if (uri == '*') {
        continue;
      }
      if (!_redirectUriPattern.hasMatch(uri)) {
        return localizations.validationMobileRedirectUriInvalid(uri);
      }
    }

    return null;
  }

  static String? validateClaim(String value, {required String label, required AppLocalizations localizations}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_claimPattern.hasMatch(trimmed)) {
      return localizations.validationFieldInvalid(label);
    }
    return null;
  }

  static String? validateSubfolder(String value, {required AppLocalizations localizations}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    if (!trimmed.startsWith('/')) {
      return localizations.validationSubfolderMustStartWithSlash;
    }

    if (trimmed == '/') {
      return localizations.validationSubfolderCannotBeOnlySlash;
    }

    if (trimmed.endsWith('/')) {
      return localizations.validationSubfolderMustNotEndWithSlash;
    }

    if (trimmed.contains(' ')) {
      return localizations.validationSubfolderCannotContainSpaces;
    }

    return null;
  }
}
