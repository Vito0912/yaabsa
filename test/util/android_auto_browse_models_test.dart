import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/stats/library_stats.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/items_in_progress.dart';
import 'package:yaabsa/util/audio_handler/auto/android_auto_browse_models.dart';

void main() {
  group('filterAndroidAutoLibraries', () {
    test('includes book and podcast libraries with audio', () {
      final libraries = <Library>[
        _library('book-audio', mediaType: 'book', numAudioFiles: 5),
        _library('podcast-audio', mediaType: 'podcast', numAudioFiles: 10),
      ];

      expect(filterAndroidAutoLibraries(libraries).map((library) => library.id), ['book-audio', 'podcast-audio']);
    });

    test('excludes empty, unsupported, and missing-stat libraries', () {
      final libraries = <Library>[
        _library('book-empty', mediaType: 'book', numAudioFiles: 0),
        _library('podcast-empty', mediaType: 'podcast', numAudioFiles: 0),
        _library('unsupported', mediaType: 'comic', numAudioFiles: 5),
        _library('missing-stats', mediaType: 'book'),
      ];

      expect(filterAndroidAutoLibraries(libraries), isEmpty);
    });
  });

  group('buildAndroidAutoRoot', () {
    test('hides Continue when the successful result is empty', () {
      final snapshot = AndroidAutoBrowseSnapshot(
        continueItems: const <MediaItem>[],
        audioLibraries: [_library('book-audio', numAudioFiles: 1)],
      );

      expect(buildAndroidAutoRoot(snapshot).map((item) => item.title), ['Libraries', 'Recent']);
    });

    test('shows Continue only when it has playable items', () {
      final snapshot = AndroidAutoBrowseSnapshot(
        continueItems: const [MediaItem(id: 'book-1', title: 'Book 1', playable: true)],
        audioLibraries: [_library('book-audio', numAudioFiles: 1)],
      );

      expect(buildAndroidAutoRoot(snapshot).map((item) => item.title), ['Continue', 'Libraries', 'Recent']);
    });

    test('can show Continue without libraries', () {
      final snapshot = AndroidAutoBrowseSnapshot(
        continueItems: const [MediaItem(id: 'book-1', title: 'Book 1', playable: true)],
        audioLibraries: const <Library>[],
      );

      expect(buildAndroidAutoRoot(snapshot).map((item) => item.title), ['Continue']);
    });

    test('does not create fake server-backed nodes for an empty snapshot', () {
      final snapshot = AndroidAutoBrowseSnapshot(continueItems: const <MediaItem>[], audioLibraries: const <Library>[]);

      expect(buildAndroidAutoRoot(snapshot), isEmpty);
    });
  });

  group('items-in-progress transformation', () {
    test('parses the libraryItems response and preserves server order', () {
      final response = ItemsInProgress.fromJson({
        'libraryItems': [_libraryItemJson('book-1'), _libraryItemJson('book-2')],
      });

      expect(response.libraryItems.map((item) => item.id), ['book-1', 'book-2']);
    });

    test('maps podcast recentEpisode and drops podcast containers and unplayable items', () {
      final items = <LibraryItem>[
        _libraryItem('book-1'),
        _libraryItem('podcast-1', mediaType: 'podcast', recentEpisode: _episode('episode-1')),
        _libraryItem('podcast-container', mediaType: 'podcast'),
        _libraryItem('unplayable'),
      ];

      final mapped = mapAndroidAutoContinueItems<String>(
        items,
        mapAudiobook: (item) => item.id == 'unplayable' ? null : 'book:${item.id}',
        mapPodcastEpisode: (item, episode) => 'episode:${episode.id}',
        idOf: (source, episode, item) => episode == null ? item : '${source.id}:${episode.id}',
      );

      expect(mapped, ['book:book-1', 'episode:episode-1']);
    });
  });

  group('AndroidAutoBrowseSnapshotCache', () {
    test('uses one in-flight load and caches a successful result', () async {
      final cache = AndroidAutoBrowseSnapshotCache();
      var calls = 0;
      final completer = Future<AndroidAutoBrowseSnapshot>.value(_snapshot('first'));

      Future<AndroidAutoBrowseSnapshot> load(int generation) async {
        calls += 1;
        return completer;
      }

      final first = cache.getSnapshot(load);
      final second = cache.getSnapshot(load);
      expect(await first, same(await second));
      expect(calls, 1);
      expect(await cache.getSnapshot(load), same(await first));
      expect(calls, 1);
    });

    test('invalidating the cache requests fresh data', () async {
      final cache = AndroidAutoBrowseSnapshotCache();
      var calls = 0;

      Future<AndroidAutoBrowseSnapshot> load(int generation) async {
        calls += 1;
        return _snapshot('snapshot-$calls');
      }

      await cache.getSnapshot(load);
      cache.invalidate();
      await cache.getSnapshot(load);

      expect(calls, 2);
      expect(cache.generation, 1);
    });

    test('preserves the last successful snapshot when a refresh fails', () async {
      final cache = AndroidAutoBrowseSnapshotCache();
      var shouldFail = false;

      Future<AndroidAutoBrowseSnapshot> load(int generation) async {
        if (shouldFail) {
          throw StateError('offline');
        }
        return _snapshot('cached');
      }

      final first = await cache.getSnapshot(load);
      shouldFail = true;
      final refreshed = await cache.getSnapshot(load, forceRefresh: true);

      expect(refreshed, same(first));
      expect(cache.state, isA<AndroidAutoBrowseFailure<AndroidAutoBrowseSnapshot>>());
    });

    test('does not publish a stale generation', () async {
      final cache = AndroidAutoBrowseSnapshotCache();
      final completer = Completer<AndroidAutoBrowseSnapshot>();

      final oldRequest = cache.getSnapshot((generation) => completer.future);
      cache.invalidate();
      final newRequest = cache.getSnapshot((generation) async => _snapshot('new'));

      expect((await newRequest).continueItems.single.id, 'new');
      completer.complete(_snapshot('old'));
      await expectLater(oldRequest, throwsA(isA<AndroidAutoBrowseStaleRequestException>()));
      expect(cache.snapshot?.continueItems.single.id, 'new');
    });
  });

  group('AndroidAutoBrowseResult', () {
    test('distinguishes initialization, auth, failure, and successful empty data', () {
      expect(const AndroidAutoBrowseInitializing<List<String>>(), isA<AndroidAutoBrowseInitializing<List<String>>>());
      expect(const AndroidAutoBrowseAuthRequired<List<String>>(), isA<AndroidAutoBrowseAuthRequired<List<String>>>());
      expect(
        const AndroidAutoBrowseFailure<List<String>>('error', StackTrace.empty),
        isA<AndroidAutoBrowseFailure<List<String>>>(),
      );
      expect(const AndroidAutoBrowseReady<List<String>>([]), isA<AndroidAutoBrowseReady<List<String>>>());
    });
  });
}

Library _library(String id, {String mediaType = 'book', int? numAudioFiles}) {
  return Library(
    id: id,
    name: id,
    displayOrder: 0,
    icon: 'book',
    mediaType: mediaType,
    provider: 'test',
    createdAt: 0,
    settings: LibrarySettings(),
    stats: numAudioFiles == null ? null : LibraryStats(numAudioFiles: numAudioFiles),
  );
}

LibraryItem _libraryItem(String id, {String? mediaType, Episode? recentEpisode}) {
  return LibraryItem(
    id: id,
    ino: 'ino-$id',
    mediaType: mediaType,
    media: null,
    libraryFiles: null,
    recentEpisode: recentEpisode,
  );
}

Map<String, dynamic> _libraryItemJson(String id) {
  return <String, dynamic>{'id': id, 'ino': 'ino-$id', 'media': null, 'libraryFiles': null};
}

Episode _episode(String id) {
  return Episode(libraryItemId: 'podcast-1', id: id);
}

AndroidAutoBrowseSnapshot _snapshot(String id) {
  return AndroidAutoBrowseSnapshot(
    continueItems: [MediaItem(id: id, title: id, playable: true)],
    audioLibraries: const <Library>[],
  );
}
