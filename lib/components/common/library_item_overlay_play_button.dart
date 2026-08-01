import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/util/globals.dart';

class LibraryItemOverlayPlayButton extends StatelessWidget {
  const LibraryItemOverlayPlayButton({
    super.key,
    this.libraryItem,
    this.libraryItemId,
    required this.shelfEpisode,
    required this.showProgressRing,
    required this.progressValue,
    required this.isFinished,
    required this.isCurrentItem,
    required this.isPlayingCurrentItem,
    required this.isEbook,
    this.isLoading = false,
    this.onPlay,
  }) : assert(libraryItem != null || libraryItemId != null);

  final LibraryItem? libraryItem;
  final String? libraryItemId;
  final Episode? shelfEpisode;
  final bool showProgressRing;
  final double progressValue;
  final bool isFinished;
  final bool isCurrentItem;
  final bool isPlayingCurrentItem;
  final VoidCallback? onPlay;
  final bool isEbook;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedLibraryItemId = libraryItem?.id ?? libraryItemId!;

    return StreamBuilder<bool>(
      stream: audioHandler.queueTransitionLoadingStream,
      initialData: audioHandler.queueTransitionLoading,
      builder: (context, queueTransitionSnapshot) {
        final isQueueTransitionLoading = queueTransitionSnapshot.data ?? audioHandler.queueTransitionLoading;
        final isLoadingCurrentItem =
            isLoading ||
            (isQueueTransitionLoading &&
                audioHandler.isQueueTransitionForItem(resolvedLibraryItemId, episodeId: shelfEpisode?.id));

        return SizedBox(
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
                tooltip: isEbook
                    ? (isFinished ? 'Read Again' : 'Read')
                    : (isLoadingCurrentItem
                          ? 'Loading...'
                          : (isPlayingCurrentItem ? 'Pause' : (isFinished ? 'Replay' : 'Play'))),
                icon: isEbook
                    ? Icon(
                        isFinished ? Icons.replay : Icons.book,
                        size: isFinished ? 18 : 16,
                        color: isFinished ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      )
                    : (isLoadingCurrentItem
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSurfaceVariant),
                              ),
                            )
                          : Icon(
                              isPlayingCurrentItem ? Icons.pause : (isFinished ? Icons.replay : Icons.play_arrow),
                              size: isFinished ? 18 : 16,
                              color: isFinished ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                            )),
                iconSize: isFinished ? 20 : 16,
                onPressed: isEbook
                    ? () {
                        final item = libraryItem;
                        if (item == null) {
                          return;
                        }
                        if (!kIsWeb && Platform.isLinux) {
                          final bookMedia = item.media?.bookMedia;
                          final candidates = <String?>[
                            bookMedia?.ebookFile?.ebookFormat,
                            bookMedia?.ebookFormat,
                            bookMedia?.ebookFile?.metadata.ext,
                          ];
                          bool isPdf = false;
                          for (final candidate in candidates) {
                            final normalized = candidate?.trim().toLowerCase() ?? '';
                            if (normalized == 'pdf') {
                              isPdf = true;
                              break;
                            }
                          }
                          if (!isPdf) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Only PDF reading is currently supported on Linux')),
                            );
                            return;
                          }
                        }
                        context.push('/ebook/${item.id}');
                      }
                    : (isLoadingCurrentItem
                          ? null
                          : () {
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

                              final item = libraryItem;
                              if (item == null) {
                                return;
                              }

                              if (item.mediaType == 'podcast') {
                                final podcastEpisodes = _playablePodcastEpisodes(item);
                                final episodeToPlay = shelfEpisode ?? podcastEpisodes.firstOrNull;

                                if (episodeToPlay != null) {
                                  final episodeIndex = podcastEpisodes.indexWhere(
                                    (episode) => episode.id == episodeToPlay.id,
                                  );
                                  audioHandler.playPodcastEpisode(
                                    item,
                                    episodeToPlay,
                                    episodeIndex: episodeIndex < 0 ? null : episodeIndex,
                                    orderedEpisodes: podcastEpisodes,
                                  );
                                  return;
                                }
                              }

                              audioHandler.playLibraryItem(item);
                            }),
                splashRadius: 8,
              ),
            ],
          ),
        );
      },
    );
  }

  List<Episode> _playablePodcastEpisodes(LibraryItem item) {
    return (item.media?.podcastMedia?.episodes ?? const <Episode>[])
        .where((episode) => episode.audioFile != null)
        .toList(growable: false);
  }
}
