part of 'queue_source_provider.dart';

extension _ContinueQueueSources on QueueSourceRepository {
  Future<_ExpandedSourceResult> _expandContinueSource(MediaSourceDescriptor source) async {
    final user = _ref.read(currentUserProvider).value;
    final userScope = '${user?.id ?? ''}@${user?.server?.url ?? ''}';
    List<String> libraryIds;

    if (source.libraryId == allLibrariesSourceId) {
      final libraries = await _libraryRequests.putIfAbsent(userScope, () => _ref.read(userLibrariesProvider.future));
      if (libraries.isEmpty) {
        throw StateError('Could not resolve libraries for the All source');
      }

      libraryIds = libraries.map((library) => library.id).toList(growable: false);
    } else {
      libraryIds = [source.libraryId];
    }

    final candidates = <QueueCandidate>[];
    final seen = <String>{};

    for (final libraryId in libraryIds) {
      final key = '$userScope::$libraryId';
      final personalized = await _personalizedRequests.putIfAbsent(
        key,
        () => _ref.read(personalizedLibraryProvider(libraryId).future),
      );
      if (personalized == null) {
        throw StateError('Could not load Continue shelves for library $libraryId');
      }

      final items = switch (source.type) {
        MediaSourceType.continueListening => personalized.continueListening?.entities ?? const <LibraryItem>[],
        MediaSourceType.continueSeries => personalized.continueSeries?.entities ?? const <LibraryItem>[],
        MediaSourceType.continueReading =>
          personalized.extraLibraryShelves
              .where((shelf) => shelf.id == 'continue-reading')
              .expand((shelf) => shelf.entities)
              .toList(growable: false),
        _ => const <LibraryItem>[],
      };

      for (final item in items) {
        final candidate = await _continueCandidate(item: item, source: source);
        if (candidate == null) {
          continue;
        }

        final reference = '${candidate.ref.itemId}::${candidate.ref.episodeId ?? ''}';
        if (seen.add(reference)) {
          candidates.add(candidate);
        }
      }
    }

    if (source.type != MediaSourceType.continueSeries) {
      final progress = _ref.read(mediaProgressProvider.notifier);
      candidates.sort((left, right) {
        final leftKey = mediaProgressKey(left.ref.itemId, left.ref.episodeId);
        final rightKey = mediaProgressKey(right.ref.itemId, right.ref.episodeId);
        final leftUpdatedAt = progress.progressForKey(leftKey)?.lastUpdate ?? 0;
        final rightUpdatedAt = progress.progressForKey(rightKey)?.lastUpdate ?? 0;

        return rightUpdatedAt.compareTo(leftUpdatedAt);
      });
    }

    return _ExpandedSourceResult(candidates: candidates, revision: null);
  }

  Future<QueueCandidate?> _continueCandidate({required LibraryItem item, required MediaSourceDescriptor source}) async {
    final isReading = source.type == MediaSourceType.continueReading;
    if (item.mediaType == 'podcast' || item.media?.podcastMedia != null) {
      if (isReading) {
        return null;
      }

      return _continuePodcastCandidate(item);
    }

    final progress = _ref.read(mediaProgressProvider.notifier).progressForKey(mediaProgressKey(item.id));
    var isFinished = progress?.isFinished ?? false;
    if (isReading && progress?.ebookProgress != null) {
      isFinished = progress!.ebookProgress! >= 1;
    }

    return QueueCandidate(
      ref: PlayableRef(itemId: item.id),
      title: item.title,
      subtitle: item.subtitle,
      addedAt: item.addedAt,
      isFinished: isFinished,
    );
  }

  Future<QueueCandidate?> _continuePodcastCandidate(LibraryItem item) async {
    final progress = _ref.read(mediaProgressProvider.notifier).progressForLibraryItem(item.id);
    MediaProgress? active;
    var hasFinishedEpisode = false;

    for (final entry in progress) {
      if (entry.episodeId == null || entry.episodeId!.isEmpty) {
        continue;
      }
      if (entry.isFinished) {
        hasFinishedEpisode = true;
        continue;
      }

      if (active == null || (entry.lastUpdate ?? 0) > (active.lastUpdate ?? 0)) {
        active = entry;
      }
    }

    if (active == null && hasFinishedEpisode) {
      return null;
    }

    var episodeId = active?.episodeId;
    var episodes = item.media?.podcastMedia?.episodes ?? const <Episode>[];
    if (episodeId == null) {
      if (!episodes.any((episode) => episode.audioFile != null)) {
        final expanded = await _ref.read(libraryItemProvider(item.id).future);
        episodes = expanded.media?.podcastMedia?.episodes ?? episodes;
      }

      episodeId = episodes.where((episode) => episode.audioFile != null).firstOrNull?.id;
    }
    if (episodeId == null) {
      return null;
    }

    final episode = episodes.where((episode) => episode.id == episodeId).firstOrNull;

    return QueueCandidate(
      ref: PlayableRef(itemId: item.id, episodeId: episodeId),
      title: episode?.title ?? item.title,
      addedAt: episode?.addedAt,
      publishedAt: episode?.publishedAt,
      estimatedBytes: episode?.size ?? episode?.audioFile?.metadata.size,
    );
  }
}
