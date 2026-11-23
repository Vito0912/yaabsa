import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaabsa/util/handler/close_desktop_window.dart';

void main() {
  test('keeps the handle alive until the queued native close runs', () async {
    final window = _QueuedCloseWindow();
    final closing = closeDesktopWindow(window).then((closed) {
      window.dispose();
      return closed;
    });

    await Future<void>.delayed(Duration.zero);
    expect(window.disposed, isFalse);
    expect(window.listener, isNotNull);

    window.runQueuedClose();
    expect(await closing, isTrue);
    expect(window.nativeClosed, isTrue);
    expect(window.disposed, isTrue);
    expect(window.listener, isNull);
  });

  test('returns false and releases its listener when queuing fails', () async {
    final window = _QueuedCloseWindow(acceptClose: false);

    expect(await closeDesktopWindow(window), isFalse);
    expect(window.listener, isNull);
    expect(window.disposed, isFalse);
  });
}

class _QueuedCloseWindow implements Window {
  _QueuedCloseWindow({this.acceptClose = true});

  final bool acceptClose;
  bool disposed = false;
  bool nativeClosed = false;
  FutureOr<void> Function(WindowEvent)? listener;

  @override
  ListenerId addListener(FutureOr<void> Function(WindowEvent) callback) {
    listener = callback;
    return 1;
  }

  @override
  bool removeListener(ListenerId listenerId) {
    listener = null;
    return true;
  }

  @override
  bool close() => acceptClose;

  void runQueuedClose() {
    if (disposed) return;
    nativeClosed = true;
    listener?.call(const WindowClosedEvent(windowId: 1));
  }

  @override
  void dispose() => disposed = true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
