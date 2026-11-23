import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';

class PlayVisibleShelfEntry {
  const PlayVisibleShelfEntry.libraryItem(this.item) : episode = null;
  const PlayVisibleShelfEntry.podcastEpisode(this.item, this.episode);

  final LibraryItem item;
  final Episode? episode;
}

class PlayVisibleShelfAction extends ConsumerWidget {
  const PlayVisibleShelfAction({super.key, required this.items, required this.onPressed});

  final List<LibraryItem> items;
  final ValueChanged<List<PlayVisibleShelfEntry>> onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relevantProgress = <MediaProgress>[];
    for (final item in items) {
      relevantProgress.addAll(ref.watch(mediaProgressForLibraryItemProvider(item.id)));
    }

    final progressByKey = <String, MediaProgress>{
      for (final progress in relevantProgress) mediaProgressKey(progress.libraryItemId, progress.episodeId): progress,
    };
    final entries = collectPlayableShelfEntries(items: items, progressByKey: progressByKey);
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: () => onPressed(entries),
            icon: const Icon(Icons.playlist_play_rounded, size: 18),
            tooltip: 'Queue all items in this shelf',
            splashRadius: 1,
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

List<PlayVisibleShelfEntry> collectPlayableShelfEntries({
  required Iterable<LibraryItem> items,
  required Map<String, MediaProgress> progressByKey,
}) {
  final entries = <PlayVisibleShelfEntry>[];

  for (final item in items) {
    if (item.mediaType == 'podcast') {
      final episode = _firstUnfinishedPodcastEpisode(item, progressByKey);
      if (episode != null) {
        entries.add(PlayVisibleShelfEntry.podcastEpisode(item, episode));
      }
      continue;
    }

    if (!(item.media?.hasAudio ?? false)) {
      continue;
    }

    if (progressByKey[item.id]?.isFinished ?? false) {
      continue;
    }

    entries.add(PlayVisibleShelfEntry.libraryItem(item));
  }

  return entries;
}

Episode? _firstUnfinishedPodcastEpisode(LibraryItem item, Map<String, MediaProgress> progressByKey) {
  if (item.mediaType != 'podcast') {
    return null;
  }

  final episodes = (item.media?.podcastMedia?.episodes ?? const <Episode>[]).where(
    (episode) => episode.audioFile != null,
  );
  for (final episode in episodes) {
    final episodeProgress = progressByKey[mediaProgressKey(item.id, episode.id)];
    if (episodeProgress?.isFinished ?? false) {
      continue;
    }

    return episode;
  }

  return null;
}
