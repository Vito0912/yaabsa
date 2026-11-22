import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart' show M3ESlider;
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/screens/player/components/bookmark_card.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';
import 'package:yaabsa/components/player/common/volume_slider_panel.dart';
import 'package:yaabsa/features/player/widgets/player_media_info_presentation.dart';
import 'package:yaabsa/features/player/widgets/player_chapter_item_presentation.dart';
import 'package:yaabsa/features/player/widgets/player_queue_item_presentation.dart';
import 'package:yaabsa/features/player/widgets/player_subtitle_presentation.dart';
import 'package:yaabsa/util/subtitles/subtitle_parser.dart';
import 'package:yaabsa/features/player/widgets/sleep_timer_active_presentation.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/previews/player_previews.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/ui/previews/preview_fixtures.dart';
import 'package:yaabsa/screens/player/components/player_cover_component.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';

void main() {
  testWidgets('player cover reuses decoded artwork across small resizes', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    final media = previewInternalMedia().copyWith(cover: Uri.file('/preview-cover.png'));

    Future<ImageProvider> coverAtWidth(double width) async {
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: Center(
            child: SizedBox(
              width: width,
              height: 400,
              child: PlayerCoverComponent(api: null, media: media, fitMode: PlayerCoverFitMode.width),
            ),
          ),
        ),
      );
      final cover = find.descendant(of: find.byType(PlayerCoverComponent), matching: find.byType(Image));
      return tester.widget<Image>(cover).image;
    }

    final initial = await coverAtWidth(260);
    final slightlyResized = await coverAtWidth(270);
    final enlarged = await coverAtWidth(400);

    expect(slightlyResized, initial);
    expect(enlarged, isNot(initial));
    expect((enlarged as ResizeImage).width, greaterThanOrEqualTo(400));
    expect(tester.takeException(), isNull);
  });

  testWidgets('skip button presentation keeps disabled and actionable states', (tester) async {
    var previousCount = 0;

    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkipButtonPresentation(previous: true, onPressed: null),
            SkipButtonPresentation(previous: false, onPressed: null),
          ],
        ),
      ),
    );

    expect(tester.widget<IconButton>(find.byType(IconButton).first).onPressed, isNull);
    expect(tester.widget<IconButton>(find.byType(IconButton).last).onPressed, isNull);

    await tester.pumpWidget(
      YaabsaPreviewApp(child: SkipButtonPresentation(previous: true, onPressed: () => previousCount++)),
    );
    await tester.tap(find.byTooltip('Previous'));

    expect(previousCount, 1);
  });

  testWidgets('player controls preview renders seek markers and horizontal and vertical volume', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(720, 520);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const YaabsaPreviewApp(child: PlayerControlsPreview()));
    await tester.pumpAndSettle();

    expect(find.text('Chapter 4 · The lighthouse'), findsOneWidget);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.byType(VolumeSliderPresentation), findsNWidgets(2));
    expect(find.byType(M3ESlider), findsNWidgets(2));
    expect(find.byType(Slider), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final size in const [
    Size(320, 640),
    Size(390, 844),
    Size(800, 1100),
    Size(1100, 800),
    Size(1280, 800),
    Size(1600, 900),
    Size(800, 450),
  ]) {
    testWidgets('player controls stay within layout constraints at $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const YaabsaPreviewApp(child: PlayerControlsPreview()));
      await tester.pumpAndSettle();

      expect(find.text('Playback'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('bookmark card supports playback, selection, and busy states', (tester) async {
    var seekCount = 0;
    var selectionCount = 0;
    const bookmark = Bookmark(libraryItemId: 'preview-book', title: 'A note', time: 900, createdAt: 0);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: BookmarkCard(
            bookmark: bookmark,
            isBusy: false,
            onSeek: () => seekCount++,
            onEdit: () {},
            onDelete: () {},
            onSelect: () => selectionCount++,
            onLongPress: () => selectionCount++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('A note'));
    expect(seekCount, 1);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: BookmarkCard(
            bookmark: bookmark,
            isBusy: false,
            selectionMode: true,
            onSeek: () => seekCount++,
            onEdit: () {},
            onDelete: () {},
            onSelect: () => selectionCount++,
            onLongPress: () => selectionCount++,
          ),
        ),
      ),
    );
    await tester.tap(find.byType(Checkbox));
    expect(selectionCount, 1);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: BookmarkCard(
            bookmark: bookmark,
            isBusy: true,
            onSeek: () => seekCount++,
            onEdit: () {},
            onDelete: () {},
            onSelect: () => selectionCount++,
            onLongPress: () => selectionCount++,
          ),
        ),
      ),
    );
    expect(find.byType(YaabsaCircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('A note'));
    expect(seekCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('media metadata presentation renders optional details and callback', (tester) async {
    var openCount = 0;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: PlayerMediaInfoPresentation(
          title: 'The Distant Shore',
          author: 'Mira Ellery',
          narrator: 'Read by Elena Mar',
          series: 'The Tidemark Stories',
          seriesPosition: '2',
          textAlignMode: PlayerMetadataTextAlign.start,
          fontScale: 1,
          onPressed: () => openCount++,
        ),
      ),
    );

    expect(find.text('The Distant Shore'), findsOneWidget);
    expect(find.text('Mira Ellery'), findsOneWidget);
    expect(find.text('Read by Elena Mar'), findsOneWidget);
    expect(find.text('The Tidemark Stories #2'), findsOneWidget);
    await tester.tap(find.text('The Distant Shore'));
    expect(openCount, 1);
  });

  testWidgets('player action bar renders all actions without audio services', (tester) async {
    await tester.pumpWidget(const YaabsaPreviewApp(child: PlayerActionBarPreview()));
    await tester.pumpAndSettle();

    expect(find.text('Playback speed'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('Chapters'), findsOneWidget);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('Sleep timer'), findsOneWidget);
    expect(find.text('Queue'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('queue and chapter presentations keep selection and action behavior', (tester) async {
    var chapterTapCount = 0;
    var removeCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Column(
          children: [
            PlayerChapterItemPresentation(
              title: 'Chapter 2',
              timeRange: '12:00 - 28:30',
              selected: true,
              onPressed: () => chapterTapCount++,
            ),
            PlayerQueueItemPresentation(
              title: 'Next book',
              subtitle: 'Mira Ellery',
              autoQueued: true,
              onRemove: () => removeCount++,
            ),
          ],
        ),
      ),
    );

    expect(tester.widget<ListTile>(find.byType(ListTile).first).selected, isTrue);
    expect(find.byIcon(Icons.playlist_add_check_rounded), findsOneWidget);
    await tester.tap(find.text('Chapter 2'));
    await tester.tap(find.byTooltip('Remove from queue'));

    expect(chapterTapCount, 1);
    expect(removeCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('player collection empty presentation shares compact and full states', (tester) async {
    await tester.pumpWidget(const YaabsaPreviewApp(child: PlayerCollectionEmptyPreview()));

    expect(find.text('Queue is empty'), findsNWidgets(2));
    expect(find.text('No chapters available'), findsOneWidget);
    expect(find.text('Winter at Low Tide'), findsOneWidget);
    expect(find.byType(YaabsaCircularProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sleep timer presentation distinguishes running and paused states', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Column(
          children: [
            SleepTimerActivePresentation(isRunning: true, description: '15 min remaining'),
            SleepTimerActivePresentation(isRunning: false, description: '2 chapters remaining'),
          ],
        ),
      ),
    );

    expect(find.text('Timer active'), findsOneWidget);
    expect(find.text('Timer paused'), findsOneWidget);
    expect(find.text('15 min remaining'), findsOneWidget);
    expect(find.text('2 chapters remaining'), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    expect(find.byIcon(Icons.pause_circle_outline), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('subtitle cue presentation preserves read-along text and compact framing', (tester) async {
    final document = ParsedSubtitleDocument(
      format: SubtitleDocumentFormat.webvtt,
      cues: const [
        ParsedSubtitleCue(
          start: Duration.zero,
          end: Duration(seconds: 4),
          text: 'A light moved across the harbor.',
          segments: [
            ParsedSubtitleSegment(start: Duration.zero, end: Duration(seconds: 2), text: 'A light moved '),
            ParsedSubtitleSegment(start: Duration(seconds: 2), end: Duration(seconds: 4), text: 'across the harbor.'),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: PlayerSubtitleCuePresentation(
          document: document,
          cueIndex: 0,
          currentPosition: const Duration(seconds: 3),
          readAlongEnabled: true,
          compact: true,
          accentColor: Colors.deepPurple,
        ),
      ),
    );

    final text = tester.widget<RichText>(find.byType(RichText));
    expect(text.text.toPlainText(), 'A light moved across the harbor.');
    final textSpan = text.text as TextSpan;
    final activeWord = textSpan.children!.whereType<TextSpan>().firstWhere((span) => span.text == 'across');
    expect(activeWord.style?.color, Colors.deepPurple);
    expect(tester.takeException(), isNull);
  });
}
