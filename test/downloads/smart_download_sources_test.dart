import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/util/globals.dart' as globals;

import 'smart_download_test_support.dart';

const _library = Library(
  id: 'library',
  name: 'Books',
  displayOrder: 0,
  icon: 'books',
  mediaType: 'book',
  provider: 'local',
  createdAt: 0,
  settings: LibrarySettings(),
);

ShelfEntry<LibraryItem> _shelf(String id, List<String> books) {
  return ShelfEntry<LibraryItem>(
    id: id,
    label: id,
    labelStringKey: id,
    type: ShelfType.book,
    total: books.length,
    entities: books.map((id) => LibraryItem(id: id, ino: id, media: null, libraryFiles: null)).toList(),
  );
}

PersonalizedLibrary _shelves({
  List<String> listening = const [],
  List<String> series = const [],
  List<String> reading = const [],
}) {
  return PersonalizedLibrary(
    continueListening: _shelf('continue-listening', listening),
    continueSeries: _shelf('continue-series', series),
    extraLibraryShelves: [_shelf('continue-reading', reading)],
  );
}

void main() {
  final handler = DownloadTestHandler();
  late DownloadTestDatabase db;
  late DownloadTestProgress progress;
  ProviderContainer? container;

  setUpAll(() {
    globals.downloadHandler = handler;
    globals.audioHandler = DownloadTestAudioHandler();
  });

  setUp(() {
    db = DownloadTestDatabase();
    progress = DownloadTestProgress();
    handler.reset(db);
  });

  tearDown(() async {
    container?.dispose();
    container = null;
    await db.close();
  });

  Future<void> saveRule(
    List<MediaSourceType> types, {
    int budget = 100,
    int retention = 24,
    int itemCount = 150,
    String libraryId = allLibrariesSourceId,
  }) async {
    final sources = types
        .map((type) => MediaSourceDescriptor(type: type, sourceId: libraryId, libraryId: libraryId))
        .toList();
    final hasReading = types.contains(MediaSourceType.continueReading);
    final downloadType = hasReading ? (types.length == 1 ? 'ebook' : 'both') : 'audiobook';
    await db.upsertSmartDownloadProfile(
      SmartDownloadProfile(
        id: 'rule',
        userId: testUserId,
        name: 'Rule',
        policy: SmartDownloadPolicy(
          targetCount: itemCount,
          maxStorageBytes: budget,
          deleteAfterHours: retention,
          downloadType: downloadType,
        ),
      ),
    );
    await db.replaceSmartDownloadSources('rule', sources);
  }

  Future<SmartDownloadManager> manager({
    PersonalizedLibrary? shelves,
    Map<String, PersonalizedLibrary>? allShelves,
  }) async {
    final libraryIds = allShelves?.keys.toList() ?? ['library'];
    container = await downloadTestContainer(
      db,
      progress,
      library: _library,
      libraries: libraryIds.map((id) => _library.copyWith(id: id)).toList(),
      personalized: shelves ?? _shelves(),
      personalizedByLibrary: allShelves,
    );
    return container!.read(smartDownloadManagerProvider.notifier);
  }

  Future<void> reconcile(SmartDownloadManager notifier) async {
    await notifier.reconcile(reason: 'test', refreshSources: false);
    expect(container!.read(smartDownloadManagerProvider).error, isNull);
  }

  test('Continue Listening is an independent rule source', () async {
    await saveRule([MediaSourceType.continueListening]);

    await reconcile(
      await manager(
        shelves: _shelves(listening: ['audio'], series: ['series'], reading: ['ebook']),
      ),
    );

    expect(handler.events, ['queue:audio']);
    expect(handler.queuedTypes['audio'], 'audiobook');
    expect(handler.queuedOwners['audio'], ['rule']);
  });

  test('Continue Series is an independent rule source', () async {
    await saveRule([MediaSourceType.continueSeries]);

    await reconcile(
      await manager(
        shelves: _shelves(listening: ['audio'], series: ['series'], reading: ['ebook']),
      ),
    );

    expect(handler.events, ['queue:series']);
  });

  test('Continue Reading downloads ebook files', () async {
    await saveRule([MediaSourceType.continueReading]);

    await reconcile(
      await manager(
        shelves: _shelves(listening: ['audio'], reading: ['ebook']),
      ),
    );

    expect(handler.events, ['queue:ebook']);
    expect(handler.queuedTypes['ebook'], 'ebook');
  });

  test('All expands every user library and shares shelf requests across sources', () async {
    await saveRule([MediaSourceType.continueListening, MediaSourceType.continueSeries], budget: 1000);
    final notifier = await manager(
      allShelves: {
        'library': _shelves(listening: ['first'], series: ['second']),
        'other': _shelves(listening: ['third'], series: ['fourth']),
      },
    );

    await reconcile(notifier);

    expect(handler.events.toSet(), {'queue:first', 'queue:second', 'queue:third', 'queue:fourth'});
    for (final libraryId in ['library', 'other']) {
      final shelves = container!.read(personalizedLibraryProvider(libraryId).notifier) as DownloadTestShelves;
      expect(shelves.loads, 1);
    }
  });

  test('a specific library excludes shelves from other libraries', () async {
    await saveRule([MediaSourceType.continueListening], libraryId: 'library');

    await reconcile(
      await manager(
        allShelves: {
          'library': _shelves(listening: ['first']),
          'other': _shelves(listening: ['second']),
        },
      ),
    );

    expect(handler.events, ['queue:first']);
    expect(container!.exists(personalizedLibraryProvider('other')), isFalse);
  });

  test('overlapping Listening and Reading sources merge their file requirements', () async {
    await saveRule([MediaSourceType.continueListening, MediaSourceType.continueReading]);

    await reconcile(
      await manager(
        shelves: _shelves(listening: ['shared'], reading: ['shared']),
      ),
    );

    expect(handler.events, ['queue:shared']);
    expect(handler.queuedTypes['shared'], 'both');
    expect(handler.estimateReads['shared'], 1);
  });

  test('all sources in a rule share its storage budget', () async {
    await saveRule([MediaSourceType.continueListening, MediaSourceType.continueSeries], budget: 75);

    await reconcile(
      await manager(
        shelves: _shelves(listening: ['first'], series: ['second']),
      ),
    );

    expect(handler.events, ['queue:first']);
  });

  test('retained Continue downloads consume the rule budget', () async {
    await saveRule([MediaSourceType.continueListening]);
    await db.addComplete('retained', ['rule'], bytes: 80, completedAt: DateTime.now().millisecondsSinceEpoch);

    await reconcile(await manager(shelves: _shelves(listening: ['waiting'])));

    expect(handler.events, isEmpty);
    expect(db.completeDownloads, contains('retained'));
  });

  test('the rule retention setting controls cleanup before queueing', () async {
    await saveRule([MediaSourceType.continueListening], retention: 12);
    await db.addComplete('expired', ['rule'], bytes: 80);

    await reconcile(await manager(shelves: _shelves(listening: ['waiting'])));

    expect(handler.events, ['delete:expired', 'queue:waiting']);
  });

  test('an audiobook download does not satisfy a Reading source', () async {
    await saveRule([MediaSourceType.continueReading], budget: 200);
    await db.addComplete('book', ['rule'], completedAt: DateTime.now().millisecondsSinceEpoch);

    await reconcile(await manager(shelves: _shelves(reading: ['book'])));

    expect(handler.events, ['queue:book']);
    expect(handler.queuedTypes['book'], 'ebook');
  });

  test('file upgrades charge the additional bytes rather than counting existing files twice', () async {
    await saveRule([MediaSourceType.continueReading], budget: 1000);
    await db.addComplete('upgrade', ['rule'], bytes: 400, completedAt: DateTime.now().millisecondsSinceEpoch);
    handler.estimates['upgrade'] = 900;
    handler.estimates['waiting'] = 200;

    await reconcile(await manager(shelves: _shelves(reading: ['upgrade', 'waiting'])));

    expect(handler.events, ['queue:upgrade']);
    expect(handler.queuedTypes['upgrade'], 'ebook');
  });

  test('an in-flight upgrade reserves only bytes not already counted in stored downloads', () async {
    await saveRule([MediaSourceType.continueReading], budget: 1000);
    await db.addComplete('upgrade', ['rule'], bytes: 400, completedAt: DateTime.now().millisecondsSinceEpoch);
    handler.active.add('upgrade::');
    handler.reservations['upgrade::'] = 900;
    handler.estimates['waiting'] = 100;

    await reconcile(await manager(shelves: _shelves(reading: ['upgrade', 'waiting'])));

    expect(handler.events, ['queue:waiting']);
  });

  test('a listening threshold source is limited to its selected library', () async {
    await saveRule([MediaSourceType.listeningThreshold], libraryId: 'library');
    for (final libraryId in ['library', 'other']) {
      await db.recordListeningDownloadProgress(
        userId: testUserId,
        itemId: libraryId,
        libraryId: libraryId,
        listenedSeconds: 3600,
        progressPercent: 50,
      );
    }

    await reconcile(await manager());

    expect(handler.events, ['queue:library']);
  });
  test('overlapping shelves count shared books towards each source item limit', () async {
    await saveRule([MediaSourceType.continueListening, MediaSourceType.continueSeries], budget: 500, itemCount: 2);

    await reconcile(
      await manager(
        shelves: _shelves(listening: ['shared', 'listening'], series: ['shared', 'series-first', 'series-extra']),
      ),
    );

    expect(handler.events.toSet(), {'queue:shared', 'queue:listening', 'queue:series-first'});
  });
}
