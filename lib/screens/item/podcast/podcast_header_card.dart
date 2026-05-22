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
    this.isCurrentPlayableEpisode = false,
    this.isPlayingCurrentPlayableEpisode = false,
    this.isLoadingCurrentPlayableEpisode = false,
    this.isFindingEpisodes = false,
    this.onPlayLatest,
    this.onPauseLatest,
    this.onFindEpisodes,
    this.onEditPodcast,
  });

  final LibraryItem item;
  final Widget cover;
  final int totalEpisodes;
  final int visibleEpisodes;
  final Duration? duration;
  final bool showFullDescription;
  final VoidCallback onBack;
  final bool isCurrentPlayableEpisode;
  final bool isPlayingCurrentPlayableEpisode;
  final bool isLoadingCurrentPlayableEpisode;
  final bool isFindingEpisodes;
  final VoidCallback? onPlayLatest;
  final VoidCallback? onPauseLatest;
  final VoidCallback? onFindEpisodes;
  final VoidCallback? onEditPodcast;
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
                    isCurrentPlayableEpisode: isCurrentPlayableEpisode,
                    isPlayingCurrentPlayableEpisode: isPlayingCurrentPlayableEpisode,
                    isLoadingCurrentPlayableEpisode: isLoadingCurrentPlayableEpisode,
                    isFindingEpisodes: isFindingEpisodes,
                    onPlayLatest: onPlayLatest,
                    onPauseLatest: onPauseLatest,
                    onFindEpisodes: onFindEpisodes,
                    onEditPodcast: onEditPodcast,
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
                      isCurrentPlayableEpisode: isCurrentPlayableEpisode,
                      isPlayingCurrentPlayableEpisode: isPlayingCurrentPlayableEpisode,
                      isLoadingCurrentPlayableEpisode: isLoadingCurrentPlayableEpisode,
                      isFindingEpisodes: isFindingEpisodes,
                      onPlayLatest: onPlayLatest,
                      onPauseLatest: onPauseLatest,
                      onFindEpisodes: onFindEpisodes,
                      onEditPodcast: onEditPodcast,
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
    required this.isCurrentPlayableEpisode,
    required this.isPlayingCurrentPlayableEpisode,
    required this.isLoadingCurrentPlayableEpisode,
    required this.isFindingEpisodes,
    this.onPlayLatest,
    this.onPauseLatest,
    this.onFindEpisodes,
    this.onEditPodcast,
  });

  final LibraryItem item;
  final int totalEpisodes;
  final int visibleEpisodes;
  final Duration? duration;
  final bool isCurrentPlayableEpisode;
  final bool isPlayingCurrentPlayableEpisode;
  final bool isLoadingCurrentPlayableEpisode;
  final bool isFindingEpisodes;
  final VoidCallback? onPlayLatest;
  final VoidCallback? onPauseLatest;
  final VoidCallback? onFindEpisodes;
  final VoidCallback? onEditPodcast;

  @override
  Widget build(BuildContext context) {
    final metadata = item.media?.podcastMedia?.metadata;
    final author = metadata?.author;
    final countLabel = '$visibleEpisodes / $totalEpisodes episodes';
    final durationLabel = duration == null ? null : formatDurationLong(duration!);
    final playLabel = isLoadingCurrentPlayableEpisode
        ? 'Loading'
        : (isPlayingCurrentPlayableEpisode ? 'Pause' : (isCurrentPlayableEpisode ? 'Resume' : 'Play'));
    final iconWidget = isLoadingCurrentPlayableEpisode
        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2))
        : Icon(isPlayingCurrentPlayableEpisode ? Icons.pause_rounded : Icons.play_arrow_rounded);
    final onPressed = isLoadingCurrentPlayableEpisode
        ? null
        : (isPlayingCurrentPlayableEpisode ? onPauseLatest : onPlayLatest);

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(onPressed: onPressed, icon: iconWidget, label: Text(playLabel)),
            if (onFindEpisodes != null)
              IconButton.filledTonal(
                onPressed: isFindingEpisodes ? null : onFindEpisodes,
                tooltip: 'Find episodes',
                icon: isFindingEpisodes
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.2))
                    : const Icon(Icons.search_rounded),
                visualDensity: VisualDensity.compact,
              ),
            if (onEditPodcast != null)
              IconButton.filledTonal(
                onPressed: onEditPodcast,
                tooltip: 'Edit podcast',
                icon: const Icon(Icons.edit_rounded),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ],
    );
  }
}

String _plainTextPreview(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
}
