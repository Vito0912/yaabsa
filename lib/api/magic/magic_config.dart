import 'dart:convert';
import 'dart:math';

import 'package:html/parser.dart' as html_parser;
import 'package:jose/jose.dart';

class MagicConfig {
  const MagicConfig({
    required this.serverUrl,
    required this.username,
    required this.headers,
    this.password,
    required this.isPasswordBearing,
  });

  final String serverUrl;
  final String username;
  final Map<String, String> headers;
  final String? password;
  final bool isPasswordBearing;

  bool get hasPassword => password != null;
}

class MagicConfigServerKeyRequiredException implements Exception {
  const MagicConfigServerKeyRequiredException();

  @override
  String toString() => 'The server key for this Authentication Code is unavailable.';
}

class MagicConfigKeyMarker {
  const MagicConfigKeyMarker({required this.keyId, required this.keyBytes});

  static const _prefix = 'yaabsa-magic-v1';
  static final _markerPattern = RegExp(
    r'''<a\s+name=["']yaabsa-magic-v1\.([A-Za-z0-9_-]+)\.([A-Za-z0-9_-]+)["']\s*></a>''',
    caseSensitive: false,
  );
  static final _markerElementPattern = RegExp(
    r'''<a\b[^>]*\bname\s*=\s*["']yaabsa-magic-v1\.[^"']+["'][^>]*>\s*</a>''',
    caseSensitive: false,
  );

  final String keyId;
  final List<int> keyBytes;

  String get encodedKey => _base64UrlEncode(keyBytes);

  String get html => '<a name="$_prefix.$keyId.$encodedKey"></a>';

  factory MagicConfigKeyMarker.generate() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256), growable: false);
    return MagicConfigKeyMarker(keyId: 'current', keyBytes: bytes);
  }

  static MagicConfigKeyMarker? extract(String? html) {
    final matches = _markerPattern.allMatches(html ?? '').toList(growable: false);
    final match = matches.isEmpty ? null : matches.last;
    if (match == null) {
      return null;
    }

    try {
      final keyBytes = _base64UrlDecode(match.group(2)!);
      if (keyBytes.length != 32) {
        return null;
      }
      return MagicConfigKeyMarker(keyId: match.group(1)!, keyBytes: keyBytes);
    } on FormatException {
      return null;
    }
  }

  static MagicConfigKeyMarker? fromSerializedName(String? name) {
    if (name == null) {
      return null;
    }
    final marker = extract('<a name="${name.replaceAll('"', '')}"></a>');
    return marker;
  }

  static String removeFromHtml(String? html) {
    return (html ?? '').replaceAll(_markerElementPattern, '').trim();
  }

  static String appendToHtml(String? html, MagicConfigKeyMarker marker) {
    final visibleHtml = removeFromHtml(html);
    if (visibleHtml.isEmpty) {
      return marker.html;
    }
    return '$visibleHtml${marker.html}';
  }

  static String? visibleHtml(String? html) {
    final visible = removeFromHtml(html);
    return visible.isEmpty ? null : visible;
  }

  static String? extractFromSanitizedHtml(String? html) {
    final fragment = html_parser.parseFragment(html ?? '');
    for (final element in fragment.querySelectorAll('a')) {
      final name = element.attributes['name'];
      if (name == null || !name.startsWith('$_prefix.')) {
        continue;
      }
      return name;
    }
    return null;
  }
}

class MagicConfigCodec {
  MagicConfigCodec._();

  static const int formatVersion = 1;
  static const String _outerType = 'JWT';
  static const String _issuer = 'yaabsa';
  static const String _audience = 'yaabsa-magic';

  // This key is public intentionally. It prevents simple scanning for passwords
  static final List<int> _obfuscationKey = List<int>.unmodifiable(<int>[
    0x4b,
    0x1a,
    0x8e,
    0x7d,
    0x24,
    0x93,
    0x61,
    0xf0,
    0x2c,
    0xa7,
    0x15,
    0x5b,
    0x88,
    0xd4,
    0x39,
    0x0e,
    0x9a,
    0xe1,
    0x42,
    0x76,
    0x0b,
    0xcd,
    0x53,
    0xf8,
    0x17,
    0x6f,
    0xb2,
    0x30,
    0xde,
    0x04,
    0x95,
    0x68,
  ]);

