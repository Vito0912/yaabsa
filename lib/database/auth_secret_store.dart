import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_secret_store.g.dart';

class AuthSecrets {
  const AuthSecrets({this.legacyToken, this.accessToken, this.refreshToken, this.apiKey});

  final String? legacyToken;
  final String? accessToken;
  final String? refreshToken;
  final String? apiKey;

  bool get hasAny => legacyToken != null || accessToken != null || refreshToken != null || apiKey != null;

  String? get preferredAuthToken => apiKey ?? accessToken ?? legacyToken;
}

class AuthSecretStore {
  AuthSecretStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

  final FlutterSecureStorage _storage;

  static const String _legacyTokenKey = 'legacyToken';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _apiKeyKey = 'apiKey';

  String _key(String userId, String field) => 'auth.$userId.$field';

  Future<AuthSecrets> read(String userId) async {
    final values = await Future.wait<String?>([
      _storage.read(key: _key(userId, _legacyTokenKey)),
      _storage.read(key: _key(userId, _accessTokenKey)),
      _storage.read(key: _key(userId, _refreshTokenKey)),
      _storage.read(key: _key(userId, _apiKeyKey)),
    ]);

    return AuthSecrets(legacyToken: values[0], accessToken: values[1], refreshToken: values[2], apiKey: values[3]);
  }

  Future<void> writeForUser(
    String userId, {
    String? legacyToken,
    String? accessToken,
    String? refreshToken,
    String? apiKey,
    bool clearMissing = false,
  }) async {
    await _writeField(userId, _legacyTokenKey, legacyToken, clearMissing);
    await _writeField(userId, _accessTokenKey, accessToken, clearMissing);
    await _writeField(userId, _refreshTokenKey, refreshToken, clearMissing);
    await _writeField(userId, _apiKeyKey, apiKey, clearMissing);
  }

  Future<void> deleteForUser(String userId) async {
    await Future.wait<void>([
      _storage.delete(key: _key(userId, _legacyTokenKey)),
      _storage.delete(key: _key(userId, _accessTokenKey)),
      _storage.delete(key: _key(userId, _refreshTokenKey)),
      _storage.delete(key: _key(userId, _apiKeyKey)),
    ]);
  }

  Future<void> _writeField(String userId, String field, String? value, bool clearMissing) async {
    final fieldKey = _key(userId, field);
    if (value != null) {
      await _storage.write(key: fieldKey, value: value);
      return;
    }

    if (clearMissing) {
      await _storage.delete(key: fieldKey);
    }
  }
}

@Riverpod(keepAlive: true)
AuthSecretStore authSecretStore(Ref ref) {
  return AuthSecretStore();
}
