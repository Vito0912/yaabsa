import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/downloads/item_download_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/media_metadata.dart';
import 'package:yaabsa/components/app/item/item_description.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/globals.dart';

export 'package:yaabsa/components/app/item/library_item_media_sections.dart';

List<ItemMetadataRowData> buildItemMetadataRows(
  BuildContext context, {
  required MediaMetadata? metadata,
  required List<String>? tags,
  required Duration? duration,
  required int? sizeBytes,
  required Future<void> Function(String filter) onFilterTap,
  ItemMetadataRowData? collectionsRow,
  ItemMetadataRowData? playlistsRow,
}) {
  return <ItemMetadataRowData>[
    if (metadata?.series != null && metadata!.series!.isNotEmpty)
      ItemMetadataRowData(
        label: 'Series',
        values: metadata.series!
            .map(
              (series) => ItemLinkValue(
                label: seriesLabel(series.name, series.sequence),
                onTap: () => context.push('/series/${series.id}', extra: MultiBookEntryData.fromSeries(series)),
              ),
            )
            .toList(),
      ),
    if (metadata?.authors != null && metadata!.authors!.isNotEmpty)
      ItemMetadataRowData(
        label: 'Authors',
        values: metadata.authors!
            .map((author) => ItemLinkValue(label: author.name, onTap: () => context.push('/author/${author.id}')))
            .toList(),
      ),
    ?collectionsRow,
    ?playlistsRow,
    if (metadata?.narrators != null && metadata!.narrators!.isNotEmpty)
      ItemMetadataRowData(
        label: 'Narrators',
        values: metadata.narrators!
            .map(
              (narrator) => ItemLinkValue(
                label: narrator,
                onTap: () => context.push('/narrator/${Uri.encodeComponent(narrator)}'),
              ),
            )
            .toList(),
      ),
    if (hasText(metadata?.publishedYear)) ItemMetadataRowData(label: 'Published', value: metadata!.publishedYear!),
    if (hasText(metadata?.publisher))
      ItemMetadataRowData(
        label: 'Publisher',
        values: [
          ItemLinkValue(
            label: metadata!.publisher!,
            onTap: () => onFilterTap(_publisherFilterQuery(metadata.publisher!)),
          ),
        ],
      ),
    if (metadata?.genres != null && metadata!.genres!.isNotEmpty)
      ItemMetadataRowData(
        label: 'Genres',
        values: metadata.genres!
            .map(
              (genre) => ItemLinkValue(
                label: genre,
                onTap: () => onFilterTap(LibraryFilter.grouped(LibraryFilterGroup.genres, genre).queryValue),
              ),
            )
            .toList(),
      ),
    if (tags != null && tags.isNotEmpty)
      ItemMetadataRowData(
        label: 'Tags',
        values: tags
            .map(
              (tag) => ItemLinkValue(
                label: tag,
                onTap: () => onFilterTap(LibraryFilter.grouped(LibraryFilterGroup.tags, tag).queryValue),
              ),
            )
            .toList(),
      ),
    if (hasText(metadata?.language))
      ItemMetadataRowData(
        label: 'Language',
        values: [
          ItemLinkValue(
            label: metadata!.language!,
            onTap: () =>
                onFilterTap(LibraryFilter.grouped(LibraryFilterGroup.languages, metadata.language!).queryValue),
          ),
        ],
      ),
    if (duration != null) ItemMetadataRowData(label: 'Duration', value: formatDurationLong(duration)),
    if (sizeBytes != null && sizeBytes > 0) ItemMetadataRowData(label: 'Size', value: formatBytes(sizeBytes)),
  ];
}

