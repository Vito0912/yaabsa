import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/audio_handler/player_mutation_barrier.dart';

void main() {
  group('PlayerMutationBarrier', () {
    test('a newer lease invalidates queued work before it is issued', () async {
      final barrier = PlayerMutationBarrier();
      final first = barrier.acquire();
      final blocker = Completer<void>();
      final firstIssued = Completer<void>();

      final running = barrier.run(first, () async {
        firstIssued.complete();
        await blocker.future;
      });
      await firstIssued.future;

      final stale = barrier.acquire();
      final staleResult = barrier.run(stale, () async => 1);
      final current = barrier.acquire();
      final currentResult = barrier.run(current, () async => 2);

      blocker.complete();
      await running;

      expect(await staleResult, isNull);
      expect(await currentResult, 2);
    });

    test('a newer mutation waits for an already issued mutation to drain', () async {
      final barrier = PlayerMutationBarrier();
      final first = barrier.acquire();
      final blocker = Completer<void>();
      final firstIssued = Completer<void>();
      var secondIssued = false;

      final firstRun = barrier.run(first, () async {
        firstIssued.complete();
        await blocker.future;
      });
      await firstIssued.future;

      final second = barrier.acquire();
      final secondRun = barrier.run(second, () async {
        secondIssued = true;
      });

      expect(secondIssued, isFalse);
      expect(first.isInvalidated, isTrue);
      await expectLater(first.invalidated, completes);

      blocker.complete();
      await firstRun;
      await secondRun;
      expect(secondIssued, isTrue);
    });

    test('an already issued mutation keeps its result after lease invalidation', () async {
      final barrier = PlayerMutationBarrier();
      final first = barrier.acquire();
      final blocker = Completer<void>();
      final firstIssued = Completer<void>();

      final firstRun = barrier.run(first, () async {
        firstIssued.complete();
        await blocker.future;
        return 7;
      });
      await firstIssued.future;

      final second = barrier.acquire();
      expect(first.isInvalidated, isTrue);

      blocker.complete();

      expect(await firstRun, 7);
      expect(barrier.isCurrent(first), isFalse);
      expect(barrier.isCurrent(second), isTrue);
    });

    test('explicit invalidation wakes lease waiters exactly once', () async {
      final barrier = PlayerMutationBarrier();
      final lease = barrier.acquire();
      var wakeups = 0;
      lease.invalidated.then((_) => wakeups += 1);

      expect(barrier.invalidate(lease), isTrue);
      expect(barrier.invalidate(lease), isFalse);
      await lease.invalidated;

      expect(lease.isInvalidated, isTrue);
      expect(wakeups, 1);
    });

    test('failed mutations do not poison the drain chain', () async {
      final barrier = PlayerMutationBarrier();
      final first = barrier.acquire();

      await expectLater(barrier.run<void>(first, () async => throw StateError('boom')), throwsStateError);

      final second = barrier.acquire();
      expect(await barrier.run(second, () async => 7), 7);
      await barrier.drained;
    });

    test('deferred guard requires the original lease and playback context', () {
      final barrier = PlayerMutationBarrier();
      final lease = barrier.acquire();
      final guard = DeferredPlayerMutationGuard(
        lease: lease,
        playbackContextGeneration: 4,
        seekGeneration: 7,
        mediaKey: 'book-a:item',
      );

      expect(
        guard.isCurrent(barrier: barrier, playbackContextGeneration: 4, seekGeneration: 7, mediaKey: 'book-a:item'),
        isTrue,
      );
      expect(
        guard.isCurrent(barrier: barrier, playbackContextGeneration: 5, seekGeneration: 7, mediaKey: 'book-a:item'),
        isFalse,
      );
      expect(
        guard.isCurrent(barrier: barrier, playbackContextGeneration: 4, seekGeneration: 8, mediaKey: 'book-a:item'),
        isFalse,
      );
      expect(
        guard.isCurrent(barrier: barrier, playbackContextGeneration: 4, seekGeneration: 7, mediaKey: 'book-b:item'),
        isFalse,
      );

      final newer = barrier.acquire();
      expect(
        guard.isCurrent(barrier: barrier, playbackContextGeneration: 4, seekGeneration: 7, mediaKey: 'book-a:item'),
        isFalse,
      );
      expect(barrier.currentLease, same(newer));
    });

    test('deferred work cannot reacquire authority after a newer command', () async {
      final barrier = PlayerMutationBarrier();
      final original = barrier.acquire();
      final guard = DeferredPlayerMutationGuard(
        lease: original,
        playbackContextGeneration: 2,
        seekGeneration: 3,
        mediaKey: 'book-a:item',
      );
      final releaseDeferredWork = Completer<void>();
      var staleMutationIssued = false;

      final deferredWork = () async {
        await releaseDeferredWork.future;
        if (!guard.isCurrent(
          barrier: barrier,
          playbackContextGeneration: 2,
          seekGeneration: 3,
          mediaKey: 'book-a:item',
        )) {
          return;
        }
        await barrier.run<void>(guard.lease, () async {
          staleMutationIssued = true;
        });
      }();

      final newer = barrier.acquire();
      releaseDeferredWork.complete();
      await deferredWork;

      expect(staleMutationIssued, isFalse);
      expect(original.isInvalidated, isTrue);
      expect(barrier.currentLease, same(newer));
      expect(barrier.isCurrent(newer), isTrue);
    });
  });
}
