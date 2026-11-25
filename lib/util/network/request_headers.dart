import 'package:yaabsa/util/l10n.dart';

String? validateServerHeader({required String name, required String value}) {
  if (name.trim().isEmpty || value.trim().isEmpty) {
    return currentAppLocalizations().validationRequestHeadersRequired;
  }

  final validName = RegExp(r"^[!#$%&'*+.^_`|~0-9a-zA-Z-]+$").hasMatch(name.trim());
  if (!validName || value.contains('\r') || value.contains('\n')) {
    return currentAppLocalizations().validationRequestHeadersInvalid;
  }

  return null;
}

Map<String, String> buildRequestHeaders({
  Map<String, String>? serverHeaders,
  String? bearerToken,
  Map<String, String>? additionalHeaders,
}) {
  final headers = <String, String>{};

  void mergeHeaders(Map<String, String>? source) {
    if (source == null || source.isEmpty) {
      return;
    }

    for (final entry in source.entries) {
      final key = entry.key.trim();
      final value = entry.value.trim();
      if (key.isEmpty || value.isEmpty) {
        continue;
      }
      headers[key] = value;
    }
  }

  mergeHeaders(serverHeaders);
  mergeHeaders(additionalHeaders);

  final normalizedToken = bearerToken?.trim();
  if (normalizedToken != null && normalizedToken.isNotEmpty) {
    headers['Authorization'] = 'Bearer $normalizedToken';
  }

  return headers;
}
