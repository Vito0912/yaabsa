import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/util/item_formatters.dart';

class PodcastEpisodeTile extends StatelessWidget {
  const PodcastEpisodeTile({
    super.key,
    required this.episode,
    required this.progress,
    required this.canDownload,
    required this.isQueued,
    required this.isCurrentEpisode,
    required this.isPlayingCurrentEpisode,
    required this.onOpenDetails,
    required this.onPlayPressed,
    required this.onQueueToggle,
    this.onDownloadPressed,
  });

  final Episode episode;
  final MediaProgress? progress;
  final bool canDownload;
  final bool isQueued;
  final bool isCurrentEpisode;
  final bool isPlayingCurrentEpisode;
  final VoidCallback onOpenDetails;
  final VoidCallback? onPlayPressed;
  final VoidCallback onQueueToggle;
  final VoidCallback? onDownloadPressed;

  @override
  Widget build(BuildContext context) {
    final progressValue = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
    final statusLabel = podcastEpisodeCompleted(progress)
        ? 'Complete'
        : podcastEpisodeInProgress(progress)
        ? 'In Progress'
        : 'Incomplete';

    final duration = episode.audioFile?.duration;
    final durationLabel = duration == null ? null : formatDurationShort(Duration(seconds: duration.round()));
    final publishedLabel = podcastFormatEpisodeDate(episode);
    final descriptionPreview = podcastEpisodeDescriptionPreview(episode);
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isCurrentEpisode
        ? colorScheme.primaryContainer.withValues(alpha: 0.18)
        : colorScheme.surfaceContainerLow;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onOpenDetails,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcastEpisodeTitle(episode),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (podcastEpisodeSubtitle(episode) != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              podcastEpisodeSubtitle(episode)!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ),
                        if (descriptionPreview != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              descriptionPreview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: onPlayPressed,
                    icon: Icon(
                      isCurrentEpisode && isPlayingCurrentEpisode ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                    tooltip: isCurrentEpisode && isPlayingCurrentEpisode ? 'Pause' : 'Play',
                  ),
                  const SizedBox(width: 4),
                  IconButton.filledTonal(
                    onPressed: isCurrentEpisode ? null : onQueueToggle,
                    icon: Icon(isQueued ? Icons.playlist_remove_rounded : Icons.queue_music_rounded),
                    tooltip: isCurrentEpisode ? 'Currently playing' : (isQueued ? 'Remove from queue' : 'Add to queue'),
                  ),
                  if (canDownload) ...[
                    const SizedBox(width: 4),
                    IconButton.filledTonal(
                      onPressed: onDownloadPressed,
                      icon: const Icon(Icons.download_rounded),
                      tooltip: 'Download',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (publishedLabel != null)
                    Text(
                      publishedLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  if (durationLabel != null)
                    Text(
                      durationLabel,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  Text(
                    statusLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              if (progressValue > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(value: progressValue, minHeight: 3.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
