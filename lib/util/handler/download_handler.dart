import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:background_downloader/background_downloader.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_file.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/download_sidecar.dart';
import 'package:yaabsa/models/download_task_metadata.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/android_saf.dart';
import 'package:yaabsa/util/download_destination.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/request_headers.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/file_formats.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadHandler {
  final ProviderContainer _ref;
  late final FileDownloader? _downloader;
  final _progressUpdateController = StreamController<TaskProgressUpdate>.broadcast();
  final _taskQueueController = StreamController<List<TaskRecord>>.broadcast();

  Stream<TaskRecord> get dbUpdates => _downloader?.database.updates ?? const Stream.empty();

  Stream<TaskProgressUpdate> get progressUpdateStream => _progressUpdateController.stream;

  Stream<List<TaskRecord>> get taskQueueStream => _taskQueueController.stream;

  DownloadHandler(this._ref) {
    if (kIsWeb) {
      _downloader = null;
      return;
    }
    _downloader = FileDownloader();

    _init();

    _updateTaskQueue();

    dbUpdates.listen(
      (update) async {
        _updateTaskQueue();
        if (update.status != TaskStatus.complete) {
          return;
        }

        await _storeCompletedDownload(update);
      },
      onError: (Object error, StackTrace stackTrace) {
        logger('Download update stream failed: $error\n$stackTrace', tag: 'DownloadHandler', level: InfoLevel.error);
      },
    );

    _downloader!.updates.listen(
      (update) {
        if (update is TaskProgressUpdate) {
          _progressUpdateController.add(update);
        }
        _updateTaskQueue();
      },
      onError: (Object error, StackTrace stackTrace) {
        logger('Download progress stream failed: $error\n$stackTrace', tag: 'DownloadHandler', level: InfoLevel.error);
      },
    );
  }

  Future<void> _init() async {
    if (kIsWeb || _downloader == null) {
      return;
    }
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

    if (!kIsWeb && Platform.isAndroid) {
      await _downloader.configure(androidConfig: [(Config.runInForeground, Config.always)]);
    } else {
      await _downloader.configure();
    }

    await _downloader.trackTasks();

    _downloader.start();

    _updateTaskQueue();
  }

  Future<void> _updateTaskQueue() async {
    if (kIsWeb || _downloader == null) {
      return;
    }
    final List<TaskRecord> tasks = (await _downloader.database.allRecords())
        .where((task) => task.status.isNotFinalState)
        .toList();
    _taskQueueController.add(tasks);
  }

  Future<bool> cancelTask(String taskId) async {
    if (kIsWeb || _downloader == null) {
      return false;
    }
    final canceled = await _downloader.cancelTaskWithId(taskId);
    await _updateTaskQueue();
    return canceled;
  }

  bool taskBelongsToItem(TaskRecord task, String itemId, {String? episodeId}) {
    if (!task.status.isNotFinalState) {
      return false;
    }
    if (task.group != itemId) {
      return false;
    }

    final normalizedItemId = itemId.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    final normalizedEpisodeId = (episodeId ?? 'item').replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    return task.taskId.startsWith('${normalizedItemId}_${normalizedEpisodeId}_');
  }

  Future<void> _ensureNotificationPermissionForDownloads() async {
    if (kIsWeb || _downloader == null || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    final permissionType = PermissionType.notifications;
    var status = await _downloader.permissions.status(permissionType);
    if (status == PermissionStatus.granted || status == PermissionStatus.partial) {
      return;
    }

    if (await _downloader.permissions.shouldShowRationale(permissionType)) {
      logger(
        'Notification permission rationale should be shown before requesting downloads notifications.',
        tag: 'DownloadHandler',
        level: InfoLevel.info,
      );
    }

    status = await _downloader.permissions.request(permissionType);
    if (status == PermissionStatus.granted || status == PermissionStatus.partial) {
      return;
    }

    throw Exception(
      'Notifications permission is required for reliable background downloads. Please enable notifications and try again.',
    );
  }

  Future<void> downloadFile(String itemId, {String? episodeId, String downloadType = 'both'}) async {
    if (kIsWeb || _downloader == null) {
      throw UnsupportedError('Downloads are not supported on the Web');
    }
    LibraryItem? item = _ref.read(libraryItemProvider(itemId)).asData?.value;
    if (item == null) {
      try {
        item = await _ref.read(libraryItemProvider(itemId).future);
      } catch (_) {
        // Keep fallback null and throw the existing not-found error below.
      }
    }

    if (item == null) {
      throw Exception('Library item with ID $itemId not found.');
    }
    final resolvedItem = item;

    if (resolvedItem.mediaType == 'podcast' && episodeId == null) {
      throw Exception('Episode ID must be provided for podcast items.');
    }

    await _ensureNotificationPermissionForDownloads();

    final sourceFiles = _collectDownloadSourceFiles(resolvedItem, episodeId: episodeId, downloadType: downloadType);
    if (sourceFiles.isEmpty) {
      throw Exception('No downloadable files found for item $itemId.');
    }
    final expectedFileCount = sourceFiles.length;

    final User? user = _ref.read(currentUserProvider).value;
    if (user == null) {
      throw Exception('No active user found for download request.');
    }

    final server = user.server;
    if (server == null || server.url.isEmpty) {
      throw Exception('No server configuration available for downloads.');
    }

    final authToken = user.preferredAuthToken;
    if (authToken == null || authToken.isEmpty) {
      throw Exception('No valid authentication token available for downloads.');
    }
    final requestHeaders = buildRequestHeaders(serverHeaders: server.headers, bearerToken: authToken);

    final String customDownloadLocation = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(user.id, SettingKeys.downloadPath, defaultValue: '');

    final destination = await resolveDownloadTaskDestination(_downloader, customDownloadLocation, resolvedItem.id);

    final List<Task> downloadTasks = <Task>[];
    for (final source in sourceFiles) {
      final taskId = _taskIdFor(source.ino, resolvedItem.id, episodeId);
      final filename = _sanitizeFilename(
        source.filename,
        fileIndex: source.fileIndex,
        fallbackExtension: source.extension,
      );
      final metaData = jsonEncode(
        DownloadTaskMetadata(
          itemId: resolvedItem.id,
          userId: user.id,
          episodeId: episodeId,
          track: source.track,
          expectedFileCount: expectedFileCount,
          fileInode: source.ino,
          fileIndex: source.fileIndex,
          fileKind: source.fileKind,
          fileName: filename,
          fileMimeType: source.mimeType,
          saf: destination.saf,
          downloadBasePath: destination.storageBasePath,
          libraryId: resolvedItem.libraryId,
          serverUrl: server.url,
          serverHost: server.host,
          serverPort: server.port,
          serverSsl: server.ssl,
          title: resolvedItem.title,
          downloadType: downloadType,
        ).toJson(),
      );

      final downloadUrl = '${server.url}/api/items/${resolvedItem.id}/file/${source.ino}/download';

      if (destination.usesUriTask) {
        downloadTasks.add(
          await _buildUriDownloadTask(
            destination: destination,
            item: resolvedItem,
            source: source,
            taskId: taskId,
            filename: filename,
            requestHeaders: requestHeaders,
            metaData: metaData,
            downloadUrl: downloadUrl,
          ),
        );
        continue;
      }

      downloadTasks.add(
        DownloadTask(
          group: resolvedItem.id,
          taskId: taskId,
          url: downloadUrl,
          filename: filename,
          displayName: resolvedItem.title,
          headers: requestHeaders,
          baseDirectory: destination.baseDirectory!,
          directory: destination.directory!,
          updates: Updates.statusAndProgress,
          metaData: metaData,
          retries: 3,
          allowPause: true,
        ),
      );
    }

    if (downloadTasks.length == 1) {
      _downloader.configureNotificationForGroup(
        resolvedItem.id,
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
      _downloader.configureNotificationForGroup(
        resolvedItem.id,
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
        groupNotificationId: resolvedItem.id,
      );
    }

    await _ref
        .read(appDatabaseProvider)
        .deleteStoredDownload(itemId, _ref.read(currentUserProvider).value!.id, episodeId: episodeId);

    final enqueueResults = await _downloader.enqueueAll(downloadTasks);
    final queuedTasks = enqueueResults.where((result) => result).length;
    if (queuedTasks == 0) {
      throw Exception('Could not queue download. Please check your connection and try again.');
    }
    if (queuedTasks != downloadTasks.length) {
      logger(
        'Only $queuedTasks/${downloadTasks.length} download task(s) were queued for item $itemId.',
        tag: 'DownloadHandler',
        level: InfoLevel.warning,
      );
    }

    await _updateTaskQueue();
  }

  Future<UriDownloadTask> _buildUriDownloadTask({
    required DownloadTaskDestination destination,
    required LibraryItem item,
    required _DownloadSourceFile source,
    required String taskId,
    required String filename,
    required Map<String, String> requestHeaders,
    required String metaData,
    required String downloadUrl,
  }) async {
    final baseTask = UriDownloadTask(
      group: item.id,
      taskId: taskId,
      url: downloadUrl,
      filename: filename,
      displayName: item.title,
      headers: requestHeaders,
      updates: Updates.statusAndProgress,
      metaData: metaData,
      retries: 3,
      allowPause: true,
      directoryUri: destination.directoryUri!,
    );

    if (!_supportsAndroidSafPreparedFiles(destination)) {
      return baseTask;
    }

    final preparedFileUri = await AndroidSafHelper.prepareDownloadFile(
      rootTreeUri: destination.directoryUri!,
      relativeDirectory: item.id,
      filename: filename,
      mimeType: source.mimeType,
    );

    if (preparedFileUri == null) {
      throw Exception(
        'Could not prepare the selected Android SAF folder for download. Please re-select the folder and try again.',
      );
    }

    final taskJson = Map<String, dynamic>.from(baseTask.toJson())
      ..['filename'] = AndroidSafHelper.packFilenameWithUri(filename, preparedFileUri);
    return UriDownloadTask.fromJson(taskJson);
  }

  bool _supportsAndroidSafPreparedFiles(DownloadTaskDestination destination) {
    final directoryUri = destination.directoryUri;
    return !kIsWeb && Platform.isAndroid && destination.saf && directoryUri != null && directoryUri.scheme == 'content';
  }

  Future<void> _storeCompletedDownload(TaskRecord update) async {
    try {
      final parsedMetaData = _parseMetaData(update.task.metaData);
      if (parsedMetaData == null) {
        return;
      }

      final storedTrackUrl = await _resolveStoredTrackUrl(update.task);
      if (storedTrackUrl == null) {
        logger(
          'Skipping completed task ${update.task.taskId} because no stored track URL could be resolved.',
          tag: 'DownloadHandler',
          level: InfoLevel.warning,
        );
        return;
      }

      LibraryItem? item = _ref.read(libraryItemProvider(parsedMetaData.itemId)).asData?.value;
      if (item == null) {
        try {
          item = await _ref.read(libraryItemProvider(parsedMetaData.itemId).future);
        } catch (e, s) {
          logger(
            'Could not resolve library item ${parsedMetaData.itemId} while storing download metadata: $e\n$s',
            tag: 'DownloadHandler',
            level: InfoLevel.warning,
          );
        }
      }

      Episode? resolvedEpisode;

      if (item != null && parsedMetaData.episodeId != null) {
        final episodes = item.media?.podcastMedia?.episodes;
        if (episodes != null) {
          for (final episode in episodes) {
            if (episode.id == parsedMetaData.episodeId) {
              resolvedEpisode = episode;
              break;
            }
          }
        }
      }

      if (item == null && resolvedEpisode == null) {
        logger(
          'Skipping download persistence for ${parsedMetaData.itemId} because item metadata is unavailable.',
          tag: 'DownloadHandler',
          level: InfoLevel.warning,
        );
        return;
      }

      final trackUri = _trackUriFromStoredUrl(storedTrackUrl);
      final resolvedUser = await _resolveUserForDownload(parsedMetaData.userId);

      final coverPath = await _storeCoverLocally(
        item: item,
        user: resolvedUser,
        trackUri: trackUri,
        metaData: parsedMetaData,
      );

      final sidecarPath = await _writeFileSidecar(
        fileUri: trackUri,
        item: item,
        episode: resolvedEpisode,
        metaData: parsedMetaData,
        coverPath: coverPath,
      );

      final storedTrackPath = await storeDownloadPath(storedTrackUrl, parsedMetaData.downloadBasePath);
      final downloadedTrack = parsedMetaData.track?.copyWith(url: storedTrackPath);
      final auxiliaryFilePaths = downloadedTrack == null
          ? <String>[storedTrackPath ?? storedTrackUrl]
          : const <String>[];
      final storedCoverPath = await storeDownloadPath(coverPath, parsedMetaData.downloadBasePath);
      final storedSidecarPath = await storeDownloadPath(sidecarPath, parsedMetaData.downloadBasePath);

      final downloadCompanion = StoredDownloadsCompanion(
        itemId: Value(parsedMetaData.itemId),
        episodeId: Value(parsedMetaData.episodeId),
        userId: Value(parsedMetaData.userId),
        download: Value(
          jsonEncode(
            InternalDownload(
              item: item,
              episode: resolvedEpisode,
              saf: parsedMetaData.saf,
              downloadBasePath: parsedMetaData.downloadBasePath,
              tracks: downloadedTrack == null ? const <InternalTrack>[] : <InternalTrack>[downloadedTrack],
              expectedFileCount: parsedMetaData.expectedFileCount,
              auxiliaryFilePaths: auxiliaryFilePaths,
              coverPath: storedCoverPath,
              sidecarPaths: storedSidecarPath == null ? const <String>[] : <String>[storedSidecarPath],
              downloadType: parsedMetaData.downloadType,
            ),
          ),
        ),
      );

      logger(
        'Download complete for item ${parsedMetaData.itemId}, episode ${parsedMetaData.episodeId}, file ${parsedMetaData.fileName ?? parsedMetaData.fileInode}',
        tag: 'DownloadHandler',
      );

      await _ref.read(appDatabaseProvider).addOrUpdateStoredDownload(downloadCompanion);
    } catch (e, s) {
      logger('Failed to persist completed download: $e\n$s', tag: 'DownloadHandler', level: InfoLevel.error);
    }
  }

  Future<DeleteStoredDownloadResult> deleteDownloadedItem(InternalDownload download, {required String userId}) async {
    final itemId = download.item?.id ?? download.episode?.libraryItemId;
    if (itemId == null) {
      throw Exception('Cannot delete download because item metadata is unavailable.');
    }

    final episodeId = download.episode?.id;

    final trackUris = <Uri>{};
    for (final track in download.tracks) {
      final parsedUri = _trackUriFromStoredUrl(track.url);
      if (parsedUri != null) {
        trackUris.add(parsedUri);
      }
    }

    for (final auxiliaryPath in download.auxiliaryFilePaths) {
      final parsedUri = _trackUriFromStoredUrl(auxiliaryPath);
      if (parsedUri != null) {
        trackUris.add(parsedUri);
      }
    }

    final auxiliaryUris = <Uri>{};
    for (final sidecarPath in download.sidecarPaths) {
      final parsedUri = _trackUriFromStoredUrl(sidecarPath);
      if (parsedUri != null) {
        auxiliaryUris.add(parsedUri);
      }
    }
    final parsedCoverUri = _trackUriFromStoredUrl(download.coverPath);
    if (parsedCoverUri != null) {
      auxiliaryUris.add(parsedCoverUri);
    }

    final allFileUris = <Uri>{...trackUris, ...auxiliaryUris};

    logger(
      'Deleting local download files for item $itemId (episode: ${episodeId ?? 'none'}) with ${allFileUris.length} file target(s).',
      tag: 'DownloadHandler',
      level: InfoLevel.warning,
    );

    var deletedFiles = 0;
    var failedFiles = 0;

    for (final trackUri in allFileUris) {
      try {
        final deleted = await _deleteTrackedFileUri(trackUri);
        if (deleted) {
          deletedFiles++;
        } else {
          failedFiles++;
          logger('Could not delete downloaded track: $trackUri', tag: 'DownloadHandler', level: InfoLevel.warning);
        }
      } catch (e, s) {
        failedFiles++;
        logger('Failed to delete track URI $trackUri: $e\n$s', tag: 'DownloadHandler', level: InfoLevel.warning);
      }
    }

    await _ref.read(appDatabaseProvider).deleteStoredDownload(itemId, userId, episodeId: episodeId);

    return DeleteStoredDownloadResult(
      itemId: itemId,
      episodeId: episodeId,
      attemptedFiles: allFileUris.length,
      deletedFiles: deletedFiles,
      failedFiles: failedFiles,
    );
  }

  Future<bool> _deleteTrackedFileUri(Uri originalUri) async {
    if (kIsWeb || _downloader == null) {
      return false;
    }
    Uri targetUri = originalUri;

    if (originalUri.scheme == 'content') {
      targetUri =
          await _downloader.uri.activate(originalUri).timeout(const Duration(seconds: 8), onTimeout: () => null) ??
          originalUri;
    }

    if (targetUri.scheme == 'file') {
      try {
        final file = File.fromUri(targetUri);
        if (!await file.exists()) {
          logger('File already deleted: $targetUri', tag: 'DownloadHandler', level: InfoLevel.warning);
          return true;
        }
        await file.delete();
        return true;
      } catch (_) {
        return false;
      }
    }

    final deleted = await _downloader.uri
        .deleteFile(targetUri)
        .timeout(const Duration(seconds: 8), onTimeout: () => false);
    return deleted;
  }

  Future<User?> _resolveUserForDownload(String userId) async {
    final activeUser = _ref.read(currentUserProvider).value;
    if (activeUser != null && activeUser.id == userId) {
      return activeUser;
    }

    try {
      return await _ref.read(appDatabaseProvider).getStoredUser(userId);
    } catch (e, s) {
      logger(
        'Failed to resolve stored user $userId for download metadata: $e\n$s',
        tag: 'DownloadHandler',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  File? _trackFileFromUri(Uri? trackUri) {
    if (trackUri == null || trackUri.scheme != 'file') {
      return null;
    }

    try {
      return File.fromUri(trackUri);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _storeCoverLocally({
    required LibraryItem? item,
    required User? user,
    required Uri? trackUri,
    required DownloadTaskMetadata metaData,
  }) async {
    if (item == null || !item.hasCover || user == null) {
      return null;
    }

    final safRootUri = _resolveAndroidSafRootUri(trackUri: trackUri, userId: metaData.userId);
    if (!kIsWeb && Platform.isAndroid && metaData.saf && trackUri?.scheme == 'content' && safRootUri != null) {
      final coverBytes = await _downloadCoverBytes(user: user, itemId: item.id);
      if (coverBytes == null || coverBytes.isEmpty) {
        return null;
      }

      final extension = _coverExtensionFor(item, coverBytes: coverBytes);
      final coverUri = await AndroidSafHelper.prepareDownloadFile(
        rootTreeUri: safRootUri,
        relativeDirectory: metaData.itemId,
        filename: 'cover$extension',
        mimeType: _mimeTypeForExtension(extension),
      );
      if (coverUri == null) {
        return null;
      }

      final saved = await _writeBytesToUri(coverUri, coverBytes);
      return saved ? coverUri.toString() : null;
    }

    final trackFile = _trackFileFromUri(trackUri);
    if (trackFile == null) {
      return null;
    }

    final itemDirectory = trackFile.parent;
    final existingCover = _findExistingCoverInDirectory(itemDirectory.path);
    if (existingCover != null) {
      return existingCover;
    }

    final coverBytes = await _downloadCoverBytes(user: user, itemId: item.id);
    if (coverBytes == null || coverBytes.isEmpty) {
      return null;
    }

    final extension = _coverExtensionFor(item, coverBytes: coverBytes);
    final coverFile = File(p.join(itemDirectory.path, 'cover$extension'));

    try {
      await coverFile.parent.create(recursive: true);
      await coverFile.writeAsBytes(coverBytes, flush: true);
      return coverFile.path;
    } catch (e, s) {
      logger('Failed to store cover for item ${item.id}: $e\n$s', tag: 'DownloadHandler', level: InfoLevel.warning);
      return null;
    }
  }

  String? _findExistingCoverInDirectory(String directoryPath) {
    const candidates = <String>['cover.jpg', 'cover.jpeg', 'cover.png', 'cover.webp'];
    for (final filename in candidates) {
      final candidate = File(p.join(directoryPath, filename));
      if (candidate.existsSync()) {
        return candidate.path;
      }
    }
    return null;
  }

  String _coverExtensionFor(LibraryItem item, {required Uint8List coverBytes}) {
    final fromCoverPath = p.extension(item.coverPath ?? '').toLowerCase();
    if (fromCoverPath == '.jpg' || fromCoverPath == '.jpeg' || fromCoverPath == '.png' || fromCoverPath == '.webp') {
      return fromCoverPath;
    }

    if (coverBytes.length >= 12 &&
        coverBytes[0] == 0x52 &&
        coverBytes[1] == 0x49 &&
        coverBytes[2] == 0x46 &&
        coverBytes[3] == 0x46 &&
        coverBytes[8] == 0x57 &&
        coverBytes[9] == 0x45 &&
        coverBytes[10] == 0x42 &&
        coverBytes[11] == 0x50) {
      return '.webp';
    }

    if (coverBytes.length >= 8 &&
        coverBytes[0] == 0x89 &&
        coverBytes[1] == 0x50 &&
        coverBytes[2] == 0x4E &&
        coverBytes[3] == 0x47) {
      return '.png';
    }

    return '.jpg';
  }

  Future<Uint8List?> _downloadCoverBytes({required User user, required String itemId}) async {
    final server = user.server;
    final authToken = user.preferredAuthToken;
    if (server == null || authToken == null || authToken.isEmpty) {
      return null;
    }
    final requestHeaders = buildRequestHeaders(serverHeaders: server.headers, bearerToken: authToken);

    final client = HttpClient();
    try {
      final uri = Uri.parse('${server.url}/api/items/$itemId/cover');
      final request = await client.getUrl(uri);
      for (final entry in requestHeaders.entries) {
        request.headers.set(entry.key, entry.value);
      }
      final response = await request.close();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        logger(
          'Cover download failed for item $itemId with status ${response.statusCode}',
          tag: 'DownloadHandler',
          level: InfoLevel.warning,
        );
        return null;
      }

      final bytesBuilder = BytesBuilder(copy: false);
      await for (final chunk in response) {
        bytesBuilder.add(chunk);
      }
      return bytesBuilder.toBytes();
    } catch (e, s) {
      logger('Failed to download cover for item $itemId: $e\n$s', tag: 'DownloadHandler', level: InfoLevel.warning);
      return null;
    } finally {
      client.close(force: true);
    }
  }

  Future<String?> _writeFileSidecar({
    required Uri? fileUri,
    required LibraryItem? item,
    required Episode? episode,
    required DownloadTaskMetadata metaData,
    required String? coverPath,
  }) async {
    final downloadedFileName = _resolveDownloadedFileName(fileUri: fileUri, metaData: metaData);

    final payload = DownloadSidecar(
      itemId: metaData.itemId,
      episodeId: metaData.episodeId,
      libraryId: metaData.libraryId ?? item?.libraryId,
      userId: metaData.userId,
      serverId: _computeServerId(
        serverUrl: metaData.serverUrl,
        serverHost: metaData.serverHost,
        serverPort: metaData.serverPort,
        serverSsl: metaData.serverSsl,
      ),
      serverUrl: metaData.serverUrl,
      serverHost: metaData.serverHost,
      serverPort: metaData.serverPort,
      serverSsl: metaData.serverSsl,
      title: metaData.title ?? episode?.title ?? item?.title,
      fileInode: metaData.fileInode,
      fileIndex: metaData.fileIndex,
      fileKind: metaData.fileKind,
      fileName: downloadedFileName,
      fileMimeType: metaData.fileMimeType ?? metaData.track?.mimeType,
      coverPath: coverPath,
      createdAtEpochMs: DateTime.now().millisecondsSinceEpoch,
    );

    final safRootUri = _resolveAndroidSafRootUri(trackUri: fileUri, userId: metaData.userId);
    if (!kIsWeb && Platform.isAndroid && metaData.saf && fileUri?.scheme == 'content' && safRootUri != null) {
      final sidecarFilename = '$downloadedFileName.yaabsa.json';
      final sidecarUri = await AndroidSafHelper.prepareDownloadFile(
        rootTreeUri: safRootUri,
        relativeDirectory: metaData.itemId,
        filename: sidecarFilename,
        mimeType: 'application/json',
      );
      if (sidecarUri == null) {
        return null;
      }

      final saved = await _writeBytesToUri(sidecarUri, Uint8List.fromList(utf8.encode(jsonEncode(payload.toJson()))));
      return saved ? sidecarUri.toString() : null;
    }

    final downloadedFile = _trackFileFromUri(fileUri);
    if (downloadedFile == null) {
      return null;
    }

    final sidecarFile = File('${downloadedFile.path}.yaabsa.json');

    try {
      await sidecarFile.parent.create(recursive: true);
      await sidecarFile.writeAsString(jsonEncode(payload.toJson()), flush: true);
      return sidecarFile.path;
    } catch (e, s) {
      logger(
        'Failed to write sidecar for file ${metaData.fileName ?? metaData.fileInode} of item ${metaData.itemId}: $e\n$s',
        tag: 'DownloadHandler',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  Uri? _resolveAndroidSafRootUri({required Uri? trackUri, required String userId}) {
    final fromTrack = _deriveAndroidSafRootFromTrackUri(trackUri);
    if (fromTrack != null) {
      return fromTrack;
    }
    return _resolveAndroidSafRootUriForUser(userId);
  }

  Uri? _deriveAndroidSafRootFromTrackUri(Uri? trackUri) {
    if (kIsWeb || !Platform.isAndroid || trackUri == null || trackUri.scheme != 'content') {
      return null;
    }

    final path = trackUri.path;
    final treeMarker = '/tree/';
    final documentMarker = '/document/';
    final treeIndex = path.indexOf(treeMarker);
    if (treeIndex < 0) {
      return null;
    }

    final treeIdStart = treeIndex + treeMarker.length;
    final documentIndex = path.indexOf(documentMarker, treeIdStart);
    if (documentIndex < 0 || documentIndex <= treeIdStart) {
      return null;
    }

    final encodedTreeId = path.substring(treeIdStart, documentIndex);
    if (encodedTreeId.isEmpty) {
      return null;
    }

    return trackUri.replace(path: '/tree/$encodedTreeId/document/$encodedTreeId');
  }

  Uri? _resolveAndroidSafRootUriForUser(String userId) {
    if (kIsWeb || !Platform.isAndroid) {
      return null;
    }

    final rawLocation = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(userId, SettingKeys.downloadPath, defaultValue: '');
    final parsed = parseDownloadLocationSetting(rawLocation);
    if (parsed == null || parsed.scheme != 'content') {
      return null;
    }
    return parsed;
  }

  String _resolveDownloadedFileName({required Uri? fileUri, required DownloadTaskMetadata metaData}) {
    if (fileUri?.scheme == 'file') {
      final fromUri = p.basename(fileUri?.path ?? '');
      if (fromUri.isNotEmpty && fromUri != '.') {
        return fromUri;
      }
    }

    final fromMetaData = (metaData.fileName ?? '').trim();
    if (fromMetaData.isNotEmpty) {
      return fromMetaData;
    }

    final fromInode = metaData.fileInode.trim();
    if (fromInode.isNotEmpty) {
      return fromInode;
    }

    return 'download_${metaData.fileIndex + 1}';
  }

  Future<bool> _writeBytesToUri(Uri destinationUri, Uint8List bytes) async {
    if (kIsWeb || _downloader == null) {
      return false;
    }
    final tempFile = File(
      p.join(
        Directory.systemTemp.path,
        'yaabsa_saf_${DateTime.now().microsecondsSinceEpoch}_${destinationUri.hashCode}.tmp',
      ),
    );

    try {
      await tempFile.parent.create(recursive: true);
      await tempFile.writeAsBytes(bytes, flush: true);
      final copiedUri = await _downloader.uri.copyFile(tempFile.uri, destinationUri);
      return copiedUri != null;
    } catch (e, s) {
      logger('Failed to write bytes to URI $destinationUri: $e\n$s', tag: 'DownloadHandler', level: InfoLevel.warning);
      return false;
    } finally {
      try {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (_) {}
    }
  }

  Uri? _trackUriFromStoredUrl(String? rawUrl) {
    if (rawUrl == null) {
      return null;
    }

    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    if (!kIsWeb && Platform.isWindows && RegExp(r'^[a-zA-Z]:[\\/]').hasMatch(trimmed)) {
      return Uri.file(trimmed, windows: true);
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed == null) {
      return null;
    }

    if (parsed.scheme.isEmpty) {
      return Uri.file(trimmed, windows: !kIsWeb && Platform.isWindows);
    }

    return parsed;
  }

  DownloadTaskMetadata? _parseMetaData(String rawMetaData) {
    try {
      final decoded = jsonDecode(rawMetaData);
      if (decoded is Map) {
        return DownloadTaskMetadata.fromJson(Map<String, dynamic>.from(decoded));
      }

      if (decoded is! List<dynamic> || decoded.length < 4) {
        throw const FormatException('Invalid metadata payload for completed task');
      }

      final itemId = decoded[0] as String?;
      final userId = decoded[1] as String?;
      final episodeId = decoded[2] as String?;
      final trackJson = decoded[3];
      final saf = decoded.length > 4 && decoded[4] == true;

      if (itemId == null || userId == null) {
        throw const FormatException('Metadata payload contains invalid fields');
      }

      final track = trackJson is Map ? InternalTrack.fromJson(Map<String, dynamic>.from(trackJson)) : null;

      return DownloadTaskMetadata(
        itemId: itemId,
        userId: userId,
        episodeId: episodeId,
        track: track,
        expectedFileCount: 1,
        fileInode: '',
        fileIndex: track?.index ?? 0,
        fileKind: track == null ? 'file' : 'audio',
        fileName: null,
        fileMimeType: track?.mimeType,
        saf: saf,
        libraryId: decoded.length > 5 ? decoded[5] as String? : null,
        serverUrl: decoded.length > 6 ? decoded[6] as String? : null,
        serverHost: decoded.length > 7 ? decoded[7] as String? : null,
        serverPort: decoded.length > 8 && decoded[8] is num ? (decoded[8] as num).toInt() : null,
        serverSsl: decoded.length > 9 && decoded[9] is bool ? decoded[9] as bool : null,
        title: decoded.length > 10 ? decoded[10] as String? : null,
      );
    } catch (e, s) {
      logger('Could not parse completed task metadata: $e\n$s', tag: 'DownloadHandler', level: InfoLevel.warning);
      return null;
    }
  }

  Future<String?> _resolveStoredTrackUrl(Task task) async {
    if (task is UriTask) {
      final uriTask = task as UriTask;
      if (uriTask.fileUri != null) {
        return uriTask.fileUri.toString();
      }
    }

    try {
      return await task.filePath();
    } catch (e, s) {
      logger(
        'Could not resolve file path for task ${task.taskId}: $e\n$s',
        tag: 'DownloadHandler',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  String _taskIdFor(String fileInode, String itemId, String? episodeId) {
    final raw = '${itemId}_${episodeId ?? 'item'}_$fileInode';
    return raw.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
  }

  String _sanitizeFilename(String originalFilename, {required int fileIndex, String? fallbackExtension}) {
    final cleaned = originalFilename.split(RegExp(r'[\\/]')).last.trim();
    if (cleaned.isNotEmpty) {
      return cleaned;
    }

    final normalizedExtension = _normalizeExtension(fallbackExtension);
    final extensionSuffix = normalizedExtension.isEmpty ? '.bin' : '.$normalizedExtension';
    return 'file_${fileIndex + 1}$extensionSuffix';
  }

  List<_DownloadSourceFile> _collectDownloadSourceFiles(
    LibraryItem item, {
    String? episodeId,
    String downloadType = 'both',
  }) {
    final files = <_DownloadSourceFile>[];
    final seenInodes = <String>{};
    var fallbackIndex = 0;

    if (item.mediaType == 'podcast') {
      if (downloadType == 'ebook') {
        return files;
      }
      Episode? episode;
      for (final candidate in item.media?.podcastMedia?.episodes ?? const <Episode>[]) {
        if (candidate.id == episodeId) {
          episode = candidate;
          break;
        }
      }
      final audioFile = episode?.audioFile;
      if (audioFile == null) {
        return files;
      }

      if (!_isIgnoredDownloadFile(filename: audioFile.metadata.filename, extension: audioFile.metadata.ext)) {
        final index = audioFile.index ?? fallbackIndex;
        _addDownloadSourceFile(
          files,
          seenInodes,
          _DownloadSourceFile(
            ino: audioFile.ino,
            filename: audioFile.metadata.filename,
            extension: audioFile.metadata.ext,
            fileKind: 'audio',
            fileIndex: index,
            mimeType: audioFile.mimeType ?? _mimeTypeForExtension(audioFile.metadata.ext),
            track: InternalTrack(
              index: index,
              duration: audioFile.duration ?? 0,
              url: null,
              mimeType: audioFile.mimeType ?? _mimeTypeForExtension(audioFile.metadata.ext),
            ),
          ),
        );
        fallbackIndex = index + 1;
      }

      return files;
    }

    final hasAudio = downloadType == 'audiobook' || downloadType == 'both';
    final hasEbook = downloadType == 'ebook' || downloadType == 'both';

    if (hasAudio) {
      final audioFiles = item.media?.bookMedia?.audioFiles ?? const <AudioFile>[];
      for (final audioFile in audioFiles) {
        if (_isIgnoredDownloadFile(filename: audioFile.metadata.filename, extension: audioFile.metadata.ext)) {
          continue;
        }

        final index = audioFile.index ?? fallbackIndex;
        _addDownloadSourceFile(
          files,
          seenInodes,
          _DownloadSourceFile(
            ino: audioFile.ino,
            filename: audioFile.metadata.filename,
            extension: audioFile.metadata.ext,
            fileKind: 'audio',
            fileIndex: index,
            mimeType: audioFile.mimeType ?? _mimeTypeForExtension(audioFile.metadata.ext),
            track: InternalTrack(
              index: index,
              duration: audioFile.duration ?? 0,
              url: null,
              mimeType: audioFile.mimeType ?? _mimeTypeForExtension(audioFile.metadata.ext),
            ),
          ),
        );
        fallbackIndex = index + 1;
      }
    }

    if (hasEbook) {
      final ebookFile = item.media?.bookMedia?.ebookFile;
      if (ebookFile != null &&
          !_isIgnoredDownloadFile(filename: ebookFile.metadata.filename, extension: ebookFile.metadata.ext)) {
        _addDownloadSourceFile(
          files,
          seenInodes,
          _DownloadSourceFile(
            ino: ebookFile.ino,
            filename: ebookFile.metadata.filename,
            extension: ebookFile.metadata.ext,
            fileKind: 'ebook',
            fileIndex: fallbackIndex,
            mimeType: _mimeTypeForExtension(ebookFile.metadata.ext),
          ),
        );
        fallbackIndex += 1;
      }
    }

    final libraryFiles = item.libraryFiles ?? const <LibraryFile>[];
    for (final libraryFile in libraryFiles) {
      if (_isIgnoredDownloadFile(filename: libraryFile.metadata.filename, extension: libraryFile.metadata.ext)) {
        continue;
      }

      final isEbook = FileFormats.isEbook(libraryFile.metadata.ext);

      if (isEbook && !hasEbook) {
        continue;
      }
      if (!isEbook && !hasAudio) {
        continue;
      }

      _addDownloadSourceFile(
        files,
        seenInodes,
        _DownloadSourceFile(
          ino: libraryFile.ino,
          filename: libraryFile.metadata.filename,
          extension: libraryFile.metadata.ext,
          fileKind: isEbook ? 'ebook' : 'file',
          fileIndex: fallbackIndex,
          mimeType: _mimeTypeForExtension(libraryFile.metadata.ext),
        ),
      );
      fallbackIndex += 1;
    }

    return files;
  }

  void _addDownloadSourceFile(List<_DownloadSourceFile> files, Set<String> seenInodes, _DownloadSourceFile candidate) {
    final normalizedInode = candidate.ino.trim();
    if (normalizedInode.isEmpty || seenInodes.contains(normalizedInode)) {
      return;
    }
    seenInodes.add(normalizedInode);
    files.add(candidate);
  }

  bool _isIgnoredDownloadFile({required String filename, String? extension}) {
    final normalizedExtension = _normalizeExtension(extension);
    if (normalizedExtension == 'json') {
      return true;
    }
    return filename.toLowerCase().trim().endsWith('.json');
  }

  String _normalizeExtension(String? rawExtension) {
    if (rawExtension == null) {
      return '';
    }
    final trimmed = rawExtension.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return '';
    }
    return trimmed.startsWith('.') ? trimmed.substring(1) : trimmed;
  }

  String _mimeTypeForExtension(String? extension) {
    switch (_normalizeExtension(extension)) {
      case 'epub':
        return 'application/epub+zip';
      case 'pdf':
        return 'application/pdf';
      case 'm4b':
        return 'audio/mp4';
      case 'm4a':
        return 'audio/mp4';
      case 'aac':
        return 'audio/aac';
      case 'ogg':
      case 'oga':
        return 'audio/ogg';
      case 'opus':
        return 'audio/opus';
      case 'wav':
        return 'audio/wav';
      case 'flac':
        return 'audio/flac';
      case 'mp3':
        return 'audio/mpeg';
      default:
        return 'application/octet-stream';
    }
  }

  String? _computeServerId({String? serverUrl, String? serverHost, int? serverPort, bool? serverSsl}) {
    final normalizedUrl = (serverUrl ?? '').trim().toLowerCase();
    final normalizedHost = (serverHost ?? '').trim().toLowerCase();
    final normalizedPort = serverPort?.toString() ?? '';
    final normalizedSsl = serverSsl == null ? '' : (serverSsl ? '1' : '0');

    final source = '$normalizedHost|$normalizedUrl|$normalizedPort|$normalizedSsl';
    if (source == '|||') {
      return null;
    }
    return sha256.convert(utf8.encode(source)).toString();
  }
}

class _DownloadSourceFile {
  const _DownloadSourceFile({
    required this.ino,
    required this.filename,
    required this.fileKind,
    required this.fileIndex,
    this.track,
    this.mimeType,
    this.extension,
  });

  final String ino;
  final String filename;
  final String fileKind;
  final int fileIndex;
  final InternalTrack? track;
  final String? mimeType;
  final String? extension;
}

class DeleteStoredDownloadResult {
  const DeleteStoredDownloadResult({
    required this.itemId,
    required this.episodeId,
    required this.attemptedFiles,
    required this.deletedFiles,
    required this.failedFiles,
  });

  final String itemId;
  final String? episodeId;
  final int attemptedFiles;
  final int deletedFiles;
  final int failedFiles;
}
