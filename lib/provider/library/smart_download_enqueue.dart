part of 'smart_download_provider.dart';

extension _SmartDownloadEnqueue on SmartDownloadManager {
  Future<void> _enqueueDesired({
    required List<SmartDownloadProfile> profiles,
    required Map<String, Set<String>> desiredByProfile,
    required String userId,
    required int generation,
    required _SmartDownloadSnapshot snapshot,
  }) async {
    final db = _managerRef.read(appDatabaseProvider);
    final enabledProfiles = profiles.where((profile) => profile.enabled).toList(growable: false);
    final profileIdsByKey = <String, Set<String>>{};
    final downloadTypeByKey = <String, String>{};
    for (final profile in enabledProfiles) {
      for (final key in desiredByProfile[profile.id] ?? const <String>{}) {
        profileIdsByKey.putIfAbsent(key, () => <String>{}).add(profile.id);
        final downloadType = profile.policy.downloadType;

        downloadTypeByKey.update(
          key,
          (existing) => _mergeDownloadTypes(existing, downloadType),
          ifAbsent: () => downloadType,
        );
      }
    }
    if (profileIdsByKey.isEmpty) {
      return;
    }

    final storedProfileIds = <String, Set<String>>{};
    for (final entry in snapshot.stored.values.where((entry) => entry.downloadOrigin == 'smart')) {
      final key = '${entry.itemId}::${entry.episodeId ?? ''}';
      final existingProfileIds = _decodeProfileIds(entry.smartProfileIds).toSet();
      final mergedProfileIds = <String>{...existingProfileIds, ...?profileIdsByKey[key]};
      storedProfileIds[key] = mergedProfileIds;
      if (existingProfileIds.length == mergedProfileIds.length) {
        continue;
      }

      await db.updateStoredDownloadSmartProfileIds(
        entry.itemId,
        userId,
        episodeId: entry.episodeId,
        smartProfileIds: mergedProfileIds.toList(growable: false)..sort(),
      );
      _throwIfReconcileStale(generation, userId);
    }

    final cappedProfiles = <String, int>{
      for (final profile in enabledProfiles)
        if ((profile.policy.maxStorageBytes ?? 0) > 0) profile.id: profile.policy.maxStorageBytes!,
    };
    final managedBytes = <String, int>{for (final id in cappedProfiles.keys) id: 0};
    final unknownReservations = <String>{};
    for (final entry in snapshot.stored.entries) {
      if (entry.value.downloadOrigin != 'smart' || !snapshot.downloadsByReference.containsKey(entry.key)) {
        continue;
      }
      for (final id in storedProfileIds[entry.key] ?? const <String>{}) {
        if (managedBytes.containsKey(id)) {
          managedBytes[id] = managedBytes[id]! + (entry.value.managedBytes ?? 0);
        }
      }
    }

    for (final entry in snapshot.reservations.entries.toList(growable: false)) {
      final downloadType = downloadTypeByKey[entry.key];
      if (downloadType == null) {
        continue;
      }

      final owners = profileIdsByKey[entry.key] ?? const <String>{};
      final cappedOwners = owners.where(cappedProfiles.containsKey).toList(growable: false);
      if (cappedOwners.isEmpty) {
        continue;
      }

      final storedBudget = _storedDownloadBudget(snapshot: snapshot, reference: entry.key, requestedType: downloadType);
      var bytes = entry.value;
      if (bytes <= 0) {
        final parts = entry.key.split('::');
        final estimatedBytes = await _estimateDownloadBytes(
          snapshot,
          parts.first,
          parts[1].isEmpty ? null : parts[1],
          storedBudget.downloadType,
        );
        _throwIfReconcileStale(generation, userId);

        bytes = estimatedBytes ?? 0;
        snapshot.reservations[entry.key] = bytes;
      }

      final reservationBytes = bytes > storedBudget.bytes ? bytes - storedBudget.bytes : 0;
      for (final id in cappedOwners) {
        managedBytes[id] = managedBytes[id]! + reservationBytes;
        if (bytes <= 0) {
          unknownReservations.add(id);
        }
      }
    }

    for (final entry in profileIdsByKey.entries) {
      _throwIfReconcileStale(generation, userId);
      final key = entry.key;
      final downloadType = downloadTypeByKey[key]!;
      final isComplete = _hasCompleteDownload(snapshot: snapshot, reference: key, downloadType: downloadType);

      if (isComplete || snapshot.activeReferences.contains(key) || _retryAfter.containsKey(key)) {
        continue;
      }

      final cappedOwners = entry.value.where(cappedProfiles.containsKey).toList(growable: false);
      if (cappedOwners.any(unknownReservations.contains) ||
          cappedOwners.any((id) => managedBytes[id]! >= cappedProfiles[id]!)) {
        continue;
      }

      final parts = key.split('::');
      final itemId = parts.first;
      final episodeId = parts[1].isEmpty ? null : parts[1];
      final storedBudget = _storedDownloadBudget(snapshot: snapshot, reference: key, requestedType: downloadType);
      var estimatedBytes = snapshot.candidateBytes[key] ?? 0;
      var additionalBytes = estimatedBytes > storedBudget.bytes ? estimatedBytes - storedBudget.bytes : 0;

      if (cappedOwners.isNotEmpty) {
        final resolvedBytes = await _estimateDownloadBytes(snapshot, itemId, episodeId, storedBudget.downloadType);
        _throwIfReconcileStale(generation, userId);
        if (resolvedBytes != null && resolvedBytes > estimatedBytes) {
          estimatedBytes = resolvedBytes;
        }
        additionalBytes = estimatedBytes > storedBudget.bytes ? estimatedBytes - storedBudget.bytes : 0;
        final exceedsBudget = cappedOwners.any((id) => managedBytes[id]! + additionalBytes > cappedProfiles[id]!);
        if (estimatedBytes <= 0 || exceedsBudget) {
          continue;
        }
      }

      try {
        await downloadHandler.downloadFile(
          itemId,
          episodeId: episodeId,
          downloadType: downloadType,
          acquisitionOrigin: 'smart',
          smartProfileIds: entry.value.toList(growable: false)..sort(),
          estimatedBytes: estimatedBytes > 0 ? estimatedBytes : null,
          requiredUserId: userId,
          requestNotificationPermission: enabledProfiles.any((profile) {
            if (!entry.value.contains(profile.id)) {
              return false;
            }

            return profile.sources.any((source) => source.type != MediaSourceType.listeningThreshold);
          }),
        );
      } on NoDownloadableFilesException {
        _throwIfReconcileStale(generation, userId);
        continue;
      }

      _throwIfReconcileStale(generation, userId);
      snapshot.activeReferences.add(key);
      snapshot.reservations[key] = estimatedBytes;
      for (final id in cappedOwners) {
        managedBytes[id] = managedBytes[id]! + additionalBytes;
      }
    }
  }
}
