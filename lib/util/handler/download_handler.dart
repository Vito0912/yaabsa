import 'dart:async';
import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadHandler {
  final ProviderContainer _ref;
  late final FileDownloader _downloader;
  final _progressUpdateController = StreamController<TaskProgressUpdate>.broadcast();
  final _taskQueueController = StreamController<List<TaskRecord>>.broadcast();

  Stream<TaskRecord> get dbUpdates => _downloader.database.updates;

  Stream<TaskProgressUpdate> get progressUpdateStream => _progressUpdateController.stream;

  Stream<List<TaskRecord>> get taskQueueStream => _taskQueueController.stream;

  DownloadHandler(this._ref) {
    _downloader = FileDownloader();

    _init();

    _updateTaskQueue();

    dbUpdates.listen((update) async {
      _updateTaskQueue();
      if (update.status == TaskStatus.complete) {
        final List<dynamic> metaData = jsonDecode(update.task.metaData);
        if (metaData.isNotEmpty && metaData[0] is String) {
          final String itemId = metaData[0];
          final String userId = metaData[1];
          final String? episodeId = metaData[2];
          final InternalTrack track = InternalTrack.fromJson(metaData[3]);

          // Update the download in the database
          StoredDownloadsCompanion downloadCompanion = StoredDownloadsCompanion(
            itemId: Value(itemId),
            episodeId: Value(episodeId),
            userId: Value(userId),
            download: Value(
              jsonEncode(
                InternalDownload(
                  item: _ref.read(libraryItemProvider(itemId)).valueOrNull,
                  episode:
                      episodeId != null
                          ? _ref
                              .read(libraryItemProvider(itemId))
                              .valueOrNull
                              ?.media
                              ?.podcastMedia
                              ?.episodes
                              ?.firstWhere((e) => e.id == episodeId)
                          : null,
                  saf: false,
                  tracks: [track.copyWith(url: await update.task.filePath())],
                ),
              ),
            ),
          );

          logger(
            'Download complete for item $itemId, episode $episodeId, track ${track.index}',
            tag: 'DownloadHandler',
          );

          _ref.read(appDatabaseProvider).addOrUpdateStoredDownload(downloadCompanion);
        }
      }
    });

    _downloader.updates.listen((update) {
      _updateTaskQueue();
    });
  }

  _init() async {
    // TODO: Need to find examples for https://github.com/781flyingdutchman/background_downloader/blob/main/doc/CONFIG.md
    List<String> ids = [];
    await _downloader.database.allRecordsWithStatus(TaskStatus.failed).then((failedTasks) {
      for (final task in failedTasks) {
        logger(
          'Failed task found: ${task.taskId} with status ${task.status}',
          tag: 'DownloadHandler',
          level: InfoLevel.warning,
        );
        ids.add(task.taskId);
      }
    });
    await _downloader.database.deleteRecordsWithIds(ids);

    FileDownloader().configure();

    await FileDownloader().trackTasks();

    FileDownloader().start();

    _updateTaskQueue();
  }

  _updateTaskQueue() async {
    final List<TaskRecord> tasks =
        (await _downloader.database.allRecords()).where((task) => task.status != TaskStatus.complete).toList();
    _taskQueueController.add(tasks);
  }

  Future<void> downloadFile(String itemId, {String? episodeId, bool ebook = false}) async {
    final LibraryItem? item = _ref.read(libraryItemProvider(itemId)).valueOrNull;
    if (item == null || absApi == null) {
      throw Exception('Library item with ID $itemId not found.');
    }
    if (item.mediaType == 'podcast' && episodeId == null) {
      throw Exception('Episode ID must be provided for podcast items.');
    }
    final List<AudioFile> audioFiles =
        item.mediaType == 'podcast'
            ? item.media!.podcastMedia!.episodes
                    ?.where((e) => e.id == episodeId)
                    .map((e) => e.audioFile)
                    .whereType<AudioFile>()
                    .toList() ??
                []
            : item.media!.bookMedia!.audioFiles ?? [];

    if (audioFiles.isEmpty) {
      throw Exception('No audio files found for item $itemId with episode $episodeId.');
    }

    List<DownloadTask> downloadTasks =
        audioFiles.map((file) {
          final User? user = _ref.read(currentUserProvider).value;
          return DownloadTask(
            group: item.id,
            taskId: file.ino,
            url: '${user!.server!.url}/api/items/${item.id}/file/${file.ino}/download',
            filename: file.metadata.filename,
            displayName: item.title,
            headers: {'Authorization': 'Bearer ${user.token}'},
            directory: '$appName/${item.id}',
            updates: Updates.statusAndProgress,
            metaData: jsonEncode([
              item.id,
              user.id,
              episodeId,
              InternalTrack(
                index: file.index ?? 0,
                duration: file.duration!,
                url: null,
                mimeType: file.mimeType ?? 'audio/mpeg',
              ),
            ]),
            retries: 3,
            allowPause: true,
          );
        }).toList();

    if (audioFiles.length == 1) {
      FileDownloader().configureNotificationForGroup(
        item.id,
        running: TaskNotification(
          'Downloading {displayName}',
          '{progress} ({timeRemaining} - {networkSpeed}) - {filename}',
        ),
        complete: TaskNotification(
          'Download Complete',
          '{displayName} - [{filename}]\n'
              'All files downloaded successfully.',
        ),
        canceled: TaskNotification(
          'Download Canceled',
          '{displayName} - [{filename}]\n'
              'The download was canceled by the user.',
        ),
        error: TaskNotification(
          'Download Failed',
          '{displayName} - [{filename}]\n'
              'An error occurred during download.',
        ),
        paused: TaskNotification(
          'Download Paused',
          '{displayName} - [{filename}]\n'
              'Progress: {progress} | Speed: {networkSpeed}\n'
              'Paused at: {progress}',
        ),
        progressBar: true,
        tapOpensFile: false,
      );
    } else {
      FileDownloader().configureNotificationForGroup(
        item.id,
        running: TaskNotification(
          'Downloading {displayName}',
          '{numFinished} out of {numTotal} | Progress: {progress} | Time left: {timeRemaining}',
        ),
        complete: TaskNotification(
          'Download Complete',
          '{displayName} - [{filename}]\n'
              'All files downloaded successfully.',
        ),
        canceled: TaskNotification(
          'Download Canceled',
          '{displayName} - [{filename}]\n'
              'The download was canceled by the user.',
        ),
        error: TaskNotification(
          'Download Failed',
          '{displayName} - [{filename}]\n'
              'An error occurred during download.',
        ),
        paused: TaskNotification(
          'Download Paused',
          '{displayName} - [{filename}]\n'
              'Progress: {progress} | Speed: {networkSpeed}\n'
              'Paused at: {progress}',
        ),
        progressBar: true,
        tapOpensFile: false,
        groupNotificationId: item.id,
      );
    }

    await _ref
        .read(appDatabaseProvider)
        .deleteStoredDownload(itemId, _ref.read(currentUserProvider).value!.id, episodeId: episodeId);

    await FileDownloader().downloadBatch(downloadTasks);
  }
}
