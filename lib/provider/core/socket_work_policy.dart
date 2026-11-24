import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'socket_work_policy.g.dart';

class SocketWorkPolicy {
  const SocketWorkPolicy({
    this.hydrateAdminTasks = true,
    this.reconcileSmartDownloads = true,
    this.allowBackground = true,
  });

  final bool hydrateAdminTasks;
  final bool reconcileSmartDownloads;
  final bool allowBackground;
}

@Riverpod(keepAlive: true)
class SocketPolicy extends _$SocketPolicy {
  @override
  SocketWorkPolicy build() => const SocketWorkPolicy();

  void configure(SocketWorkPolicy policy) {
    state = policy;
  }
}

@Riverpod(keepAlive: true)
class SocketInteractionActive extends _$SocketInteractionActive {
  @override
  bool build() => true;

  void setActive(bool active) {
    state = active;
  }
}
