import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/routes/interceptors/bearer_auth_interceptor.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/wear/wear_credentials_store.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;
import 'package:yaabsa/util/interceptors/wear_auth_refresh_interceptor.dart';
import 'package:yaabsa/util/network/dio_factory.dart';
import 'package:yaabsa/util/router.dart' show globalRouter;

export 'package:yaabsa/provider/wear/wear_credentials_store.dart';

const _wearDataChannelName = 'de.vito0912.yaabsa/wear_data';

final wearCredentialsStoreProvider = Provider<WearCredentialsStore>((ref) => WearCredentialsStore());

final wearHasCredentialsProvider = FutureProvider<bool>((ref) async {
  return ref.watch(wearCredentialsStoreProvider).hasCredentials;
});

class WearDataLayer {
  WearDataLayer() : _channel = const MethodChannel(_wearDataChannelName);
  final MethodChannel _channel;

  Future<WearCredentials?> requestCredentials() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('requestCredentials');
      if (result == null) return null;
      final serverUrl = result['serverUrl'] as String?;
      final accessToken = result['accessToken'] as String?;
      if (serverUrl == null || serverUrl.isEmpty || accessToken == null || accessToken.isEmpty) return null;
      return WearCredentials(
        serverUrl: serverUrl,
        accessToken: accessToken,
        refreshToken: result['refreshToken'] as String?,
      );
    } on PlatformException catch (_) {
      return null;
    }
  }
}

final wearDataLayerProvider = Provider<WearDataLayer>((ref) => WearDataLayer());

final wearApiProvider = FutureProvider<ABSApi?>((ref) async {
  final store = ref.read(wearCredentialsStoreProvider);
  final creds = await store.getCredentials();
  if (creds == null) return null;
  final bearerAuth = BearerAuthInterceptor();
  final api = ABSApi(
    dio: createNativeDio(
      options: BaseOptions(
        baseUrl: creds.serverUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 20),
      ),
    ),
    basePathOverride: creds.serverUrl,
    interceptors: [bearerAuth, WearAuthRefreshInterceptor(store: store, bearerAuth: bearerAuth)],
  )..setBearerAuth('BearerAuth', creds.accessToken);
  return api;
});

/// Phone side: reacts to a watch pairing request by opening the sign-in
/// screen in wear pairing mode, pre-filled with the active user's server and
/// username.
void initPhoneWearHandler() {
  const channel = MethodChannel(_wearDataChannelName);
  channel.setMethodCallHandler((call) async {
    if (call.method == 'wearSignInRequested') {
      final user = containerRef.read(currentUserProvider).value;
      final serverUrl = user?.server?.url;
      final username = user?.username;
      final uri = Uri(
        path: '/add-user',
        queryParameters: {
          'wear': '1',
          if (serverUrl != null && serverUrl.isNotEmpty) 'serverUrl': serverUrl,
          if (username != null && username.isNotEmpty) 'username': username,
        },
      );
      globalRouter.go(uri.toString());
      return null;
    }
    throw MissingPluginException();
  });
}
