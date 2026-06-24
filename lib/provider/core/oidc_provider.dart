import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/api/me/login.dart';
import 'package:yaabsa/api/me/server.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/core/user_scope_invalidation.dart';
import 'package:yaabsa/util/globals.dart' show audioHandler;
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/dio_factory.dart';
import 'package:yaabsa/util/network/request_headers.dart';

part 'oidc_provider.g.dart';

@Riverpod(keepAlive: true)
class OidcState extends _$OidcState {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  AsyncValue<void> build() {
    ref.onDispose(() {
      _linkSubscription?.cancel();
    });
    return const AsyncValue.data(null);
  }

  void initializeDeepLinkListener() {
    if (_linkSubscription != null) return;

    final appLinks = AppLinks();

    appLinks
        .getInitialLink()
        .then((uri) {
          if (uri != null) {
            _handleIncomingUri(uri);
          }
        })
        .catchError((dynamic err) {
          logger('Failed to get initial app link: $err', tag: 'OidcProvider', level: InfoLevel.warning);
        });

    // Subscribe to warm start URLs
    _linkSubscription = appLinks.uriLinkStream.listen(
      (uri) {
        _handleIncomingUri(uri);
      },
      onError: (dynamic err) {
        logger('Error in app links stream: $err', tag: 'OidcProvider', level: InfoLevel.warning);
      },
    );
  }

  void _handleIncomingUri(Uri uri) {
    logger('Received deep link URL: $uri', tag: 'OidcProvider');
    if (uri.scheme == 'yaabsa' && uri.host == 'oauth') {
      handleCallbackUri(uri);
    }
  }

  Future<void> initiateOidc({required String serverUrl, required Map<String, String> customHeaders}) async {
    state = const AsyncValue.loading();
    try {
      final codeVerifier = _generateCodeVerifier();
      final sessionState = _randomBase64Url(24);
      final codeChallenge = _toBase64UrlNoPadding(sha256.convert(utf8.encode(codeVerifier)).bytes);

      final headers = buildRequestHeaders(serverHeaders: customHeaders);
      final dio = createNativeDio(
        options: BaseOptions(
          baseUrl: serverUrl,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 5000),
          headers: headers.isEmpty ? null : headers,
        ),
      );

      final response = await dio.get<dynamic>(
        '/auth/openid',
        queryParameters: <String, dynamic>{
          'code_challenge': codeChallenge,
          'code_challenge_method': 'S256',
          'redirect_uri': 'yaabsa://oauth',
          'client_id': 'Yaabsa',
          'response_type': 'code',
          'state': sessionState,
        },
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status != null && status >= 200 && status < 400,
        ),
      );

      final location = response.headers.value('location');
      if (location == null || location.isEmpty) {
        throw Exception('Server did not return OIDC redirect location. OIDC is likely misconfigured on the server.');
      }

      final setCookie = _parseSetCookieHeaders(response.headers['set-cookie']);

      final session = <String, dynamic>{
        'serverUrl': serverUrl,
        'state': sessionState,
        'codeVerifier': codeVerifier,
        'cookie': setCookie,
        'customHeaders': customHeaders,
        'timestamp': DateTime.now().toIso8601String(),
      };

      const storage = FlutterSecureStorage();
      await storage.write(key: 'oidc_session', value: jsonEncode(session));

      logger('OIDC flow initialized. Launching browser: $location', tag: 'OidcProvider');
      final launched = await launchUrl(Uri.parse(location), mode: LaunchMode.externalApplication);
      if (!launched) {
        throw Exception('Could not launch OpenID login page in browser.');
      }

