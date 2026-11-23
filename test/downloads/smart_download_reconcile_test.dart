import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/me/media_item_type.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/util/globals.dart' as globals;

import '../collections/collection_test_support.dart' as sources;
import 'smart_download_test_support.dart';

void main() {
  final handler = DownloadTestHandler();
  final audio = DownloadTestAudioHandler();
  late DownloadTestDatabase db;
  late DownloadTestProgress progress;
  ProviderContainer? container;

  setUpAll(() {
    globals.downloadHandler = handler;
    globals.audioHandler = audio;
  });

  setUp(() {
    db = DownloadTestDatabase();
    progress = DownloadTestProgress();
    handler.reset(db);
    audio.protectedItems.clear();
  });

  tearDown(() async {
    container?.dispose();
    container = null;
    await db.close();
  });

  SmartDownloadProfile listeningRule(String id, {int budget = 100, int retention = 0}) {
    return SmartDownloadProfile(
      id: id,
      userId: testUserId,
      name: id,
      policy: SmartDownloadPolicy(maxStorageBytes: budget, deleteAfterHours: retention),
      sources: const [
        MediaSourceDescriptor(
          type: MediaSourceType.listeningThreshold,
          sourceId: allLibrariesSourceId,
          libraryId: allLibrariesSourceId,
          listeningThreshold: 1,
        ),
      ],
    );
  }

  Future<void> saveRule(SmartDownloadProfile profile) async {
    await db.upsertSmartDownloadProfile(profile);
    await db.replaceSmartDownloadSources(profile.id, profile.sources);
  }

  Future<void> heard(String itemId) {
    return db.recordListeningDownloadProgress(
      userId: testUserId,
      itemId: itemId,
      libraryId: 'library',
      listenedSeconds: 120,
      progressPercent: 20,
    );
  }

  MediaProgress bookProgress(String itemId, {bool finished = false, int updated = 10}) {
    return MediaProgress(
      id: 'progress-$itemId',
      userId: testUserId,
      libraryItemId: itemId,
      episodeId: null,
      mediaItemId: itemId,
      mediaItemType: MediaItemType.BOOK,
      duration: 600,
      progress: finished ? 1 : 0.2,
      currentTime: finished ? 600 : 120,
      isFinished: finished,
      lastUpdate: updated,
      startedAt: 1,
      finishedAt: finished ? updated : null,
    );
  }

  Future<SmartDownloadManager> manager() async {
    container = await downloadTestContainer(db, progress);
    return container!.read(smartDownloadManagerProvider.notifier);
  }

  Future<void> reconcile(SmartDownloadManager manager, {bool refresh = false}) async {
    await manager.reconcile(reason: 'test', refreshSources: refresh);
    expect(container!.read(smartDownloadManagerProvider).error, isNull);
  }

  test('expired downloads free the budget for a waiting book in the same pass', () async {
    await saveRule(listeningRule('rule'));
    await db.addComplete('expired', ['rule']);
    await heard('waiting');

    await reconcile(await manager());

    expect(handler.events, ['delete:expired', 'queue:waiting']);
    expect(handler.taskReads, 1);
    expect(db.storedReads, 1);
    expect(db.downloadResolutions, 1);
  });

  test('retained downloads still consume budget and are not deleted early', () async {
    await saveRule(listeningRule('rule', retention: 24));
    await db.addComplete('retained', ['rule'], completedAt: DateTime.now().millisecondsSinceEpoch);
    await heard('waiting');

    await reconcile(await manager());

    expect(handler.events, isEmpty);
    expect(db.completeDownloads, contains('retained'));
  });

  test('playing or queued downloads remain protected during cleanup', () async {
    await saveRule(listeningRule('rule'));
    await db.addComplete('protected', ['rule']);
    audio.protectedItems.add('protected');
    await heard('waiting');

    await reconcile(await manager());

    expect(handler.events, isEmpty);
    expect(handler.duplicateChecks, 0);
  });

  test('all listening rules and cleanup share one stored and cached progress snapshot', () async {
    await saveRule(listeningRule('first'));
    await saveRule(listeningRule('second'));
    await db.addComplete('expired', ['first']);
    await heard('waiting');

    await reconcile(await manager());

    expect(db.progressReads, 1);
    expect(db.listeningReads, 1);
    expect(progress.snapshotReads, 1);
    expect(handler.events, ['delete:expired', 'queue:waiting']);
    expect(handler.queuedOwners['waiting'], ['first', 'second']);
    expect(handler.estimateReads['waiting'], 1);
  });

  test('a shared download must fit every owning rule budget', () async {
    await saveRule(listeningRule('large', budget: 100));
    await saveRule(listeningRule('small', budget: 40));
    await heard('shared');

    await reconcile(await manager());

    expect(handler.events, isEmpty);
    expect(handler.estimateReads['shared'], 1);
  });

  test('shared reservations count towards every owning rule', () async {
    await saveRule(listeningRule('first', budget: 75));
    await saveRule(listeningRule('second', budget: 75));
    await heard('reserved');
    await heard('waiting');
    handler.active.add('reserved::');
    handler.reservations['reserved::'] = 50;

    await reconcile(await manager());

    expect(handler.events, isEmpty);
    expect(handler.taskReads, 1);
  });

  test('unknown reservation sizes prevent oversubscribing a capped rule', () async {
    await saveRule(listeningRule('rule'));
    await heard('reserved');
    await heard('waiting');
    handler.active.add('reserved::');
    handler.reservations['reserved::'] = 0;
    handler.estimates['reserved'] = null;

    await reconcile(await manager());

    expect(handler.events, isEmpty);
    expect(handler.estimateReads['reserved'], 1);
    expect(handler.estimateReads, isNot(contains('waiting')));
  });

  test('a newer cached finished state overrides stale persisted progress', () async {
    await saveRule(listeningRule('rule'));
    await heard('finished');
    final stale = bookProgress('finished');
    await db
        .into(db.storedMediaProgress)
        .insert(
          StoredMediaProgressEntry(
            progressId: stale.id,
            userId: testUserId,
            itemId: 'finished',
            lastUpdated: DateTime.fromMillisecondsSinceEpoch(10),
            mediaProgress: jsonEncode(stale.toJson()),
          ),
        );
    progress.cached['finished'] = bookProgress('finished', finished: true, updated: 20);

    await reconcile(await manager());

    expect(handler.events, isEmpty);
    expect(await db.getSmartDownloadClaims('rule'), isEmpty);
  });

  test('manual active downloads are skipped without per-item task scans', () async {
    await saveRule(listeningRule('rule'));
    await heard('manual');
    handler.active.add('manual::');

    await reconcile(await manager());

    expect(handler.events, isEmpty);
    expect(handler.taskReads, 1);
    expect(handler.duplicateChecks, 0);
    expect(handler.estimateReads, isEmpty);
  });

  test('disabled rules with no managed downloads do no progress or task work', () async {
    final rule = listeningRule('disabled').copyWith(enabled: false);
    await saveRule(rule);

    await reconcile(await manager());

    expect(db.progressReads, 0);
    expect(db.listeningReads, 0);
    expect(db.downloadResolutions, 0);
    expect(progress.snapshotReads, 0);
    expect(handler.taskReads, 0);
    expect(handler.events, isEmpty);
  });

  test('overlapping sources reuse network pages and unchanged claims', () async {
    final server = DownloadSourceServer([
      sources.collection('collection', books: [sources.testBook]),
    ]);
    const source = MediaSourceDescriptor(
      type: MediaSourceType.collection,
      sourceId: 'collection',
      libraryId: 'library',
    );
    for (final id in ['first', 'second']) {
      final profile = SmartDownloadProfile(id: id, userId: testUserId, name: id, sources: [source]);
      await saveRule(profile);
      await db.replaceSmartDownloadSources(id, [source]);
    }
    container = await downloadTestContainer(db, progress, api: server.api);
    final notifier = container!.read(smartDownloadManagerProvider.notifier);

    await reconcile(notifier);
    expect(server.requests, hasLength(1));
    expect(db.claimWrites, 2);
    expect(handler.events, ['queue:book']);

    await reconcile(notifier);
    expect(server.requests, hasLength(1));
    expect(db.claimWrites, 2);
    expect(handler.events, ['queue:book']);

    notifier.requestReconcile(reason: 'library item updated');
    await reconcile(notifier);
    expect(server.requests, hasLength(2));

    await reconcile(notifier, refresh: true);
    expect(server.requests, hasLength(3));
  });

  test('cached source pages recheck finished progress before selecting books', () async {
    final server = DownloadSourceServer([
      sources.collection('collection', books: [sources.testBook]),
    ]);
    const source = MediaSourceDescriptor(
      type: MediaSourceType.collection,
      sourceId: 'collection',
      libraryId: 'library',
    );
    await saveRule(SmartDownloadProfile(id: 'rule', userId: testUserId, name: 'rule', sources: [source]));
    await db.replaceSmartDownloadSources('rule', [source]);
    container = await downloadTestContainer(db, progress, api: server.api);
    final notifier = container!.read(smartDownloadManagerProvider.notifier);
    await reconcile(notifier);
    progress.cached['book'] = bookProgress('book', finished: true);

    await reconcile(notifier);

    expect(server.requests, hasLength(1));
    expect(await db.getSmartDownloadClaims('rule'), isEmpty);
  });
  test('Continue Listening and threshold downloads share progress, tasks and duplicate checks', () async {
    await saveRule(listeningRule('rule'));
    await heard('waiting');
    final settings = DownloadTestSettings();
    const source = MediaSourceDescriptor(
      type: MediaSourceType.continueListening,
      sourceId: 'library',
      libraryId: 'library',
    );
    await saveRule(SmartDownloadProfile(id: 'continue', userId: testUserId, name: 'Continue'));
    await db.replaceSmartDownloadSources('continue', [source]);
    const library = Library(
      id: 'library',
      name: 'Books',
      displayOrder: 0,
      icon: 'books',
      mediaType: 'book',
      provider: 'local',
      createdAt: 0,
      settings: LibrarySettings(),
    );
    const shelves = PersonalizedLibrary(
      continueListening: ShelfEntry<LibraryItem>(
        id: 'continue-listening',
        label: 'Continue Listening',
        labelStringKey: '',
        type: ShelfType.book,
        total: 3,
        entities: [
          LibraryItem(id: 'waiting', ino: 'waiting', media: null, libraryFiles: null),
          LibraryItem(id: 'other', ino: 'other', media: null, libraryFiles: null),
          LibraryItem(id: 'finished', ino: 'finished', media: null, libraryFiles: null),
        ],
      ),
    );
    progress.cached['finished'] = bookProgress('finished', finished: true);
    container = await downloadTestContainer(db, progress, settings: settings, library: library, personalized: shelves);

    await reconcile(container!.read(smartDownloadManagerProvider.notifier));

    expect(handler.events, ['queue:waiting', 'queue:other']);
    expect(db.progressReads, 1);
    expect(progress.snapshotReads, 1);
    expect(db.storedReads, 1);
    expect(handler.taskReads, 1);
    expect(handler.duplicateChecks, 0);
  });

  test('newer persisted progress wins over a stale cached finished state', () async {
    await saveRule(listeningRule('rule'));
    await heard('book');
    final current = bookProgress('book', updated: 20);
    await db
        .into(db.storedMediaProgress)
        .insert(
          StoredMediaProgressEntry(
            progressId: current.id,
            userId: testUserId,
            itemId: 'book',
            lastUpdated: DateTime.fromMillisecondsSinceEpoch(20),
            mediaProgress: jsonEncode(current.toJson()),
          ),
        );
    progress.cached['book'] = bookProgress('book', finished: true, updated: 10);

    await reconcile(await manager());

    expect(handler.events, ['queue:book']);
  });
  test('a failed automatic download cools down while other books can proceed', () async {
    await saveRule(listeningRule('rule', budget: 200));
    await heard('failed');
    await heard('waiting');
    final notifier = await manager();
    notifier.recordAutomaticDownloadFailure(userId: testUserId, itemId: 'failed');

    await reconcile(notifier);
    await reconcile(notifier);

    expect(handler.events, ['queue:waiting']);
    expect(handler.estimateReads, isNot(contains('failed')));
  });

  test('failures from another account cannot delay the active account downloads', () async {
    await saveRule(listeningRule('rule'));
    await heard('book');
    final notifier = await manager();
    notifier.recordAutomaticDownloadFailure(userId: 'other-user', itemId: 'book');

    await reconcile(notifier);

    expect(handler.events, ['queue:book']);
  });

  test('progress rules prioritize recent listening when only one book fits', () async {
    final rule = listeningRule('rule', budget: 50);
    await saveRule(
      rule.copyWith(
        sources: [
          rule.sources.single.copyWith(listeningTrigger: ListeningDownloadTrigger.progress, listeningThreshold: 10),
        ],
      ),
    );
    await heard('older');
    await heard('recent');
    progress.cached['older'] = bookProgress('older', updated: 10);
    progress.cached['recent'] = bookProgress('recent', updated: 20);

    await reconcile(await manager());

    expect(handler.events, ['queue:recent']);
    expect(db.progressReads, 1);
  });

  test('progress rules prioritize known recent listening over missing timestamps', () async {
    final rule = listeningRule('rule', budget: 50);
    await saveRule(
      rule.copyWith(
        sources: [
          rule.sources.single.copyWith(listeningTrigger: ListeningDownloadTrigger.progress, listeningThreshold: 10),
        ],
      ),
    );
    await heard('unknown');
    await heard('recent');
    progress.cached['recent'] = bookProgress('recent', updated: 20);

    await reconcile(await manager());

    expect(handler.events, ['queue:recent']);
  });

  test('reset progress does not inherit finished flags from cached source pages', () async {
    final server = DownloadSourceServer([
      sources.collection('collection', books: [sources.testBook]),
    ]);
    const source = MediaSourceDescriptor(
      type: MediaSourceType.collection,
      sourceId: 'collection',
      libraryId: 'library',
    );
    await saveRule(SmartDownloadProfile(id: 'rule', userId: testUserId, name: 'rule', sources: [source]));
    await db.replaceSmartDownloadSources('rule', [source]);
    progress.cached['book'] = bookProgress('book', finished: true);
    container = await downloadTestContainer(db, progress, api: server.api);
    final notifier = container!.read(smartDownloadManagerProvider.notifier);
    await reconcile(notifier);
    expect(handler.events, isEmpty);

    progress.cached.clear();
    await reconcile(notifier);

    expect(server.requests, hasLength(1));
    expect(handler.events, ['queue:book']);
  });
  test('finishing a book cancels an obsolete listening-source download', () async {
    await saveRule(listeningRule('rule'));
    await heard('book');
    final notifier = await manager();
    await reconcile(notifier);
    expect(handler.active, contains('book::'));

    progress.cached['book'] = bookProgress('book', finished: true);
    await reconcile(notifier);

    expect(handler.active, isEmpty);
    expect(await db.getSmartDownloadClaims('rule'), isEmpty);
  });
}
