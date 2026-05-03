import 'package:freezed_annotation/freezed_annotation.dart';

part 'server.freezed.dart';
part 'server.g.dart';

enum ServerConnection { external, local }

@unfreezed
abstract class Server with _$Server {
  Server._();

  factory Server({
    @JsonKey(name: 'port') required int externalPort,
    @JsonKey(name: 'host') required String externalHost,
    @JsonKey(name: 'ssl') required bool externalSsl,
    @JsonKey(name: 'subdirectory') String? externalSubdirectory,
    Map<String, String>? headers,
    String? localHost,
    int? localPort,
    bool? localSsl,
    String? localSubdirectory,
    @Default(ServerConnection.external)
    @JsonKey(unknownEnumValue: ServerConnection.external)
    ServerConnection activeConnection,
  }) = _Server;

  factory Server.fromJson(Map<String, dynamic> json) => _$ServerFromJson(json);

  factory Server.fromExternalAddress({
    required String externalAddress,
    Map<String, String>? headers,
    String? localAddress,
    ServerConnection activeConnection = ServerConnection.external,
  }) {
    final externalUri = _parseServerUri(externalAddress);
    final localUri = localAddress == null ? null : _tryParseServerUri(localAddress);

    return Server(
      externalHost: externalUri.host,
      externalPort: externalUri.port,
      externalSsl: externalUri.scheme == 'https',
      externalSubdirectory: _normalizeSubdirectory(externalUri.path),
      headers: headers,
      localHost: localUri?.host,
      localPort: localUri?.port,
      localSsl: localUri == null ? null : localUri.scheme == 'https',
      localSubdirectory: localUri == null ? null : _normalizeSubdirectory(localUri.path),
      activeConnection: activeConnection,
    );
  }

  bool get hasLocalConnection =>
      localHost != null && localHost!.trim().isNotEmpty && localPort != null && localSsl != null;

  bool get usesLocalConnection => activeConnection == ServerConnection.local && hasLocalConnection;

  String get host => usesLocalConnection ? localHost! : externalHost;

  int get port => usesLocalConnection ? localPort! : externalPort;

  bool get ssl => usesLocalConnection ? localSsl! : externalSsl;

  String? get subdirectory => usesLocalConnection ? localSubdirectory : externalSubdirectory;

  String get externalUrl {
    return _buildServerUrl(
      host: externalHost,
      port: externalPort,
      ssl: externalSsl,
      subdirectory: externalSubdirectory,
    );
  }

  String? get localUrl {
    if (!hasLocalConnection) {
      return null;
    }

    return _buildServerUrl(host: localHost!, port: localPort!, ssl: localSsl!, subdirectory: localSubdirectory);
  }

  String get url => _buildServerUrl(host: host, port: port, ssl: ssl, subdirectory: subdirectory);

  void setConnection(ServerConnection nextConnection) {
    if (nextConnection == ServerConnection.local && !hasLocalConnection) {
      activeConnection = ServerConnection.external;
      return;
    }

    activeConnection = nextConnection;
  }
}

Uri _parseServerUri(String input) {
  final uri = _tryParseServerUri(input);
  if (uri == null) {
    throw FormatException('Invalid server address: $input');
  }
  return uri;
}

Uri? _tryParseServerUri(String input) {
  final trimmedInput = input.trim();
  if (trimmedInput.isEmpty) {
    return null;
  }

  final withScheme = trimmedInput.contains('://') ? trimmedInput : 'https://$trimmedInput';
  final uri = Uri.tryParse(withScheme);
  if (uri == null || uri.host.isEmpty) {
    return null;
  }

  final pathSegments = uri.pathSegments.where((segment) => segment.trim().isNotEmpty).toList(growable: false);
  final normalizedPath = pathSegments.isEmpty ? '' : '/${pathSegments.join('/')}';

  return uri.replace(path: normalizedPath, query: null, fragment: null);
}

String? _normalizeSubdirectory(String? rawValue) {
  if (rawValue == null) {
    return null;
  }

  final segments = rawValue
      .split('/')
      .map((segment) => segment.trim())
      .where((segment) => segment.isNotEmpty)
      .toList(growable: false);
  if (segments.isEmpty) {
    return null;
  }

  return segments.join('/');
}

String _buildServerUrl({required String host, required int port, required bool ssl, String? subdirectory}) {
  final normalizedSubdirectory = _normalizeSubdirectory(subdirectory);
  final uri = Uri(
    scheme: ssl ? 'https' : 'http',
    host: host,
    port: port,
    path: normalizedSubdirectory == null ? '' : '/$normalizedSubdirectory',
  );

  final asString = uri.toString();
  return asString.endsWith('/') ? asString.substring(0, asString.length - 1) : asString;
}
