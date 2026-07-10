import 'package:flutter/foundation.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/library_item_overlay_play_button.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class LibraryItemWidget extends ConsumerStatefulWidget {
  const LibraryItemWidget(
    this.libraryItem,
    this.api, {
    super.key,
    this.sequenceBadge,
    this.showProgress = false,
    this.compact = false,
    this.squareCover = true,
    this.selectionMode = false,
    this.isSelected = false,
    this.enableHoverSelection = false,
    this.onToggleSelection,
    this.onEnterSelectionMode,
    this.onPlay,
    this.canEdit = false,
    this.onEdit,
  });

  final LibraryItem libraryItem;
  final ABSApi api;
  final String? sequenceBadge;
  final bool showProgress;
  final bool compact;
  final bool squareCover;
  final bool selectionMode;
  final bool isSelected;
  final bool enableHoverSelection;
  final VoidCallback? onToggleSelection;
  final VoidCallback? onEnterSelectionMode;
  final VoidCallback? onPlay;
  final bool canEdit;
  final VoidCallback? onEdit;

  @override
  ConsumerState<LibraryItemWidget> createState() => _LibraryItemWidgetState();
}

class _LibraryItemWidgetState extends ConsumerState<LibraryItemWidget> {
  bool _isHovered = false;

  bool get _isDesktopPlatform {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows;
  }

  bool get _isSelectableCard => widget.libraryItem.collapsedSeries == null;

  bool get _showHoverSelectionDot {
    return _isDesktopPlatform &&
        widget.enableHoverSelection &&
        _isHovered &&
        !widget.selectionMode &&
        _isSelectableCard;
  }

