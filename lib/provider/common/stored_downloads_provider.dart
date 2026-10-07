import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/models/download_availability.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/download_file_entry.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

part 'stored_downloads_provider.g.dart';

typedef DownloadFileKey = (String, String?, String);

@riverpod
Stream<Map<ItemDownloadKey, DownloadAvailability>> downloadAvailability(Ref ref) {
  final userId = ref.watch(currentUserProvider.select((user) => user.value?.id));
  if (userId == null) return Stream.value(const <ItemDownloadKey, DownloadAvailability>{});
  return ref.watch(appDatabaseProvider).watchDownloadAvailabilityByUser(userId);
}

@riverpod
Stream<List<InternalDownload>> storedDownloads(Ref ref) {
  final userId = ref.watch(currentUserProvider.select((user) => user.value?.id));
  if (userId == null) return Stream.value(const <InternalDownload>[]);
  return ref.watch(appDatabaseProvider).watchStoredDownloadsByUser(userId);
}

@riverpod
Stream<InternalDownload?> storedDownloadEntry(Ref ref, String itemId, {String? episodeId}) {
  final userId = ref.watch(currentUserProvider.select((user) => user.value?.id));
  if (userId == null) return Stream.value(null);
  return ref.watch(appDatabaseProvider).watchStoredDownloadByKey(itemId, userId, episodeId: episodeId);
}

@riverpod
InternalDownload? storedDownloadForItem(Ref ref, String itemId, {String? episodeId}) {
  return ref.watch(storedDownloadEntryProvider(itemId, episodeId: episodeId)).value;
}

@riverpod
Future<List<DownloadFileEntry>> downloadFilesForItem(Ref ref, String itemId, {String? episodeId}) async {
  final download = ref.watch(storedDownloadForItemProvider(itemId, episodeId: episodeId));
  final userId = ref.watch(currentUserProvider.select((user) => user.value?.id));
  if (download == null || userId == null) return const <DownloadFileEntry>[];
  return downloadHandler.downloadFiles(download, userId: userId);
}

@riverpod
Stream<Map<DownloadFileKey, ItemDownloadStatus>> downloadFileStatuses(Ref ref) async* {
  final userId = ref.watch(currentUserProvider.select((user) => user.value?.id));
  final keys = <String, DownloadFileKey?>{};
  Map<DownloadFileKey, ItemDownloadStatus> summarize(List<TaskRecord> tasks) {
    final activeIds = <String>{};
    final result = <DownloadFileKey, ItemDownloadStatus>{};
    for (final task in tasks) {
      activeIds.add(task.taskId);
      final key = keys.putIfAbsent(task.taskId, () {
        try {
          final data = jsonDecode(task.task.metaData) as Map<String, dynamic>;
          if (data['userId'] != userId || data['fileInode'] == null) return null;
          return (data['itemId'] as String, data['episodeId'] as String?, data['fileInode'] as String);
        } catch (_) {
          return null;
        }
      });
      if (key != null) {
        result[key] = (
          status: task.status,
          percent: task.progress.isFinite ? (task.progress.clamp(0.0, 1.0) * 100).floor() : 0,
        );
      }
    }
    keys.removeWhere((id, _) => !activeIds.contains(id));
    return result;
  }

  yield summarize(downloadHandler.taskQueueSnapshot);
  yield* downloadHandler.taskQueueStream.map(summarize);
}
