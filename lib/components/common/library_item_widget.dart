import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/models/internal_media.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = showProgress
        ? ref.watch(mediaProgressProvider.select((asyncValue) => asyncValue.value?[libraryItem.id]))
        : null;
    final completedDownloadItemIds = ref.watch(completedDownloadItemIdsProvider).asData?.value ?? const <String>{};
    final isDownloaded = completedDownloadItemIds.contains(libraryItem.id);

    final progressValue = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
    final showProgressBar = showProgress && progressValue > 0;

    return StreamBuilder<PlayerState>(
      stream: audioHandler.player.playerStateStream,
      initialData: audioHandler.player.playerState,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isCurrentItem = audioHandler.currentMediaItem?.itemId == libraryItem.id;
        final isPlayingCurrentItem = isCurrentItem && (playerState?.playing ?? false);
        final colorScheme = Theme.of(context).colorScheme;

        return Padding(
          padding: compact ? const EdgeInsets.all(4) : const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              if (selectionMode) {
                onToggleSelection?.call();
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
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: isCurrentItem
                            ? Border.all(
                                color: colorScheme.primary.withValues(alpha: isPlayingCurrentItem ? 1 : 0.5),
                                width: 4,
                              )
                            : null,
                      ),
                      child: ClipRRect(
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
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (libraryItem.media?.hasAudio ?? false)
                              IconButton(
                                tooltip: isPlayingCurrentItem ? 'Pause' : 'Play',
                                icon: Icon(isPlayingCurrentItem ? Icons.pause : Icons.play_arrow, size: 14),
                                iconSize: 10,
                                onPressed: () {
                                  if (isPlayingCurrentItem) {
                                    audioHandler.pause();
                                    return;
                                  }

                                  if (isCurrentItem) {
                                    audioHandler.play();
                                    return;
                                  }

                                  audioHandler.setQueue(QueueItem(itemId: libraryItem.id));
                                  audioHandler.play();
                                },
                                splashRadius: 8,
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
                if (showProgressBar) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(value: progressValue, minHeight: compact ? 3.5 : 4),
                  ),
                ],
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
}