      state = const AsyncValue.data(null);
    } catch (e, st) {
      logger('Failed to initiate OIDC flow: $e\n$st', tag: 'OidcProvider', level: InfoLevel.error);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> handleCallbackUri(Uri uri) async {
    state = const AsyncValue.loading();
    try {
      final queryParams = uri.queryParameters;
      final code = queryParams['code'];
      final stateValue = queryParams['state'];

      if (code == null || stateValue == null) {
        throw Exception('Authorization callback URL is missing code or state parameters.');
      }

      const storage = FlutterSecureStorage();
      final sessionJson = await storage.read(key: 'oidc_session');
      if (sessionJson == null) {
        throw Exception('No active OIDC session context found in storage. Please try logging in again.');
      }

      final session = jsonDecode(sessionJson) as Map<String, dynamic>;
      await storage.delete(key: 'oidc_session');

      final savedState = session['state'] as String;
      final codeVerifier = session['codeVerifier'] as String;
      final serverUrl = session['serverUrl'] as String;
      final cookie = session['cookie'] as String?;
      final customHeaders = Map<String, String>.from(session['customHeaders'] as Map);
      final timestamp = DateTime.parse(session['timestamp'] as String);

      if (DateTime.now().difference(timestamp) > const Duration(minutes: 5)) {
        throw Exception('Authorization session timed out. Please try logging in again.');
      }

      if (savedState != stateValue) {
        throw Exception('State validation mismatch. Potential security breach or duplicate login flow.');
      }

      final baseHeaders = buildRequestHeaders(serverHeaders: customHeaders);
      final headers = Map<String, dynamic>.from(baseHeaders);
      if (cookie != null && cookie.isNotEmpty) {
        headers['Cookie'] = cookie;
      }

      final dio = createNativeDio(
        options: BaseOptions(
          baseUrl: serverUrl,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 15000),
          headers: headers,
        ),
      );

      logger('Requesting callback token exchange at: $serverUrl/auth/openid/callback', tag: 'OidcProvider');
      final response = await dio.get<dynamic>(
        '/auth/openid/callback',
        queryParameters: <String, dynamic>{'code': code, 'state': stateValue, 'code_verifier': codeVerifier},
      );

      final responseData = response.data;
      if (responseData == null || responseData is! Map<String, dynamic>) {
        throw Exception('Server OIDC callback response is empty or malformed.');
      }

      final loginData = Login.fromJson(responseData);
      final loggedInUser = loginData.user.copyWith(setting: loginData.serverSettings);
      final serverDefaultLibraryId = loginData.userDefaultLibraryId;

      final token = loggedInUser.preferredAuthToken;
      ABSApi? authenticatedApi;
      if (token != null && token.isNotEmpty) {
        authenticatedApi = ABSApi(
          dio: createNativeDio(
            options: BaseOptions(
              baseUrl: serverUrl,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
              headers: baseHeaders.isEmpty ? null : baseHeaders,
            ),
          ),
          basePathOverride: serverUrl,
        );
        authenticatedApi.setBearerAuth('BearerAuth', token);
      }

      final db = ref.read(appDatabaseProvider);
      await db.addOrUpdateStoredUser(
        loggedInUser.copyWith(
          server: Server.fromExternalAddress(
            externalAddress: serverUrl,
            headers: baseHeaders.isEmpty ? null : baseHeaders,
            activeConnection: ServerConnection.external,
          ),
        ),
      );

      // Save initial library settings
      final normalizedDefaultLibraryId = serverDefaultLibraryId.trim();
      if (normalizedDefaultLibraryId.isNotEmpty) {
        await db.setUserSetting(loggedInUser.id, 'selectedLibraryId', normalizedDefaultLibraryId);
      }

      if (authenticatedApi != null) {
        try {
          final librariesResponse = await authenticatedApi.getLibraryApi().getLibraries();
          final libraries = librariesResponse.data?.libraries;
          if (libraries != null && libraries.isNotEmpty) {
            final hasValidDefault =
                normalizedDefaultLibraryId.isNotEmpty &&
                libraries.any((library) => library.id == normalizedDefaultLibraryId);
            final selectedLibraryId = hasValidDefault ? normalizedDefaultLibraryId : libraries.first.id;
            if (selectedLibraryId.isNotEmpty) {
              await db.setUserSetting(loggedInUser.id, 'selectedLibraryId', selectedLibraryId);
            }
          }
        } catch (e, s) {
          logger(
            'OIDC callback failed pre-fetching library details: $e\n$s',
            tag: 'OidcProvider',
            level: InfoLevel.warning,
          );
        }
      }

      await db.setActiveUserId(loggedInUser.id);
      await audioHandler.clearAndroidAutoAuthenticationError();

      ref.invalidate(allStoredUsersProvider);
      ref.invalidate(currentUserProvider);
      invalidateUserScopedProviders(ref);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      logger('OIDC Callback exchange failed: $e\n$st', tag: 'OidcProvider', level: InfoLevel.error);
      state = AsyncValue.error(e, st);
    }
  }

  void clearError() {
    state = const AsyncValue.data(null);
  }
}

String _generateCodeVerifier() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
  final random = Random.secure();
  return List.generate(64, (_) => chars[random.nextInt(chars.length)]).join();
}

String _randomBase64Url(int bytes) {
  final random = Random.secure();
  final data = List<int>.generate(bytes, (_) => random.nextInt(256));
  return _toBase64UrlNoPadding(data);
}

String _toBase64UrlNoPadding(List<int> data) {
  return base64Url.encode(data).replaceAll('=', '');
}

String? _parseSetCookieHeaders(List<String>? setCookieHeaders) {
  if (setCookieHeaders == null || setCookieHeaders.isEmpty) return null;

  final parsedCookies = <String>[];
  for (final header in setCookieHeaders) {
    final parts = header.split(';');
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i].trim();
      if (part.isEmpty) continue;

      if (i == 0) {
        if (part.contains('=')) {
          parsedCookies.add(part);
        }
      } else {
        if (part.contains(',')) {
          final subparts = part.split(',');
          for (var j = 0; j < subparts.length; j++) {
            final sub = subparts[j].trim();
            if (sub.isEmpty) continue;
            if (j > 0 && sub.contains('=')) {
              final key = sub.split('=').first.trim().toLowerCase();
              final knownAttributes = {'path', 'domain', 'max-age', 'expires', 'samesite', 'secure', 'httponly'};
              if (!knownAttributes.contains(key)) {
                parsedCookies.add(sub);
              }
            }
          }
        }
      }
    }
  }

  return parsedCookies.isEmpty ? null : parsedCookies.join('; ');
}
