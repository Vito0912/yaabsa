import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/provider/common/stored_downloads_provider.dart';
import 'package:yaabsa/components/common/library_item_issue_indicator.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/ui/components/buttons/media_play_button.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryItemOverlayPlayButton extends ConsumerWidget {
  static const double size = 36;

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
    this.playbackStateHandler,
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
  final BGAudioHandler? playbackStateHandler;
  final bool isEbook;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedLibraryItemId = libraryItem?.id ?? libraryItemId!;
    final resolvedPlaybackStateHandler = playbackStateHandler ?? audioHandler;

    if (libraryItem?.hasIssue ?? false) {
      final download = ref.watch(storedDownloadForItemProvider(resolvedLibraryItemId, episodeId: shelfEpisode?.id));
      final downloadType = isEbook ? 'ebook' : 'audiobook';
      if (download == null || !download.isCompleteForType(downloadType)) {
        return SizedBox(
          width: size,
          height: size,
          child: LibraryItemIssueIndicator(item: libraryItem!),
        );
      }
    }

    return StreamBuilder<bool>(
      stream: resolvedPlaybackStateHandler.queueTransitionLoadingStream,
      initialData: resolvedPlaybackStateHandler.queueTransitionLoading,
      builder: (context, queueTransitionSnapshot) {
        final isQueueTransitionLoading =
            queueTransitionSnapshot.data ?? resolvedPlaybackStateHandler.queueTransitionLoading;
        final isLoadingCurrentItem =
            isLoading ||
            (isQueueTransitionLoading &&
                resolvedPlaybackStateHandler.isQueueTransitionForItem(
                  resolvedLibraryItemId,
                  episodeId: shelfEpisode?.id,
                ));
        final tooltip = isEbook
            ? (isFinished ? 'Read Again' : 'Read')
            : (isLoadingCurrentItem
                  ? 'Loading...'
                  : (isPlayingCurrentItem ? 'Pause' : (isFinished ? 'Replay' : 'Play')));

        return YaabsaMediaPlayButton(
          size: size,
          tooltip: tooltip,
          isPlaying: isPlayingCurrentItem,
          isFinished: isFinished,
          isLoading: !isEbook && isLoadingCurrentItem,
          progress: showProgressRing ? progressValue : null,
          iconOverride: isEbook && !isFinished ? Icons.book : null,
          onPressed: isEbook || !isLoadingCurrentItem
              ? () {
                  if (isEbook) {
                    _openEbook(context);
                    return;
                  }

                  _playOrToggle(resolvedPlaybackStateHandler);
                }
              : null,
        );
      },
    );
  }

  void _openEbook(BuildContext context) {
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
      var isPdf = false;
      for (final candidate in candidates) {
        final normalized = candidate?.trim().toLowerCase() ?? '';
        if (normalized == 'pdf') {
          isPdf = true;
          break;
        }
      }

      if (!isPdf) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.errorPdfReadingLinuxOnly)));
        return;
      }
    }

    context.push('/ebook/${item.id}');
  }

  void _playOrToggle(BGAudioHandler playbackHandler) {
    if (isPlayingCurrentItem) {
      playbackHandler.pause();
      return;
    }

    if (isCurrentItem) {
      playbackHandler.play();
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
      if (episodeToPlay == null) {
        return;
      }

      final episodeIndex = podcastEpisodes.indexWhere((episode) => episode.id == episodeToPlay.id);
      playbackHandler.playPodcastEpisode(
        item,
        episodeToPlay,
        episodeIndex: episodeIndex < 0 ? null : episodeIndex,
        orderedEpisodes: podcastEpisodes,
      );
      return;
    }

    playbackHandler.playLibraryItem(item);
  }

  List<Episode> _playablePodcastEpisodes(LibraryItem item) {
    return (item.media?.podcastMedia?.episodes ?? const <Episode>[])
        .where((episode) => episode.audioFile != null)
        .toList(growable: false);
  }
}
