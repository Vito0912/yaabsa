import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart' show PlaybackPreferenceGuard;

void main() {
  group('PlaybackPreferenceGuard', () {
    test('queued stale speed mutation is suppressed before it reaches the player', () async {
      final guard = PlaybackPreferenceGuard();
      final effects = <String>[];

      final staleRevision = guard.beginSpeedMutation();
      final staleMutation = guard.runSpeedMutation(staleRevision, () async {
        effects.add('stale');
      });

      final currentRevision = guard.beginSpeedMutation();
      final currentMutation = guard.runSpeedMutation(currentRevision, () async {
        effects.add('current');
      });

      expect(await staleMutation, isFalse);
      expect(await currentMutation, isTrue);
      expect(effects, ['current']);
    });

    test('a newer speed mutation is serialized after an already-running older mutation', () async {
      final guard = PlaybackPreferenceGuard();
      final firstStarted = Completer<void>();
      final releaseFirst = Completer<void>();
      final effects = <String>[];

      final firstRevision = guard.beginSpeedMutation();
      final firstMutation = guard.runSpeedMutation(firstRevision, () async {
        effects.add('first-start');
        firstStarted.complete();
        await releaseFirst.future;
        effects.add('first-end');
      });

      await firstStarted.future;

      final secondRevision = guard.beginSpeedMutation();
      final secondMutation = guard.runSpeedMutation(secondRevision, () async {
        effects.add('second');
      });

      releaseFirst.complete();

      expect(await firstMutation, isTrue);
      expect(await secondMutation, isTrue);
      expect(effects, ['first-start', 'first-end', 'second']);
    });

    test('stale speed persistence is dropped before writing', () async {
      final guard = PlaybackPreferenceGuard();
      final writes = <String>[];

      final staleRevision = guard.beginSpeedMutation();
      final currentRevision = guard.beginSpeedMutation();

      final stalePersistence = guard.enqueueSpeedPersistence(staleRevision, () async {
        writes.add('stale');
      });
      final currentPersistence = guard.enqueueSpeedPersistence(currentRevision, () async {
        writes.add('current');
      });

      expect(await stalePersistence, isFalse);
      expect(await currentPersistence, isTrue);
      expect(writes, ['current']);
    });

    test('volume mutations are independent from a blocked speed mutation', () async {
      final guard = PlaybackPreferenceGuard();
      final speedStarted = Completer<void>();
      final releaseSpeed = Completer<void>();
      var volumeApplied = false;

      final speedRevision = guard.beginSpeedMutation();
      final speedMutation = guard.runSpeedMutation(speedRevision, () async {
        speedStarted.complete();
        await releaseSpeed.future;
      });

      await speedStarted.future;

      final volumeRevision = guard.beginVolumeMutation();
      final volumeMutation = guard.runVolumeMutation(volumeRevision, () async {
        volumeApplied = true;
      });

      expect(await volumeMutation, isTrue);
      expect(volumeApplied, isTrue);

      releaseSpeed.complete();
      expect(await speedMutation, isTrue);
    });
  });
}
