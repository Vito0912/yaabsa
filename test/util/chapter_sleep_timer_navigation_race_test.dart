import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/audio_handler/player_mutation_barrier.dart';
import 'package:yaabsa/util/handler/sleep_timer_target.dart';

void main() {
  test('chapter target follows an issued seek that lands after supersession', () async {
    final barrier = PlayerMutationBarrier();
    final seekLease = barrier.acquire();
    final seekIssued = Completer<void>();
    final backendSeek = Completer<Duration>();

    final seekResult = barrier.run<Duration>(seekLease, () async {
      seekIssued.complete();
      return backendSeek.future;
    });
    await seekIssued.future;

    final pauseLease = barrier.acquire();
    backendSeek.complete(const Duration(seconds: 90));

    final landedPosition = await seekResult;
    expect(landedPosition, const Duration(seconds: 90));
    expect(barrier.isCurrent(seekLease), isFalse);
    expect(barrier.isCurrent(pauseLease), isTrue);

    const previousTarget = ChapterSleepTarget(itemId: 'book-1', episodeId: null, endPosition: Duration(seconds: 60));
    final settledTarget = resolveChapterSleepTarget(
      chapters: const [
        InternalChapter(start: 0, end: 60, title: 'Chapter 1'),
        InternalChapter(start: 60, end: 120, title: 'Chapter 2'),
      ],
      mediaDuration: const Duration(seconds: 120),
      position: landedPosition!,
      itemId: 'book-1',
      episodeId: null,
    );

    expect(previousTarget.endPosition, const Duration(seconds: 60));
    expect(settledTarget?.endPosition, const Duration(seconds: 120));
  });

  test('sleep timer retargets after the last settled user navigation regardless of success hint', () {
    final source = File('lib/util/handler/sleep_timer_handler.dart').readAsStringSync();
    final start = source.indexOf('void _handleUserSeekNavigation(UserSeekNavigationEvent event)');
    final end = source.indexOf('void _resolveChapterTimerAfterUserNavigation(', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));

    final handler = source.substring(start, end);
    expect(handler, isNot(contains('event.shouldRetarget')));
    expect(handler, contains('_resolveChapterTimerAfterUserNavigation(_chapterRunGeneration);'));
  });

  test('confirmed landing reconciles track index before stale lease settlement', () {
    final source = File('lib/util/audio_handler/bg_audio_handler.dart').readAsStringSync();
    final start = source.indexOf('Future<void> _seekResolved(');
    final end = source.indexOf('bool _isSeekOwnershipCurrent(', start);

    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));

    final seekBody = source.substring(start, end);
    final responseAwait = seekBody.indexOf('final seekResult = await _playerMutationBarrier.run<SeekConfirmationResult>');
    final staleOwnershipReturn = seekBody.indexOf(
      'if (!_isSeekOwnershipCurrent(lease, seekGeneration, mediaKey))',
      responseAwait,
    );
    final reconciliation = seekBody.indexOf('_currentTrackIndex = actualIndex;', responseAwait);

    expect(responseAwait, greaterThanOrEqualTo(0));
    expect(reconciliation, greaterThan(responseAwait));
    expect(staleOwnershipReturn, greaterThan(reconciliation));
    expect(seekBody, contains('final audioSourceGeneration = _audioSourceGeneration;'));
    expect(seekBody, contains('audioSourceGeneration == _audioSourceGeneration'));
    expect(seekBody, contains('seekGeneration == _seekGeneration'));
    expect(seekBody, contains('identical(_currentMediaItem, media)'));
  });
}
