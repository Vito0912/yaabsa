import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/buttons/media_play_button.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
    this.showMarkAsFinished = true,
    this.showMarkAsUnfinished = false,
    this.showPinAction = false,
    this.showAddToPlaylist = false,
    this.isPinned = false,
    this.isHighlighted = false,
    this.allowSelection = false,
    this.selectionMode = false,
    this.isSelected = false,
    this.onSelectedChanged,
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
  final bool showMarkAsFinished;
  final bool showMarkAsUnfinished;
  final bool showPinAction;
  final bool showAddToPlaylist;
  final bool isPinned;
  final bool isHighlighted;
  final bool allowSelection;
  final bool selectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectedChanged;

  @override
  Widget build(BuildContext context) {
    final effectiveSelectionMode = allowSelection && selectionMode;
    final progressValue = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
    final isFinished = podcastEpisodeCompleted(progress);

    final duration = episode.audioFile?.duration ?? episode.duration;
    final durationLabel = duration == null ? null : formatDurationShort(Duration(seconds: duration.round()));
    final publishedLabel = podcastFormatEpisodeDate(episode);
    final descriptionPreview = podcastEpisodeDescriptionPreview(episode);
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = _backgroundColor(
      colorScheme,
      isHighlighted: isHighlighted,
      isCurrentEpisode: isCurrentEpisode,
      isSelected: isSelected,
    );
    final borderColor = _borderColor(
      colorScheme,
      isHighlighted: isHighlighted,
      isCurrentEpisode: isCurrentEpisode,
      isSelected: isSelected,
    );
    final showProgressRing = progressValue > 0 && !isFinished;
    final playTooltip = isCurrentEpisode && isPlayingCurrentEpisode ? 'Pause' : (isFinished ? 'Replay' : 'Play');
    const playButtonTouchSize = 48.0;
    const playButtonVisualSize = 40.0;
    Widget secondaryActionButton(Widget child) {
      return SizedBox(
        width: playButtonTouchSize,
        height: playButtonTouchSize,
        child: Center(child: child),
      );
    }

    const cardRadius = 20.0;
    final onTap = effectiveSelectionMode ? () => onSelectedChanged?.call(!isSelected) : onOpenDetails;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: borderColor),
      ),
      child: YaabsaSurfaceCard(
        color: Colors.transparent,
        padding: EdgeInsets.zero,
        borderRadius: cardRadius,
        child: InkWell(
          onTap: onTap,
          onLongPress: allowSelection ? () => onSelectedChanged?.call(!isSelected) : null,
          borderRadius: BorderRadius.circular(cardRadius),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (effectiveSelectionMode) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 8),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(value: isSelected, onChanged: onSelectedChanged),
                        ),
                      ),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            podcastEpisodeTitle(episode),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (podcastEpisodeSubtitle(episode) != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                podcastEpisodeSubtitle(episode)!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                          if (descriptionPreview != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                descriptionPreview,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!effectiveSelectionMode) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: playButtonTouchSize,
                        height: playButtonTouchSize,
                        child: Center(
                          child: YaabsaMediaPlayButton(
                            size: playButtonVisualSize,
                            tooltip: playTooltip,
                            isPlaying: isCurrentEpisode && isPlayingCurrentEpisode,
                            isFinished: isFinished,
                            isLoading: false,
                            onPressed: onPlayPressed,
                            progress: showProgressRing ? progressValue : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      secondaryActionButton(
                        YaabsaActionIconButton(
                          icon: isQueued ? Icons.playlist_remove_rounded : Icons.queue_music_rounded,
                          variant: YaabsaActionButtonVariant.filledTonal,
                          shape: YaabsaActionButtonShape.rounded,
                          tooltip: isCurrentEpisode
                              ? 'Currently playing'
                              : (isQueued ? 'Remove from queue' : 'Add to queue'),
                          onPressed: isCurrentEpisode ? null : onQueueToggle,
                        ),
                      ),
                      if (canDownload && !context.isMobile) ...[
                        secondaryActionButton(
                          isDownloaded && !isDownloading
                              ? YaabsaDeleteIconButton(tooltip: 'Delete download', onPressed: onDeletePressed)
                              : YaabsaActionIconButton(
                                  icon: isDownloading ? null : Icons.download_rounded,
                                  iconWidget: isDownloading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: YaabsaCircularProgressIndicator(strokeWidth: 2.2),
                                        )
                                      : null,
                                  variant: YaabsaActionButtonVariant.filledTonal,
                                  shape: YaabsaActionButtonShape.rounded,
                                  enabled: !isDownloading,
                                  onPressed: onDownloadPressed,
                                  tooltip: isDownloading ? 'Downloading' : 'Download',
                                ),
                        ),
                      ],
                      if (onMoreActionSelected != null) ...[
                        secondaryActionButton(
                          ItemMoreActionsButton(
                            onActionSelected: onMoreActionSelected!,
                            shape: YaabsaActionButtonShape.rounded,
                            showMarkAsFinished: showMarkAsFinished,
                            showMarkAsUnfinished: showMarkAsUnfinished,
                            showSelect: allowSelection,
                            showPinAction: showPinAction,
                            showAddToPlaylist: showAddToPlaylist,
                            isPinned: isPinned,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (publishedLabel != null)
                      _episodeInfoChip(context, icon: Icons.calendar_today_rounded, label: publishedLabel),
                    if (durationLabel != null)
                      _episodeInfoChip(context, icon: Icons.schedule_rounded, label: durationLabel),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(
    ColorScheme colorScheme, {
    required bool isHighlighted,
    required bool isCurrentEpisode,
    required bool isSelected,
  }) {
    if (isHighlighted) {
      return colorScheme.primaryContainer.withValues(alpha: 0.64);
    }
    if (isCurrentEpisode) {
      return colorScheme.primaryContainer.withValues(alpha: 0.24);
    }
    if (isSelected) {
      return colorScheme.primaryContainer.withValues(alpha: 0.18);
    }
    return colorScheme.surfaceContainerLow;
  }

  Color _borderColor(
    ColorScheme colorScheme, {
    required bool isHighlighted,
    required bool isCurrentEpisode,
    required bool isSelected,
  }) {
    if (isHighlighted) {
      return colorScheme.primary.withValues(alpha: 0.72);
    }
    if (isCurrentEpisode) {
      return colorScheme.primary.withValues(alpha: 0.48);
    }
    if (isSelected) {
      return colorScheme.primary.withValues(alpha: 0.34);
    }
    return colorScheme.outlineVariant.withValues(alpha: 0.42);
  }
}

Widget _episodeInfoChip(BuildContext context, {required IconData icon, required String label}) {
  final theme = Theme.of(context);
  final foreground = theme.colorScheme.onSurfaceVariant;

  return Chip(
    avatar: Icon(icon, size: 16, color: foreground),
    label: Text(label),
    labelStyle: theme.textTheme.labelMedium?.copyWith(color: foreground),
    visualDensity: VisualDensity.compact,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    side: BorderSide.none,
    backgroundColor: theme.colorScheme.surfaceContainerHigh,
  );
}
