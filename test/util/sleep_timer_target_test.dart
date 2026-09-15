import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/handler/sleep_timer_target.dart';

void main() {
  group('resolveChapterSleepTarget', () {
    test('resolves the current chapter to an absolute media target', () {
      final target = resolveChapterSleepTarget(
        chapters: const [
          InternalChapter(start: 600, end: 1200, title: 'Chapter 1'),
          InternalChapter(start: 1200, end: 1860, title: 'Chapter 2'),
        ],
        mediaDuration: const Duration(minutes: 40),
        position: const Duration(minutes: 15),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target, isNotNull);
      expect(target!.endPosition, const Duration(minutes: 20));
      expect(target.remainingAt(const Duration(minutes: 17)), const Duration(minutes: 3));
      expect(target.matchesMedia(itemId: 'book-1', episodeId: null), isTrue);
    });

    test('allows one chapter spanning the whole audiobook', () {
      final target = resolveChapterSleepTarget(
        chapters: const [InternalChapter(start: 0, end: 34200, title: 'Book')],
        mediaDuration: const Duration(hours: 9, minutes: 30),
        position: const Duration(hours: 2),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target?.endPosition, const Duration(hours: 9, minutes: 30));
    });

    test('allows a very short remaining distance', () {
      final target = resolveChapterSleepTarget(
        chapters: const [InternalChapter(start: 0, end: 10, title: 'Short')],
        mediaDuration: const Duration(seconds: 20),
        position: const Duration(seconds: 9, milliseconds: 900),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target?.remainingAt(const Duration(seconds: 9, milliseconds: 900)), const Duration(milliseconds: 100));
    });

    test('uses the following chapter at a shared boundary', () {
      final target = resolveChapterSleepTarget(
        chapters: const [
          InternalChapter(start: 0, end: 10, title: 'Chapter 1'),
          InternalChapter(start: 10, end: 20, title: 'Chapter 2'),
        ],
        mediaDuration: const Duration(seconds: 30),
        position: const Duration(seconds: 10),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target?.endPosition, const Duration(seconds: 20));
    });

    test('does not start at the final chapter end', () {
      final target = resolveChapterSleepTarget(
        chapters: const [InternalChapter(start: 0, end: 10, title: 'Chapter 1')],
        mediaDuration: const Duration(seconds: 10),
        position: const Duration(seconds: 10),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target, isNull);
    });

    test('returns null without chapters or inside a chapter gap', () {
      expect(
        resolveChapterSleepTarget(
          chapters: const [],
          mediaDuration: const Duration(seconds: 30),
          position: const Duration(seconds: 5),
          itemId: 'book-1',
          episodeId: null,
        ),
        isNull,
      );

      expect(
        resolveChapterSleepTarget(
          chapters: const [
            InternalChapter(start: 0, end: 10, title: 'Chapter 1'),
            InternalChapter(start: 15, end: 20, title: 'Chapter 2'),
          ],
          mediaDuration: const Duration(seconds: 30),
          position: const Duration(seconds: 12),
          itemId: 'book-1',
          episodeId: null,
        ),
        isNull,
      );
    });

    test('rejects ambiguous overlapping chapters at the current position', () {
      final target = resolveChapterSleepTarget(
        chapters: const [
          InternalChapter(start: 0, end: 20, title: 'Chapter 1'),
          InternalChapter(start: 10, end: 30, title: 'Chapter 2'),
        ],
        mediaDuration: const Duration(seconds: 40),
        position: const Duration(seconds: 15),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target, isNull);
    });

    test('rejects a malformed chapter containing the current position', () {
      final target = resolveChapterSleepTarget(
        chapters: const [InternalChapter(start: -5, end: 10, title: 'Broken')],
        mediaDuration: const Duration(seconds: 30),
        position: const Duration(seconds: 5),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target, isNull);
    });

    test('rejects non-finite and out-of-bounds current chapter metadata', () {
      final infiniteTarget = resolveChapterSleepTarget(
        chapters: const [InternalChapter(start: 0, end: double.infinity, title: 'Broken')],
        mediaDuration: const Duration(seconds: 30),
        position: const Duration(seconds: 5),
        itemId: 'book-1',
        episodeId: null,
      );
      final outOfBoundsTarget = resolveChapterSleepTarget(
        chapters: const [InternalChapter(start: 0, end: 31, title: 'Broken')],
        mediaDuration: const Duration(seconds: 30),
        position: const Duration(seconds: 5),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(infiniteTarget, isNull);
      expect(outOfBoundsTarget, isNull);
    });

    test('rejects double-non-finite intervals because overlap cannot be excluded', () {
      const malformedIntervals = [
        InternalChapter(start: double.nan, end: double.nan, title: 'NaN/NaN'),
        InternalChapter(start: double.negativeInfinity, end: double.infinity, title: '-Inf/+Inf'),
        InternalChapter(start: double.infinity, end: double.negativeInfinity, title: '+Inf/-Inf'),
      ];

      for (final malformed in malformedIntervals) {
        final target = resolveChapterSleepTarget(
          chapters: [
            const InternalChapter(start: 0, end: 10, title: 'Chapter 1'),
            malformed,
          ],
          mediaDuration: const Duration(seconds: 30),
          position: const Duration(seconds: 5),
          itemId: 'book-1',
          episodeId: null,
        );

        expect(target, isNull, reason: malformed.title);
      }
    });

    test('does not reject malformed chapters proven to be elsewhere in the book', () {
      final target = resolveChapterSleepTarget(
        chapters: const [
          InternalChapter(start: 0, end: 10, title: 'Chapter 1'),
          InternalChapter(start: double.nan, end: 2, title: 'Broken earlier'),
          InternalChapter(start: 20, end: double.infinity, title: 'Broken later'),
        ],
        mediaDuration: const Duration(seconds: 30),
        position: const Duration(seconds: 5),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target?.endPosition, const Duration(seconds: 10));
    });

    test('rejects a malformed interval that could overlap the valid current chapter', () {
      final target = resolveChapterSleepTarget(
        chapters: const [
          InternalChapter(start: 0, end: 10, title: 'Chapter 1'),
          InternalChapter(start: 2, end: double.infinity, title: 'Broken overlap'),
        ],
        mediaDuration: const Duration(seconds: 30),
        position: const Duration(seconds: 5),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target, isNull);
    });

    test('ignores a malformed interval that starts after the current position', () {
      final target = resolveChapterSleepTarget(
        chapters: const [
          InternalChapter(start: 0, end: 10, title: 'Chapter 1'),
          InternalChapter(start: 20, end: double.infinity, title: 'Broken later'),
        ],
        mediaDuration: const Duration(seconds: 30),
        position: const Duration(seconds: 5),
        itemId: 'book-1',
        episodeId: null,
      );

      expect(target?.endPosition, const Duration(seconds: 10));
    });

    test('preserves podcast episode identity', () {
      final target = resolveChapterSleepTarget(
        chapters: const [InternalChapter(start: 0, end: 10, title: 'Episode chapter')],
        mediaDuration: const Duration(seconds: 20),
        position: const Duration(seconds: 5),
        itemId: 'podcast-1',
        episodeId: 'episode-7',
      );

      expect(target, isNotNull);
      expect(target!.matchesMedia(itemId: 'podcast-1', episodeId: 'episode-7'), isTrue);
      expect(target.matchesMedia(itemId: 'podcast-1', episodeId: 'episode-8'), isFalse);
    });

    test('remainingAt clamps positions beyond the target to zero', () {
      const target = ChapterSleepTarget(itemId: 'book-1', episodeId: null, endPosition: Duration(seconds: 10));

      expect(target.remainingAt(const Duration(seconds: 12)), Duration.zero);
    });
  });
}
