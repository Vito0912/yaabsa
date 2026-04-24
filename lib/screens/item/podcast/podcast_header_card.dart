import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';

class PodcastHeaderCard extends StatelessWidget {
  const PodcastHeaderCard({
    super.key,
    required this.item,
    required this.cover,
    required this.totalEpisodes,
    required this.visibleEpisodes,
    required this.duration,
    required this.showFullDescription,
    required this.onBack,
    required this.onToggleDescription,
    this.onPlayLatest,
  });

  final LibraryItem item;
  final Widget cover;
  final int totalEpisodes;
  final int visibleEpisodes;
  final Duration? duration;
  final bool showFullDescription;
  final VoidCallback onBack;
  final VoidCallback? onPlayLatest;
  final VoidCallback onToggleDescription;

  @override
  Widget build(BuildContext context) {
    final metadata = item.media?.podcastMedia?.metadata;
    final description = metadata?.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;
    final previewDescription = hasDescription ? _plainTextPreview(description) : null;
    final coverSize = context.isMobile ? 164.0 : 210.0;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded), tooltip: 'Back'),
                const SizedBox(width: 4),
                Text('Podcast', style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            if (context.isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(width: coverSize, height: coverSize, child: cover),
                  ),
                  const SizedBox(height: 10),
                  _PodcastHeaderText(
                    item: item,
                    totalEpisodes: totalEpisodes,
                    visibleEpisodes: visibleEpisodes,
                    duration: duration,
                    onPlayLatest: onPlayLatest,
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(width: coverSize, height: coverSize, child: cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PodcastHeaderText(
                      item: item,
                      totalEpisodes: totalEpisodes,
                      visibleEpisodes: visibleEpisodes,
                      duration: duration,
                      onPlayLatest: onPlayLatest,
                    ),
                  ),
                ],
              ),
            if (hasDescription) ...[
              const SizedBox(height: 10),
              Text('DESCRIPTION', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 6),
              Text(
                showFullDescription ? description : previewDescription!,
                maxLines: showFullDescription ? null : 4,
                overflow: showFullDescription ? TextOverflow.visible : TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              TextButton(onPressed: onToggleDescription, child: Text(showFullDescription ? 'Show less' : 'Show more')),
            ],
          ],
        ),
      ),
    );
  }
}

class _PodcastHeaderText extends StatelessWidget {
  const _PodcastHeaderText({
    required this.item,
    required this.totalEpisodes,
    required this.visibleEpisodes,
    required this.duration,
    this.onPlayLatest,
  });

  final LibraryItem item;
  final int totalEpisodes;
  final int visibleEpisodes;
  final Duration? duration;
  final VoidCallback? onPlayLatest;

  @override
  Widget build(BuildContext context) {
    final metadata = item.media?.podcastMedia?.metadata;
    final author = metadata?.author;
    final countLabel = '$visibleEpisodes / $totalEpisodes episodes';
    final durationLabel = duration == null ? null : formatDurationLong(duration!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title, maxLines: 3, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
        if (author != null && author.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              author,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          durationLabel == null ? countLabel : '$countLabel • $durationLabel',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: onPlayLatest,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Play'),
        ),
      ],
    );
  }
}

String _plainTextPreview(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
}
