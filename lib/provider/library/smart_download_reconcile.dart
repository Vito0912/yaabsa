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
        for (final source in profile.sources) {
          final targetCount = profile.policy.targetCount.clamp(1, 150).toInt();
          var page = 0;
          var selectedForSource = 0;
          final selectedReferences = <String>{};
          int? sourceRevision;
          final compactSnapshot = <QueueCandidate>[];
          final listeningCandidates = source.type == MediaSourceType.listeningThreshold
              ? await _listeningThresholdCandidates(source: source, snapshot: snapshot, claims: claims)
              : null;

          while (selectedForSource < targetCount && page < (source.type == MediaSourceType.latestEpisodes ? 100 : 20)) {
            CandidatePage result;
            if (listeningCandidates != null) {
              final offset = page * queueSourcePageSize;
              result = CandidatePage(
                candidates: listeningCandidates.skip(offset).take(queueSourcePageSize).toList(growable: false),
                total: listeningCandidates.length,
                page: page,
                pageSize: queueSourcePageSize,
              );
            } else {
              result = await _downloadSourcePage(sourceRepository, source, page);
            }
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
              final progress = snapshot.progressByKey[progressKey];
              var isFinished = progress?.isFinished ?? false;
              if ((source.type == MediaSourceType.continueReading || profile.policy.downloadType == 'ebook') &&
                  progress?.ebookProgress != null) {
                isFinished = progress!.ebookProgress! >= 1;
              }
              if (selectedForSource >= targetCount || isFinished) {
                continue;
              }
              if (!_withinAge(candidate, profile.policy.maxAgeDays)) {
                continue;
              }

              final key = _key(candidate.ref);
              if (!selectedReferences.add(key)) {
                continue;
              }

              selectedForSource++;
              if (!desired.add(key)) {
                continue;
              }
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

        final obsoleteClaims = claimRows
            .where((claim) {
              final reference = '${claim.itemId}::${claim.episodeId ?? ''}';
              return !desired.contains(reference);
            })
            .toList(growable: false);

        if (obsoleteClaims.isNotEmpty) {
          final references = obsoleteClaims.map((claim) => '${claim.itemId}::${claim.episodeId ?? ''}').toSet();
          await downloadHandler.cancelSmartTasksForReferences(
            userId: userId,
            references: references,
            profileId: profile.id,
          );
          _throwIfReconcileStale(generation, userId);
        }

        for (final claim in obsoleteClaims) {
          await db.deleteSmartDownloadClaim(profile.id, claim.itemId, episodeId: claim.episodeId);
          _throwIfReconcileStale(generation, userId);
        }
      }

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
