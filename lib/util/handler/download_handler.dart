import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:buchshelfly/api/library_items/audio_file.dart';
import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/provider/common/library_item_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadHandler {
  final ProviderContainer _ref;
  late final FileDownloader _downloader;
  final _progressUpdateController = StreamController<TaskProgressUpdate>.broadcast();

  Stream<TaskRecord> get dbUpdates => _downloader.database.updates;

  Stream<TaskProgressUpdate> get progressUpdateStream => _progressUpdateController.stream;

  DownloadHandler(this._ref) {
    _downloader = FileDownloader();

    _init();

    dbUpdates.listen((update) {
      print(update.progress);
      print(update.task.filename);
    });
  }

  _init() async {
    // TODO: Need to find examples for https://github.com/781flyingdutchman/background_downloader/blob/main/doc/CONFIG.md
    FileDownloader().configure();

    await FileDownloader().trackTasks();

    FileDownloader().start();
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
            // TODO: requiresWiFi
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

    await FileDownloader().downloadBatch(downloadTasks);
  }
}
