import 'dart:async';

import 'package:flutter/widget_previews.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/components/common/narrator_card.dart';
import 'package:yaabsa/components/app/library/library_filter_toolbar.dart';
import 'package:yaabsa/components/app/series/series_detail_header.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/app/item/item_media_file_section.dart';
import 'package:yaabsa/components/app/item/set_library_item_progress_dialog.dart';
import 'package:yaabsa/features/library/widgets/library_entity_list_card.dart';
import 'package:yaabsa/features/library/widgets/library_item_card.dart';
import 'package:yaabsa/screens/item/podcast/podcast_header_card.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_tile.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episodes_header_card.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/ui/components/buttons/media_play_button.dart';

import 'preview_fixtures.dart';
import 'preview_theme.dart';

import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

@Preview(name: 'Library cards / light', size: Size(800, 620), wrapper: yaabsaPreviewLight)
@Preview(name: 'Library cards / dark', size: Size(800, 620), wrapper: yaabsaPreviewDark)
@Preview(name: 'Library cards / AMOLED', size: Size(800, 620), wrapper: yaabsaPreviewAmoled)
Widget libraryCardsPreview() => const LibraryCardsPreview();

@Preview(name: 'Library entity rows / light', size: Size(640, 380), wrapper: yaabsaPreviewLight)
@Preview(name: 'Library entity rows / dark', size: Size(640, 380), wrapper: yaabsaPreviewDark)
@Preview(name: 'Library entity rows / AMOLED', size: Size(640, 380), wrapper: yaabsaPreviewAmoled)
Widget libraryEntityCardsPreview() => const LibraryEntityCardsPreview();

@Preview(name: 'Shared media play buttons / light', size: Size(560, 200), wrapper: yaabsaPreviewLight)
@Preview(name: 'Shared media play buttons / dark', size: Size(560, 200), wrapper: yaabsaPreviewDark)
@Preview(name: 'Shared media play buttons / AMOLED', size: Size(560, 200), wrapper: yaabsaPreviewAmoled)
Widget sharedMediaPlayButtonsPreview() => const SharedMediaPlayButtonsPreview();

@Preview(name: 'Series and narrator sort headers / light', size: Size(390, 260), wrapper: yaabsaPreviewLight)
@Preview(name: 'Series and narrator sort headers / dark', size: Size(390, 260), wrapper: yaabsaPreviewDark)
@Preview(name: 'Series and narrator sort headers / AMOLED', size: Size(390, 260), wrapper: yaabsaPreviewAmoled)
Widget sortHeaderControlsPreview() => const SortHeaderControlsPreview();

@Preview(name: 'Set progress dialog / light', size: Size(480, 480), wrapper: yaabsaPreviewLight)
@Preview(name: 'Set progress dialog / dark', size: Size(480, 480), wrapper: yaabsaPreviewDark)
@Preview(name: 'Set progress dialog / AMOLED', size: Size(480, 480), wrapper: yaabsaPreviewAmoled)
Widget setProgressDialogPreview() => SetLibraryItemProgressDialog(
  initialProgress: 1,
  durationSeconds: 14340,
  initialStartedDate: DateTime(2026, 10, 16),
  initialFinishedDate: DateTime(2026, 10, 17),
  onCancel: _ignoreEntityAction,
  onSave: _ignoreProgressAction,
);

@Preview(name: 'Podcast filters / medium / light', size: Size(750, 200), wrapper: yaabsaPreviewLight)
@Preview(name: 'Podcast filters / medium / dark', size: Size(750, 200), wrapper: yaabsaPreviewDark)
@Preview(name: 'Podcast filters / medium / AMOLED', size: Size(750, 200), wrapper: yaabsaPreviewAmoled)
Widget podcastEpisodeFiltersPreview() => const PodcastEpisodeFiltersPreview();

class PodcastEpisodeFiltersPreview extends StatefulWidget {
  const PodcastEpisodeFiltersPreview({super.key});

