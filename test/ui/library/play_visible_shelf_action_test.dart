import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/book_media.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/media.dart';
import 'package:yaabsa/api/library_items/media_metadata.dart';
import 'package:yaabsa/api/me/media_item_type.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/features/library/widgets/play_visible_shelf_action.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';

void main() {
  const unfinishedBook = LibraryItem(
    id: 'unfinished',
    ino: 'unfinished',
    mediaType: 'book',
    media: Media(
      bookMedia: BookMedia(
        id: 'media-unfinished',
        metadata: MediaMetadata(title: 'Unfinished'),
        numAudioFiles: 1,
      ),
    ),
    libraryFiles: null,
  );
  const finishedBook = LibraryItem(
    id: 'finished',
    ino: 'finished',
    mediaType: 'book',
    media: Media(
      bookMedia: BookMedia(
        id: 'media-finished',
        metadata: MediaMetadata(title: 'Finished'),
        numAudioFiles: 1,
      ),
    ),
    libraryFiles: null,
  );

  testWidgets('play visible action returns only unfinished audio items', (tester) async {
    List<PlayVisibleShelfEntry>? queuedEntries;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mediaProgressForLibraryItemProvider('unfinished').overrideWithValue(const []),
          mediaProgressForLibraryItemProvider('finished').overrideWithValue([_finishedProgress]),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PlayVisibleShelfAction(
              items: const [unfinishedBook, finishedBook],
              onPressed: (entries) => queuedEntries = entries,
            ),
          ),
        ),
      ),
    );

    final action = find.byTooltip('Queue all items in this shelf');
    expect(action, findsOneWidget);

    await tester.tap(action);
    await tester.pump();

    expect(queuedEntries, hasLength(1));
    expect(queuedEntries!.single.item.id, 'unfinished');
    expect(queuedEntries!.single.episode, isNull);
  });

  testWidgets('play visible action stays hidden when there are no playable audio items', (tester) async {
    const itemWithoutAudio = LibraryItem(id: 'no-audio', ino: 'no-audio', media: null, libraryFiles: null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [mediaProgressForLibraryItemProvider('no-audio').overrideWithValue(const [])],
        child: const MaterialApp(
          home: Scaffold(
            body: PlayVisibleShelfAction(items: [itemWithoutAudio], onPressed: _ignorePlayableEntries),
          ),
        ),
      ),
    );

    expect(find.byTooltip('Queue all items in this shelf'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

const _finishedProgress = MediaProgress(
  id: 'finished-progress',
  userId: 'user',
  libraryItemId: 'finished',
  episodeId: null,
  mediaItemId: 'media-finished',
  mediaItemType: MediaItemType.BOOK,
  duration: 3600,
  progress: 1,
  currentTime: 3600,
  isFinished: true,
  lastUpdate: null,
  startedAt: 0,
  finishedAt: 1,
);

void _ignorePlayableEntries(List<PlayVisibleShelfEntry> entries) {}
