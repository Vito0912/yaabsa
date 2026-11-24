import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/util/auth/account_sign_in.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;
import 'package:yaabsa/util/network/dio_factory.dart';
import 'package:yaabsa/util/router.dart' show globalRouter;

const _wearDataChannelName = 'de.vito0912.yaabsa/wear_data';

enum WearPairingResult { paired, noPhone, noResponse }

/// Watch side: asks the phone for credentials (which opens the sign-in
/// screen there), then fetches the full user with the returned token pair
/// and stores it exactly like a phone sign-in. From then on the watch uses
/// the regular stored-user stack ([currentUserProvider], [absApiProvider],
/// `AuthRefreshInterceptor`).
///
Future<WearPairingResult> pairWithPhone({CancelToken? cancelToken}) async {
  const channel = MethodChannel(_wearDataChannelName);
  final Map<dynamic, dynamic>? result;
  try {
    result = await channel.invokeMethod<Map<dynamic, dynamic>>('requestCredentials');
  } on PlatformException catch (error) {
    if (error.code == 'NO_PHONE') {
      return WearPairingResult.noPhone;
    }

    return WearPairingResult.noResponse;
  }

  if (cancelToken?.isCancelled == true) {
    return WearPairingResult.noResponse;
  }

  final serverUrl = result?['serverUrl'] as String?;
  final accessToken = result?['accessToken'] as String?;
  if (serverUrl == null || serverUrl.isEmpty || accessToken == null || accessToken.isEmpty) {
    return WearPairingResult.noResponse;
  }
  final headers = (result?['headers'] as Map<dynamic, dynamic>?)?.cast<String, String>();

  final api = ABSApi(
    dio: createNativeDio(
      options: BaseOptions(
        baseUrl: serverUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 20),
        headers: headers,
      ),
    ),
    basePathOverride: serverUrl,
  )..setBearerAuth('BearerAuth', accessToken);

  try {
    final response = await api.getMeApi().checkLogin(cancelToken: cancelToken);
    final login = response.data;
    if (login == null || cancelToken?.isCancelled == true) {
      return WearPairingResult.noResponse;
    }

    final user = login.user.copyWith(
      accessToken: accessToken,
      refreshToken: result?['refreshToken'] as String?,
      setting: login.serverSettings,
    );
    final db = containerRef.read(appDatabaseProvider);
    await storeSignedInAccount(
      db: db,
      user: user,
      serverUrl: serverUrl,
      headers: headers,
      serverDefaultLibraryId: login.userDefaultLibraryId,
    );
    return WearPairingResult.paired;
  } finally {
    api.dio.close();
  }
}

/// Phone side: reacts to a watch pairing request by opening the sign-in
/// screen in wear pairing mode, pre-filled with the active user's server and
/// username.
void initPhoneWearHandler() {
  const channel = MethodChannel(_wearDataChannelName);
  channel.setMethodCallHandler((call) async {
    if (call.method == 'wearSignInRequested') {
      _openWearSignIn();
      return null;
    }
    throw MissingPluginException();
  });
  // The request may have arrived before this handler existed (app cold-started
  // from the pairing notification), so also check for a stored pending one.
  unawaited(_openWearSignInIfRequestPending(channel));
}

Future<void> _openWearSignInIfRequestPending(MethodChannel channel) async {
  try {
    final pending = await channel.invokeMethod<bool>('hasPendingCredentialRequest') ?? false;
    if (pending) {
      _openWearSignIn();
    }
  } on PlatformException {
    // Channel unavailable; nothing pending.
  } on MissingPluginException {
    // Non-Android host; nothing pending.
  }
}

void _openWearSignIn() {
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
}