  @override
  State<PodcastEpisodeFiltersPreview> createState() => _PodcastEpisodeFiltersPreviewState();
}

class _PodcastEpisodeFiltersPreviewState extends State<PodcastEpisodeFiltersPreview> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodcastEpisodesHeaderCard(
      totalEpisodeCount: 126,
      visibleEpisodeCount: 126,
      searchQuery: _searchController.text,
      searchController: _searchController,
      progressFilter: PodcastEpisodeProgressFilter.all,
      sortMode: PodcastEpisodeSortMode.newestFirst,
      onSearchChanged: (value) => setState(() {}),
      onClearSearch: () {
        _searchController.clear();
        setState(() {});
      },
      onFilterChanged: (_) {},
      onSortChanged: (_) {},
    );
  }
}

class SortHeaderControlsPreview extends StatelessWidget {
  const SortHeaderControlsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SeriesDetailHeader(
          onBack: _ignoreEntityAction,
          onSortPressed: _ignoreEntityAction,
          sortLabel: 'Title A-Z',
          title: 'The Tidemark Stories',
          subtitle: 'A coastal mystery series',
        ),
        const Divider(height: 1),
        LibraryFilterToolbar(
          libraryMediaType: 'book',
          activeFilter: 'narrators:sample',
          activeSort: null,
          activeSortDesc: null,
          filterDataAsync: const AsyncData<LibraryFilterData?>(null),
          onFilterSelected: (_) async {},
          onSortSelected: (_) async {},
          onClearFilter: () async {},
          title: 'Mara Ellery',
          onBack: _ignoreEntityAction,
        ),
      ],
    );
  }
}

class SharedMediaPlayButtonsPreview extends StatelessWidget {
  const SharedMediaPlayButtonsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayButtonState(
            context,
            'Library item',
            const YaabsaMediaPlayButton(
              size: 36,
              tooltip: 'Play',
              isPlaying: false,
              isFinished: false,
              isLoading: false,
              onPressed: _ignoreEntityAction,
              progress: 0.42,
            ),
          ),
          _buildPlayButtonState(
            context,
            'Podcast episode',
            const YaabsaMediaPlayButton(
              size: 40,
              tooltip: 'Pause',
              isPlaying: true,
              isFinished: false,
              isLoading: false,
              onPressed: _ignoreEntityAction,
              progress: 0.42,
            ),
          ),
          _buildPlayButtonState(
            context,
            'Loading',
            const YaabsaMediaPlayButton(
              size: 40,
              tooltip: 'Loading',
              isPlaying: false,
              isFinished: false,
              isLoading: true,
              onPressed: null,
            ),
          ),
          _buildPlayButtonState(
            context,
            'Finished',
            const YaabsaMediaPlayButton(
              size: 40,
              tooltip: 'Replay',
              isPlaying: false,
              isFinished: true,
              isLoading: false,
              onPressed: _ignoreEntityAction,
              progress: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButtonState(BuildContext context, String label, Widget button) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 12),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

@Preview(name: 'Podcast header actions / light', size: Size(1120, 340), wrapper: yaabsaPreviewLight)
@Preview(name: 'Podcast header actions / dark', size: Size(1120, 340), wrapper: yaabsaPreviewDark)
@Preview(name: 'Podcast header actions / AMOLED', size: Size(1120, 340), wrapper: yaabsaPreviewAmoled)
Widget podcastHeaderActionsPreview() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: PodcastHeaderCard(
      item: previewPodcastLibraryItem(),
      cover: const ColoredBox(
        color: Color(0xFF194F4B),
        child: Center(child: Icon(Icons.podcasts_rounded, size: 68, color: Colors.white)),
      ),
      totalEpisodes: 135,
      visibleEpisodes: 135,
      duration: const Duration(hours: 139, minutes: 57),
      showFullDescription: false,
      onBack: _ignoreEntityAction,
      onToggleDescription: _ignoreEntityAction,
      onPlayLatest: _ignoreEntityAction,
      onDownloadPress: _ignoreEntityAction,
      onMoreActionSelected: (_) async {},
    ),
  );
}

