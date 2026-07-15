import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/services.dart';
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

class AuthSecretsUnavailableException implements Exception {
  const AuthSecretsUnavailableException({required this.error, required this.stackTrace});

  final Object error;
  final StackTrace stackTrace;

  @override
  String toString() => 'AuthSecretsUnavailableException($error)';
}

class AuthSecretStore {
  AuthSecretStore({FlutterSecureStorage? storage, FlutterSecureStorage? legacyStorage})
    : _storage =
          storage ??
          const FlutterSecureStorage(iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock)),
      _legacyStorage = legacyStorage ?? storage ?? const FlutterSecureStorage(),
      _usesSystemStorage = storage == null && legacyStorage == null;

  final FlutterSecureStorage _storage;
  final FlutterSecureStorage _legacyStorage;
  final bool _usesSystemStorage;

  static const String _legacyTokenKey = 'legacyToken';
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _apiKeyKey = 'apiKey';
  static const MethodChannel _iosKeychainMigrationChannel = MethodChannel('de.vito0912.yaabsa/auth_secret_migration');

  String _key(String userId, String field) => 'auth.$userId.$field';

  Future<AuthSecrets> read(String userId) async {
    try {
      final values = await Future.wait<String?>([
        _readField(_key(userId, _legacyTokenKey)),
        _readField(_key(userId, _accessTokenKey)),
        _readField(_key(userId, _refreshTokenKey)),
        _readField(_key(userId, _apiKeyKey)),
      ]);

      return AuthSecrets(legacyToken: values[0], accessToken: values[1], refreshToken: values[2], apiKey: values[3]);
    } catch (error, stackTrace) {
      throw AuthSecretsUnavailableException(error: error, stackTrace: stackTrace);
    }
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
      final migrated = await _migrateLegacyValueIfNeeded(fieldKey);
      await (migrated ? _storage : _legacyStorage).write(key: fieldKey, value: value);
      return;
    }

    if (clearMissing) {
      await _storage.delete(key: fieldKey);
    }
  }

  Future<String?> _readField(String key) async {
    final value = await _storage.read(key: key);
    if (value != null || identical(_storage, _legacyStorage)) {
      return value;
    }

    final legacyValue = await _legacyStorage.read(key: key);
    if (legacyValue == null) {
      return null;
    }

    await _migrateLegacyValue(key);
    return legacyValue;
  }

  Future<bool> _migrateLegacyValueIfNeeded(String key) async {
    if (identical(_storage, _legacyStorage)) {
      return true;
    }

    final value = await _storage.read(key: key);
    if (value != null) {
      return true;
    }

    final legacyValue = await _legacyStorage.read(key: key);
    if (legacyValue != null) {
      return _migrateLegacyValue(key);
    }

    return true;
  }

  Future<bool> _migrateLegacyValue(String key) async {
    if (!_usesSystemStorage || kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      return true;
    }

    try {
      await _iosKeychainMigrationChannel.invokeMethod<void>('migrateAccessibility', <String, String>{'key': key});
      return true;
    } catch (_) {
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
AuthSecretStore authSecretStore(Ref ref) {
  return AuthSecretStore();
}
