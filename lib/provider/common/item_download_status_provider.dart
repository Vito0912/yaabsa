import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;

part 'item_download_status_provider.g.dart';

typedef ItemDownloadKey = (String, String?);
typedef ItemDownloadStatus = ({TaskStatus status, int percent});

@riverpod
Stream<Map<ItemDownloadKey, ItemDownloadStatus>> itemDownloadStatuses(Ref ref) async* {
  final metadata = <String, ({ItemDownloadKey key, int fileCount})>{};

  Map<ItemDownloadKey, ItemDownloadStatus> summarize(List<TaskRecord> tasks) {
    final batches = <ItemDownloadKey, List<TaskRecord>>{};
    final taskIds = <String>{};
    for (final task in tasks) {
      taskIds.add(task.taskId);
      final data = metadata.putIfAbsent(task.taskId, () {
        try {
          final json = jsonDecode(task.task.metaData) as Map<String, dynamic>;
          return (
            key: (json['itemId'] as String, json['episodeId'] as String?),
            fileCount: (json['expectedFileCount'] as num?)?.toInt() ?? 1,
          );
        } catch (_) {
          return (key: (task.group, null), fileCount: 1);
        }
      });
      (batches[data.key] ??= []).add(task);
    }
    metadata.removeWhere((id, _) => !taskIds.contains(id));
    final result = <ItemDownloadKey, ItemDownloadStatus>{};
    for (final entry in batches.entries) {
      var total = entry.value.length;
      var progress = 0.0;
      var status = TaskStatus.enqueued;
      for (final task in entry.value) {
        final expected = metadata[task.taskId]!.fileCount;
        if (expected > total) total = expected;
        if (task.progress.isFinite) progress += task.progress.clamp(0.0, 1.0);
        if (task.status == TaskStatus.running ||
            (status != TaskStatus.running && task.status == TaskStatus.waitingToRetry) ||
            (status == TaskStatus.enqueued && task.status == TaskStatus.paused)) {
          status = task.status;
        }
      }
      final completed = downloadHandler
          .completedFilesInBatch(entry.key.$1, episodeId: entry.key.$2)
          .clamp(0, total - entry.value.length);
      progress += completed;
      result[entry.key] = (status: status, percent: (progress / total * 100).floor().clamp(0, 100));
    }
    return result;
  }

  yield summarize(downloadHandler.taskQueueSnapshot);
  yield* downloadHandler.taskQueueStream.map(summarize);
}
