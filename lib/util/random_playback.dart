import 'dart:math';

import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/globals.dart';

bool isPodcastLibraryItem(LibraryItem item) {
  return item.mediaType == 'podcast' || item.media?.podcastMedia != null;
}

List<Episode> playablePodcastEpisodes(LibraryItem item) {
  return (item.media?.podcastMedia?.episodes ?? const <Episode>[])
      .where((episode) => episode.audioFile != null)
      .toList(growable: false);
}

bool hasRandomPlaybackTarget(List<LibraryItem> items) {
  return items.any(_hasRandomPlaybackTarget);
}

bool hasRandomPlaylistPlaybackTarget(List<PlaylistItem> playlistItems) {
  return playlistItems.any((entry) {
    final item = entry.libraryItem;
    if (item == null) {
      return false;
    }

    if (entry.episode != null) {
      return entry.episode!.audioFile != null;
    }

    return _hasRandomPlaybackTarget(item);
  });
}

Future<bool> playRandomLibraryItemOrEpisode(
  List<LibraryItem> items, {
  AutoQueueStartType sourceType = AutoQueueStartType.none,
  String? sourceId,
}) async {
  final playableItems = items.where(_hasRandomPlaybackTarget).toList(growable: false);

  if (playableItems.isEmpty) {
    return false;
  }

  final item = playableItems[Random().nextInt(playableItems.length)];
  return _playItemOrEpisode(item, sourceType: sourceType, sourceId: sourceId, sourceIndex: items.indexOf(item));
}

Future<bool> playRandomPlaylistItemOrEpisode(
  List<PlaylistItem> playlistItems, {
  AutoQueueStartType sourceType = AutoQueueStartType.none,
  String? sourceId,
}) async {
  final playableItems = playlistItems
      .where((entry) {
        final item = entry.libraryItem;
        if (item == null) {
          return false;
        }

        if (entry.episode != null) {
          return entry.episode!.audioFile != null;
        }

        return _hasRandomPlaybackTarget(item);
      })
      .toList(growable: false);

  if (playableItems.isEmpty) {
    return false;
  }

  final random = Random();
  final entry = playableItems[random.nextInt(playableItems.length)];
  final item = entry.libraryItem!;
  final explicitEpisode = entry.episode;

  if (explicitEpisode != null) {
    await audioHandler.playPodcastEpisode(item, explicitEpisode);
    return true;
  }

  return _playItemOrEpisode(
    item,
    sourceType: sourceType,
    sourceId: sourceId,
    sourceIndex: playlistItems.indexOf(entry),
    random: random,
  );
}

bool _hasRandomPlaybackTarget(LibraryItem item) {
  if (isPodcastLibraryItem(item)) {
    return playablePodcastEpisodes(item).isNotEmpty;
  }

  return item.media?.hasAudio ?? false;
}

Future<bool> _playItemOrEpisode(
  LibraryItem item, {
  required AutoQueueStartType sourceType,
  required String? sourceId,
  required int sourceIndex,
  Random? random,
}) async {
  final podcastEpisodes = isPodcastLibraryItem(item) ? playablePodcastEpisodes(item) : const <Episode>[];

  if (podcastEpisodes.isNotEmpty) {
    final episodeIndex = (random ?? Random()).nextInt(podcastEpisodes.length);
    await audioHandler.playPodcastEpisode(
      item,
      podcastEpisodes[episodeIndex],
      episodeIndex: episodeIndex,
      orderedEpisodes: podcastEpisodes,
    );
    return true;
  }

  final autoQueueStart = sourceType == AutoQueueStartType.none
      ? const AutoQueueStart.none()
      : AutoQueueStart(type: sourceType, sourceId: sourceId, globalIndex: sourceIndex);
  await audioHandler.playLibraryItem(item, autoQueueStart: autoQueueStart);
  return true;
}
