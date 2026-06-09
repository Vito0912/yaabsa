import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/routes/interceptors/bearer_auth_interceptor.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;
import 'package:yaabsa/util/network/dio_factory.dart';

class WearCredentialsStore {
  WearCredentialsStore() : _storage = const FlutterSecureStorage();
  final FlutterSecureStorage _storage;
  static const _serverUrlKey = 'wear_server_url';
  static const _tokenKey = 'wear_token';

  Future<bool> get hasCredentials async {
    final url = await _storage.read(key: _serverUrlKey);
    final token = await _storage.read(key: _tokenKey);
    return url != null && url.isNotEmpty && token != null && token.isNotEmpty;
  }

  Future<Map<String, String>?> getCredentials() async {
    final url = await _storage.read(key: _serverUrlKey);
    final token = await _storage.read(key: _tokenKey);
    if (url == null || url.isEmpty || token == null || token.isEmpty) return null;
    return {'serverUrl': url, 'token': token};
  }

  Future<void> saveCredentials({required String serverUrl, required String token}) async {
    await _storage.write(key: _serverUrlKey, value: serverUrl);
    await _storage.write(key: _tokenKey, value: token);
  }
}

final wearCredentialsStoreProvider = Provider<WearCredentialsStore>((ref) => WearCredentialsStore());

final wearHasCredentialsProvider = FutureProvider<bool>((ref) async {
  return ref.watch(wearCredentialsStoreProvider).hasCredentials;
});

class WearDataLayer {
  WearDataLayer() : _channel = const MethodChannel('de.vito0912.yaabsa/wear_data');
  final MethodChannel _channel;

  Future<Map<String, String>?> requestCredentials() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('requestCredentials');
      if (result == null) return null;
      return {'serverUrl': result['serverUrl'] as String, 'token': result['token'] as String};
    } on PlatformException catch (_) {
      return null;
    }
  }
}

final wearDataLayerProvider = Provider<WearDataLayer>((ref) => WearDataLayer());

final wearApiProvider = FutureProvider<ABSApi?>((ref) async {
  final creds = await ref.read(wearCredentialsStoreProvider).getCredentials();
  if (creds == null) return null;
  final api = ABSApi(
    dio: createNativeDio(
      options: BaseOptions(
        baseUrl: creds['serverUrl']!,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 20),
      ),
    ),
    basePathOverride: creds['serverUrl']!,
    interceptors: [BearerAuthInterceptor()],
  )..setBearerAuth('BearerAuth', creds['token']!);
  return api;
});

void initPhoneWearHandler() {
  const channel = MethodChannel('de.vito0912.yaabsa/wear_data');
  channel.setMethodCallHandler((call) async {
    if (call.method == 'getStoredCredentials') {
      final user = containerRef.read(currentUserProvider).value;
      if (user == null) return null;
      final url = user.server?.url;
      final token = user.preferredAuthToken;
      if (url == null || url.isEmpty || token == null || token.isEmpty) return null;
      return {'serverUrl': url, 'token': token};
    }
    throw MissingPluginException();
  });
}
