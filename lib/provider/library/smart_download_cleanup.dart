part of 'smart_download_provider.dart';

extension _SmartDownloadCleanup on SmartDownloadManager {
  Future<void> _cleanupUnclaimed({
    required String userId,
    required Set<String> desiredByReference,
    required List<SmartDownloadProfile> profiles,
    required int generation,
    required _SmartDownloadSnapshot snapshot,
  }) async {
    if (!isAudioHandlerInitialized) {
      return;
    }

    final db = _managerRef.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    final profilesById = <String, SmartDownloadProfile>{for (final profile in profiles) profile.id: profile};
    for (final entry in snapshot.stored.values.toList(growable: false)) {
      _throwIfReconcileStale(generation, userId);
      final key = '${entry.itemId}::${entry.episodeId ?? ''}';
      if (entry.downloadOrigin != 'smart' ||
          desiredByReference.contains(key) ||
          snapshot.activeReferences.contains(key) ||
          _isProtected(entry.itemId, entry.episodeId)) {
        continue;
      }

      final graceHours = _graceHoursForEntry(entry.smartProfileIds, profilesById);
      final graceMillis = Duration(hours: graceHours).inMilliseconds;
      final completedAt = entry.completedAt ?? 0;
      if (completedAt <= 0) {
        continue;
      }
      final progress = snapshot.progressByKey[mediaProgressKey(entry.itemId, entry.episodeId)];
      final finishedAt = progress?.isFinished == true ? (progress?.finishedAt ?? progress?.lastUpdate) : null;
      if (progress?.isFinished == true && (finishedAt == null || finishedAt <= 0)) {
        continue;
      }
      final retentionStart = finishedAt != null && finishedAt > completedAt ? finishedAt : completedAt;
      if (now - retentionStart < graceMillis) {
        continue;
      }
      if (await downloadHandler.hasActiveTask(entry.itemId, episodeId: entry.episodeId)) {
        continue;
      }
      _throwIfReconcileStale(generation, userId);
      final download = await db.getStoredDownload(entry.itemId, userId, episodeId: entry.episodeId);
      _throwIfReconcileStale(generation, userId);
      if (download != null) {
        await downloadHandler.deleteDownloadedItem(download, userId: userId);
        _throwIfReconcileStale(generation, userId);
        snapshot.stored.remove(key);
        snapshot.completeKeys.remove(key);
      }
    }
  }

  int _graceHoursForEntry(String rawProfileIds, Map<String, SmartDownloadProfile> profilesById) {
    try {
      final values = _decodeProfileIds(rawProfileIds)
          .map((id) => profilesById[id]?.policy.deleteAfterHours)
          .whereType<int>()
          .where((hours) => hours >= 0)
          .toList(growable: false);
      if (values.isNotEmpty) {
        return values.reduce((left, right) => left < right ? left : right);
      }
    } catch (_) {}
    return 24;
  }

  List<String> _decodeProfileIds(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<String>().where((id) => id.trim().isNotEmpty).toList(growable: false);
      }
    } catch (_) {}
    return const <String>[];
  }

  Set<String> _snapshotReferences(String? rawSnapshot) {
    if (rawSnapshot == null || rawSnapshot.isEmpty) {
      return <String>{};
    }
    try {
      final decoded = jsonDecode(rawSnapshot);
      if (decoded is! List) {
        return <String>{};
      }
      return decoded
          .whereType<Map>()
          .map((candidate) => candidate['ref'])
          .whereType<Map>()
          .map((ref) {
            final itemId = ref['itemId'];
            final episodeId = ref['episodeId'];
            if (itemId is! String || itemId.isEmpty) {
              return null;
            }
            return '$itemId::${episodeId is String ? episodeId : ''}';
          })
          .whereType<String>()
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  bool _isProtected(String itemId, String? episodeId) {
    final current = audioHandler.currentMediaItem;
    if (current != null && current.itemId == itemId && current.episodeId == episodeId) {
      return true;
    }
    return audioHandler.isInQueue(itemId, episodeId: episodeId);
  }
}
