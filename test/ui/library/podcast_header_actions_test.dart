import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/library_item_view_components.dart';
import 'package:yaabsa/screens/item/podcast/podcast_header_card.dart';
import 'package:yaabsa/ui/components/buttons/playback_action_button.dart';
import 'package:yaabsa/ui/theme/component_styles.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('podcast header uses the audiobook primary action and shared side actions', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: PodcastHeaderCard(
          item: const LibraryItem(id: 'podcast-1', ino: 'podcast-1', media: null, libraryFiles: null),
          cover: const ColoredBox(color: Colors.teal),
          totalEpisodes: 135,
          visibleEpisodes: 135,
          duration: const Duration(hours: 139, minutes: 57),
          showFullDescription: false,
          onBack: () {},
          onToggleDescription: () {},
          onPlayLatest: () {},
          onDownloadPress: () {},
          onMoreActionSelected: (_) async {},
        ),
      ),
    );

    final playbackAction = find.byType(YaabsaPlaybackActionButton);
    final playButton = tester.widget<FilledButton>(
      find.descendant(of: playbackAction, matching: find.byType(FilledButton)),
    );
    expect(playButton.style, YaabsaButtonStyles.compactProminentAction);

    final iconButtons = tester.widgetList<IconButton>(find.byType(IconButton));
    for (final tooltip in ['Download options', 'More actions']) {
      final button = iconButtons.singleWhere((button) => button.tooltip == tooltip);
      expect(button.style?.shape?.resolve(const {}), isA<RoundedRectangleBorder>());
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast and audiobook details use identical prominent playback controls', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: ListView(
          children: [
            PodcastHeaderCard(
              item: const LibraryItem(id: 'podcast-1', ino: 'podcast-1', media: null, libraryFiles: null),
              cover: const ColoredBox(color: Colors.teal),
              totalEpisodes: 135,
              visibleEpisodes: 135,
              duration: const Duration(hours: 139, minutes: 57),
              showFullDescription: false,
              onBack: () {},
              onToggleDescription: () {},
              onPlayLatest: () {},
            ),
            buildItemActionButtons(
              hasAudio: true,
              hasBook: false,
              canDownload: false,
              downloadItemId: 'book-1',
              isDownloaded: false,
              isQueued: false,
              isCurrentItem: false,
              isPlayingCurrentItem: false,
              isLoadingCurrentItem: false,
              prominentPlayback: true,
              playbackLabel: 'Play',
              onPlay: () {},
              onPause: () {},
              onQueueToggle: () {},
              onRead: () {},
              onDownload: () {},
              onDeleteDownload: () {},
            ),
          ],
        ),
      ),
    );

    final playbackActions = tester.widgetList<YaabsaPlaybackActionButton>(find.byType(YaabsaPlaybackActionButton));
    expect(playbackActions, hasLength(2));
    expect(playbackActions.first.label, playbackActions.last.label);

    final podcastButton = tester.getSize(find.byType(YaabsaPlaybackActionButton).first);
    final audiobookButton = tester.getSize(find.byType(YaabsaPlaybackActionButton).last);
    expect(podcastButton, audiobookButton);
    expect(tester.takeException(), isNull);
  });
}
