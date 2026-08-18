import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServerReachabilityNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void setReachable() {
    state = true;
  }

  void setUnreachable() {
    state = false;
  }
}

final serverReachabilityProvider = NotifierProvider<ServerReachabilityNotifier, bool>(ServerReachabilityNotifier.new);
