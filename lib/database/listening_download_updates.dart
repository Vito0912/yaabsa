part of 'app_database.dart';

extension ListeningDownloadUpdates on AppDatabase {
  Future<ListeningDownloadProgressEntry> recordListeningDownloadProgress({
    required String userId,
    required String itemId,
    required String libraryId,
    required double listenedSeconds,
    required double progressPercent,
  }) async {
    return transaction(() async {
      final existing = await (select(
        listeningDownloadProgress,
      )..where((row) => row.userId.equals(userId) & row.itemId.equals(itemId))).getSingleOrNull();
      final entry = ListeningDownloadProgressEntry(
        userId: userId,
        itemId: itemId,
        libraryId: libraryId,
        listenedSeconds: (existing?.listenedSeconds ?? 0) + listenedSeconds,
        progressPercent: progressPercent,
      );

      await into(listeningDownloadProgress).insertOnConflictUpdate(entry);
      return entry;
    });
  }
}
