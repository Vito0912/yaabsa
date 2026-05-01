import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class LibraryItemWidget extends ConsumerWidget {
  const LibraryItemWidget(
    this.libraryItem,
    this.api, {
    super.key,
    this.showProgress = false,
    this.compact = false,
    this.squareCover = true,
    this.selectionMode = false,
    this.isSelected = false,
    this.onToggleSelection,
    this.onEnterSelectionMode,
    this.onPlay,
  });

  final LibraryItem libraryItem;
  final ABSApi api;
  final bool showProgress;
  final bool compact;
  final bool squareCover;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelection;
  final VoidCallback? onEnterSelectionMode;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressMap = showProgress
        ? (ref.watch(mediaProgressProvider).asData?.value ?? const <String, MediaProgress>{})
        : null;
    final progress = showProgress ? _resolveProgress(progressMap!) : null;
    final completedDownloadItemIds = ref.watch(completedDownloadItemIdsProvider).asData?.value ?? const <String>{};
    final isDownloaded = completedDownloadItemIds.contains(libraryItem.id);
    final collapsedSeriesBookCount = libraryItem.collapsedSeries?.numBooks ?? 0;
    final collapsedSeriesId = libraryItem.collapsedSeries?.id;
    final isCollapsedSeriesCard = libraryItem.collapsedSeries != null;

    final progressValue = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
    final showProgressRing = showProgress && progressValue > 0;

    return StreamBuilder<PlayerState>(
      stream: audioHandler.playerControlStateStream,
      initialData: audioHandler.playerControlState,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isCurrentItem = audioHandler.currentMediaItem?.itemId == libraryItem.id;
        final isPlayingCurrentItem = isCurrentItem && (playerState?.playing ?? false);
        final colorScheme = Theme.of(context).colorScheme;
        final isFinished = showProgressRing && (progress?.isFinished ?? false);
        final activeBorderProgress = isPlayingCurrentItem ? progressValue : 0.0;

        return Padding(
          padding: compact ? const EdgeInsets.all(4) : const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              if (selectionMode) {
                onToggleSelection?.call();
                return;
              }

              if (isCollapsedSeriesCard && collapsedSeriesId != null && collapsedSeriesId.isNotEmpty) {
                context.push('/series/$collapsedSeriesId');
                return;
              }

              context.push('/item/${libraryItem.id}');
            },
            onLongPress: (onEnterSelectionMode == null && onToggleSelection == null)
                ? null
                : () {
                    if (onEnterSelectionMode != null) {
                      onEnterSelectionMode!.call();
                      return;
                    }
                    onToggleSelection?.call();
                  },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: squareCover
                          ? AspectRatio(
                              aspectRatio: 1,
                              child: api.getLibraryItemApi().getLibraryItemCover(libraryItem.id, item: libraryItem),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: api.getLibraryItemApi().getLibraryItemCover(libraryItem.id, item: libraryItem),
                            ),
                    ),
                    if (isCurrentItem)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: CustomPaint(
                              key: ValueKey<double>(activeBorderProgress),
                              painter: _SquareProgressBorderPainter(
                                borderRadius: 16,
                                strokeWidth: 4,
                                baseColor: colorScheme.primary.withValues(alpha: 0.5),
                                progressColor: colorScheme.primary,
                                progress: activeBorderProgress,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (selectionMode)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: isSelected ? colorScheme.primary : colorScheme.surface.withValues(alpha: 0.9),
                            border: Border.all(color: isSelected ? colorScheme.primary : colorScheme.outline),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isSelected ? Icons.check : Icons.circle_outlined,
                            size: 14,
                            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    if (isDownloaded)
                      Positioned(
                        top: selectionMode ? 34 : 4,
                        left: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: colorScheme.primary,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(Icons.cloud_done_rounded, size: 14, color: colorScheme.onPrimary),
                        ),
                      ),
                    Positioned(
                      top: 4,
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
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: isFinished ? colorScheme.primary : colorScheme.surface.withAlpha(230),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (libraryItem.media?.hasAudio ?? false)
                                    SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          if (showProgressRing)
                                            SizedBox(
                                              width: 34,
                                              height: 34,
                                              child: CircularProgressIndicator(
                                                value: progressValue,
                                                strokeWidth: 3,
                                                backgroundColor: Colors.white24,
                                                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                                              ),
                                            ),
                                          IconButton(
                                            tooltip: isPlayingCurrentItem ? 'Pause' : (isFinished ? 'Replay' : 'Play'),
                                            icon: Icon(
                                              isPlayingCurrentItem
                                                  ? Icons.pause
                                                  : isFinished
                                                  ? Icons.replay
                                                  : Icons.play_arrow,
                                              size: isFinished ? 18 : 16,
                                              color: isFinished ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                                            ),
                                            iconSize: isFinished ? 20 : 16,
                                            onPressed: () {
                                              if (isPlayingCurrentItem) {
                                                audioHandler.pause();
                                                return;
                                              }

                                              if (isCurrentItem) {
                                                audioHandler.play();
                                                return;
                                              }

                                              if (onPlay != null) {
                                                onPlay!();
                                                return;
                                              }

                                              if (libraryItem.mediaType == 'podcast') {
                                                final podcastEpisodes =
                                                    (libraryItem.media?.podcastMedia?.episodes ?? const <Episode>[])
                                                        .where((episode) => episode.audioFile != null)
                                                        .toList(growable: false);
                                                if (podcastEpisodes.isNotEmpty) {
                                                  audioHandler.playPodcastEpisode(
                                                    libraryItem,
                                                    podcastEpisodes.first,
                                                    episodeIndex: 0,
                                                    orderedEpisodes: podcastEpisodes,
                                                  );
                                                  return;
                                                }
                                              }

                                              audioHandler.playLibraryItem(libraryItem);
                                            },
                                            splashRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (!(libraryItem.media?.hasAudio ?? false) && (libraryItem.media?.hasBook ?? false))
                                    IconButton(
                                      icon: const Icon(Icons.my_library_books_outlined, size: 14),
                                      iconSize: 10,
                                      onPressed: () {},
                                    ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(height: compact ? 6 : 8),
                Text(
                  libraryItem.title,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: compact ? Theme.of(context).textTheme.bodyMedium : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  MediaProgress? _resolveProgress(Map<String, MediaProgress> progressMap) {
    final itemProgress = progressMap[libraryItem.id];
    if (itemProgress != null && libraryItem.mediaType != 'podcast') {
      return itemProgress;
    }

    final podcastEpisodes = libraryItem.media?.podcastMedia?.episodes;
    if (podcastEpisodes == null || podcastEpisodes.isEmpty) {
      return null;
    }

    for (final episode in podcastEpisodes) {
      final episodeProgress = progressMap[mediaProgressKey(libraryItem.id, episode.id)];
      if (episodeProgress != null) {
        return episodeProgress;
      }
    }

    return null;
  }
}

class _SquareProgressBorderPainter extends CustomPainter {
  const _SquareProgressBorderPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.baseColor,
    required this.progressColor,
    required this.progress,
  });

  final double borderRadius;
  final double strokeWidth;
  final Color baseColor;
  final Color progressColor;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(inset, inset, size.width - strokeWidth, size.height - strokeWidth);
    final radiusValue = borderRadius.clamp(0.0, rect.shortestSide / 2);
    final r = Radius.circular(radiusValue);

    final path = Path()
      ..moveTo(rect.center.dx, rect.top)
      ..lineTo(rect.right - radiusValue, rect.top)
      ..arcToPoint(Offset(rect.right, rect.top + radiusValue), radius: r, clockwise: true)
      ..lineTo(rect.right, rect.bottom - radiusValue)
      ..arcToPoint(Offset(rect.right - radiusValue, rect.bottom), radius: r, clockwise: true)
      ..lineTo(rect.left + radiusValue, rect.bottom)
      ..arcToPoint(Offset(rect.left, rect.bottom - radiusValue), radius: r, clockwise: true)
      ..lineTo(rect.left, rect.top + radiusValue)
      ..arcToPoint(Offset(rect.left + radiusValue, rect.top), radius: r, clockwise: true)
      ..lineTo(rect.center.dx, rect.top);

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = baseColor;
    canvas.drawPath(path, basePaint);

    final clampedProgress = progress.clamp(0.0, 1.0);
    if (clampedProgress <= 0) {
      return;
    }

    final metric = path.computeMetrics().first;
    final progressPath = metric.extractPath(0, metric.length * clampedProgress);
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = progressColor;
    canvas.drawPath(progressPath, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _SquareProgressBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