@Preview(name: 'Book metadata actions / light', size: Size(640, 620), wrapper: yaabsaPreviewLight)
@Preview(name: 'Book metadata actions / dark', size: Size(640, 620), wrapper: yaabsaPreviewDark)
@Preview(name: 'Book metadata actions / AMOLED', size: Size(640, 620), wrapper: yaabsaPreviewAmoled)
@Preview(name: 'Book metadata actions / compact phone', size: Size(320, 640), wrapper: yaabsaPreviewLight)
Widget bookMetadataActionsPreview() => const BookMetadataActionsPreview();

@Preview(name: 'Library item actions / desktop / light', size: Size(1280, 220), wrapper: yaabsaPreviewLight)
@Preview(name: 'Library item actions / desktop / dark', size: Size(1280, 220), wrapper: yaabsaPreviewDark)
@Preview(name: 'Library item actions / desktop / AMOLED', size: Size(1280, 220), wrapper: yaabsaPreviewAmoled)
Widget libraryItemActionsDesktopPreview() => const LibraryItemActionsDesktopPreview();

class LibraryItemActionsDesktopPreview extends StatelessWidget {
  const LibraryItemActionsDesktopPreview({super.key, this.showMarkAsFinished = true, this.showMarkAsUnfinished = true});

  final bool showMarkAsFinished;
  final bool showMarkAsUnfinished;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('The Clockmaker’s Atlas', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ItemMoreActionsButton(
            onActionSelected: (_) async {},
            showSelect: true,
            showEditItem: true,
            showQuickMatch: true,
            showManualMatch: true,
            showPinAction: true,
            showMarkAction: true,
            showMarkAsFinished: showMarkAsFinished,
            showMarkAsUnfinished: showMarkAsUnfinished,
            showAddToPlaylist: true,
            showAddToCollection: true,
            showDeleteItem: true,
            showSetProgress: true,
          ),
        ],
      ),
    );
  }
}

class LibraryItemContextMenuDesktopPreview extends StatelessWidget {
  const LibraryItemContextMenuDesktopPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = ItemMoreActionsButton(
      onActionSelected: (_) async {},
      showEditItem: true,
      showQuickMatch: true,
      showManualMatch: true,
      showMarkAction: true,
      showMarkAsUnfinished: true,
      showSetProgress: true,
      showAddToPlaylist: true,
      showAddToCollection: true,
      showPinAction: true,
      showDeleteItem: true,
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 260,
        child: Builder(
          builder: (context) {
            return LibraryItemCard(
              cover: const AspectRatio(
                aspectRatio: 1,
                child: ColoredBox(
                  color: Color(0xFF245F5A),
                  child: Center(child: Icon(Icons.menu_book_rounded, size: 72, color: Colors.white)),
                ),
              ),
              title: 'The Clockmaker’s Atlas',
              subtitle: const Text('M. Ellery'),
              isDesktop: true,
              onContextMenu: (position) => unawaited(actions.showAt(context: context, globalPosition: position)),
            );
          },
        ),
      ),
    );
  }
}

@Preview(name: 'Library item context menu / card / dark', size: Size(420, 420), wrapper: yaabsaPreviewDark)
Widget libraryItemContextMenuDesktopPreview() => const LibraryItemContextMenuDesktopPreview();

