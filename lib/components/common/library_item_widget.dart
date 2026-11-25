import 'dart:async';

import 'package:yaabsa/features/library/widgets/library_item_card.dart';
import 'package:yaabsa/components/app/item/editor/open_library_item_editor_dialog.dart';
import 'package:yaabsa/components/app/library/library_item_context_menu.dart';
import 'package:yaabsa/components/app/item/item_progress_actions.dart';
import 'package:yaabsa/components/common/library_item_issue_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/additional_information_text.dart';
import 'package:yaabsa/components/common/library_item_overlay_play_button.dart';
import 'package:yaabsa/components/app/downloads/item_download_indicator.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/library_view_subtitles.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/server_management_preferences.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class LibraryItemWidget extends ConsumerStatefulWidget {
  const LibraryItemWidget(
    this.libraryItem,
    this.api, {
    super.key,
    this.sequenceBadge,
    this.subtitle,
    this.showProgress = false,
    this.compact = false,
    this.squareCover = true,
    this.coverCacheSize,
    this.selectionMode = false,
    this.isSelected = false,
    this.enableHoverSelection = false,
    this.onToggleSelection,
    this.onEnterSelectionMode,
    this.onActivate,
    this.playbackStateHandler,
    this.onPlay,
    this.canEdit = false,
    this.onEdit,
    this.onContextMenu,
    this.episodeIdToReveal,
  });

  final LibraryItem libraryItem;
  final ABSApi api;
  final String? sequenceBadge;
  final LibraryViewSubtitle? subtitle;
  final bool showProgress;
  final bool compact;
  final bool squareCover;
  final int? coverCacheSize;
  final bool selectionMode;
  final bool isSelected;
  final bool enableHoverSelection;
  final VoidCallback? onToggleSelection;
  final VoidCallback? onEnterSelectionMode;
  final VoidCallback? onActivate;
  final BGAudioHandler? playbackStateHandler;
  final VoidCallback? onPlay;
  final bool canEdit;
  final VoidCallback? onEdit;
  final ValueChanged<Offset>? onContextMenu;
  final String? episodeIdToReveal;

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

  bool get _isSelectableCard => isBulkSelectableLibraryItem(widget.libraryItem);

  bool get _showHoverSelectionDot {
    return _isDesktopPlatform &&
        widget.enableHoverSelection &&
        _isHovered &&
        !widget.selectionMode &&
        _isSelectableCard;
  }

  @override
  Widget build(BuildContext context) {
    final playbackStateHandler = widget.playbackStateHandler ?? audioHandler;
    final shelfEpisode = _podcastShelfEpisode();
    final isPodcastItem = widget.libraryItem.mediaType == 'podcast';
    final itemProgress = widget.showProgress && !isPodcastItem
        ? ref.watch(mediaProgressByKeyProvider(widget.libraryItem.id))
        : null;
    final podcastProgress = widget.showProgress && isPodcastItem
        ? ref.watch(mediaProgressForLibraryItemProvider(widget.libraryItem.id))
        : const <MediaProgress>[];
    final progress = isPodcastItem ? _resolvePodcastProgress(podcastProgress) : itemProgress;
    final finishedEpisodeCount = isPodcastItem ? podcastProgress.where((progress) => progress.isFinished).length : 0;
    final displayTitle = _resolvedDisplayTitle(shelfEpisode);
    final collapsedSeriesBookCount = widget.libraryItem.collapsedSeries?.numBooks ?? 0;
    final collapsedSeriesId = widget.libraryItem.collapsedSeries?.id;
    final isCollapsedSeriesCard = widget.libraryItem.collapsedSeries != null;
    final isPodcast = !(widget.libraryItem.media?.hasAudio ?? widget.libraryItem.media?.hasBook ?? true);
    final unplayedEpisodes = isPodcast
        ? ((widget.libraryItem.media?.podcastMedia?.numEpisodes ?? 0) - finishedEpisodeCount)
        : 0;

    final sequenceBadgeLabel = unplayedEpisodes > 0 ? unplayedEpisodes.toString() : widget.sequenceBadge?.trim();
    final showSequenceBadge = unplayedEpisodes > 0 || (sequenceBadgeLabel != null && sequenceBadgeLabel.isNotEmpty);

    final progressValue =
        (progress != null ? (progress.progress != 0.0 ? progress.progress : progress.ebookProgress) : 0.0) ?? 0.0;
    final showProgressRing = widget.showProgress && progressValue > 0;

    final colorScheme = Theme.of(context).colorScheme;
    final showSelectionDot = (widget.selectionMode || _showHoverSelectionDot) && _isSelectableCard;
    final selectionOverlayAlpha = widget.isSelected ? 0.15 : 0.5;
    final downloadBadgeTop = showSelectionDot ? 34.0 : 4.0;
    final canShowEditControls =
        widget.canEdit && widget.onEdit != null && !widget.selectionMode && !isCollapsedSeriesCard;
    final showDesktopHoverEdit = canShowEditControls && _isDesktopPlatform && _isHovered;
    const topRightPrimaryTop = 4.0;
    final desktopEditLeft = showSelectionDot ? 38.0 : 4.0;

    void handleCardTap() {
      if (widget.selectionMode && _isSelectableCard) {
        widget.onToggleSelection?.call();
        return;
      }

      if (widget.onActivate != null) {
        widget.onActivate!.call();
        return;
      }

      if (isCollapsedSeriesCard && collapsedSeriesId != null && collapsedSeriesId.isNotEmpty) {
        context.push('/series/$collapsedSeriesId');
        return;
      }

      final episodeId = widget.episodeIdToReveal?.trim();
      context.push(
        Uri(
          path: '/item/${widget.libraryItem.id}',
          queryParameters: episodeId == null || episodeId.isEmpty ? null : <String, String>{'episodeId': episodeId},
        ).toString(),
      );
    }

    void handleCardLongPress() {
      if (!_isSelectableCard) {
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

    final cover = _LibraryItemPlaybackStateBuilder(
      itemId: widget.libraryItem.id,
      episodeId: shelfEpisode?.id,
      audioHandler: playbackStateHandler,
      builder: (context, isCurrentItem, isPlayingCurrentItem) {
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

        return AnimatedContainer(
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
                          cacheWidth: widget.coverCacheSize?.toDouble(),
                          cacheHeight: widget.coverCacheSize?.toDouble(),
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
              if (widget.selectionMode && _isSelectableCard)
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
                          color: widget.isSelected ? colorScheme.primary : colorScheme.surface.withValues(alpha: 0.85),
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
              Positioned(
                top: downloadBadgeTop,
                left: 4,
                child: ItemDownloadBadges(
                  itemId: widget.libraryItem.id,
                  episodeId: shelfEpisode?.id,
                  sequenceBadge: showSequenceBadge
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: colorScheme.primaryContainer.withValues(alpha: 0.92),
                            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.42)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          child: Text(
                            sequenceBadgeLabel!,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colorScheme.onPrimaryContainer),
                          ),
                        )
                      : null,
                ),
              ),
              Positioned(
                top: topRightPrimaryTop,
                right: 4,
                child: isCollapsedSeriesCard
                    ? Tooltip(
                        message: context.l10n.seriesBookCount(collapsedSeriesBookCount),
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
                                context.l10n.numberValue(collapsedSeriesBookCount),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      )
                    : (widget.selectionMode && _isSelectableCard) || widget.libraryItem.hasIssue
                    ? const SizedBox.shrink()
                    : LibraryItemOverlayPlayButton(
                        libraryItem: widget.libraryItem,
                        shelfEpisode: shelfEpisode,
                        showProgressRing: showProgressRing,
                        progressValue: progressValue,
                        isFinished: isFinished,
                        isCurrentItem: isCurrentItem,
                        isPlayingCurrentItem: isPlayingCurrentItem,
                        playbackStateHandler: playbackStateHandler,
                        onPlay: widget.onPlay,
                        isEbook:
                            !(widget.libraryItem.media?.hasAudio ?? false) &&
                            (widget.libraryItem.media?.hasBook ?? false),
                      ),
              ),
              if (widget.libraryItem.hasIssue)
                Positioned(right: 4, bottom: 4, child: LibraryItemIssueIndicator(item: widget.libraryItem)),
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
        );
      },
    );

    final canHandleTap = !(widget.selectionMode && isCollapsedSeriesCard);
    final subtitle = widget.subtitle == null || widget.subtitle!.isEmpty
        ? null
        : AdditionalInformationText(
            subtitle: widget.subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          );

    return LibraryItemCard(
      cover: cover,
      title: displayTitle,
      subtitle: subtitle,
      compact: widget.compact,
      isDesktop: _isDesktopPlatform,
      canActivate: canHandleTap,
      onTap: handleCardTap,
      onLongPress: (isCollapsedSeriesCard || (widget.onEnterSelectionMode == null && widget.onToggleSelection == null))
          ? null
          : handleCardLongPress,
      onContextMenu: _isDesktopPlatform
          ? widget.onContextMenu ?? (position) => unawaited(_showContextMenu(position))
          : null,
      onHoverChanged: _isDesktopPlatform ? (hovered) => setState(() => _isHovered = hovered) : null,
    );
  }

  Future<void> _showContextMenu(Offset position) async {
    final item = widget.libraryItem;
    final currentUser = ref.read(currentUserProvider).value;
    final userId = currentUser?.id;
    final managementPreferences = readServerManagementPreferences(ref, userId);
    final hasUpdatePermission = currentUser?.permissions.update ?? false;
    final hasDeletePermission = currentUser?.permissions.delete ?? false;
    final filterData = item.libraryId == null
        ? null
        : ref.read(libraryFilterDataProvider(item.libraryId!)).asData?.value;
    final canEdit = hasUpdatePermission && managementPreferences.editItemsEnabled && item.collapsedSeries == null;

    await showLibraryItemContextMenu(
      context: context,
      ref: ref,
      item: item,
      position: position,
      canEdit: canEdit,
      canQuickMatch: item.mediaType == 'book' && canEdit && managementPreferences.allowMatchesQuickMatchesEnabled,
      canDelete: hasDeletePermission && managementPreferences.deleteItemsEnabled,
      canAddToCollection: hasUpdatePermission && managementPreferences.collectionsEnabled,
      currentUserId: userId,
      filterData: filterData,
      onEdit:
          widget.onEdit ??
          () => unawaited(openSingleLibraryItemEditorDialog(context: context, item: item, filterData: filterData)),
      onAfterDelete: () async {},
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
    final recentEpisodeId = widget.libraryItem.recentEpisode?.id;
    if (recentEpisodeId != null) {
      return episodes.where((episode) => episode.id == recentEpisodeId).firstOrNull;
    }
    if (episodes.length != 1) {
      return null;
    }

    return episodes.first;
  }

  MediaProgress? _resolvePodcastProgress(List<MediaProgress> progressList) {
    final progressByEpisodeId = <String, MediaProgress>{};
    for (final progress in progressList) {
      final episodeId = progress.episodeId;
      if (episodeId != null && episodeId.isNotEmpty) {
        progressByEpisodeId[episodeId] = progress;
      }
    }
    final shelfEpisode = _podcastShelfEpisode();
    if (shelfEpisode != null) {
      return progressByEpisodeId[shelfEpisode.id];
    }

    final podcastEpisodes = widget.libraryItem.media?.podcastMedia?.episodes;
    if (podcastEpisodes == null || podcastEpisodes.isEmpty) {
      return null;
    }

    for (final episode in podcastEpisodes) {
      final episodeProgress = progressByEpisodeId[episode.id];
      if (episodeProgress != null) {
        return episodeProgress;
      }
    }

    return null;
  }
}

class _LibraryItemPlaybackStateBuilder extends StatelessWidget {
  const _LibraryItemPlaybackStateBuilder({
    required this.itemId,
    required this.episodeId,
    required this.audioHandler,
    required this.builder,
  });

  final String itemId;
  final String? episodeId;
  final BGAudioHandler audioHandler;
  final Widget Function(BuildContext context, bool isCurrentItem, bool isPlayingCurrentItem) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioHandler.playerControlStateStream,
      initialData: audioHandler.playerControlState,
      builder: (context, snapshot) {
        final currentMediaItem = audioHandler.currentMediaItem;
        final isCurrentItem =
            currentMediaItem?.itemId == itemId && (episodeId == null || currentMediaItem?.episodeId == episodeId);
        final isPlayingCurrentItem = isCurrentItem && (snapshot.data?.playing ?? false);

        return builder(context, isCurrentItem, isPlayingCurrentItem);
      },
    );
  }
}
