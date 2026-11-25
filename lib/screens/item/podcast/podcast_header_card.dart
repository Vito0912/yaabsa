import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/buttons/playback_action_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
    this.onShuffle,
    this.onPauseLatest,
    this.onFindEpisodes,
    this.onEditPodcast,
    this.onDownloadPress,
    this.isPinned = false,
    this.onMoreActionSelected,
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
  final VoidCallback? onShuffle;
  final VoidCallback? onPauseLatest;
  final VoidCallback? onFindEpisodes;
  final VoidCallback? onEditPodcast;
  final VoidCallback? onDownloadPress;
  final bool isPinned;
  final Future<void> Function(ItemMoreAction action)? onMoreActionSelected;
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
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: context.l10n.actionBack,
                ),
                const SizedBox(width: 4),
                Text(context.l10n.mediaTypePodcast, style: Theme.of(context).textTheme.titleSmall),
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
                    onShuffle: onShuffle,
                    onPauseLatest: onPauseLatest,
                    onFindEpisodes: onFindEpisodes,
                    onEditPodcast: onEditPodcast,
                    onDownloadPress: onDownloadPress,
                    isPinned: isPinned,
                    onMoreActionSelected: onMoreActionSelected,
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
                      onShuffle: onShuffle,
                      onPauseLatest: onPauseLatest,
                      onFindEpisodes: onFindEpisodes,
                      onEditPodcast: onEditPodcast,
                      onDownloadPress: onDownloadPress,
                      isPinned: isPinned,
                      onMoreActionSelected: onMoreActionSelected,
                    ),
                  ),
                ],
              ),
            if (hasDescription) ...[
              const SizedBox(height: 10),
              Text(context.l10n.fieldDescription, style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 6),
              Text(
                showFullDescription ? description : previewDescription!,
                maxLines: showFullDescription ? null : 4,
                overflow: showFullDescription ? TextOverflow.visible : TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: onToggleDescription,
                child: Text(showFullDescription ? context.l10n.actionShowLess : context.l10n.actionReadMore),
              ),
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
    this.onShuffle,
    this.onPauseLatest,
    this.onFindEpisodes,
    this.onEditPodcast,
    this.onDownloadPress,
    this.isPinned = false,
    this.onMoreActionSelected,
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
  final VoidCallback? onShuffle;
  final VoidCallback? onPauseLatest;
  final VoidCallback? onFindEpisodes;
  final VoidCallback? onEditPodcast;
  final VoidCallback? onDownloadPress;
  final bool isPinned;
  final Future<void> Function(ItemMoreAction action)? onMoreActionSelected;

  @override
  Widget build(BuildContext context) {
    final metadata = item.media?.podcastMedia?.metadata;
    final author = metadata?.author;
    final countLabel = visibleEpisodes == totalEpisodes
        ? context.l10n.episodeCount(totalEpisodes)
        : context.l10n.statusEpisodeResultsSubset(visibleEpisodes, totalEpisodes);
    final durationLabel = duration == null ? null : formatDurationLong(duration!);
    final playLabel = isLoadingCurrentPlayableEpisode
        ? context.l10n.statusLoading
        : (isPlayingCurrentPlayableEpisode ? context.l10n.playbackPause : context.l10n.playbackPlay);
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
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        const SizedBox(height: 8),
        Text(
          durationLabel == null ? countLabel : context.l10n.podcastEpisodeCountAndDuration(countLabel, durationLabel),
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            YaabsaPlaybackActionButton(
              label: playLabel,
              isPlaying: isPlayingCurrentPlayableEpisode,
              isLoading: isLoadingCurrentPlayableEpisode,
              onPressed: onPressed,
            ),
            if (onShuffle != null)
              YaabsaActionIconButton(
                icon: Icons.shuffle_rounded,
                variant: YaabsaActionButtonVariant.filledTonal,
                shape: YaabsaActionButtonShape.rounded,
                tooltip: context.l10n.actionPlayRandomItem,
                onPressed: onShuffle,
              ),
            if (onDownloadPress != null)
              YaabsaActionIconButton(
                icon: Icons.download_rounded,
                variant: YaabsaActionButtonVariant.filledTonal,
                shape: YaabsaActionButtonShape.rounded,
                tooltip: context.l10n.actionDownloadOptions,
                onPressed: onDownloadPress,
              ),
            if (onFindEpisodes != null)
              YaabsaActionIconButton(
                icon: isFindingEpisodes ? null : Icons.search_rounded,
                iconWidget: isFindingEpisodes
                    ? const SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2.2))
                    : null,
                variant: YaabsaActionButtonVariant.filledTonal,
                shape: YaabsaActionButtonShape.rounded,
                enabled: !isFindingEpisodes,
                tooltip: context.l10n.actionFindEpisodes,
                onPressed: onFindEpisodes,
              ),
            if (onEditPodcast != null)
              YaabsaActionIconButton(
                icon: Icons.edit_rounded,
                variant: YaabsaActionButtonVariant.filledTonal,
                shape: YaabsaActionButtonShape.rounded,
                tooltip: context.l10n.actionEdit,
                onPressed: onEditPodcast,
              ),
            if (onMoreActionSelected != null)
              ItemMoreActionsButton(
                onActionSelected: onMoreActionSelected!,
                shape: YaabsaActionButtonShape.rounded,
                showMarkAction: false,
                showPinAction: true,
                isPinned: isPinned,
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