class BookMetadataActionsPreview extends StatelessWidget {
  const BookMetadataActionsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ItemMediaFileSection(itemId: 'preview-book', title: 'Audio files (4)', files: []),
        const SizedBox(height: 8),
        const ItemMediaFileSection(itemId: 'preview-book', title: 'Library files (2)', files: []),
        const SizedBox(height: 8),
        ItemMetadataCard(
          rows: [
            ItemMetadataRowData(
              label: 'Series',
              values: [const ItemLinkValue(label: 'North Sea Stories', onTap: _ignoreEntityAction)],
            ),
            ItemMetadataRowData(
              label: 'Authors',
              values: [
                const ItemLinkValue(label: 'Alexandra von Hohenfels', onTap: _ignoreEntityAction),
                const ItemLinkValue(label: 'Markus Winterfeld', onTap: _ignoreEntityAction),
              ],
            ),
            ItemMetadataRowData(
              label: 'Tags',
              values: [
                const ItemLinkValue(label: 'Historical Fiction', onTap: _ignoreEntityAction),
                const ItemLinkValue(label: 'Coastal Mysteries', onTap: _ignoreEntityAction),
                const ItemLinkValue(label: 'Family Saga', onTap: _ignoreEntityAction),
              ],
            ),
          ],
          inlineValues: true,
        ),
      ],
    );
  }
}

@Preview(name: 'Podcast episode controls / phone', size: Size(390, 700), wrapper: yaabsaPreviewLight)
@Preview(name: 'Podcast episode controls / medium', size: Size(750, 520), wrapper: yaabsaPreviewLight)
@Preview(name: 'Podcast episode controls / desktop', size: Size(1280, 960), wrapper: yaabsaPreviewLight)
@Preview(name: 'Podcast episode controls / dark', size: Size(800, 900), wrapper: yaabsaPreviewDark)
@Preview(name: 'Podcast episode controls / AMOLED', size: Size(800, 900), wrapper: yaabsaPreviewAmoled)
Widget podcastEpisodeControlsPreview() => const PodcastEpisodeControlsPreview();

class PodcastEpisodeControlsPreview extends StatefulWidget {
  const PodcastEpisodeControlsPreview({super.key});

  @override
  State<PodcastEpisodeControlsPreview> createState() => _PodcastEpisodeControlsPreviewState();
}

class _PodcastEpisodeControlsPreviewState extends State<PodcastEpisodeControlsPreview> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final episodes = previewPodcastEpisodes();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PodcastHeaderCard(
          item: previewPodcastLibraryItem(),
          cover: const ColoredBox(
            color: Color(0xFF194F4B),
            child: Center(child: Icon(Icons.podcasts_rounded, size: 68, color: Colors.white)),
          ),
          totalEpisodes: 135,
          visibleEpisodes: 135,
          duration: const Duration(hours: 139, minutes: 57),
          showFullDescription: false,
          onBack: _ignoreEntityAction,
          onToggleDescription: _ignoreEntityAction,
          onPlayLatest: _ignoreEntityAction,
          onDownloadPress: _ignoreEntityAction,
          onMoreActionSelected: (_) async {},
        ),
        const SizedBox(height: 12),
        PodcastEpisodesHeaderCard(
          totalEpisodeCount: 135,
          visibleEpisodeCount: 135,
          searchQuery: _searchController.text,
          searchController: _searchController,
          progressFilter: PodcastEpisodeProgressFilter.all,
          sortMode: PodcastEpisodeSortMode.newestFirst,
          onSearchChanged: (_) => setState(() {}),
          onClearSearch: () {
            _searchController.clear();
            setState(() {});
          },
          onFilterChanged: (_) {},
          onSortChanged: (_) {},
        ),
        const SizedBox(height: 16),
        PodcastEpisodeTile(
          episode: episodes[0],
          progress: previewPodcastEpisodeProgress(episodeId: episodes[0].id, progress: 0.42),
          canDownload: true,
          isDownloading: false,
          isDownloaded: false,
          isQueued: false,
          isCurrentEpisode: true,
          isPlayingCurrentEpisode: true,
          onOpenDetails: _ignoreEntityAction,
          onPlayPressed: _ignoreEntityAction,
          onQueueToggle: _ignoreEntityAction,
          onDownloadPressed: _ignoreEntityAction,
          onMoreActionSelected: (_) async {},
          allowSelection: true,
          showPinAction: true,
          showAddToPlaylist: true,
        ),
        const SizedBox(height: 8),
        PodcastEpisodeTile(
          episode: episodes[1],
          progress: null,
          canDownload: true,
          isDownloading: true,
          isDownloaded: false,
          isQueued: true,
          isCurrentEpisode: false,
          isPlayingCurrentEpisode: false,
          onOpenDetails: _ignoreEntityAction,
          onPlayPressed: _ignoreEntityAction,
          onQueueToggle: _ignoreEntityAction,
          onMoreActionSelected: (_) async {},
          allowSelection: true,
          showPinAction: true,
          showAddToPlaylist: true,
        ),
        const SizedBox(height: 8),
        PodcastEpisodeTile(
          episode: episodes[2],
          progress: previewPodcastEpisodeProgress(episodeId: episodes[2].id, progress: 1, isFinished: true),
          canDownload: true,
          isDownloading: false,
          isDownloaded: true,
          isQueued: false,
          isCurrentEpisode: false,
          isPlayingCurrentEpisode: false,
          onOpenDetails: _ignoreEntityAction,
          onPlayPressed: _ignoreEntityAction,
          onQueueToggle: _ignoreEntityAction,
          onDeletePressed: _ignoreEntityAction,
          onMoreActionSelected: (_) async {},
          allowSelection: true,
          showPinAction: true,
          showAddToPlaylist: true,
        ),
      ],
    );
  }
}

