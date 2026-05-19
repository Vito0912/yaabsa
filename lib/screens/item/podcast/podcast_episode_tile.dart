import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';

class PodcastEpisodeTile extends StatelessWidget {
  const PodcastEpisodeTile({
    super.key,
    required this.episode,
    required this.progress,
    required this.canDownload,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isQueued,
    required this.isCurrentEpisode,
    required this.isPlayingCurrentEpisode,
    required this.onOpenDetails,
    required this.onPlayPressed,
    required this.onQueueToggle,
    this.onDownloadPressed,
    this.onDeletePressed,
    this.onMoreActionSelected,
    this.showMarkAsUnfinished = false,
  });

  final Episode episode;
  final MediaProgress? progress;
  final bool canDownload;
  final bool isDownloading;
  final bool isDownloaded;
  final bool isQueued;
  final bool isCurrentEpisode;
  final bool isPlayingCurrentEpisode;
  final VoidCallback onOpenDetails;
  final VoidCallback? onPlayPressed;
  final VoidCallback onQueueToggle;
  final VoidCallback? onDownloadPressed;
  final VoidCallback? onDeletePressed;
  final Future<void> Function(ItemMoreAction action)? onMoreActionSelected;
  final bool showMarkAsUnfinished;

  @override
  Widget build(BuildContext context) {
    final progressValue = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
    final isFinished = podcastEpisodeCompleted(progress);
    final statusLabel = isFinished
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
    final showProgressRing = progressValue > 0 && !isFinished;
    final isPlayEnabled = onPlayPressed != null;
    final playIcon = isCurrentEpisode && isPlayingCurrentEpisode
        ? Icons.pause_rounded
        : (isFinished ? Icons.replay_rounded : Icons.play_arrow_rounded);
    final playTooltip = isCurrentEpisode && isPlayingCurrentEpisode
        ? S.current.commonPause
        : (isFinished ? S.current.commonReplay : S.current.commonPlay);
    final playBackgroundColor = isPlayEnabled
        ? (isFinished ? colorScheme.primary : colorScheme.surface.withAlpha(230))
        : colorScheme.surfaceContainerHighest;
    final playIconColor = isPlayEnabled
        ? (isFinished ? colorScheme.onPrimary : colorScheme.onSurfaceVariant)
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    const playButtonTouchSize = 48.0;
    const playButtonVisualSize = 40.0;
    Widget secondaryActionButton(Widget child) {
      return SizedBox(
        width: playButtonTouchSize,
        height: playButtonTouchSize,
        child: Center(child: child),
      );
    }

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
                  SizedBox(
                    width: playButtonTouchSize,
                    height: playButtonTouchSize,
                    child: Center(
                      child: Container(
                        width: playButtonVisualSize,
                        height: playButtonVisualSize,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: playBackgroundColor),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (showProgressRing)
                              SizedBox(
                                width: playButtonVisualSize - 4,
                                height: playButtonVisualSize - 4,
                                child: CircularProgressIndicator(
                                  value: progressValue,
                                  strokeWidth: 3,
                                  backgroundColor: Colors.white24,
                                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                                ),
                              ),
                            IconButton(
                              onPressed: onPlayPressed,
                              tooltip: playTooltip,
                              constraints: const BoxConstraints.tightFor(
                                width: playButtonVisualSize,
                                height: playButtonVisualSize,
                              ),
                              padding: EdgeInsets.zero,
                              icon: Icon(playIcon, color: playIconColor, size: isFinished ? 20 : 18),
                              splashRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  secondaryActionButton(
                    IconButton.filledTonal(
                      onPressed: isCurrentEpisode ? null : onQueueToggle,
                      icon: Icon(isQueued ? Icons.playlist_remove_rounded : Icons.queue_music_rounded),
                      tooltip: isCurrentEpisode
                          ? 'Currently playing'
                          : (isQueued ? 'Remove from queue' : 'Add to queue'),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  if (canDownload && !context.isMobile) ...[
                    secondaryActionButton(
                      IconButton.filledTonal(
                        onPressed: isDownloading ? null : (isDownloaded ? onDeletePressed : onDownloadPressed),
                        icon: isDownloading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2))
                            : Icon(isDownloaded ? Icons.delete_outline_rounded : Icons.download_rounded),
                        tooltip: isDownloading ? 'Downloading' : (isDownloaded ? 'Delete download' : 'Download'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                  if (onMoreActionSelected != null) ...[
                    secondaryActionButton(
                      ItemMoreActionsButton(
                        onActionSelected: onMoreActionSelected!,
                        showMarkAsUnfinished: showMarkAsUnfinished,
                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
