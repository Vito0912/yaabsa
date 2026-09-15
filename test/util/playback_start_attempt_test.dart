import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/audio_handler/playback_start_attempt.dart';
import 'package:yaabsa/util/audio_handler/player_mutation_barrier.dart';

void main() {
  group('PlaybackStartAttemptLedger', () {
    test('currentness binds exact lease, source generation, and reservation', () {
      final barrier = PlayerMutationBarrier();
      final lease = barrier.acquire();
      final ledger = PlaybackStartAttemptLedger();
      final reservations = <String>{'q1'};
      final attempt = ledger.begin(lease: lease, sourceGeneration: 7, reservedQueueEntryId: 'q1');

      bool current({int generation = 7, bool disposing = false}) => ledger.isCurrent(
        attempt,
        barrier: barrier,
        currentSourceGeneration: generation,
        isDisposing: disposing,
        reservationIsCurrent: reservations.contains,
      );

      expect(current(), isTrue);
      expect(current(generation: 8), isFalse);
      expect(current(disposing: true), isFalse);
      reservations.clear();
      expect(current(), isFalse);
    });

    test('newer attempt supersedes older attempt', () {
      final barrier = PlayerMutationBarrier();
      final ledger = PlaybackStartAttemptLedger();
      final first = ledger.begin(lease: barrier.acquire(), sourceGeneration: 1);
      final second = ledger.begin(lease: barrier.acquire(), sourceGeneration: 1);

      expect(first.status, PlaybackStartAttemptStatus.superseded);
      expect(first.isPending, isFalse);
      expect(identical(ledger.active, second), isTrue);
    });

    test('every non-start terminal releases the active attempt', () {
      for (final status in const [
        PlaybackStartAttemptStatus.superseded,
        PlaybackStartAttemptStatus.rejected,
        PlaybackStartAttemptStatus.failed,
        PlaybackStartAttemptStatus.unsupported,
      ]) {
        final barrier = PlayerMutationBarrier();
        final ledger = PlaybackStartAttemptLedger();
        final attempt = ledger.begin(lease: barrier.acquire(), sourceGeneration: 1);
        expect(ledger.settle(attempt, status), isTrue);
        expect(attempt.status, status);
        expect(ledger.active, isNull);
      }
    });

    test('stale reservation cannot be authorized by backend success', () {
      final barrier = PlayerMutationBarrier();
      final lease = barrier.acquire();
      final ledger = PlaybackStartAttemptLedger();
      final attempt = ledger.begin(lease: lease, sourceGeneration: 2, reservedQueueEntryId: 'q42');

      expect(
        ledger.isCurrent(
          attempt,
          barrier: barrier,
          currentSourceGeneration: 2,
          isDisposing: false,
          reservationIsCurrent: (_) => false,
        ),
        isFalse,
      );
    });
  });

  test('backend wait is interrupted by a newer lease without serializing the mutation barrier', () async {
    final barrier = PlayerMutationBarrier();
    final oldLease = barrier.acquire();
    final backend = Completer<String>();
    final waiting = awaitPlaybackStartOrLeaseInvalidated<String>(
      lease: oldLease,
      backendResult: backend.future,
      supersededValue: 'superseded',
    );

    final newerLease = barrier.acquire();
    var newerMutationRan = false;
    await barrier.run<void>(newerLease, () async {
      newerMutationRan = true;
    });

    expect(newerMutationRan, isTrue);
    expect(await waiting, 'superseded');
    backend.complete('started');
  });

  test('handler waits for backend confirmation outside the player mutation barrier', () {
    final source = File('lib/util/audio_handler/bg_audio_handler_playback_internal.dart').readAsStringSync();
    final start = source.indexOf('Future<PlaybackStartResult> _syncedPlay(');
    final end = source.indexOf('Future<void> _reconcileResumeProgressInBackground(', start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final method = source.substring(start, end);
    expect(method, contains('_player.waitForPlaybackStart()'));
    expect(method, contains('awaitPlaybackStartOrLeaseInvalidated'));
    expect(method, isNot(contains('_playerMutationBarrier.run')));
  });

  test('queue consumption is guarded by exact reservation and confirmed start', () {
    final source = File('lib/util/audio_handler/bg_audio_handler.dart').readAsStringSync();
    expect(source, contains('reservedQueueEntryId: matchingCurrentQueueEntry?.id'));
    expect(source, contains('reservedQueueEntryId: nextEntry?.id'));
    expect(RegExp(r'if \(!attemptCurrent \|\| !startResult\.started\)').allMatches(source).length, 2);

    final currentStart = source.indexOf('reservedQueueEntryId: matchingCurrentQueueEntry?.id');
    final currentRemove = source.indexOf('queueList.removeAt(matchingIndex)', currentStart);
    expect(currentRemove, greaterThan(currentStart));

    final queuedStart = source.indexOf('reservedQueueEntryId: nextEntry?.id');
    final queuedRemove = source.indexOf('queueList.removeAt(reservedIndex)', queuedStart);
    expect(queuedRemove, greaterThan(queuedStart));
  });
}
