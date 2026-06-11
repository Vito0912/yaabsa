import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/util/globals.dart';

class LibraryItemOverlayPlayButton extends StatelessWidget {
  const LibraryItemOverlayPlayButton({
    super.key,
    required this.libraryItem,
    required this.shelfEpisode,
    required this.showProgressRing,
    required this.progressValue,
    required this.isFinished,
    required this.isCurrentItem,
    required this.isPlayingCurrentItem,
    required this.isEbook,
    this.onPlay,
  });

  final LibraryItem libraryItem;
  final Episode? shelfEpisode;
  final bool showProgressRing;
  final double progressValue;
  final bool isFinished;
  final bool isCurrentItem;
  final bool isPlayingCurrentItem;
  final VoidCallback? onPlay;
  final bool isEbook;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<bool>(
      stream: audioHandler.queueTransitionLoadingStream,
      initialData: audioHandler.queueTransitionLoading,
      builder: (context, queueTransitionSnapshot) {
        final isQueueTransitionLoading = queueTransitionSnapshot.data ?? audioHandler.queueTransitionLoading;
        final isLoadingCurrentItem =
            isQueueTransitionLoading &&
            audioHandler.isQueueTransitionForItem(libraryItem.id, episodeId: shelfEpisode?.id);

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
                        context.push('/ebook/${libraryItem.id}');
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

                              if (libraryItem.mediaType == 'podcast') {
                                final podcastEpisodes = _playablePodcastEpisodes(libraryItem);
                                final episodeToPlay = shelfEpisode ?? podcastEpisodes.firstOrNull;

                                if (episodeToPlay != null) {
                                  final episodeIndex = podcastEpisodes.indexWhere(
                                    (episode) => episode.id == episodeToPlay.id,
                                  );
                                  audioHandler.playPodcastEpisode(
                                    libraryItem,
                                    episodeToPlay,
                                    episodeIndex: episodeIndex < 0 ? null : episodeIndex,
                                    orderedEpisodes: podcastEpisodes,
                                  );
                                  return;
                                }
                              }

                              audioHandler.playLibraryItem(libraryItem);
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
