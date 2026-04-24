import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/socket/abs_socket_client.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
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

  void updateSocketForUser(User? user) {
    final serverUrl = user?.server?.url;
    final token = user?.preferredAuthToken;

    if (serverUrl == null || serverUrl.isEmpty || token == null || token.isEmpty) {
      socketClient.disconnect();
      return;
    }

    logger(
      'Connecting Audiobookshelf socket for user ${user!.username}',
      tag: 'SocketProvider',
      level: InfoLevel.debug,
    );
    socketClient.connect(serverUrl: serverUrl, apiToken: token);
  }

  ref.listen<AsyncValue<User?>>(currentUserProvider, (previous, next) {
    updateSocketForUser(next.value);
  });

  updateSocketForUser(ref.read(currentUserProvider).value);

  ref.onDispose(socketClient.dispose);

  return socketClient;
}