  static String create({
    required String serverUrl,
    required String username,
    MagicConfigKeyMarker? marker,
    Map<String, String> headers = const <String, String>{},
    String? password,
  }) {
    final normalizedServerUrl = _normalizeServerUrl(serverUrl);
    final normalizedUsername = username.trim();
    if (normalizedUsername.isEmpty) {
      throw const FormatException('Authentication Code username cannot be empty.');
    }

    final claims = <String, dynamic>{
      'iss': _issuer,
      'aud': _audience,
      'v': formatVersion,
      'sub': normalizedUsername,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'jti': _randomId(),
      if (headers.isNotEmpty) 'headers': Map<String, String>.from(headers),
    };

    final requiresServerKey = password != null || headers.isNotEmpty;
    if (requiresServerKey && marker == null) {
      throw const FormatException('This Authentication Code requires a server key.');
    }

    final inner = requiresServerKey
        ? _createProtectedJwe(
            claims: <String, dynamic>{
              ...claims,
              'mode': password == null ? 'login-protected' : 'login-password',
              ...?(password == null ? null : <String, dynamic>{'pwd': password}),
            },
            marker: marker!,
          )
        : _createSignedJwt(claims: <String, dynamic>{...claims, 'mode': 'login'}, keyBytes: _obfuscationKey);

    final outerBuilder = JsonWebEncryptionBuilder()
      ..encryptionAlgorithm = 'A256GCM'
      ..setProtectedHeader('typ', _outerType)
      ..setProtectedHeader('v', formatVersion)
      ..jsonContent = <String, dynamic>{'srv': normalizedServerUrl, 'inner': inner};
    outerBuilder.addRecipient(_jwk(_obfuscationKey), algorithm: 'dir');
    return outerBuilder.build().toCompactSerialization();
  }

  static String extractToken(String input) {
    final trimmed = input.trim().replaceAll(RegExp(r'\s+'), '');
    if (trimmed.length > 16 * 1024) {
      throw const FormatException('Authentication Code is too large.');
    }
    if (trimmed.isEmpty || trimmed.contains(RegExp(r'[\s#?/\\]'))) {
      throw const FormatException('Authentication Code contains invalid characters.');
    }
    return trimmed;
  }

  static Future<String> serverUrlFromInput(String input) async {
    final outer = JsonWebEncryption.fromCompactSerialization(extractToken(input));
    final header = outer.commonProtectedHeader.toJson();
    _requireHeader(header, 'typ', _outerType);
    _requireHeader(header, 'v', formatVersion);
    final payload = await _readOuterPayload(outer);
    return _normalizeServerUrl(payload['srv'] as String? ?? '');
  }

  static Future<MagicConfig> decode({required String input, MagicConfigKeyMarker? marker}) async {
    final token = extractToken(input);
    final outer = JsonWebEncryption.fromCompactSerialization(token);
    final outerHeader = outer.commonProtectedHeader.toJson();
    _requireHeader(outerHeader, 'typ', _outerType);
    _requireHeader(outerHeader, 'v', formatVersion);
    _requireHeader(outerHeader, 'alg', 'dir');
    _requireHeader(outerHeader, 'enc', 'A256GCM');

    final outerPayload = await _readOuterPayload(outer);
    final serverUrl = _normalizeServerUrl(outerPayload['srv'] as String? ?? '');
    final inner = outerPayload['inner'] as String;

    if (inner.split('.').length == 3) {
      final signature = JsonWebSignature.fromCompactSerialization(inner);
      final header = signature.commonProtectedHeader.toJson();
      _requireHeader(header, 'typ', _outerType);
      _requireHeader(header, 'v', formatVersion);
      _requireHeader(header, 'alg', 'HS256');
      final payload = await signature.getPayload(
        _keyStore(_obfuscationKey),
        allowedAlgorithms: const <String>['HS256'],
      );
      final content = payload.jsonContent;
      if (content is! Map) {
        throw const FormatException('Authentication Code payload is invalid.');
      }
      final claims = _validateClaims(Map<String, dynamic>.from(content), expectedMode: 'login');
      final headers = _readHeaders(claims['headers']);
      if (headers.isNotEmpty) {
        throw const FormatException('This Authentication Code requires a server key.');
      }
      return MagicConfig(
        serverUrl: serverUrl,
        username: claims['sub'] as String,
        headers: headers,
        isPasswordBearing: false,
      );
    }

    final passwordJwe = JsonWebEncryption.fromCompactSerialization(inner);
    if (marker == null) {
      throw const MagicConfigServerKeyRequiredException();
    }
    final header = passwordJwe.commonProtectedHeader.toJson();
    _requireHeader(header, 'typ', _outerType);
    _requireHeader(header, 'v', formatVersion);
    _requireHeader(header, 'alg', 'dir');
    _requireHeader(header, 'enc', 'A256GCM');
    late final JosePayload passwordPayload;
    try {
      passwordPayload = await passwordJwe.getPayload(
        _keyStore(marker.keyBytes),
        allowedAlgorithms: const <String>['dir'],
      );
    } on JoseException {
      throw const FormatException('The Authentication Code is damaged or its server key was rotated.');
    }
    final content = passwordPayload.jsonContent;
    if (content is! Map) {
      throw const FormatException('Authentication Code payload is invalid.');
    }
    final rawClaims = Map<String, dynamic>.from(content);
    final mode = rawClaims['mode'];
    if (mode != 'login-password' && mode != 'login-protected') {
      throw const FormatException('Authentication Code mode is invalid.');
    }
    final claims = _validateClaims(rawClaims, expectedMode: mode as String);
    final rawPassword = claims['pwd'];
    if (rawPassword != null && (rawPassword is! String || rawPassword.isEmpty)) {
      throw const FormatException('Authentication Code password is invalid.');
    }
    if (mode == 'login-password' && rawPassword == null) {
      throw const FormatException('Authentication Code does not contain a password.');
    }
    final password = rawPassword as String?;

    return MagicConfig(
      serverUrl: serverUrl,
      username: claims['sub'] as String,
      password: password,
      headers: _readHeaders(claims['headers']),
      isPasswordBearing: password != null,
    );
  }