  @override
  Widget build(BuildContext context) {
    final progressMap = widget.showProgress
        ? (ref.watch(mediaProgressProvider).asData?.value ?? const <String, MediaProgress>{})
        : null;
    final shelfEpisode = _podcastShelfEpisode();
    final displayTitle = _resolvedDisplayTitle(shelfEpisode);
    final progress = widget.showProgress ? _resolveProgress(progressMap!) : null;
    final completedDownloadItemIds = ref.watch(completedDownloadItemIdsProvider).asData?.value ?? const <String>{};
    final isDownloaded = shelfEpisode != null
        ? completedDownloadItemIds.contains(shelfEpisode.id)
        : (widget.libraryItem.mediaType != 'podcast' && completedDownloadItemIds.contains(widget.libraryItem.id));
    final collapsedSeriesBookCount = widget.libraryItem.collapsedSeries?.numBooks ?? 0;
    final collapsedSeriesId = widget.libraryItem.collapsedSeries?.id;
    final isCollapsedSeriesCard = widget.libraryItem.collapsedSeries != null;
    final isPodcast = !(widget.libraryItem.media?.hasAudio ?? widget.libraryItem.media?.hasBook ?? true);
    final unplayedEpisodes = isPodcast
        ? ((widget.libraryItem.media?.podcastMedia?.numEpisodes ?? 0) -
              ref
                  .read(mediaProgressProvider.notifier)
                  .getAllProgressForLibraryItem(widget.libraryItem.id)
                  .where((progress) => progress.isFinished)
                  .length)
        : 0;

    final sequenceBadgeLabel = unplayedEpisodes > 0 ? unplayedEpisodes.toString() : widget.sequenceBadge?.trim();
    final showSequenceBadge = unplayedEpisodes > 0 || (sequenceBadgeLabel != null && sequenceBadgeLabel.isNotEmpty);

    final progressValue =
        (progress != null ? (progress.progress != 0.0 ? progress.progress : progress.ebookProgress) : 0.0) ?? 0.0;
    final showProgressRing = widget.showProgress && progressValue > 0;

    return StreamBuilder<PlayerState>(
      stream: audioHandler.playerControlStateStream,
      initialData: audioHandler.playerControlState,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isCurrentItem =
            audioHandler.currentMediaItem?.itemId == widget.libraryItem.id &&
            (shelfEpisode == null || audioHandler.currentMediaItem?.episodeId == shelfEpisode.id);
        final isPlayingCurrentItem = isCurrentItem && (playerState?.playing ?? false);
        final colorScheme = Theme.of(context).colorScheme;
        final isFinished =
            showProgressRing && (progressValue >= 0.999 == true ? true : (progress?.isFinished ?? false));
        const activeBorderWidth = 4.0;
        const selectedBorderWidth = 2.5;
        final hasSelectionBorder = widget.selectionMode && widget.isSelected;
        final borderWidth = isCurrentItem
            ? activeBorderWidth
            : hasSelectionBorder
            ? selectedBorderWidth
            : 0.0;
        final activeCoverInset = borderWidth > 0 ? (borderWidth / 4) : 0.0;
        final coverRadius = BorderRadius.circular(isCurrentItem ? 14 : 16);
        final activeBorderColor = isCurrentItem
            ? colorScheme.primary.withValues(alpha: isPlayingCurrentItem ? 1.0 : 0.75)
            : colorScheme.primary;

        void handleCardTap() {
          if (widget.selectionMode) {
            if (isCollapsedSeriesCard) {
              return;
            }
            widget.onToggleSelection?.call();
            return;
          }

          if (isCollapsedSeriesCard && collapsedSeriesId != null && collapsedSeriesId.isNotEmpty) {
            context.push('/series/$collapsedSeriesId');
            return;
          }

          context.push('/item/${widget.libraryItem.id}');
        }

        void handleCardLongPress() {
          if (isCollapsedSeriesCard) {
            return;
          }
          if (widget.onEnterSelectionMode != null) {
            widget.onEnterSelectionMode!.call();
            return;
          }
          widget.onToggleSelection?.call();
        }

        void handleSelectionDotTap() {
          if (widget.selectionMode) {
            widget.onToggleSelection?.call();
            return;
          }

          if (widget.onEnterSelectionMode != null) {
            widget.onEnterSelectionMode!.call();
            return;
          }

          widget.onToggleSelection?.call();
        }

        final showSelectionDot = (widget.selectionMode || _showHoverSelectionDot) && !isCollapsedSeriesCard;
        final selectionOverlayAlpha = widget.isSelected ? 0.15 : 0.5;
        final downloadBadgeTop = showSelectionDot ? 34.0 : 4.0;
        final sequenceBadgeTop = isDownloaded ? downloadBadgeTop + 30.0 : (showSelectionDot ? 34.0 : 4.0);
        final canShowEditControls =
            widget.canEdit && widget.onEdit != null && !widget.selectionMode && !isCollapsedSeriesCard;
        final showDesktopHoverEdit = canShowEditControls && _isDesktopPlatform && _isHovered;
        final topRightPrimaryTop = 4.0;
        final desktopEditLeft = showSelectionDot ? 38.0 : 4.0;

        final cardContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.all(activeCoverInset),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: borderWidth > 0 ? Border.all(color: activeBorderColor, width: borderWidth) : null,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: coverRadius,
                    child: widget.squareCover
                        ? AspectRatio(
                            aspectRatio: 1,
                            child: widget.api.getLibraryItemApi().getLibraryItemCover(
                              widget.libraryItem.id,
                              item: widget.libraryItem,
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: widget.api.getLibraryItemApi().getLibraryItemCover(
                              widget.libraryItem.id,
                              item: widget.libraryItem,
                            ),
                          ),
                  ),
                  if (widget.selectionMode)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: ClipRRect(
                          borderRadius: coverRadius,
                          child: ColoredBox(color: Colors.black.withValues(alpha: selectionOverlayAlpha)),
                        ),
                      ),
                    ),
                  if (showSelectionDot)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: handleSelectionDotTap,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: widget.isSelected
                                  ? colorScheme.primary
                                  : colorScheme.surface.withValues(alpha: 0.85),
                              border: Border.all(color: widget.isSelected ? colorScheme.primary : colorScheme.outline),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              widget.isSelected ? Icons.check : Icons.circle_outlined,
                              size: 14,
                              color: widget.isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isDownloaded)
                    Positioned(
                      top: downloadBadgeTop,
                      left: 4,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: colorScheme.primary),
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.cloud_done_rounded, size: 14, color: colorScheme.onPrimary),
                      ),
                    ),
                  if (showSequenceBadge)
                    Positioned(
                      top: sequenceBadgeTop,
                      left: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: colorScheme.primaryContainer.withValues(alpha: 0.92),
                          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.42)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          sequenceBadgeLabel!,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: colorScheme.onPrimaryContainer),
                        ),
                      ),
                    ),
                  Positioned(
                    top: topRightPrimaryTop,
                    right: 4,
                    child: isCollapsedSeriesCard
                        ? Tooltip(
                            message:
                                '$collapsedSeriesBookCount '
                                '${collapsedSeriesBookCount == 1 ? 'book' : 'books'} in series',
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: colorScheme.secondaryContainer,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.collections_bookmark_rounded,
                                    size: 14,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$collapsedSeriesBookCount',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : widget.selectionMode
                        ? const SizedBox.shrink()
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: isFinished ? colorScheme.primary : colorScheme.surface.withAlpha(230),
                            ),
                            child: LibraryItemOverlayPlayButton(
                              libraryItem: widget.libraryItem,
                              shelfEpisode: shelfEpisode,
                              showProgressRing: showProgressRing,
                              progressValue: progressValue,
                              isFinished: isFinished,
                              isCurrentItem: isCurrentItem,
                              isPlayingCurrentItem: isPlayingCurrentItem,
                              onPlay: widget.onPlay,
                              isEbook:
                                  !(widget.libraryItem.media?.hasAudio ?? false) &&
                                  (widget.libraryItem.media?.hasBook ?? false),
                            ),
                          ),
                  ),
                  if (showDesktopHoverEdit)
                    Positioned(
                      top: 4,
                      left: desktopEditLeft,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: widget.onEdit,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: colorScheme.surface.withValues(alpha: 0.85),
                              border: Border.all(color: colorScheme.outline),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.edit_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: widget.compact ? 6 : 8),
            Text(
              displayTitle,
              maxLines: widget.compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
              style: widget.compact ? Theme.of(context).textTheme.bodyMedium : null,
            ),
          ],
        );

        final canHandleTap = !(widget.selectionMode && isCollapsedSeriesCard);

        return Padding(
          padding: widget.compact ? const EdgeInsets.all(4) : const EdgeInsets.all(8),
          child: _isDesktopPlatform
              ? MouseRegion(
                  cursor: canHandleTap ? SystemMouseCursors.click : SystemMouseCursors.basic,
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: canHandleTap ? handleCardTap : null,
                    onLongPress:
                        (isCollapsedSeriesCard ||
                            (widget.onEnterSelectionMode == null && widget.onToggleSelection == null))
                        ? null
                        : handleCardLongPress,
                    child: cardContent,
                  ),
                )
              : InkWell(
                  onTap: canHandleTap ? handleCardTap : null,
                  onLongPress:
                      (isCollapsedSeriesCard ||
                          (widget.onEnterSelectionMode == null && widget.onToggleSelection == null))
                      ? null
                      : handleCardLongPress,
                  borderRadius: BorderRadius.circular(16),
                  child: cardContent,
                ),
        );
      },
    );
  }

  String _resolvedDisplayTitle(Episode? shelfEpisode) {
    final episodeTitle = shelfEpisode?.title?.trim();
    if (episodeTitle != null && episodeTitle.isNotEmpty) {
      return episodeTitle;
    }

    return widget.libraryItem.title;
  }

  List<Episode> _playablePodcastEpisodes() {
    return (widget.libraryItem.media?.podcastMedia?.episodes ?? const <Episode>[])
        .where((episode) => episode.audioFile != null)
        .toList(growable: false);
  }

  Episode? _podcastShelfEpisode() {
    if (widget.libraryItem.mediaType != 'podcast') {
      return null;
    }

    final episodes = _playablePodcastEpisodes();
    if (episodes.length != 1) {
      return null;
    }

    return episodes.first;
  }

  MediaProgress? _resolveProgress(Map<String, MediaProgress> progressMap) {
    final shelfEpisode = _podcastShelfEpisode();
    if (shelfEpisode != null) {
      return progressMap[mediaProgressKey(widget.libraryItem.id, shelfEpisode.id)];
    }

    final itemProgress = progressMap[widget.libraryItem.id];
    if (itemProgress != null && widget.libraryItem.mediaType != 'podcast') {
      return itemProgress;
    }

    final podcastEpisodes = widget.libraryItem.media?.podcastMedia?.episodes;
    if (podcastEpisodes == null || podcastEpisodes.isEmpty) {
      return null;
    }

    for (final episode in podcastEpisodes) {
      final episodeProgress = progressMap[mediaProgressKey(widget.libraryItem.id, episode.id)];
      if (episodeProgress != null) {
        return episodeProgress;
      }
    }

    return null;
  }
}
