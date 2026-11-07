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

    final profiles = _managerProfiles.where((profile) => profile.enabled && profile.policy.listeningTrigger != null);
    if (profiles.isEmpty) {
      return;
    }

    try {
      final progress = await _managerRef
          .read(appDatabaseProvider)
          .recordListeningDownloadProgress(
            userId: session.userId,
            itemId: session.libraryItemId,
            libraryId: session.libraryId ?? '',
            listenedSeconds: listenedSeconds,
            progressPercent: (position / duration * 100).clamp(0, 100).toDouble(),
          );
      if (_managerRef.read(currentUserProvider).value?.id != userId) {
        return;
      }

      for (final profile in profiles) {
        final key = '${profile.id}::${session.libraryItemId}';
        if (_meetsListeningThreshold(profile.policy, progress) && _thresholdReady.add(key)) {
          requestReconcile(reason: 'listening threshold reached', refreshSources: false);
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

  bool _meetsListeningThreshold(SmartDownloadPolicy policy, ListeningDownloadProgressEntry progress) {
    if (policy.listeningThreshold <= 0 || progress.listenedSeconds <= 0) {
      return false;
    }

    return switch (policy.listeningTrigger) {
      ListeningDownloadTrigger.minutes => progress.listenedSeconds >= policy.listeningThreshold * 60,
      ListeningDownloadTrigger.progress => progress.progressPercent >= policy.listeningThreshold,
      null => false,
    };
  }

  Future<Set<String>> _listeningThresholdReferences(
    SmartDownloadProfile profile,
    int generation,
    String userId,
    _SmartDownloadSnapshot snapshot,
    Map<String, SmartDownloadClaimEntry> claims,
  ) async {
    final db = _managerRef.read(appDatabaseProvider);
    final claimed = claims.values.map((claim) => claim.itemId).toSet();
    final desired = <String>{};

    for (final entry in snapshot.listeningProgress) {
      final currentProgress = snapshot.progressByKey[mediaProgressKey(entry.itemId)];
      if (entry.progressPercent >= 100 || currentProgress?.isFinished == true) {
        if (claimed.contains(entry.itemId)) {
          await downloadHandler.cancelSmartTasksForReferences(
            userId: userId,
            references: {'${entry.itemId}::'},
            profileId: profile.id,
          );
          _throwIfReconcileStale(generation, userId);
          await db.deleteSmartDownloadClaim(profile.id, entry.itemId);
          _throwIfReconcileStale(generation, userId);
        }
        continue;
      }
      if (!claimed.contains(entry.itemId) && !_meetsListeningThreshold(profile.policy, entry)) {
        continue;
      }

      desired.add('${entry.itemId}::');
      if (!claimed.contains(entry.itemId)) {
        await db.upsertSmartDownloadClaim(
          SmartDownloadClaim(
            profileId: profile.id,
            ref: PlayableRef(itemId: entry.itemId),
            source: MediaSourceDescriptor(
              type: MediaSourceType.collection,
              sourceId: profile.id,
              libraryId: entry.libraryId,
            ),
          ),
        );
        _throwIfReconcileStale(generation, userId);
      }
    }
    return desired;
  }
}
