import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/auth/account_sign_in.dart';
import 'package:yaabsa/util/network/dio_factory.dart';

part 'wear_sign_in_provider.g.dart';

@riverpod
class WearSignIn extends _$WearSignIn {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({
    required String serverAddress,
    required String username,
    required String password,
    required Map<String, String> headers,
  }) async {
    if (state.isLoading) {
      return;
    }

    final serverUrl = normalizeServerAddress(serverAddress);
    if (serverUrl == null) {
      state = AsyncError(const FormatException('Enter a valid server address.'), StackTrace.current);
      return;
    }

    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    final api = ABSApi(
      dio: createNativeDio(
        options: BaseOptions(
          baseUrl: serverUrl,
          headers: headers,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 20),
        ),
      ),
      basePathOverride: serverUrl,
    );
    state = const AsyncLoading();

    try {
      final statusResponse = await api.getMeApi().getStatus(cancelToken: cancelToken);
      final status = statusResponse.data;
      if (status == null || status.app.toLowerCase() != 'audiobookshelf') {
        throw const FormatException('This address is not an Audiobookshelf server.');
      }
      if (!status.authMethods.contains('local')) {
        throw const FormatException('Password sign in is disabled. Continue on phone to use OpenID Connect.');
      }

      final login = await signInWithPassword(
        api: api,
        username: username,
        password: password,
        cancelToken: cancelToken,
      );
      if (!ref.mounted || cancelToken.isCancelled) {
        return;
      }

      await storeSignedInAccount(
        db: ref.read(appDatabaseProvider),
        user: login.user.copyWith(setting: login.serverSettings),
        serverUrl: serverUrl,
        headers: headers,
        serverDefaultLibraryId: login.userDefaultLibraryId,
      );
      if (ref.mounted) {
        ref.invalidate(allStoredUsersProvider);
        ref.invalidate(currentUserProvider);
        state = const AsyncData(null);
      }
    } catch (error, stackTrace) {
      if (ref.mounted && !cancelToken.isCancelled) {
        state = AsyncError(error, stackTrace);
      }
    } finally {
      api.dio.close();
    }
  }
}

String wearRequestError(Object error) {
  if (error is FormatException) {
    return error.message;
  }
  if (error is DioException) {
    final code = error.response?.statusCode;
    if (code == 401 || code == 403) {
      return 'Access denied. Check your account details and server permissions.';
    }
    if (error.type == DioExceptionType.badCertificate) {
      return 'The server certificate could not be verified.';
    }
    return 'Could not reach the server. Check your connection and try again.';
  }
  return 'Could not complete this action. Please try again.';
}
