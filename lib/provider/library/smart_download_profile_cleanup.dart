part of 'smart_download_provider.dart';

extension _SmartDownloadProfileCleanup on SmartDownloadManager {
  Future<void> _deleteManagedDownloadsForProfile({required String profileId, required String userId}) async {
    if (!isAudioHandlerInitialized) {
      return;
    }

    final db = _managerRef.read(appDatabaseProvider);
    await downloadHandler.cancelSmartTasksForProfile(profileId, userId: userId);
    final entries = await db.getStoredDownloadEntriesByUser(userId);
    final downloads = await db.getAllStoredDownloadsByUser(userId);
    final enabledProfileIds = (await db.getSmartDownloadProfiles(userId))
        .where((profile) => profile.enabled && profile.id != profileId)
        .map((profile) => profile.id)
        .toSet();
    for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
      final profileIds = _decodeProfileIds(entry.smartProfileIds);
      if (!profileIds.contains(profileId)) {
        continue;
      }
      final otherClaimingProfileIds = (await db.getSmartDownloadClaimsForReference(
        entry.itemId,
        entry.episodeId,
      )).map((claim) => claim.profileId).where(enabledProfileIds.contains);
      final remainingProfileIds = <String>{
        ...profileIds.where((id) => id != profileId),
        ...otherClaimingProfileIds,
      }.toList(growable: false)..sort();
      if (remainingProfileIds.isNotEmpty) {
        await db.updateStoredDownloadSmartProfileIds(
          entry.itemId,
          userId,
          episodeId: entry.episodeId,
          smartProfileIds: remainingProfileIds,
        );
        continue;
      }
      if (_isProtected(entry.itemId, entry.episodeId) ||
          await downloadHandler.hasActiveTask(entry.itemId, episodeId: entry.episodeId)) {
        continue;
      }
      final download = downloads.where((candidate) {
        final itemId = candidate.item?.id ?? candidate.episode?.libraryItemId;
        return itemId == entry.itemId && candidate.episode?.id == entry.episodeId;
      }).firstOrNull;
      if (download != null) {
        await downloadHandler.deleteDownloadedItem(download, userId: userId);
      }
    }
  }

  Future<void> _deleteManagedDownloadsForRemovedSources(SmartDownloadProfile profile) async {
    if (!isAudioHandlerInitialized) {
      return;
    }

    final db = _managerRef.read(appDatabaseProvider);
    final previousSources = await db.getSmartDownloadSources(profile.id);
    final currentSourceKeys = profile.sources.map(_descriptorSourceKey).toSet();
    final removedSourceKeys = previousSources
        .map(_storedSourceKey)
        .where((key) => !currentSourceKeys.contains(key))
        .toSet();
    if (removedSourceKeys.isEmpty) {
      return;
    }

    final claims = await db.getSmartDownloadClaims(profile.id);
    final removedReferences = claims
        .where((claim) => removedSourceKeys.contains('${claim.sourceType}::${claim.sourceId}'))
        .map((claim) => '${claim.itemId}::${claim.episodeId ?? ''}')
        .toSet();
    for (final source in previousSources.where((source) => removedSourceKeys.contains(_storedSourceKey(source)))) {
      removedReferences.addAll(_snapshotReferences(source.candidateSnapshot));
    }
    if (removedReferences.isEmpty && currentSourceKeys.isEmpty) {
      final entries = await db.getStoredDownloadEntriesByUser(profile.userId);
      for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
        final profileIds = _decodeProfileIds(entry.smartProfileIds);
        if (profileIds.length == 1 && profileIds.first == profile.id) {
          removedReferences.add('${entry.itemId}::${entry.episodeId ?? ''}');
        }
      }
    }
    if (removedReferences.isEmpty) {
      return;
    }

    await downloadHandler.cancelSmartTasksForReferences(
      userId: profile.userId,
      references: removedReferences,
      profileId: profile.id,
    );

    final entries = await db.getStoredDownloadEntriesByUser(profile.userId);
    final downloads = await db.getAllStoredDownloadsByUser(profile.userId);
    final enabledProfileIds = (await db.getSmartDownloadProfiles(profile.userId))
        .where((storedProfile) => storedProfile.enabled && storedProfile.id != profile.id)
        .map((storedProfile) => storedProfile.id)
        .toSet();
    for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
      final reference = '${entry.itemId}::${entry.episodeId ?? ''}';
      if (!removedReferences.contains(reference)) {
        continue;
      }
      final profileIds = _decodeProfileIds(entry.smartProfileIds);
      if (!profileIds.contains(profile.id)) {
        continue;
      }
      final otherClaimingProfileIds = (await db.getSmartDownloadClaimsForReference(
        entry.itemId,
        entry.episodeId,
      )).map((claim) => claim.profileId).where(enabledProfileIds.contains);
      final remainingProfileIds = <String>{
        ...profileIds.where((id) => id != profile.id),
        ...otherClaimingProfileIds,
      }.toList(growable: false)..sort();
      if (remainingProfileIds.isNotEmpty) {
        await db.updateStoredDownloadSmartProfileIds(
          entry.itemId,
          profile.userId,
          episodeId: entry.episodeId,
          smartProfileIds: remainingProfileIds,
        );
        continue;
      }
      if (_isProtected(entry.itemId, entry.episodeId) ||
          await downloadHandler.hasActiveTask(entry.itemId, episodeId: entry.episodeId)) {
        continue;
      }
      final download = downloads.where((candidate) {
        final itemId = candidate.item?.id ?? candidate.episode?.libraryItemId;
        return itemId == entry.itemId && candidate.episode?.id == entry.episodeId;
      }).firstOrNull;
      if (download != null) {
        await downloadHandler.deleteDownloadedItem(download, userId: profile.userId);
      }
    }
  }

  MediaSourceDescriptor? _sourceFromRow(SmartDownloadSourceEntry row) {
    final type = MediaSourceType.values.where((value) => value.name == row.sourceType).firstOrNull;
    if (type == null) {
      return null;
    }
    return MediaSourceDescriptor(
      type: type,
      sourceId: row.sourceId,
      libraryId: row.libraryId,
      displayName: row.displayName,
      descending: row.descending,
      revision: row.sourceRevision,
      listeningTrigger:
          ListeningDownloadTrigger.values.where((trigger) => trigger.name == row.listeningTrigger).firstOrNull ??
          ListeningDownloadTrigger.minutes,
      listeningThreshold: row.listeningThreshold,
    );
  }
}
