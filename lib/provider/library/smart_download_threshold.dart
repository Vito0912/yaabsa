part of 'smart_download_provider.dart';

extension ListeningThresholdDownloads on SmartDownloadManager {
  Future<void> recordListeningForDownload({
    required PlaybackSession session,
    required double position,
    required double listenedSeconds,
  }) async {
    final userId = _managerRef.read(currentUserProvider).value?.id;
    final duration = session.duration ?? 0;
    if (kIsWeb ||
        userId != session.userId ||
        session.mediaType != 'book' ||
        session.episodeId != null ||
        !listenedSeconds.isFinite ||
        listenedSeconds <= 0 ||
        !position.isFinite ||
        !duration.isFinite ||
        duration <= 0) {
      return;
    }

    final profiles = _managerProfiles
        .where((profile) {
          return profile.enabled && profile.sources.any((source) => source.type == MediaSourceType.listeningThreshold);
        })
        .toList(growable: false);
    if (profiles.isEmpty) {
      return;
    }

    final libraryId = session.libraryId ?? session.libraryItem?.libraryId ?? '';

    try {
      final progress = await _managerRef
          .read(appDatabaseProvider)
          .recordListeningDownloadProgress(
            userId: session.userId,
            itemId: session.libraryItemId,
            libraryId: libraryId,
            listenedSeconds: listenedSeconds,
            progressPercent: (position / duration * 100).clamp(0, 100).toDouble(),
          );
      if (_managerRef.read(currentUserProvider).value?.id != userId) {
        return;
      }

      for (final profile in profiles) {
        for (final source in profile.sources) {
          if (source.type != MediaSourceType.listeningThreshold || !_matchesListeningLibrary(source, libraryId)) {
            continue;
          }

          final key =
              '${profile.id}::${source.sourceId}::${source.listeningTrigger.name}::'
              '${source.listeningThreshold}::${session.libraryItemId}';
          if (_meetsListeningThreshold(source: source, progress: progress) && _thresholdReady.add(key)) {
            requestReconcile(reason: 'listening threshold reached', refreshSources: false);
          }
        }
      }
    } catch (error, stackTrace) {
      logger(
        'Could not record listening threshold: $error\n$stackTrace',
        tag: 'SmartDownloadManager',
        level: InfoLevel.warning,
      );
    }
  }

  bool _matchesListeningLibrary(MediaSourceDescriptor source, String libraryId) {
    return source.libraryId == allLibrariesSourceId || source.libraryId == libraryId;
  }

  bool _meetsListeningThreshold({
    required MediaSourceDescriptor source,
    required ListeningDownloadProgressEntry progress,
  }) {
    if (source.listeningThreshold <= 0 || progress.listenedSeconds <= 0) {
      return false;
    }

    return switch (source.listeningTrigger) {
      ListeningDownloadTrigger.minutes => progress.listenedSeconds >= source.listeningThreshold * 60,
      ListeningDownloadTrigger.progress => progress.progressPercent >= source.listeningThreshold,
    };
  }

  Future<List<QueueCandidate>> _listeningThresholdCandidates({
    required MediaSourceDescriptor source,
    required _SmartDownloadSnapshot snapshot,
    required Map<String, SmartDownloadClaimEntry> claims,
  }) async {
    if (source.listeningTrigger == ListeningDownloadTrigger.progress) {
      return _progressThresholdCandidates(source: source, snapshot: snapshot, claims: claims);
    }

    final listeningProgress = snapshot.listeningProgress.toList(growable: false);

    final candidates = <QueueCandidate>[];

    for (final entry in listeningProgress) {
      final progress = snapshot.progressByKey[mediaProgressKey(entry.itemId)];
      if (!_matchesListeningLibrary(source, entry.libraryId) ||
          entry.progressPercent >= 100 ||
          progress?.isFinished == true) {
        continue;
      }

      final claim = claims['${entry.itemId}::'];
      final alreadyClaimed = claim?.sourceType == source.type.name && claim?.sourceId == source.sourceId;
      if (!alreadyClaimed && !_meetsListeningThreshold(source: source, progress: entry)) {
        continue;
      }

      candidates.add(QueueCandidate(ref: PlayableRef(itemId: entry.itemId)));
    }

    return candidates;
  }

  Future<List<QueueCandidate>> _progressThresholdCandidates({
    required MediaSourceDescriptor source,
    required _SmartDownloadSnapshot snapshot,
    required Map<String, SmartDownloadClaimEntry> claims,
  }) async {
    if (source.listeningThreshold <= 0) {
      return [];
    }

    final localProgress = {for (final entry in snapshot.listeningProgress) entry.itemId: entry};
    final itemIds = localProgress.keys.toSet();
    for (final progress in snapshot.progressByKey.values) {
      if (progress.mediaItemType == MediaItemType.BOOK && (progress.episodeId == null || progress.episodeId!.isEmpty)) {
        itemIds.add(progress.libraryItemId);
      }
    }

    final sortedItemIds = itemIds.toList();
    sortedItemIds.sort((left, right) {
      final leftUpdatedAt = snapshot.progressByKey[mediaProgressKey(left)]?.lastUpdate ?? 0;
      final rightUpdatedAt = snapshot.progressByKey[mediaProgressKey(right)]?.lastUpdate ?? 0;
      final byRecency = rightUpdatedAt.compareTo(leftUpdatedAt);
      return byRecency == 0 ? left.compareTo(right) : byRecency;
    });

    final candidates = <QueueCandidate>[];
    for (final itemId in sortedItemIds) {
      final progress = snapshot.progressByKey[mediaProgressKey(itemId)];
      final local = localProgress[itemId];
      final percent = progress == null ? local?.progressPercent ?? 0 : progress.progress * 100;
      if (progress?.isFinished == true || !percent.isFinite || percent >= 100) {
        continue;
      }

      final claim = claims['$itemId::'];
      final alreadyClaimed = claim?.sourceType == source.type.name && claim?.sourceId == source.sourceId;
      if (!alreadyClaimed && percent < source.listeningThreshold) {
        continue;
      }

      if (source.libraryId != allLibrariesSourceId) {
        var libraryId = local?.libraryId;
        if (libraryId == null || libraryId.isEmpty) {
          final libraryFuture = snapshot.itemLibraries.putIfAbsent(itemId, () async {
            final item = await _managerRef.read(libraryItemProvider(itemId).future);
            return item.libraryId;
          });
          libraryId = await libraryFuture;
        }

        if (!_matchesListeningLibrary(source, libraryId ?? '')) {
          continue;
        }
      }

      candidates.add(QueueCandidate(ref: PlayableRef(itemId: itemId)));
    }

    return candidates;
  }
}
