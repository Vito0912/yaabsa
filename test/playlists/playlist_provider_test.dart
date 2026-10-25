import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';

import 'playlist_test_support.dart';

void main() {
  test('a change arriving during removal validation aborts the save', () async {
    final server = PlaylistTestServer([
      playlist('a', items: [bookEntry, otherEntry]),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    final gate = Completer<void>();
    final readStarted = Completer<void>();
    server.beforeRead = () {
      if (!readStarted.isCompleted) readStarted.complete();
      return gate.future;
    };
    final notifier = container.read(playlistsProvider('library').notifier);
    final save = notifier.updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {});
    final rejected = expectLater(save, throwsException);
    await readStarted.future;
    server.playlists[0] = playlist('a', items: [bookEntry], revision: 2);
    final changed = notifier.refresh(withLoading: false, invalidatePending: true);
    gate.complete();
    await Future.wait([rejected, changed]);
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
    expect(container.read(playlistsProvider('library')).requireValue.items.single.lastUpdate, 2);
  });

  test('a server change invalidates an older refresh and coalesces subsequent refreshes', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await container.read(playlistsProvider('library').future);
    final gate = Completer<void>();
    final readStarted = Completer<void>();
    server.beforeRead = () {
      if (!readStarted.isCompleted) readStarted.complete();
      return gate.future;
    };
    final notifier = container.read(playlistsProvider('library').notifier);
    server.requests.clear();
    final oldRefresh = notifier.refresh(withLoading: false);
    await readStarted.future;
    server.playlists[0] = playlist('a', items: [bookEntry, otherEntry], revision: 2);
    final changed = notifier.refresh(withLoading: false, invalidatePending: true);
    final repeated = notifier.refresh(withLoading: false, invalidatePending: true);
    gate.complete();
    await Future.wait([oldRefresh, changed, repeated]);
    expect(container.read(playlistsProvider('library')).requireValue.items.single.lastUpdate, 2);
    expect(server.requests, hasLength(2));
  });

  test('disposing during background synchronization does not cause an unhandled error', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    final original = await container.read(playlistsProvider('library').future);
    final gate = Completer<void>();
    server.beforeRead = () => gate.future;
    final notifier = container.read(playlistsProvider('library').notifier);
    await notifier.updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'a'});
    final background = notifier.refresh(withLoading: false, requireServer: true);
    container.dispose();
    gate.complete();
    await background;
  });

  test('another user\'s playlist cannot be edited', () async {
    final server = PlaylistTestServer([playlist('foreign', userId: 'someone')]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    server.requests.clear();
    await expectLater(
      container
          .read(playlistsProvider('library').notifier)
          .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'foreign'}),
      throwsException,
    );
    expect(server.requests, isEmpty);
  });

  test('removal preserves other entries and their order', () async {
    const episode = PlaylistItem(itemId: 'podcast', episodeId: 'episode');
    final server = PlaylistTestServer([
      playlist('a', items: [episode, bookEntry, otherEntry]),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    await container
        .read(playlistsProvider('library').notifier)
        .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {});
    expect(server.playlists.single.items, [episode, otherEntry]);
    expect(server.requests.singleWhere((request) => request.method == 'POST').data, {
      'items': [
        {'libraryItemId': 'book', 'episodeId': null},
      ],
    });
  });

  test('existing podcast episode additions retain episode IDs', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await container.read(playlistsProvider('library').future);
    await container
        .read(playlistsProvider('library').notifier)
        .addPodcastEpisodesToPlaylist('a', libraryItemId: 'podcast', episodeIds: ['ep1', 'ep2']);
    expect(server.playlists.single.items, [
      const PlaylistItem(itemId: 'podcast', episodeId: 'ep1'),
      const PlaylistItem(itemId: 'podcast', episodeId: 'ep2'),
    ]);
  });

  test('applies multiple edits and synchronizes once after the batch', () async {
    final server = PlaylistTestServer([
      playlist('remove', items: [bookEntry, otherEntry]),
      playlist('add'),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    server.requests.clear();
    await container
        .read(playlistsProvider('library').notifier)
        .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'add'});
    expect(server.requests.map((request) => request.uri.path), [
      '/api/playlists',
      '/api/playlists/add/batch/add',
      '/api/playlists/remove/batch/remove',
      '/api/playlists',
    ]);
    expect(
      server.requests
          .where((request) => request.method == 'GET')
          .every((request) => request.extra['noCache'] == true && request.extra['skipCacheOnError'] == true),
      isTrue,
    );
    final state = container.read(playlistsProvider('library')).requireValue;
    expect(state.items.singleWhere((item) => item.id == 'remove').items!.map((book) => book.itemId), ['other']);
    expect(state.items.singleWhere((item) => item.id == 'add').items!.map((book) => book.itemId), ['book']);
  });

  test('removing the book from its last playlist leaves no memberships', () async {
    final server = PlaylistTestServer([
      playlist('last', items: [bookEntry, otherEntry]),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    await container
        .read(playlistsProvider('library').notifier)
        .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {});
    expect(container.read(playlistsProvider('library')).requireValue.items.single.items, [otherEntry]);
  });

  test('a no-op does not request or mutate data', () async {
    final server = PlaylistTestServer([
      playlist('keep', items: [bookEntry]),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    server.requests.clear();
    await container
        .read(playlistsProvider('library').notifier)
        .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'keep'});
    expect(server.requests, isEmpty);
  });

  test('a concurrent edit aborts all writes and publishes fresh data', () async {
    final server = PlaylistTestServer([
      playlist('a', items: [bookEntry, otherEntry]),
      playlist('b'),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    server.playlists[0] = playlist('a', items: [bookEntry], revision: 2);
    await expectLater(
      container
          .read(playlistsProvider('library').notifier)
          .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'b'}),
      throwsException,
    );
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
    expect(container.read(playlistsProvider('library')).requireValue.items.first.lastUpdate, 2);
  });

  test('changes to untouched playlists are preserved', () async {
    final server = PlaylistTestServer([playlist('a'), playlist('b')]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    server.playlists[1] = playlist('b', items: [bookEntry], revision: 2);
    await container
        .read(playlistsProvider('library').notifier)
        .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'a'});
    expect(server.requests.where((request) => request.method == 'POST').map((request) => request.uri.path), [
      '/api/playlists/a/batch/add',
    ]);
    await container.read(playlistsProvider('library').notifier).refresh(withLoading: false, requireServer: true);
    expect(container.read(playlistsProvider('library')).requireValue.items.last.items, [bookEntry]);
  });

  test('deleted or incomplete targets abort the entire batch', () async {
    for (final deleted in [true, false]) {
      final server = PlaylistTestServer([
        playlist('a', items: [bookEntry, otherEntry]),
        playlist('b'),
      ]);
      final container = await server.container();
      addTearDown(container.dispose);
      final original = await container.read(playlistsProvider('library').future);
      if (deleted) {
        server.playlists.removeAt(0);
      } else {
        server.playlists[0] = playlist('a', items: null);
      }
      await expectLater(
        container
            .read(playlistsProvider('library').notifier)
            .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'b'}),
        throwsException,
      );
      expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
    }
  });

  test('preflight failure sends no removals', () async {
    final server = PlaylistTestServer([
      playlist('a', items: [bookEntry, otherEntry]),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    server.failReads = true;
    await expectLater(
      container
          .read(playlistsProvider('library').notifier)
          .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {}),
      throwsException,
    );
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
  });

  test('partial failure retains successful changes and reloads actual memberships', () async {
    final server = PlaylistTestServer([playlist('a'), playlist('b')])..failIds.add('b');
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    await expectLater(
      container
          .read(playlistsProvider('library').notifier)
          .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'a', 'b'}),
      throwsA(predicate((error) => error.toString().contains('1 of 2'))),
    );
    final state = container.read(playlistsProvider('library')).requireValue;
    expect(state.items[0].items, [bookEntry]);
    expect(state.items[1].items, isEmpty);
    expect(server.requests.where((request) => request.method == 'GET').length, 2);
  });

  test('background reconciliation failure retains a confirmed addition', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    server.beforeMutation = () async {
      server.failReads = true;
    };
    final notifier = container.read(playlistsProvider('library').notifier);
    await notifier.updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'a'});
    await notifier.refresh(withLoading: false, requireServer: true);
    final state = container.read(playlistsProvider('library')).requireValue;
    expect(state.items.single.items, [bookEntry]);
    expect(state.error, isNotNull);
  });

  test('an addition completes before background playlist synchronization', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    final gate = Completer<void>();
    server.beforeRead = () => gate.future;
    server.requests.clear();
    final notifier = container.read(playlistsProvider('library').notifier);
    await notifier
        .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'a'})
        .timeout(const Duration(seconds: 5));
    expect(container.read(playlistsProvider('library')).requireValue.items.single.items, [bookEntry]);
    expect(server.requests.first.method, 'POST');
    gate.complete();
    await notifier.refresh(withLoading: false, requireServer: true);
    expect(server.requests.where((request) => request.method == 'GET').length, 1);
  });

  test('concurrent additions to other books are preserved in the returned playlist', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    server.playlists[0] = playlist('a', items: [otherEntry], revision: 2);
    await container
        .read(playlistsProvider('library').notifier)
        .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'a'});
    expect(container.read(playlistsProvider('library')).requireValue.items.single.items, [otherEntry, bookEntry]);
    await container.read(playlistsProvider('library').notifier).refresh(withLoading: false, requireServer: true);
  });

  test('overlapping equivalent refreshes share a request', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await container.read(playlistsProvider('library').future);
    final gate = Completer<void>();
    server.beforeRead = () => gate.future;
    server.requests.clear();
    final notifier = container.read(playlistsProvider('library').notifier);
    final first = notifier.refresh(withLoading: false, requireServer: true);
    final second = notifier.refresh(withLoading: false, requireServer: true);
    gate.complete();
    await Future.wait([first, second]);
    expect(server.requests.length, 1);
  });

  test('a pre-mutation refresh cannot overwrite the confirmed addition', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    final gate = Completer<void>();
    final readStarted = Completer<void>();
    server.beforeRead = () {
      if (!readStarted.isCompleted) readStarted.complete();
      return gate.future;
    };
    final notifier = container.read(playlistsProvider('library').notifier);
    final oldRefresh = notifier.refresh(withLoading: false, requireServer: true);
    await readStarted.future;
    await notifier.updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'a'});
    final snapshots = <List<String>>[];
    final subscription = container.listen(playlistsProvider('library'), (_, next) {
      snapshots.add(next.requireValue.items.single.items!.map((book) => book.itemId).toList());
    });
    gate.complete();
    await oldRefresh;
    await notifier.refresh(withLoading: false, requireServer: true);
    expect(snapshots.every((ids) => ids.contains('book')), isTrue);
    expect(container.read(playlistsProvider('library')).requireValue.items.single.items, [bookEntry]);
    subscription.close();
  });

  test('bulk additions still synchronize after an older refresh', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await container.read(playlistsProvider('library').future);
    final gate = Completer<void>();
    final readStarted = Completer<void>();
    final mutationStarted = Completer<void>();
    server.beforeRead = () {
      if (!readStarted.isCompleted) readStarted.complete();
      return gate.future;
    };
    server.beforeMutation = () async {
      mutationStarted.complete();
    };
    final notifier = container.read(playlistsProvider('library').notifier);
    final oldRefresh = notifier.refresh(withLoading: false);
    await readStarted.future;
    final addition = notifier.addBooksToPlaylist('a', bookIds: ['book']);
    await mutationStarted.future;
    await Future<void>.delayed(Duration.zero);
    gate.complete();
    await Future.wait([oldRefresh, addition]);
    expect(container.read(playlistsProvider('library')).requireValue.items.single.items, [bookEntry]);
  });

  test('a loading refresh during submission preserves the confirmed addition', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    final original = await container.read(playlistsProvider('library').future);
    final mutationGate = Completer<void>();
    final mutationStarted = Completer<void>();
    server.beforeMutation = () {
      mutationStarted.complete();
      return mutationGate.future;
    };
    final notifier = container.read(playlistsProvider('library').notifier);
    final addition = notifier.updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {'a'});
    await mutationStarted.future;
    final readGate = Completer<void>();
    server.beforeRead = () => readGate.future;
    final refresh = notifier.refresh(requireServer: true);
    mutationGate.complete();
    try {
      await addition.timeout(const Duration(seconds: 2));
      expect(container.read(playlistsProvider('library')).requireValue.items.single.items, [bookEntry]);
    } finally {
      readGate.complete();
      await refresh;
      await notifier.refresh(withLoading: false, requireServer: true);
    }
  });

  test('fresh synchronization does not share a refresh that allows an offline fallback', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await container.read(playlistsProvider('library').future);
    final gate = Completer<void>();
    server.beforeRead = () => gate.future;
    server.requests.clear();
    final notifier = container.read(playlistsProvider('library').notifier);
    final cached = notifier.refresh(withLoading: false, forceServer: false);
    final fresh = notifier.refresh(withLoading: false, requireServer: true);
    gate.complete();
    await Future.wait([cached, fresh]);
    expect(server.requests.length, 2);
    expect(server.requests.last.extra['skipCacheOnError'], isTrue);
    expect(server.requests.last.extra['noCache'], isTrue);
  });

  test('permission denial sends no request', () async {
    final server = PlaylistTestServer([playlist('a')]);
    final container = await server.container(allowed: false);
    addTearDown(container.dispose);
    await container.read(playlistsProvider('library').future);
    server.requests.clear();
    await expectLater(
      container
          .read(playlistsProvider('library').notifier)
          .updateBookMemberships(bookId: 'book', original: server.playlists, selectedIds: {'a'}),
      throwsException,
    );
    expect(server.requests, isEmpty);
  });

  test('unknown data and last-book removal never send a destructive request', () async {
    for (final books in [
      null,
      [bookEntry],
    ]) {
      final server = PlaylistTestServer([playlist('a', items: books)]);
      final container = await server.container();
      addTearDown(container.dispose);
      final original = await container.read(playlistsProvider('library').future);
      try {
        await container
            .read(playlistsProvider('library').notifier)
            .updateBookMemberships(bookId: 'book', original: original.items, selectedIds: {});
      } catch (_) {
        /* A last-book removal is rejected. Unknown entries are ignored. */
      }
      expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
    }
  });
}
