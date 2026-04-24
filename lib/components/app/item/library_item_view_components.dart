import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/api/library_items/ebook_file.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/media_metadata.dart';
import 'package:yaabsa/components/app/item/item_description.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/util/item_formatters.dart';

List<ItemMetadataRowData> buildItemMetadataRows(
  BuildContext context, {
  required MediaMetadata? metadata,
  required List<String>? tags,
  required Duration? duration,
  required int? sizeBytes,
  required Future<void> Function(String filter) onFilterTap,
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
    if (hasText(metadata?.publishedYear)) ItemMetadataRowData(label: 'Published year', value: metadata!.publishedYear!),
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
  required bool isQueued,
  bool queueEnabled = true,
  required VoidCallback onPlay,
  required VoidCallback onQueueToggle,
  required VoidCallback onRead,
  required VoidCallback onDownload,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final hasPrimaryActions = hasBook || hasAudio;
      final hasSmallActions = canDownload || hasAudio;
      final primaryActions = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasBook)
            OutlinedButton.icon(
              onPressed: onRead,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text('Read'),
            ),
          if (hasBook && hasAudio) const SizedBox(height: 8),
          if (hasAudio)
            FilledButton.icon(onPressed: onPlay, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Play')),
        ],
      );

      if (!hasSmallActions) {
        return primaryActions;
      }

      final smallActions = _buildSmallActionButtons(
        context,
        showDownload: canDownload,
        showQueue: hasAudio,
        isQueued: isQueued,
        queueEnabled: queueEnabled,
        onDownload: onDownload,
        onQueueToggle: onQueueToggle,
      );

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
  required bool showQueue,
  required bool isQueued,
  required bool queueEnabled,
  required VoidCallback onDownload,
  required VoidCallback onQueueToggle,
}) {
  final children = <Widget>[
    if (showDownload)
      IconButton.filledTonal(
        onPressed: onDownload,
        tooltip: 'Download',
        icon: const Icon(Icons.download_rounded),
        visualDensity: VisualDensity.compact,
      ),
    if (showQueue)
      IconButton.filledTonal(
        onPressed: queueEnabled ? onQueueToggle : null,
        tooltip: queueEnabled ? (isQueued ? 'Remove from queue' : 'Add to queue') : 'Currently playing',
        icon: Icon(isQueued ? Icons.playlist_remove_rounded : Icons.queue_music_rounded),
        visualDensity: VisualDensity.compact,
      ),
  ];

  if (children.isEmpty) {
    return const SizedBox.shrink();
  }

  return Row(mainAxisSize: MainAxisSize.min, spacing: 8.0, children: children);
}

class ItemChapterRow extends StatelessWidget {
  const ItemChapterRow({
    super.key,
    required this.title,
    required this.start,
    required this.duration,
    required this.onTap,
  });

  final String title;
  final Duration start;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)),
            SizedBox(width: 74, child: Text(formatDurationShort(start), textAlign: TextAlign.right)),
            const SizedBox(width: 10),
            SizedBox(width: 74, child: Text(formatDurationShort(duration), textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}

class _ChapterTableHeader extends StatelessWidget {
  const _ChapterTableHeader();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, letterSpacing: 0.4);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
      child: Row(
        children: [
          Expanded(child: Text('Chapter', style: style)),
          SizedBox(
            width: 74,
            child: Text('Start', style: style, textAlign: TextAlign.right),
          ),
          SizedBox(
            width: 74,
            child: Text('Length', style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
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
  });

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
    if (isLargeScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemHeroCard(
                  compactLayout: false,
                  onBack: onBack,
                  title: title,
                  subtitle: subtitle,
                  cover: cover,
                  actions: actionButtons,
                ),
                const SizedBox(height: 8),
                ItemDescription(item: item),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: ItemMetadataCard(rows: metadataRows, inlineValues: true)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemHeroCard(
          compactLayout: true,
          onBack: onBack,
          title: title,
          subtitle: subtitle,
          cover: cover,
          actions: actionButtons,
        ),
        const SizedBox(height: 4),
        ItemDescription(item: item, useCard: false),
        const SizedBox(height: 4),
        ItemMetadataCard(rows: metadataRows, inlineValues: true, useCard: false),
      ],
    );
  }
}

class LibraryItemMediaSections extends StatelessWidget {
  const LibraryItemMediaSections({
    super.key,
    required this.itemId,
    required this.chapters,
    required this.audioFiles,
    required this.ebookFile,
    required this.onChapterTap,
  });

  final String itemId;
  final List<Chapter> chapters;
  final List<AudioFile> audioFiles;
  final EbookFile? ebookFile;
  final void Function(Chapter chapter) onChapterTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chapters.isNotEmpty) ...[
          const SizedBox(height: 8),
          ItemExpandableSection(
            title: 'Chapters (${chapters.length})',
            children: [
              const _ChapterTableHeader(),
              ...chapters.map(
                (chapter) => ItemChapterRow(
                  title: chapter.title,
                  start: Duration(seconds: chapter.start.round()),
                  duration: chapterDuration(chapter.start, chapter.end),
                  onTap: () => onChapterTap(chapter),
                ),
              ),
            ],
          ),
        ],
        if (audioFiles.isNotEmpty) ...[
          const SizedBox(height: 8),
          ItemExpandableSection(
            title: 'Audio files (${audioFiles.length})',
            children: audioFiles
                .map(
                  (audioFile) => ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Text(audioFile.metadata.filename),
                    subtitle: audioFile.duration == null
                        ? null
                        : Text(formatDurationShort(Duration(seconds: audioFile.duration!.round()))),
                  ),
                )
                .toList(),
          ),
        ],
        if (ebookFile != null) ...[
          const SizedBox(height: 8),
          ItemExpandableSection(
            title: 'Ebook files',
            children: [
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                title: Text(ebookFile!.metadata.filename),
                subtitle: Text(ebookFile!.ebookFormat.toUpperCase()),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

String _publisherFilterQuery(String publisher) {
  return 'publishers.${encodeFilterValue(publisher)}';
}