class LibraryEntityCardsPreview extends StatelessWidget {
  const LibraryEntityCardsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        LibraryEntityListCard(
          leading: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.person_outline_rounded, color: colors.onPrimaryContainer, size: 32),
          ),
          title: 'Mara Ellery',
          subtitle: '14 books · 92 hours',
          description: 'Coastal histories and quiet mysteries.',
          onTap: () {},
        ),
        const SizedBox(height: 10),
        const NarratorCard(name: 'Jonas Vale', subtitle: '8 audiobooks · 34 hours', onTap: _ignoreEntityAction),
        const SizedBox(height: 10),
        LibraryEntityListCard(
          leading: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: colors.tertiaryContainer, borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.person_outline_rounded, color: colors.onTertiaryContainer),
          ),
          title: 'Tamsin Rowe',
          subtitle: '3 audiobook titles',
          compact: true,
        ),
      ],
    );
  }
}

void _ignoreEntityAction() {}

void _ignoreProgressAction(SetLibraryItemProgressSelection _) {}

class LibraryCardsPreview extends StatelessWidget {
  const LibraryCardsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.extent(
      padding: const EdgeInsets.all(16),
      maxCrossAxisExtent: 240,
      mainAxisExtent: 460,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        LibraryItemCard(
          cover: _PreviewBookCover(
            title: 'The distant shore',
            background: colorScheme.primaryContainer,
            foreground: colorScheme.onPrimaryContainer,
          ),
          title: 'The Distant Shore',
          subtitle: const Text('M. Ellery · 12 hours', maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {},
        ),
        LibraryItemCard(
          cover: _PreviewBookCover(
            title: 'Coastal stories',
            background: colorScheme.tertiaryContainer,
            foreground: colorScheme.onTertiaryContainer,
            progress: 0.64,
          ),
          title: 'Coastal Stories: Collected Accounts',
          subtitle: const Text('M. Ellery · 64% complete', maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {},
        ),
        LibraryItemCard(
          compact: true,
          cover: _PreviewBookCover(
            title: 'Field notes',
            background: colorScheme.secondaryContainer,
            foreground: colorScheme.onSecondaryContainer,
          ),
          title: 'Field Notes, Volume One',
          subtitle: const Text('A. Morgan', maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {},
        ),
      ],
    );
  }
}

class _PreviewBookCover extends StatelessWidget {
  const _PreviewBookCover({required this.title, required this.background, required this.foreground, this.progress});

  final String title;
  final Color background;
  final Color foreground;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.68,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: background),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: foreground, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            if (progress case final value?)
              Align(
                alignment: Alignment.bottomCenter,
                child: YaabsaLinearProgressIndicator(
                  value: value,
                  minHeight: 4,
                  backgroundColor: foreground.withValues(alpha: 0.2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