Widget buildItemActionButtons({
  required bool hasAudio,
  required bool hasBook,
  required bool canDownload,
  required String downloadItemId,
  String? downloadEpisodeId,
  required bool isDownloaded,
  required bool isQueued,
  required bool isCurrentItem,
  required bool isPlayingCurrentItem,
  required bool isLoadingCurrentItem,
  bool queueEnabled = true,
  String? playbackLabel,
  String? playbackDetail,
  bool prominentPlayback = false,
  required VoidCallback onPlay,
  required VoidCallback onPause,
  required VoidCallback onQueueToggle,
  required VoidCallback onRead,
  required VoidCallback onDownload,
  required VoidCallback onDeleteDownload,
  Future<void> Function(ItemMoreAction action)? onMoreActionSelected,
  bool showMarkAsUnfinished = false,
  bool showMarkAction = true,
  bool showEditItem = false,
  bool showQuickMatch = false,
  bool showManualMatch = false,
  bool showAddToPlaylist = false,
  bool showAddToCollection = false,
  bool manageMemberships = false,
  bool showDeleteItem = false,
  bool showPinAction = false,
  bool isPinned = false,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final hasPrimaryActions = hasBook || hasAudio;
      final hasSmallActions = canDownload || hasAudio || onMoreActionSelected != null;
      final playLabel =
          playbackLabel ??
          (isLoadingCurrentItem ? 'Loading' : (isPlayingCurrentItem ? 'Pause' : (isCurrentItem ? 'Resume' : 'Play')));
      final primaryActions = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasBook && !prominentPlayback)
            OutlinedButton.icon(
              onPressed: onRead,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text('Read'),
            ),
          if (hasBook && hasAudio && !prominentPlayback) const SizedBox(height: 8),
          if (hasAudio)
            FilledButton.icon(
              onPressed: isLoadingCurrentItem ? null : (isPlayingCurrentItem ? onPause : onPlay),
              icon: isLoadingCurrentItem
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2))
                  : Icon(isPlayingCurrentItem ? Icons.pause_rounded : Icons.play_arrow_rounded),
              style: prominentPlayback
                  ? FilledButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    )
                  : null,
              label: Text(playbackDetail ?? playLabel),
            ),
        ],
      );

      if (!hasSmallActions && !prominentPlayback) {
        return primaryActions;
      }

      final smallActions = _buildSmallActionButtons(
        context,
        showDownload: canDownload,
        downloadItemId: downloadItemId,
        downloadEpisodeId: downloadEpisodeId,
        isDownloaded: isDownloaded,
        showQueue: hasAudio,
        isQueued: isQueued,
        queueEnabled: queueEnabled,
        onDownload: onDownload,
        onDeleteDownload: onDeleteDownload,
        onQueueToggle: onQueueToggle,
        showMoreActions: onMoreActionSelected != null,
        onMoreActionSelected: onMoreActionSelected,
        showMarkAsUnfinished: showMarkAsUnfinished,
        showMarkAction: showMarkAction,
        showEditItem: showEditItem,
        showQuickMatch: showQuickMatch,
        showManualMatch: showManualMatch,
        showAddToPlaylist: showAddToPlaylist,
        showAddToCollection: showAddToCollection,
        manageMemberships: manageMemberships,
        showDeleteItem: showDeleteItem,
        showPinAction: showPinAction,
        isPinned: isPinned,
      );

      if (prominentPlayback) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (hasAudio) primaryActions,
            if (hasBook)
              OutlinedButton.icon(
                onPressed: onRead,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text('Read'),
              ),
            smallActions,
          ],
        );
      }

      final placeSmallBelowPrimary = constraints.maxWidth < 360 || !hasPrimaryActions;

      if (placeSmallBelowPrimary) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasPrimaryActions) primaryActions,
            if (hasPrimaryActions) const SizedBox(height: 12),
            smallActions,
          ],
        );
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          primaryActions,
          const SizedBox(width: 10),
          SizedBox(
            height: 36,
            child: VerticalDivider(color: Theme.of(context).colorScheme.outlineVariant, width: 1, thickness: 1),
          ),
          const SizedBox(width: 8),
          smallActions,
        ],
      );
    },
  );
}

