part of 'app_database.dart';

extension StoredDownloadAssetUpdates on AppDatabase {
  Future<void> updateStoredDownloadAssets({
    required String itemId,
    required String userId,
    required String? episodeId,
    required String fileKey,
    required String? coverPath,
    required String? sidecarPath,
  }) {
    return transaction(() async {
      final whereClause = _storedDownloadWhereExpression(itemId: itemId, userId: userId, episodeId: episodeId);
      final entry = await (select(storedDownloads)..where((_) => whereClause)).getSingleOrNull();
      if (entry == null) return;

      final normalized = _isNormalizedStoredDownload(entry.download);
      final download = normalized
          ? await _decodeNormalizedStoredDownloadBase(entry)
          : _decodeDownloadJsonOrNull(entry.download, itemId: itemId, userId: userId, episodeId: episodeId);
      if (download == null) return;

      if (normalized && _storedDownloadFilesAvailable != false) {
        final fileWhereClause =
            _storedDownloadFileWhereExpression(itemId: itemId, userId: userId, episodeId: episodeId) &
            storedDownloadFiles.fileKey.equals(fileKey);
        final file = await (select(storedDownloadFiles)..where((_) => fileWhereClause)).getSingleOrNull();
        if (file == null) return;
        if (sidecarPath != null) {
          await (update(
            storedDownloadFiles,
          )..where((_) => fileWhereClause)).write(StoredDownloadFilesCompanion(sidecarPath: Value(sidecarPath)));
        }
        final coverChanged = coverPath != null && coverPath != download.coverPath;
        await (update(storedDownloads)..where((_) => whereClause)).write(
          StoredDownloadsCompanion(
            download: coverChanged
                ? Value(
                    _encodeNormalizedStoredDownload(download.copyWith(coverPath: coverPath), includeInlineFiles: true),
                  )
                : const Value.absent(),
            completedAt: Value(
              _nextStoredDownloadCompletedAt(DateTime.now().millisecondsSinceEpoch, entry.completedAt),
            ),
          ),
        );
        if (coverChanged) _storedDownloadBaseCache.remove(entry.download);
        _storedDownloadCache.remove(_storedDownloadCacheKey(entry));
        return;
      }

      final updated = download.copyWith(
        coverPath: coverPath ?? download.coverPath,
        sidecarPaths: <String>{...download.sidecarPaths, ?sidecarPath}.toList(growable: false),
      );
      await (update(storedDownloads)..where((_) => whereClause)).write(
        StoredDownloadsCompanion(
          download: Value(
            normalized
                ? _encodeNormalizedStoredDownload(updated, includeInlineFiles: true)
                : jsonEncode(updated.toJson()),
          ),
        ),
      );
      _storedDownloadBaseCache.remove(entry.download);
      _storedDownloadCache.remove(_storedDownloadCacheKey(entry));
    });
  }
}
