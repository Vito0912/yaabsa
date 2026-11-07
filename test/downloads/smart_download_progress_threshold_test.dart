import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/media_item_type.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/util/globals.dart' as globals;

import 'smart_download_test_support.dart';

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

  MediaProgress bookProgress(String id, {double fraction = 0.2, int updated = 10, bool finished = false}) {
    return MediaProgress(
      id: 'progress-$id',
      userId: testUserId,
      libraryItemId: id,
      episodeId: null,
      mediaItemId: id,
      mediaItemType: MediaItemType.BOOK,
      duration: 600,
      progress: fraction,
      currentTime: 600 * fraction,
      isFinished: finished,
      lastUpdate: updated,
      startedAt: 1,
      finishedAt: null,
    );
  }

  Future<void> saveRule({
    String id = 'rule',
    String libraryId = allLibrariesSourceId,
    ListeningDownloadTrigger trigger = ListeningDownloadTrigger.progress,
    int targetCount = 10,
  }) async {
    final rule = SmartDownloadProfile(
      id: id,
      userId: testUserId,
      name: id,
      policy: SmartDownloadPolicy(targetCount: targetCount),
      sources: [
        MediaSourceDescriptor(
          type: MediaSourceType.listeningThreshold,
          sourceId: libraryId,
          libraryId: libraryId,
          listeningTrigger: trigger,
          listeningThreshold: 10,
        ),
      ],
    );
    await db.upsertSmartDownloadProfile(rule);
    await db.replaceSmartDownloadSources(rule.id, rule.sources);
  }

  Future<void> reconcile({Map<String, LibraryItem> items = const {}}) async {
    container = await downloadTestContainer(db, progress, items: items);
    await container!.read(smartDownloadManagerProvider.notifier).reconcile(reason: 'test');
    expect(container!.read(smartDownloadManagerProvider).error, isNull);
  }

  test('existing persisted progress qualifies without any local listening history', () async {
    await saveRule();
    final existing = bookProgress('existing');
    await db
        .into(db.storedMediaProgress)
        .insert(
          StoredMediaProgressEntry(
            progressId: existing.id,
            userId: testUserId,
            itemId: existing.libraryItemId,
            lastUpdated: DateTime.fromMillisecondsSinceEpoch(10),
            mediaProgress: jsonEncode(existing.toJson()),
          ),
        );

    await reconcile();

    expect(handler.events, ['queue:existing']);
    expect(await db.getListeningDownloadProgress(testUserId), isEmpty);
  });

  test('percentage rules use current progress and exclude finished books and podcasts', () async {
    await saveRule();
    progress.cached.addAll({
      'eligible': bookProgress('eligible'),
      'boundary': bookProgress('boundary', fraction: 0.1),
      'below': bookProgress('below', fraction: 0.09),
      'finished': bookProgress('finished', finished: true),
      'complete': bookProgress('complete', fraction: 1),
      'episode::episode': bookProgress('episode')
          .copyWith(episodeId: 'episode', mediaItemType: MediaItemType.PODCAST_EPISODE),
    });
    await db.recordListeningDownloadProgress(
      userId: testUserId,
      itemId: 'below',
      libraryId: 'library',
      listenedSeconds: 120,
      progressPercent: 50,
    );

    await reconcile();

    expect(handler.events, ['queue:boundary', 'queue:eligible']);
  });

  test('recent server progress wins when the rule has a one-book limit', () async {
    await saveRule(targetCount: 1);
    progress.cached['older'] = bookProgress('older');
    progress.cached['recent'] = bookProgress('recent', updated: 20);

    await reconcile();

    expect(handler.events, ['queue:recent']);
  });

  test('existing progress respects a specific library without local listening history', () async {
    await saveRule(libraryId: 'selected');
    progress.cached['matching'] = bookProgress('matching');
    progress.cached['other'] = bookProgress('other');

    await reconcile(
      items: {
        'matching': const LibraryItem(
          id: 'matching',
          ino: 'matching',
          libraryId: 'selected',
          media: null,
          libraryFiles: null,
        ),
        'other': const LibraryItem(
          id: 'other',
          ino: 'other',
          libraryId: 'other-library',
          media: null,
          libraryFiles: null,
        ),
      },
    );

    expect(handler.events, ['queue:matching']);
  });

  test('minutes rules still require playback recorded on this device', () async {
    await saveRule(trigger: ListeningDownloadTrigger.minutes);
    progress.cached['remote'] = bookProgress('remote', fraction: 0.9);

    await reconcile();

    expect(handler.events, isEmpty);
  });
}
