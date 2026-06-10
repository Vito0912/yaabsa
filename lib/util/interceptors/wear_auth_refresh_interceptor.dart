import 'package:yaabsa/api/me/login.dart';
import 'package:yaabsa/api/routes/interceptors/bearer_auth_interceptor.dart';
import 'package:yaabsa/provider/wear/wear_credentials_store.dart';
import 'package:yaabsa/util/interceptors/auth_refresh_interceptor.dart';

/// Wear variant of [BaseAuthRefreshInterceptor]: the watch keeps its own token
/// pair in [WearCredentialsStore] instead of the stored-user database.
class WearAuthRefreshInterceptor extends BaseAuthRefreshInterceptor {
  WearAuthRefreshInterceptor({required this.store, required this.bearerAuth});

  final WearCredentialsStore store;
  final BearerAuthInterceptor bearerAuth;

  @override
  Future<AuthRefreshTarget?> loadRefreshTarget() async {
    final creds = await store.getCredentials();
    final refreshToken = creds?.refreshToken;
    if (creds == null || refreshToken == null || refreshToken.isEmpty) {
      return null;
    }
    return AuthRefreshTarget(serverUrl: creds.serverUrl, refreshToken: refreshToken);
  }

  @override
  Future<String?> persistRefreshedLogin(Login login, AuthRefreshTarget target) async {
    final user = login.user;
    final accessToken = user.accessToken ?? user.token;
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    await store.updateTokens(accessToken: accessToken, refreshToken: user.refreshToken);
    bearerAuth.tokens['BearerAuth'] = accessToken;
    return accessToken;
  }
}
