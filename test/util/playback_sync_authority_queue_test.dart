import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/audio_handler/playback_sync_authority_queue.dart';

void main() {
  test('online A/B race delivers A listening time once and leaves B position authoritative', () async {
    final queue = PlaybackSyncAuthorityQueue();
    final firstStarted = Completer<void>();
    final releaseFirst = Completer<void>();
    var callCount = 0;
    var serverPosition = Duration.zero;
    var serverListening = 0.0;

    Future<bool> dispatch({required Duration position, required double listenedTime, required String sessionId}) async {
      if (callCount++ == 0) {
        firstStarted.complete();
        await releaseFirst.future;
      }
      serverPosition = position;
      serverListening += listenedTime;
      return true;
    }

    final a = queue.enqueue(
      position: const Duration(seconds: 10),
      listenedTime: 5,
      sessionId: 'session',
      dispatch: dispatch,
    );
    await firstStarted.future;

    final b = queue.correct(position: const Duration(seconds: 80), sessionId: 'session', dispatch: dispatch);
    releaseFirst.complete();

    expect(await a, isTrue);
    expect(await b, isTrue);
    expect(serverListening, 5);
    expect(serverPosition, const Duration(seconds: 80));
    expect(callCount, greaterThanOrEqualTo(3));
  });

  test('offline A/B race accumulates A time while zero-time B replaces position', () async {
    final queue = PlaybackSyncAuthorityQueue();
    final firstStarted = Completer<void>();
    final releaseFirst = Completer<void>();
    var callCount = 0;
    var storedPosition = Duration.zero;
    var storedListening = 0.0;

    Future<bool> store({required Duration position, required double listenedTime, required String sessionId}) async {
      if (callCount++ == 0) {
        firstStarted.complete();
        await releaseFirst.future;
      }
      storedListening += listenedTime;
      storedPosition = position;
      return true;
    }

    final a = queue.enqueue(
      position: const Duration(seconds: 12),
      listenedTime: 7,
      sessionId: 'session',
      dispatch: store,
    );
    await firstStarted.future;

    final b = queue.correct(position: const Duration(seconds: 65), sessionId: 'session', dispatch: store);
    releaseFirst.complete();

    expect(await a, isTrue);
    expect(await b, isTrue);
    expect(storedListening, 7);
    expect(storedPosition, const Duration(seconds: 65));
  });

  test('newest authoritative correction wins when confirmed seeks race', () async {
    final queue = PlaybackSyncAuthorityQueue();
    final firstStarted = Completer<void>();
    final releaseFirst = Completer<void>();
    var callCount = 0;
    var finalPosition = Duration.zero;

    Future<bool> dispatch({required Duration position, required double listenedTime, required String sessionId}) async {
      if (callCount++ == 0) {
        firstStarted.complete();
        await releaseFirst.future;
      }
      finalPosition = position;
      return true;
    }

    final a = queue.enqueue(
      position: const Duration(seconds: 5),
      listenedTime: 4,
      sessionId: 'session',
      dispatch: dispatch,
    );
    await firstStarted.future;
    final b = queue.correct(position: const Duration(seconds: 40), sessionId: 'session', dispatch: dispatch);
    final c = queue.correct(position: const Duration(seconds: 90), sessionId: 'session', dispatch: dispatch);
    releaseFirst.complete();

    await Future.wait([a, b, c]);
    expect(finalPosition, const Duration(seconds: 90));
  });

  test('historical replay keeps listening time but cannot replace newer live position', () async {
    final queue = PlaybackSyncAuthorityQueue();
    var finalPosition = Duration.zero;
    var totalListening = 0.0;

    Future<bool> dispatch({required Duration position, required double listenedTime, required String sessionId}) async {
      finalPosition = position;
      totalListening += listenedTime;
      return true;
    }

    expect(
      await queue.correct(position: const Duration(seconds: 60), sessionId: 'session', dispatch: dispatch),
      isTrue,
    );
    expect(
      await queue.enqueueHistorical(
        position: const Duration(seconds: 115),
        listenedTime: 55,
        sessionId: 'session',
        dispatch: dispatch,
      ),
      isTrue,
    );

    expect(totalListening, 55);
    expect(finalPosition, const Duration(seconds: 60));
  });

  test('live correction queued during an in-flight historical replay wins last', () async {
    final queue = PlaybackSyncAuthorityQueue();
    final replayStarted = Completer<void>();
    final releaseReplay = Completer<void>();
    var callCount = 0;
    var finalPosition = Duration.zero;
    var totalListening = 0.0;

    Future<bool> dispatch({required Duration position, required double listenedTime, required String sessionId}) async {
      if (callCount++ == 0) {
        replayStarted.complete();
        await releaseReplay.future;
      }
      finalPosition = position;
      totalListening += listenedTime;
      return true;
    }

    final replay = queue.enqueueHistorical(
      position: const Duration(seconds: 115),
      listenedTime: 55,
      sessionId: 'session',
      dispatch: dispatch,
    );
    await replayStarted.future;

    final correction = queue.correct(
      position: const Duration(seconds: 60),
      sessionId: 'session',
      dispatch: dispatch,
    );
    releaseReplay.complete();

    expect(await replay, isTrue);
    expect(await correction, isTrue);
    expect(totalListening, 55);
    expect(finalPosition, const Duration(seconds: 60));
  });
}
