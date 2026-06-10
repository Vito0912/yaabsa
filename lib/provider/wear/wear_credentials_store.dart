import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WearCredentials {
  const WearCredentials({required this.serverUrl, required this.accessToken, this.refreshToken});

  final String serverUrl;
  final String accessToken;
  final String? refreshToken;
}

class WearCredentialsStore {
  WearCredentialsStore() : _storage = const FlutterSecureStorage();
  final FlutterSecureStorage _storage;
  static const _serverUrlKey = 'wear_server_url';
  static const _accessTokenKey = 'wear_access_token';
  static const _refreshTokenKey = 'wear_refresh_token';
  static const _legacyTokenKey = 'wear_token';

  Future<bool> get hasCredentials async => await getCredentials() != null;

  Future<WearCredentials?> getCredentials() async {
    final url = await _storage.read(key: _serverUrlKey);
    final accessToken = await _storage.read(key: _accessTokenKey);
    if (url == null || url.isEmpty || accessToken == null || accessToken.isEmpty) return null;
    return WearCredentials(
      serverUrl: url,
      accessToken: accessToken,
      refreshToken: await _storage.read(key: _refreshTokenKey),
    );
  }

  Future<void> saveCredentials({required String serverUrl, required String accessToken, String? refreshToken}) async {
    await _storage.write(key: _serverUrlKey, value: serverUrl);
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    } else {
      await _storage.delete(key: _refreshTokenKey);
    }
    // Token copied from the phone in the proof-of-concept pairing flow.
    await _storage.delete(key: _legacyTokenKey);
  }

  /// Token rotation after a refresh; keeps the current refresh token when the
  /// server does not return a new one.
  Future<void> updateTokens({required String accessToken, String? refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }
}
