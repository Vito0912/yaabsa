part of 'smart_download_provider.dart';

class _SmartDownloadSnapshot {
  final Map<String, MediaProgress> progressByKey = <String, MediaProgress>{};
  final Map<String, MediaProgress> activePodcastProgress = <String, MediaProgress>{};
  final Set<String> finishedPodcastItems = <String>{};
  final Map<String, StoredDownloadsEntry> stored = <String, StoredDownloadsEntry>{};
  final Set<String> completeKeys = <String>{};
  final Map<String, int?> candidateBytes = <String, int?>{};
  final Map<String, Future<int?>> estimates = <String, Future<int?>>{};
  List<ListeningDownloadProgressEntry> listeningProgress = const [];
  Set<String> activeReferences = <String>{};
  Map<String, int> reservations = <String, int>{};
}

extension _SmartDownloadSnapshots on SmartDownloadManager {
  Future<_SmartDownloadSnapshot> _loadDownloadSnapshot(
    List<SmartDownloadProfile> profiles,
    int generation,
    String userId,
  ) async {
    final db = _managerRef.read(appDatabaseProvider);
    final snapshot = _SmartDownloadSnapshot();
    final stored = await db.getStoredDownloadEntriesByUser(userId);
    _throwIfReconcileStale(generation, userId);
    for (final entry in stored) {
      snapshot.stored['${entry.itemId}::${entry.episodeId ?? ''}'] = entry;
    }

    final hasEnabledProfiles = profiles.any((profile) => profile.enabled);
    final hasManagedDownloads = stored.any((entry) => entry.downloadOrigin == 'smart');
    if (hasEnabledProfiles || hasManagedDownloads || _continueDownloadsEnabled(userId)) {
      for (final stored in await db.getStoredMediaProgressByUser(userId)) {
        final progress = _decodeProgressOrNull(stored.mediaProgress);
        if (progress != null) {
          snapshot.progressByKey[mediaProgressKey(progress.libraryItemId, progress.episodeId)] = progress;
        }
      }
      _throwIfReconcileStale(generation, userId);

      for (final entry in _managerRef.read(mediaProgressProvider.notifier).snapshot.entries) {
        final cached = snapshot.progressByKey[entry.key];
        if (cached == null || (entry.value.lastUpdate ?? 0) >= (cached.lastUpdate ?? 0)) {
          snapshot.progressByKey[entry.key] = entry.value;
        }
      }
    }

    for (final progress in snapshot.progressByKey.values) {
      if (progress.episodeId == null || progress.episodeId!.isEmpty) {
        continue;
      }
      if (progress.isFinished) {
        snapshot.finishedPodcastItems.add(progress.libraryItemId);
        continue;
      }

      final previous = snapshot.activePodcastProgress[progress.libraryItemId];
      if (previous == null || (progress.lastUpdate ?? 0) > (previous.lastUpdate ?? 0)) {
        snapshot.activePodcastProgress[progress.libraryItemId] = progress;
      }
    }

    if (profiles.any((profile) => profile.enabled && profile.policy.listeningTrigger != null)) {
      snapshot.listeningProgress = await db.getListeningDownloadProgress(userId);
      _throwIfReconcileStale(generation, userId);
    }

    if (hasEnabledProfiles || _continueDownloadsEnabled(userId)) {
      final downloads = await db.resolveStoredDownloadEntries(stored);
      _throwIfReconcileStale(generation, userId);
      snapshot.completeKeys.addAll(
        downloads.where((download) => download.isComplete).map(_downloadKey).whereType<String>(),
      );
    }

    return snapshot;
  }

  Future<CandidatePage> _downloadSourcePage(
    QueueSourceRepository repository,
    MediaSourceDescriptor source,
    int page,
  ) async {
    final key = jsonEncode([source.type.name, source.libraryId, source.sourceId, source.descending, page]);
    final cached = _sourcePages[key];
    if (cached != null) {
      return cached;
    }

    final generation = _sourceCacheGeneration;
    final result = await repository.page(source, page: page, pageSize: queueSourcePageSize);
    if (generation == _sourceCacheGeneration && _sourcePages.length < 128) {
      _sourcePages[key] = result;
    }

    return result;
  }

  Future<int?> _estimateDownloadBytes(
    _SmartDownloadSnapshot snapshot,
    String itemId,
    String? episodeId,
    String downloadType,
  ) {
    final key = jsonEncode([itemId, episodeId, downloadType]);
    return snapshot.estimates.putIfAbsent(key, () {
      return downloadHandler.estimateDownloadBytes(itemId, episodeId: episodeId, downloadType: downloadType);
    });
  }
}
