part of 'smart_download_provider.dart';

class _SmartDownloadSnapshot {
  final Map<String, MediaProgress> progressByKey = <String, MediaProgress>{};
  final Map<String, MediaProgress> activePodcastProgress = <String, MediaProgress>{};
  final Set<String> finishedPodcastItems = <String>{};
  final Map<String, StoredDownloadsEntry> stored = <String, StoredDownloadsEntry>{};
  final Set<String> completeKeys = <String>{};
  final Map<String, InternalDownload> downloadsByReference = <String, InternalDownload>{};
  final Map<String, int?> candidateBytes = <String, int?>{};
  final Map<String, Future<int?>> estimates = <String, Future<int?>>{};
  final Map<String, Future<String?>> itemLibraries = <String, Future<String?>>{};
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
    if (hasEnabledProfiles || hasManagedDownloads) {
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

    final hasListeningSources = profiles.any((profile) {
      return profile.enabled && profile.sources.any((source) => source.type == MediaSourceType.listeningThreshold);
    });

    if (hasListeningSources) {
      snapshot.listeningProgress = await db.getListeningDownloadProgress(userId);
      _throwIfReconcileStale(generation, userId);
    }

    if (hasEnabledProfiles) {
      final downloads = await db.resolveStoredDownloadEntries(stored);
      _throwIfReconcileStale(generation, userId);
      for (final download in downloads) {
        final reference = _downloadKey(download);
        if (reference == null) {
          continue;
        }

        snapshot.downloadsByReference[reference] = download;
        if (download.isComplete) {
          snapshot.completeKeys.add(reference);
        }
      }
    }

    return snapshot;
  }

  bool _hasCompleteDownload({
    required _SmartDownloadSnapshot snapshot,
    required String reference,
    required String downloadType,
  }) {
    final download = snapshot.downloadsByReference[reference];
    return download?.isCompleteForType(downloadType) ?? false;
  }

  ({int bytes, String downloadType}) _storedDownloadBudget({
    required _SmartDownloadSnapshot snapshot,
    required String reference,
    required String requestedType,
  }) {
    final entry = snapshot.stored[reference];
    final download = snapshot.downloadsByReference[reference];
    if (entry?.downloadOrigin != 'smart' || download == null) {
      return (bytes: 0, downloadType: requestedType);
    }

    return (bytes: entry?.managedBytes ?? 0, downloadType: _mergeDownloadTypes(download.downloadType, requestedType));
  }

  Future<CandidatePage> _downloadSourcePage(
    QueueSourceRepository repository,
    MediaSourceDescriptor source,
    int page,
  ) async {
    final key = jsonEncode([
      source.type.name,
      source.libraryId,
      source.sourceId,
      source.descending,
      source.listeningTrigger.name,
      source.listeningThreshold,
      page,
    ]);
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