  static Future<Map<String, dynamic>> _readOuterPayload(JsonWebEncryption outer) async {
    final payload = await outer.getPayload(_keyStore(_obfuscationKey), allowedAlgorithms: const <String>['dir']);
    final content = payload.jsonContent;
    if (content is! Map) {
      throw const FormatException('Authentication Code outer payload is invalid.');
    }
    final inner = content['inner'];
    final serverUrl = content['srv'];
    if (inner is! String || serverUrl is! String) {
      throw const FormatException('Authentication Code outer payload is invalid.');
    }
    return <String, dynamic>{'srv': serverUrl, 'inner': inner};
  }

  static String _createSignedJwt({required Map<String, dynamic> claims, required List<int> keyBytes}) {
    final builder = JsonWebSignatureBuilder()
      ..setProtectedHeader('typ', 'JWT')
      ..setProtectedHeader('v', formatVersion)
      ..jsonContent = claims;
    builder.addRecipient(_jwk(keyBytes), algorithm: 'HS256');
    return builder.build().toCompactSerialization();
  }

  static String _createProtectedJwe({required Map<String, dynamic> claims, required MagicConfigKeyMarker marker}) {
    final builder = JsonWebEncryptionBuilder()
      ..encryptionAlgorithm = 'A256GCM'
      ..setProtectedHeader('typ', 'JWT')
      ..setProtectedHeader('v', formatVersion)
      ..jsonContent = claims;
    builder.addRecipient(_jwk(marker.keyBytes), algorithm: 'dir');
    return builder.build().toCompactSerialization();
  }

  static JsonWebKey _jwk(List<int> bytes) {
    return JsonWebKey.fromJson(<String, dynamic>{'kty': 'oct', 'k': _base64UrlEncode(bytes)});
  }

  static JsonWebKeyStore _keyStore(List<int> bytes) {
    final store = JsonWebKeyStore();
    store.addKey(_jwk(bytes));
    return store;
  }

  static Map<String, dynamic> _validateClaims(Map<String, dynamic> claims, {required String expectedMode}) {
    if (claims['iss'] != _issuer || claims['aud'] != _audience || claims['v'] != formatVersion) {
      throw const FormatException('Authentication Code claims are invalid.');
    }
    if (claims['mode'] != expectedMode) {
      throw const FormatException('Authentication Code mode is invalid.');
    }
    final username = claims['sub'];
    if (username is! String || username.trim().isEmpty || username.length > 256) {
      throw const FormatException('Authentication Code username is invalid.');
    }
    return claims;
  }

  static Map<String, String> _readHeaders(Object? value) {
    if (value == null) {
      return const <String, String>{};
    }
    if (value is! Map) {
      throw const FormatException('Authentication Code headers are invalid.');
    }
    final headers = <String, String>{};
    for (final entry in value.entries) {
      if (entry.key is! String || entry.value is! String) {
        throw const FormatException('Authentication Code headers are invalid.');
      }
      final name = (entry.key as String).trim();
      final headerValue = entry.value as String;
      if (name.isEmpty || name.length > 256 || headerValue.length > 8192 || headerValue.contains(RegExp(r'[\r\n]'))) {
        throw const FormatException('Authentication Code headers are invalid.');
      }
      headers[name] = headerValue;
    }
    return headers;
  }

  static String _normalizeServerUrl(String raw) {
    final trimmed = raw.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https') || uri.host.isEmpty) {
      throw const FormatException('Authentication Code server URL is invalid.');
    }
    if (uri.userInfo.isNotEmpty || uri.query.isNotEmpty || uri.fragment.isNotEmpty) {
      throw const FormatException('Authentication Code server URL contains unsupported components.');
    }
    final normalizedPath = uri.pathSegments.where((segment) => segment.isNotEmpty).join('/');
    final normalized = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.hasPort ? uri.port : null,
      path: normalizedPath.isEmpty ? null : '/$normalizedPath',
    ).toString();
    return normalized.endsWith('/') ? normalized.substring(0, normalized.length - 1) : normalized;
  }

  static void _requireHeader(Map<String, dynamic> header, String name, Object expected) {
    if (header[name] != expected) {
      throw FormatException('Authentication Code header $name is invalid.');
    }
  }

  static String _randomId() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    return _base64UrlEncode(bytes);
  }
}

String _base64UrlEncode(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');

List<int> _base64UrlDecode(String value) {
  final normalized = value.replaceAll('-', '+').replaceAll('_', '/');
  return base64Decode(normalized.padRight((normalized.length + 3) ~/ 4 * 4, '='));
}
