part of 'smart_download_provider.dart';

extension _SmartDownloadReconciliation on SmartDownloadManager {
  Future<void> _reconcileInternal({required String reason}) async {
    final user = _managerRef.read(currentUserProvider).value;
    if (user == null || kIsWeb) {
      return;
    }
    if (_managerRef.read(serverStatusProvider).value == false) {
      return;
    }

    final generation = ++_generation;
    final userId = user.id;
    _setManagerState(_managerState.copyWith(isReconciling: true, clearError: true));
    try {
      final profiles = await loadProfiles();
      _throwIfReconcileStale(generation, userId);
      final desiredByReference = <String>{};
      final desiredByProfile = <String, Set<String>>{};
      final db = _managerRef.read(appDatabaseProvider);
      final snapshot = await _loadDownloadSnapshot(profiles, generation, userId);
      _throwIfReconcileStale(generation, userId);
      final sourceRepository = QueueSourceRepository(_managerRef);
      if (_sourcePagesExpireAt == null || !DateTime.now().isBefore(_sourcePagesExpireAt!)) {
        _clearSourcePages();
        _sourcePagesExpireAt = DateTime.now().add(const Duration(seconds: 30));
      }

      for (final profile in profiles.where((profile) => profile.enabled)) {
        if (generation != _generation) {
          _setManagerState(_managerState.copyWith(isReconciling: false));
          return;
        }
        final claimRows = await db.getSmartDownloadClaims(profile.id);
        _throwIfReconcileStale(generation, userId);
        final claims = <String, SmartDownloadClaimEntry>{
          for (final claim in claimRows) '${claim.itemId}::${claim.episodeId ?? ''}': claim,
        };
        final desired = <String>{};
        desiredByProfile[profile.id] = desired;
        if (profile.policy.listeningTrigger != null) {
          desired.addAll(await _listeningThresholdReferences(profile, generation, userId, snapshot, claims));
          desiredByReference.addAll(desired);
          continue;
        }
        for (final source in profile.sources) {
          final targetCount = profile.policy.targetCount.clamp(1, 150).toInt();
          var page = 0;
          var selectedForSource = 0;
          int? sourceRevision;
          final compactSnapshot = <QueueCandidate>[];
          while (selectedForSource < targetCount && page < (source.type == MediaSourceType.latestEpisodes ? 100 : 20)) {
            final result = await _downloadSourcePage(sourceRepository, source, page);
            _throwIfReconcileStale(generation, userId);
            sourceRevision ??= result.revision;
            if (compactSnapshot.length < queueSourcePageSize) {
              compactSnapshot.addAll(result.candidates.take(queueSourcePageSize - compactSnapshot.length));
            }
            final candidates = result.candidates;
            if (candidates.isEmpty && result.nextCursor == null) {
              break;
            }
            for (final candidate in candidates) {
              final progressKey = mediaProgressKey(candidate.ref.itemId, candidate.ref.episodeId);
              final isFinished = snapshot.progressByKey[progressKey]?.isFinished ?? false;
              if (selectedForSource >= targetCount || isFinished) {
                continue;
              }
              if (!_withinAge(candidate, profile.policy.maxAgeDays)) {
                continue;
              }

              final key = _key(candidate.ref);
              if (!desired.add(key)) {
                continue;
              }
              selectedForSource++;
              desiredByReference.add(key);
              snapshot.candidateBytes[key] = candidate.estimatedBytes;
              final existingClaim = claims[key];
              if (existingClaim != null &&
                  existingClaim.sourceType == source.type.name &&
                  existingClaim.sourceId == source.sourceId &&
                  existingClaim.estimatedBytes == candidate.estimatedBytes) {
                continue;
              }

              _throwIfReconcileStale(generation, userId);
              await db.upsertSmartDownloadClaim(
                SmartDownloadClaim(
                  profileId: profile.id,
                  ref: candidate.ref,
                  source: source,
                  estimatedBytes: candidate.estimatedBytes,
                ),
              );
            }
            if (candidates.length < queueSourcePageSize && result.nextCursor == null) {
              break;
            }
            page++;
          }
          await db.updateSmartDownloadSourceSnapshot(
            profile.id,
            source,
            revision: sourceRevision,
            candidateSnapshot: jsonEncode(
              compactSnapshot.map((candidate) => candidate.toJson()).toList(growable: false),
            ),
          );
          _throwIfReconcileStale(generation, userId);
        }

        for (final claim in claimRows) {
          final key = '${claim.itemId}::${claim.episodeId ?? ''}';
          if (!desired.contains(key)) {
            await db.deleteSmartDownloadClaim(profile.id, claim.itemId, episodeId: claim.episodeId);
            _throwIfReconcileStale(generation, userId);
          }
        }
      }

      final continueReferences = await _continueShelfReferences(snapshot);
      _throwIfReconcileStale(generation, userId);
      desiredByReference.addAll(continueReferences.map(_key));
      if (desiredByReference.isNotEmpty || snapshot.stored.values.any((entry) => entry.downloadOrigin == 'smart')) {
        final tasks = await downloadHandler.automaticDownloadTasks(userId);
        _throwIfReconcileStale(generation, userId);
        snapshot.activeReferences = tasks.activeReferences;
        snapshot.reservations = tasks.smartReservations;
      }

      await _cleanupUnclaimed(
        userId: userId,
        desiredByReference: desiredByReference,
        profiles: profiles,
        generation: generation,
        snapshot: snapshot,
      );
      _throwIfReconcileStale(generation, userId);
      await _enqueueDesired(
        profiles: profiles,
        desiredByProfile: desiredByProfile,
        userId: userId,
        generation: generation,
        snapshot: snapshot,
      );
      _throwIfReconcileStale(generation, userId);
      await _enqueueContinueReferences(
        userId: userId,
        references: continueReferences,
        generation: generation,
        snapshot: snapshot,
      );
      _throwIfReconcileStale(generation, userId);
      _setManagerState(_managerState.copyWith(isReconciling: false, lastReconciled: DateTime.now(), clearError: true));
      logger('Smart-download reconciliation completed ($reason).', tag: 'SmartDownloadManager', level: InfoLevel.debug);
    } catch (e, s) {
      if (e is _StaleSmartDownloadReconcile || generation != _generation) {
        _setManagerState(_managerState.copyWith(isReconciling: false));
        return;
      }
      logger(
        'Smart-download reconciliation failed ($reason): $e\n$s',
        tag: 'SmartDownloadManager',
        level: InfoLevel.warning,
      );
      _setManagerState(_managerState.copyWith(isReconciling: false, error: e));
    }
  }
}
