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
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/util/android_saf.dart';
import 'package:yaabsa/util/download_destination.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/request_headers.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/file_formats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _DownloadBatchProgress {
  _DownloadBatchProgress(this.expectedFileCount);

  int expectedFileCount;
  final Set<String> completedTaskIds = <String>{};
}

class DownloadHandler {
  final ProviderContainer _ref;
  late final FileDownloader? _downloader;
  late final Future<void> _initialization;
  Future<void>? _settingsUpdate;
  Timer? _taskQueueRefreshTimer;
  Future<void>? _taskQueueRefresh;
  bool _taskQueueRefreshRequested = false;
  List<TaskRecord> _taskQueueSnapshot = const <TaskRecord>[];
  final Map<String, _DownloadBatchProgress> _downloadBatchProgress = <String, _DownloadBatchProgress>{};
  final Map<String, Future<String?>> _coverStorageInFlight = <String, Future<String?>>{};
  final _progressUpdateController = StreamController<TaskProgressUpdate>.broadcast();
  final _taskQueueController = StreamController<List<TaskRecord>>.broadcast();

  Stream<TaskRecord> get dbUpdates => _downloader?.database.updates ?? const Stream.empty();

  Stream<TaskProgressUpdate> get progressUpdateStream => _progressUpdateController.stream;

  Stream<List<TaskRecord>> get taskQueueStream => _taskQueueController.stream;

  Stream<List<TaskRecord>> taskQueueStreamForItem(String itemId, {String? episodeId}) async* {
    yield _tasksForItem(_taskQueueSnapshot, itemId, episodeId: episodeId);
    yield* taskQueueStream
        .map((tasks) => _tasksForItem(tasks, itemId, episodeId: episodeId))
        .distinct(_sameTaskRecords);
  }

  Stream<List<TaskRecord>> taskQueueStreamForItemAndEpisodes(String itemId) async* {
    yield _tasksForItemAndEpisodes(_taskQueueSnapshot, itemId);
    yield* taskQueueStream.map((tasks) => _tasksForItemAndEpisodes(tasks, itemId)).distinct(_sameTaskRecords);
  }

