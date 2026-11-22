import 'package:dio/dio.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/dio_factory.dart';

Future<bool> removeStoredAccount({required AppDatabase db, required User user}) async {
  await _notifyServerLogout(user);

  final activeUserId = (await db.getGlobalSetting('activeUserId'))?.value;
  await db.deleteStoredUser(user.id);

  return activeUserId == user.id;
}

Future<void> _notifyServerLogout(User user) async {
  final server = user.server;
  final refreshToken = user.refreshToken;
  if (server == null || refreshToken == null || refreshToken.isEmpty) {
    return;
  }

  Dio? dio;
  try {
    dio = createNativeDio(
      options: BaseOptions(
        baseUrl: server.url,
        headers: server.headers,
        connectTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );
    final api = ABSApi(dio: dio, basePathOverride: server.url);
    final authToken = user.preferredAuthToken;
    if (authToken != null && authToken.isNotEmpty) {
      api.setBearerAuth('BearerAuth', authToken);
    }

    await api.getMeApi().logout(refreshToken: refreshToken, extra: const {'skip_auth_refresh': true});
  } catch (error, stackTrace) {
    logger(
      'Failed to notify server logout for ${user.username}: $error\n$stackTrace',
      tag: 'AccountRemoval',
      level: InfoLevel.warning,
    );
  } finally {
    dio?.close(force: true);
  }
}
