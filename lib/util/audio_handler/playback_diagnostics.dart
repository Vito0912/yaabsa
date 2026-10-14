import 'package:yaabsa/util/log_exporter.dart' show redactSensitiveUrls;
import 'package:yaabsa/util/logger.dart';

final _sensitiveHeaderPattern = RegExp(
  r'\b(authorization|proxy-authorization|cookie|set-cookie|http-header-fields)\s*[:=][^\r\n]*',
  caseSensitive: false,
);
final _sensitiveQueryPattern = RegExp(
  r'\b(token|access_token|refresh_token|api_key|apikey|password)=[^\s&\]\)>,]+',
  caseSensitive: false,
);

String sanitizePlaybackDiagnostic(String message, {Iterable<String?> secrets = const []}) {
  var sanitized = message;
  final values = secrets.whereType<String>().where((value) => value.isNotEmpty).toList()
    ..sort((left, right) => right.length.compareTo(left.length));
  for (final value in values) {
    sanitized = sanitized.replaceAll(value, '[REDACTED]');
  }

  sanitized = redactSensitiveUrls(sanitized);
  sanitized = sanitized.replaceAllMapped(_sensitiveHeaderPattern, (match) => '${match[1]}: [REDACTED]');
  return sanitized.replaceAllMapped(_sensitiveQueryPattern, (match) => '${match[1]}=[REDACTED]');
}

void logNativePlaybackDiagnostic(
  String playerId,
  String level,
  String prefix,
  String message, {
  Iterable<String?> secrets = const [],
}) {
  final severity = switch (level.toLowerCase()) {
    'fatal' || 'error' => InfoLevel.error,
    'warn' || 'warning' => InfoLevel.warning,
    _ => InfoLevel.debug,
  };
  if (!appLoggerService.shouldLog(severity)) {
    return;
  }

  final sanitized = sanitizePlaybackDiagnostic('[$prefix] ${message.trim()}', secrets: secrets);
  logger('player=$playerId, nativeLevel=$level, $sanitized', tag: 'MPV', level: severity);
}

String describePlaybackUri(Uri? uri, {Uri? serverUri}) {
  if (uri == null) {
    return 'invalid';
  }

  final path = uri.path.toLowerCase();
  var endpoint = 'other';
  if (path.contains('/public/session/') && path.contains('/track/')) {
    endpoint = 'public-session-track';
  } else if (path.endsWith('.m3u8')) {
    endpoint = 'hls-playlist';
  } else if (path.endsWith('.mpd')) {
    endpoint = 'dash-manifest';
  } else if (uri.scheme == 'file' || !uri.hasScheme) {
    endpoint = 'local-file';
  }

  final isHttp = uri.scheme == 'http' || uri.scheme == 'https';
  final sameOrigin = serverUri == null
      ? null
      : uri.scheme == serverUri.scheme && uri.host == serverUri.host && uri.port == serverUri.port;
  return 'scheme=${uri.scheme}, port=${isHttp ? uri.port : 'n/a'}, endpoint=$endpoint, '
      'loopback=${uri.host == 'localhost' || uri.host == '127.0.0.1' || uri.host == '::1'}, '
      'sameServerOrigin=$sameOrigin, hasQuery=${uri.hasQuery}, '
      'hasUserInfo=${uri.userInfo.isNotEmpty}, hasFragment=${uri.hasFragment}';
}
