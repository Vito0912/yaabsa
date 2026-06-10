import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/api/me/server.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;
import 'package:yaabsa/util/network/dio_factory.dart';
import 'package:yaabsa/util/router.dart' show globalRouter;

const _wearDataChannelName = 'de.vito0912.yaabsa/wear_data';

/// Watch side: asks the phone for credentials (which opens the sign-in
/// screen there), then fetches the full user with the returned token pair
/// and stores it exactly like a phone sign-in. From then on the watch uses
/// the regular stored-user stack ([currentUserProvider], [absApiProvider],
/// `AuthRefreshInterceptor`).
///
/// Returns false when the phone did not answer; throws on server errors.
Future<bool> pairWithPhone() async {
  const channel = MethodChannel(_wearDataChannelName);
  final Map<dynamic, dynamic>? result;
  try {
    result = await channel.invokeMethod<Map<dynamic, dynamic>>('requestCredentials');
  } on PlatformException catch (_) {
    return false;
  }

  final serverUrl = result?['serverUrl'] as String?;
  final accessToken = result?['accessToken'] as String?;
  if (serverUrl == null || serverUrl.isEmpty || accessToken == null || accessToken.isEmpty) {
    return false;
  }

  final api = ABSApi(
    dio: createNativeDio(
      options: BaseOptions(
        baseUrl: serverUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 20),
      ),
    ),
    basePathOverride: serverUrl,
  )..setBearerAuth('BearerAuth', accessToken);

  final login = (await api.getMeApi().checkLogin()).data;
  if (login == null) {
    return false;
  }

  final user = login.user.copyWith(
    accessToken: accessToken,
    refreshToken: result?['refreshToken'] as String?,
    setting: login.user.setting ?? login.serverSettings,
    server: Server.fromExternalAddress(externalAddress: serverUrl, activeConnection: ServerConnection.external),
  );

  final db = containerRef.read(appDatabaseProvider);
  await db.addOrUpdateStoredUser(user);
  await db.setActiveUserId(user.id);
  return true;
}

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
