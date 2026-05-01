import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/socket/abs_socket_client.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

part 'socket_provider.g.dart';

@Riverpod(keepAlive: true)
ABSSocketClient absSocketClient(Ref ref) {
  final socketClient = ABSSocketClient(
    onUserItemProgressUpdated: (event) {
      ref.read(mediaProgressProvider.notifier).applyRemoteProgressUpdate(event.data);
    },
  );

  void updateSocketForUser(User? user, {required bool serverReachable}) {
    final serverUrl = user?.server?.url;
    final token = user?.preferredAuthToken;
    final serverHeaders = user?.server?.headers;

    if (serverUrl == null || serverUrl.isEmpty || token == null || token.isEmpty) {
      socketClient.disconnect();
      return;
    }

    if (!serverReachable) {
      logger(
        'Skipping socket connect for user ${user!.username} because server is offline/unreachable.',
        tag: 'SocketProvider',
        level: InfoLevel.debug,
      );
      socketClient.disconnect();
      return;
    }

    logger(
      'Connecting Audiobookshelf socket for user ${user!.username}',
      tag: 'SocketProvider',
      level: InfoLevel.debug,
    );
    socketClient.connect(serverUrl: serverUrl, apiToken: token, headers: serverHeaders);
  }

  ref.listen<AsyncValue<User?>>(currentUserProvider, (previous, next) {
    final canReachServer = ref.read(serverStatusProvider).value ?? false;
    updateSocketForUser(next.value, serverReachable: canReachServer);
  });

  ref.listen<AsyncValue<bool>>(serverStatusProvider, (previous, next) {
    final currentUser = ref.read(currentUserProvider).value;
    final canReachServer = next.value ?? false;
    updateSocketForUser(currentUser, serverReachable: canReachServer);
  });

  updateSocketForUser(
    ref.read(currentUserProvider).value,
    serverReachable: ref.read(serverStatusProvider).value ?? false,
  );

  ref.onDispose(socketClient.dispose);

  return socketClient;
}
