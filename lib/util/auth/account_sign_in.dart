import 'package:dio/dio.dart';
import 'package:yaabsa/api/me/login.dart';
import 'package:yaabsa/api/me/request/login_request.dart';
import 'package:yaabsa/api/me/server.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/logger.dart';

String? normalizeServerAddress(String input) {
  final trimmedInput = input.trim();
  if (trimmedInput.isEmpty) {
    return null;
  }

  final lowerInput = trimmedInput.toLowerCase();
  final hasExplicitHttpScheme = RegExp(r'^https?://').hasMatch(lowerInput);
  final hasExplicitScheme = lowerInput.contains('://');
  final isIncompleteHttpScheme =
      lowerInput == 'http' || lowerInput == 'https' || RegExp(r'^https?:/{0,2}$').hasMatch(lowerInput);
  if (isIncompleteHttpScheme || (hasExplicitScheme && !hasExplicitHttpScheme)) {
    return null;
  }

  final withScheme = hasExplicitHttpScheme ? trimmedInput : 'https://$trimmedInput';
  final uri = Uri.tryParse(withScheme);
  final scheme = uri?.scheme.toLowerCase();

  if (uri == null || !uri.hasAuthority || uri.host.isEmpty || (scheme != 'http' && scheme != 'https')) {
    return null;
  }

  final pathSegments = uri.pathSegments.where((segment) => segment.trim().isNotEmpty).toList(growable: false);
  final normalizedPath = pathSegments.isEmpty ? '' : '/${pathSegments.join('/')}';

  final normalized = uri.replace(path: normalizedPath, query: null, fragment: null).toString();
  return normalized.endsWith('/') ? normalized.substring(0, normalized.length - 1) : normalized;
}

Future<Login> signInWithPassword({
  required ABSApi api,
  required String username,
  required String password,
  CancelToken? cancelToken,
}) async {
  if (username.trim().isEmpty || password.isEmpty) {
    throw const FormatException('Username and password are required.');
  }

  final response = await api.getMeApi().login(
    loginRequest: LoginRequest(username: username.trim(), password: password),
    returnTokens: true,
    cancelToken: cancelToken,
  );
  final login = response.data;
  if (login == null || login.user.preferredAuthToken?.isNotEmpty != true) {
    throw const FormatException('The server did not return a valid account session.');
  }

  api.setBearerAuth('BearerAuth', login.user.preferredAuthToken!);
  return login;
}

Future<void> storeSignedInAccount({
  required AppDatabase db,
  required User user,
  required String serverUrl,
  Map<String, String>? headers,
  ABSApi? api,
  String? serverDefaultLibraryId,
}) async {
  final storedUser = user.copyWith(
    server: Server.fromExternalAddress(
      externalAddress: serverUrl,
      headers: headers == null || headers.isEmpty ? null : headers,
      activeConnection: ServerConnection.external,
    ),
  );
  await db.addOrUpdateStoredUser(storedUser);

  final defaultLibraryId = serverDefaultLibraryId?.trim();
  if (defaultLibraryId != null && defaultLibraryId.isNotEmpty) {
    await db.setUserSetting(user.id, 'selectedLibraryId', defaultLibraryId);
  }

  if (api != null) {
    try {
      final response = await api.getLibraryApi().getLibraries();
      final libraries = response.data?.libraries ?? [];
      if (libraries.isNotEmpty) {
        final hasDefault = libraries.any((library) => library.id == defaultLibraryId);
        final selectedId = hasDefault ? defaultLibraryId! : libraries.first.id;
        await db.setUserSetting(user.id, 'selectedLibraryId', selectedId);
      }
    } catch (error, stackTrace) {
      logger('Could not initialize library selection: $error\n$stackTrace', tag: 'SignIn');
    }
  }

  await db.setActiveUserId(user.id);
}
