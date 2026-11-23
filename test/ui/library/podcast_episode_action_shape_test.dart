import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_tile.dart';
import 'package:yaabsa/ui/previews/preview_fixtures.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('podcast episode side actions use shared rounded controls', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SizedBox(
          width: 1100,
          child: PodcastEpisodeTile(
            episode: const Episode(libraryItemId: 'podcast-1', id: 'episode-1', title: 'Episode one'),
            progress: null,
            canDownload: true,
            isDownloading: false,
            isDownloaded: false,
            isQueued: false,
            isCurrentEpisode: false,
            isPlayingCurrentEpisode: false,
            onOpenDetails: () {},
            onPlayPressed: () {},
            onQueueToggle: () {},
            onDownloadPressed: () {},
          ),
        ),
      ),
    );

    final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
    for (final tooltip in ['Add to queue', 'Download']) {
      final button = buttons.singleWhere((button) => button.tooltip == tooltip);
      expect(button.style?.shape?.resolve(const {}), isA<RoundedRectangleBorder>());
    }

    expect(find.text('Incomplete'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast episode cards keep their M3 layout at narrow sizes and larger text', (tester) async {
    const widths = [320.0, 390.0, 800.0, 1100.0];
    final episode = previewPodcastEpisodes().first;

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 960);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in widths) {
      for (final textScale in [1.0, 1.8]) {
        await tester.pumpWidget(
          YaabsaPreviewApp(
            child: MediaQuery(
              data: MediaQueryData(size: Size(width, 840), textScaler: TextScaler.linear(textScale)),
              child: SizedBox(
                width: width,
                child: PodcastEpisodeTile(
                  episode: episode,
                  progress: previewPodcastEpisodeProgress(episodeId: episode.id, progress: 0.42),
                  canDownload: true,
                  isDownloading: false,
                  isDownloaded: false,
                  isQueued: false,
                  isCurrentEpisode: false,
                  isPlayingCurrentEpisode: false,
                  onOpenDetails: () {},
                  onPlayPressed: () {},
                  onQueueToggle: () {},
                  onDownloadPressed: () {},
                  onMoreActionSelected: (_) async {},
                  allowSelection: true,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('A lighthouse in the fog'), findsOneWidget);
        expect(find.text('In Progress'), findsNothing);
        expect(find.text('Incomplete'), findsNothing);
        expect(find.text('Complete'), findsNothing);
        expect(find.text('42%'), findsNothing);
        expect(tester.getSize(find.byKey(const ValueKey('yaabsa-media-play-background'))), const Size(32, 32));
        expect(tester.getSize(find.byKey(const ValueKey('yaabsa-media-play-progress-ring'))), const Size(40, 40));
        expect(tester.takeException(), isNull, reason: '$width wide at ${textScale}x text');
      }
    }
  });

  testWidgets('completed podcast episodes do not show a completion status badge', (tester) async {
    final episode = previewPodcastEpisodes().last;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: PodcastEpisodeTile(
          episode: episode,
          progress: previewPodcastEpisodeProgress(episodeId: episode.id, progress: 1, isFinished: true),
          canDownload: false,
          isDownloading: false,
          isDownloaded: false,
          isQueued: false,
          isCurrentEpisode: false,
          isPlayingCurrentEpisode: false,
          onOpenDetails: () {},
          onPlayPressed: () {},
          onQueueToggle: () {},
        ),
      ),
    );

    expect(find.text('Complete'), findsNothing);
    expect(find.text('Incomplete'), findsNothing);
    expect(find.text('In Progress'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
