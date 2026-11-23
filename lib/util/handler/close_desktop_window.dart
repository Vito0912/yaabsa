import 'dart:async';

import 'package:window_manager/window_manager.dart';

Future<bool> closeDesktopWindow(Window window) async {
  final closed = Completer<void>();
  final listenerId = window.addListener((event) {
    if (event is WindowClosedEvent && !closed.isCompleted) {
      closed.complete();
    }
  });

  try {
    if (!window.close()) {
      return false;
    }

    await closed.future;
    return true;
  } finally {
    window.removeListener(listenerId);
  }
}