  DownloadHandler(this._ref) {
    if (kIsWeb) {
      _downloader = null;
      return;
    }
    _downloader = FileDownloader();

    _initialization = _init();

    _ref.listen<AsyncValue<User?>>(currentUserProvider, (previous, next) {
      if (previous?.value?.id == next.value?.id) {
        return;
      }
      _downloadBatchProgress.clear();
      unawaited(_applyDownloadSettingsForUser(next.value?.id));
    }, fireImmediately: true);

    _scheduleTaskQueueRefresh();

    dbUpdates.listen(
      (update) async {
        _scheduleTaskQueueRefresh();
        if (update.status != TaskStatus.complete) {
          if (update.status == TaskStatus.failed || update.status == TaskStatus.canceled) {
            _ref.read(smartDownloadManagerProvider.notifier).requestReconcile(reason: 'download task failed');
          }
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
        _scheduleTaskQueueRefresh();
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
    await _ref.read(settingsManagerProvider.notifier).ensureInitialized();

    User? user;
    try {
      user = await _ref.read(currentUserProvider.future).timeout(const Duration(seconds: 5));
    } catch (e) {
      logger('Could not resolve the active user before configuring downloads: $e', tag: 'DownloadHandler');
    }

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

    await _configureDownloadSettings(user?.id);

    await _downloader.trackTasks();

    await _downloader.start();

    _scheduleTaskQueueRefresh();
  }

  Future<void> _configureDownloadSettings(String? userId) async {
    if (kIsWeb || _downloader == null) {
      return;
    }

    final settings = _ref.read(settingsManagerProvider.notifier);
    final maxParallel = settings
        .getUserSetting<int>(userId, SettingKeys.downloadMaxParallel, defaultValue: 3)
        .clamp(1, 10)
        .toInt();
    final onlyOnWifi = settings.getUserSetting<bool>(userId, SettingKeys.downloadOnlyOnWifi, defaultValue: true);

    await _downloader.configure(
      globalConfig: (Config.holdingQueue, (maxParallel, null, null)),
      androidConfig: !kIsWeb && Platform.isAndroid ? [(Config.runInForeground, Config.always)] : null,
    );
    await _downloader.requireWiFi(
      onlyOnWifi ? RequireWiFi.forAllTasks : RequireWiFi.forNoTasks,
      rescheduleRunningTasks: true,
    );
  }

  Future<void> _applyDownloadSettingsForUser(String? userId) {
    final previous = _settingsUpdate ?? Future<void>.value();
    final next = previous.then((_) async {
      await _initialization;
      try {
        await _configureDownloadSettings(userId);
      } catch (e, s) {
        logger('Could not apply download settings: $e\n$s', tag: 'DownloadHandler', level: InfoLevel.warning);
      }
    });
    _settingsUpdate = next;
    return next;
  }

  /// Re-applies settings after a user changes a download preference.
  Future<void> applyDownloadSettings() {
    return _applyDownloadSettingsForUser(_ref.read(currentUserProvider).value?.id);
  }

  void _scheduleTaskQueueRefresh() {
    if (kIsWeb || _downloader == null) {
      return;
    }

    _taskQueueRefreshRequested = true;
    if (_taskQueueRefreshTimer != null) {
      return;
    }

    _taskQueueRefreshTimer = Timer(const Duration(milliseconds: 100), () {
      _taskQueueRefreshTimer = null;
      unawaited(_refreshTaskQueue());
    });
  }

  Future<void> _refreshTaskQueue() {
    final activeRefresh = _taskQueueRefresh;
    if (activeRefresh != null) {
      return activeRefresh;
    }

    final refresh = _refreshTaskQueueInternal();
    _taskQueueRefresh = refresh;
    return refresh.whenComplete(() {
      if (!identical(_taskQueueRefresh, refresh)) {
        return;
      }

      _taskQueueRefresh = null;
      if (_taskQueueRefreshRequested) {
        _scheduleTaskQueueRefresh();
      }
    });
  }

  Future<void> _refreshTaskQueueInternal() async {
    _taskQueueRefreshRequested = false;
    final tasks = (await _downloader!.database.allRecords())
        .where((task) => task.status.isNotFinalState)
        .toList(growable: false);
    _taskQueueSnapshot = tasks;
    _taskQueueController.add(tasks);
  }

  List<TaskRecord> _tasksForItem(List<TaskRecord> tasks, String itemId, {String? episodeId}) {
    return tasks.where((task) => taskBelongsToItem(task, itemId, episodeId: episodeId)).toList(growable: false);
  }

  List<TaskRecord> _tasksForItemAndEpisodes(List<TaskRecord> tasks, String itemId) {
    return tasks.where((task) => task.status.isNotFinalState && task.group == itemId).toList(growable: false);
  }

  bool _sameTaskRecords(List<TaskRecord> left, List<TaskRecord> right) {
    if (left.length != right.length) {
      return false;
    }

    for (var index = 0; index < left.length; index++) {
      final leftTask = left[index];
      final rightTask = right[index];
      if (leftTask.taskId != rightTask.taskId ||
          leftTask.status != rightTask.status ||
          leftTask.progress != rightTask.progress) {
        return false;
      }
    }

    return true;
  }

  Future<bool> cancelTask(String taskId) async {
    if (kIsWeb || _downloader == null) {
      return false;
    }
    final canceled = await _downloader.cancelTaskWithId(taskId);
    await _refreshTaskQueue();
    return canceled;
  }

  Future<int> cancelSmartTasksForProfile(String profileId, {String? userId}) async {
    if (kIsWeb || _downloader == null) {
      return 0;
    }
    final records = await _downloader.database.allRecords();
    var canceled = 0;
    for (final record in records.where((record) => record.status.isNotFinalState)) {
      final metadata = _parseMetaData(record.task.metaData);
      if (metadata?.acquisitionOrigin != 'smart' ||
          (userId != null && metadata?.userId != userId) ||
          metadata?.smartProfileIds.length != 1 ||
          metadata?.smartProfileIds.first != profileId) {
        continue;
      }
      if (await cancelTask(record.task.taskId)) {
        canceled++;
      }
    }
    return canceled;
  }

  Future<int> cancelSmartTasksForReferences({
    required String userId,
    required Set<String> references,
    String? profileId,
  }) async {
    if (kIsWeb || _downloader == null || references.isEmpty) {
      return 0;
    }
    final records = await _downloader.database.allRecords();
    var canceled = 0;
    for (final record in records.where((record) => record.status.isNotFinalState)) {
      final metadata = _parseMetaData(record.task.metaData);
      if (metadata == null ||
          metadata.userId != userId ||
          metadata.acquisitionOrigin != 'smart' ||
          (profileId != null &&
              (metadata.smartProfileIds.length != 1 || metadata.smartProfileIds.first != profileId))) {
        continue;
      }
      final reference = '${metadata.itemId}::${metadata.episodeId ?? ''}';
      if (!references.contains(reference)) {
        continue;
      }
      if (await cancelTask(record.task.taskId)) {
        canceled++;
      }
    }
    return canceled;
  }

  Future<Map<String, int>> activeSmartDownloadReservations(String userId) async {
    if (kIsWeb || _downloader == null) {
      return const <String, int>{};
    }
    final reservations = <String, int>{};
    final records = await _downloader.database.allRecords();
    for (final record in records.where((record) => record.status.isNotFinalState)) {
      final metadata = _parseMetaData(record.task.metaData);
      if (metadata == null || metadata.userId != userId || metadata.acquisitionOrigin != 'smart') {
        continue;
      }
      final reference = '${metadata.itemId}::${metadata.episodeId ?? ''}';
      final estimatedBytes = metadata.estimatedBytes ?? 0;
      final current = reservations[reference] ?? 0;
      if (estimatedBytes > current) {
        reservations[reference] = estimatedBytes;
      } else {
        reservations.putIfAbsent(reference, () => current);
      }
    }
    return reservations;
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

  Future<bool> hasActiveTask(String itemId, {String? episodeId}) async {
    if (kIsWeb || _downloader == null) {
      return false;
    }
    final records = await _downloader.database.allRecords();
    return records.any((task) {
      if (!task.status.isNotFinalState) {
        return false;
      }
      final metadata = _parseMetaData(task.task.metaData);
      if (metadata != null && metadata.itemId == itemId && metadata.episodeId == episodeId) {
        return true;
      }
      return taskBelongsToItem(task, itemId, episodeId: episodeId);
    });
  }

  String _downloadBatchKey(String itemId, String? episodeId) {
    return '$itemId::${episodeId ?? ''}';
  }

  bool _isFinalFileInDownloadBatch(DownloadTaskMetadata metadata, String taskId) {
    final expectedFileCount = metadata.expectedFileCount;
    if (expectedFileCount <= 1) {
      return true;
    }

    final key = _downloadBatchKey(metadata.itemId, metadata.episodeId);
    final progress = _downloadBatchProgress.putIfAbsent(key, () => _DownloadBatchProgress(expectedFileCount));
    if (expectedFileCount > progress.expectedFileCount) {
      progress.expectedFileCount = expectedFileCount;
    }
    progress.completedTaskIds.add(taskId);

    if (progress.completedTaskIds.length < progress.expectedFileCount) {
      return false;
    }

    _downloadBatchProgress.remove(key);
    return true;
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

  Future<void> downloadFile(
    String itemId, {
    String? episodeId,
    String? downloadType,
    String acquisitionOrigin = 'manual',
    List<String> smartProfileIds = const <String>[],
    int? estimatedBytes,
    String? requiredUserId,
  }) async {
    if (kIsWeb || _downloader == null) {
      throw UnsupportedError('Downloads are not supported on the Web');
    }
    await _initialization;
    final User? user = _ref.read(currentUserProvider).value;
    if (user == null) {
      throw Exception('No active user found for download request.');
    }
    if (requiredUserId != null && user.id != requiredUserId) {
      throw StateError('The active user changed before the download could be queued.');
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

    if (_ref.read(currentUserProvider).value?.id != user.id) {
      throw StateError('The active user changed while preparing the download.');
    }

    final effectiveDownloadType = downloadType ?? _defaultDownloadType(resolvedItem, user.id);
    final onlyOnWifi = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(user.id, SettingKeys.downloadOnlyOnWifi, defaultValue: true);

    await _ensureNotificationPermissionForDownloads();

    final sourceFiles = _collectDownloadSourceFiles(
      resolvedItem,
      episodeId: episodeId,
      downloadType: effectiveDownloadType,
    );
    if (sourceFiles.isEmpty) {
      throw Exception('No downloadable files found for item $itemId.');
    }
    final orderedSourceFiles = sourceFiles.toList()..sort((left, right) => (right.size ?? 0).compareTo(left.size ?? 0));
    final expectedFileCount = sourceFiles.length;
    final actualSourceBytes = sourceFiles.fold<int>(0, (total, source) => total + (source.size ?? 0));
    final effectiveEstimatedBytes = actualSourceBytes > (estimatedBytes ?? 0) ? actualSourceBytes : estimatedBytes;

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
    for (final source in orderedSourceFiles) {
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
          downloadType: effectiveDownloadType,
          acquisitionOrigin: acquisitionOrigin,
          smartProfileIds: smartProfileIds,
          estimatedBytes: effectiveEstimatedBytes,
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
            requiresWifi: onlyOnWifi,
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
          requiresWiFi: onlyOnWifi,
        ),
      );
    }

    final notificationGroupId = _notificationGroupId(itemId, episodeId);
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
          '{displayName}\n'
              'All files downloaded successfully.',
        ),
        canceled: TaskNotification(
          'Download Canceled',
          '{displayName}\n'
              'The download was canceled by the user.',
        ),
        error: TaskNotification(
          'Download Failed',
          '{displayName}\n'
              'An error occurred during download.',
        ),
        paused: TaskNotification(
          'Download Paused',
          '{displayName}\n'
              'Progress: {progress} | Speed: {networkSpeed}\n'
              'Paused at: {progress}',
        ),
        progressBar: true,
        tapOpensFile: false,
        groupNotificationId: notificationGroupId,
      );
    }

    if (_ref.read(currentUserProvider).value?.id != user.id) {
      throw StateError('The active user changed before the download could be queued.');
    }

    await _ref.read(appDatabaseProvider).deleteStoredDownload(itemId, user.id, episodeId: episodeId);

    final batchKey = _downloadBatchKey(itemId, episodeId);
    _downloadBatchProgress[batchKey] = _DownloadBatchProgress(expectedFileCount);
    final enqueueResults = await _downloader.enqueueAll(downloadTasks);
    final queuedTasks = enqueueResults.where((result) => result).length;
    if (queuedTasks == 0) {
      _downloadBatchProgress.remove(batchKey);
      throw Exception('Could not queue download. Please check your connection and try again.');
    }
    if (queuedTasks != downloadTasks.length) {
      for (var index = 0; index < enqueueResults.length; index++) {
        if (enqueueResults[index]) {
          await _downloader.cancelTaskWithId(downloadTasks[index].taskId);
        }
      }
      _downloadBatchProgress.remove(batchKey);
      logger(
        'Only $queuedTasks/${downloadTasks.length} download task(s) were queued for item $itemId. '
        'The partial batch was canceled.',
        tag: 'DownloadHandler',
        level: InfoLevel.warning,
      );
      _scheduleTaskQueueRefresh();
      throw Exception('Could not queue every file in the download. Please try again.');
    }

    _scheduleTaskQueueRefresh();
  }

  Future<int?> estimateDownloadBytes(String itemId, {String? episodeId, String downloadType = 'both'}) async {
    LibraryItem? item = _ref.read(libraryItemProvider(itemId)).asData?.value;
    if (item == null) {
      try {
        item = await _ref.read(libraryItemProvider(itemId).future);
      } catch (_) {
        return null;
      }
    }
    if (item == null) {
      return null;
    }
    final sources = _collectDownloadSourceFiles(item, episodeId: episodeId, downloadType: downloadType);
    final total = sources.fold<int>(0, (sum, source) => sum + (source.size ?? 0));
    return total > 0 ? total : null;
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
    required bool requiresWifi,
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
      requiresWiFi: requiresWifi,
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

      final coverPath = await _storeCoverLocallyOnce(
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

      final completedDownload = InternalDownload(
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
      );

      logger(
        'Download complete for item ${parsedMetaData.itemId}, episode ${parsedMetaData.episodeId}, file ${parsedMetaData.fileName ?? parsedMetaData.fileInode}',
        tag: 'DownloadHandler',
      );

      await _ref
          .read(appDatabaseProvider)
          .addOrUpdateStoredDownloadFile(
            itemId: parsedMetaData.itemId,
            userId: parsedMetaData.userId,
            episodeId: parsedMetaData.episodeId,
            fileKey: update.task.taskId,
            download: completedDownload,
            downloadOrigin: parsedMetaData.acquisitionOrigin,
            smartProfileIds: parsedMetaData.smartProfileIds,
            managedBytes: parsedMetaData.estimatedBytes,
            completedAt: DateTime.now().millisecondsSinceEpoch,
          );
      if (_isFinalFileInDownloadBatch(parsedMetaData, update.task.taskId)) {
        _ref.read(smartDownloadManagerProvider.notifier).requestReconcile(reason: 'download completed');
      }
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
    _downloadBatchProgress.remove(_downloadBatchKey(itemId, episodeId));

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

  Future<String?> _storeCoverLocallyOnce({
    required LibraryItem? item,
    required User? user,
    required Uri? trackUri,
    required DownloadTaskMetadata metaData,
  }) {
    final key = '${metaData.userId}\u0000${metaData.itemId}\u0000${metaData.downloadBasePath ?? ''}';
    final existing = _coverStorageInFlight[key];
    if (existing != null) {
      return existing;
    }

    final future = _storeCoverLocally(item: item, user: user, trackUri: trackUri, metaData: metaData);
    _coverStorageInFlight[key] = future;
    unawaited(
      future.then<void>(
        (_) {
          if (identical(_coverStorageInFlight[key], future)) {
            _coverStorageInFlight.remove(key);
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (identical(_coverStorageInFlight[key], future)) {
            _coverStorageInFlight.remove(key);
          }
        },
      ),
    );
    return future;
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

  String _notificationGroupId(String itemId, String? episodeId) {
    final seed = '$itemId::${episodeId ?? ''}::${DateTime.now().microsecondsSinceEpoch}';
    final digest = sha256.convert(utf8.encode(seed));
    return 'yaabsa-${digest.toString()}';
  }

  String _defaultDownloadType(LibraryItem item, String userId) {
    if (item.mediaType == 'podcast') {
      return 'audiobook';
    }

    final preference = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(userId, SettingKeys.downloadTypePreference, defaultValue: 'askEveryTime');

    switch (preference) {
      case 'audiobook':
      case 'ebook':
      case 'both':
        return preference;
      case 'askEveryTime':
      default:
        return 'both';
    }
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
            size: audioFile.metadata.size,
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
            size: audioFile.metadata.size,
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
            size: ebookFile.metadata.size,
          ),
        );
        fallbackIndex += 1;
      }
    }

    final ebookFileInode = item.media?.bookMedia?.ebookFile?.ino;
    final libraryFiles = item.libraryFiles ?? const <LibraryFile>[];
    for (final libraryFile in libraryFiles) {
      if (_isIgnoredDownloadFile(filename: libraryFile.metadata.filename, extension: libraryFile.metadata.ext)) {
        continue;
      }

      final isEbook = _isEbookLibraryFile(libraryFile, ebookFileInode: ebookFileInode);

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
          size: libraryFile.metadata.size,
        ),
      );
      fallbackIndex += 1;
    }

    return files;
  }

  bool _isEbookLibraryFile(LibraryFile file, {String? ebookFileInode}) {
    if (file.ino == ebookFileInode) {
      return true;
    }

    final fileType = file.fileType?.trim().toLowerCase();
    if (fileType == 'ebook' || fileType == 'e-book') {
      return true;
    }

    return FileFormats.isEbook(file.metadata.ext) ||
        FileFormats.isEbook(file.metadata.filename) ||
        FileFormats.isEbook(file.metadata.path) ||
        FileFormats.isEbook(file.metadata.relPath);
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
    this.size,
  });

  final String ino;
  final String filename;
  final String fileKind;
  final int fileIndex;
  final InternalTrack? track;
  final String? mimeType;
  final String? extension;
  final int? size;
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