Widget _buildSmallActionButtons(
  BuildContext context, {
  required bool showDownload,
  required String downloadItemId,
  String? downloadEpisodeId,
  required bool isDownloaded,
  required bool showQueue,
  required bool isQueued,
  required bool queueEnabled,
  required VoidCallback onDownload,
  required VoidCallback onDeleteDownload,
  required VoidCallback onQueueToggle,
  required bool showMoreActions,
  required Future<void> Function(ItemMoreAction action)? onMoreActionSelected,
  required bool showMarkAsUnfinished,
  required bool showMarkAction,
  required bool showEditItem,
  required bool showQuickMatch,
  required bool showManualMatch,
  required bool showAddToPlaylist,
  required bool showAddToCollection,
  required bool manageMemberships,
  required bool showDeleteItem,
  required bool showPinAction,
  required bool isPinned,
}) {
  final children = <Widget>[
    if (showDownload)
      ItemDownloadButton(
        itemId: downloadItemId,
        episodeId: downloadEpisodeId,
        isDownloaded: isDownloaded,
        onDownload: onDownload,
        onDeleteDownload: onDeleteDownload,
      ),
    if (showQueue)
      IconButton.filledTonal(
        onPressed: queueEnabled ? onQueueToggle : null,
        tooltip: queueEnabled ? (isQueued ? 'Remove from queue' : 'Add to queue') : 'Currently playing',
        icon: Icon(isQueued ? Icons.playlist_remove_rounded : Icons.queue_music_rounded),
        visualDensity: VisualDensity.compact,
      ),
    if (showMoreActions && onMoreActionSelected != null)
      ItemMoreActionsButton(
        onActionSelected: onMoreActionSelected,
        showMarkAction: showMarkAction,
        showEditItem: showEditItem,
        showQuickMatch: showQuickMatch,
        showManualMatch: showManualMatch,
        showMarkAsUnfinished: showMarkAsUnfinished,
        showAddToPlaylist: showAddToPlaylist,
        showAddToCollection: showAddToCollection,
        manageMemberships: manageMemberships,
        showDeleteItem: showDeleteItem,
        showPinAction: showPinAction,
        isPinned: isPinned,
      ),
  ];

  if (children.isEmpty) {
    return const SizedBox.shrink();
  }

  return Row(mainAxisSize: MainAxisSize.min, spacing: 8.0, children: children);
}

class LibraryItemTopContent extends StatelessWidget {
  const LibraryItemTopContent({
    super.key,
    required this.isLargeScreen,
    required this.title,
    required this.subtitle,
    required this.cover,
    required this.actionButtons,
    required this.metadataRows,
    required this.item,
    required this.onBack,
    required this.mediaSections,
    this.progressValue = 0,
    this.stats,
  });

  final Widget mediaSections;
  final double progressValue;
  final Widget? stats;
  final bool isLargeScreen;
  final String title;
  final String? subtitle;
  final Widget cover;
  final Widget actionButtons;
  final List<ItemMetadataRowData> metadataRows;
  final LibraryItem item;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasDescription = hasText(item.media?.bookMedia?.metadata.description);
        final description = ItemDescription(item: item, useCard: false);
        final showSidebar = isLargeScreen && constraints.maxWidth >= 1000 && metadataRows.isNotEmpty;
        final metadata = ItemMetadataCard(rows: metadataRows, inlineValues: !context.isDesktop, useCard: !showSidebar);
        final bookMetadata = item.media?.bookMedia?.metadata;
        final byline = bookMetadata?.authors?.map((author) => author.name).join(', ');
        final duration = item.media?.duration() ?? 0;
        final summary = [
          if (duration > 0) formatDurationLong(Duration(seconds: duration.round())),
          if (hasText(bookMetadata?.publishedYear)) bookMetadata!.publishedYear!,
        ].join(' · ');
        final mainContent = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasDescription) ...[description, const SizedBox(height: 12)],
            if (!showSidebar && metadataRows.isNotEmpty) ...[metadata, const SizedBox(height: 12)],
            mediaSections,
            ?stats,
          ],
        );

        final pageContent = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ItemHeroCard(
              compactLayout: !isLargeScreen,
              progressValue: progressValue,
              onBack: onBack,
              title: title,
              subtitle: subtitle,
              byline: byline,
              summary: summary,
              cover: cover,
              actions: actionButtons,
            ),
            const SizedBox(height: 16),
            mainContent,
          ],
        );

        if (!showSidebar) {
          return pageContent;
        }

        return Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: 320,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: pageContent),
                const SizedBox(width: 16),
                SizedBox(width: 320, child: metadata),
              ],
            ),
          ],
        );
      },
    );
  }
}

String _publisherFilterQuery(String publisher) {
  return 'publishers.${encodeFilterValue(publisher)}';
}
