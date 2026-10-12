part of '../bg_audio_handler.dart';

const _aaosBrowseDownloadAction = 'aa.browse.download';
const _aaosBrowseDeleteAction = 'aa.browse.delete_download';
const _aaosBrowseDownloadingAction = 'aa.browse.downloading';
const _aaosBrowseActionLimitKey = 'aaos.browseActionLimit';
const _aaosBrowseActionIdsKey = 'androidx.media.utils.extras.CUSTOM_BROWSER_ACTION_ID_LIST';

void _aaosScheduleDownloadActionRefresh(BGAudioHandler handler) {
  if (handler._isDisposing) {
    return;
  }

  handler._aaosBrowseActionRefreshTimer?.cancel();
  handler._aaosBrowseActionRefreshTimer = Timer(const Duration(milliseconds: 500), () {
    unawaited(_androidAutoRefreshBrowseRoots(handler));
  });
}

void _aaosUpdateStoredDownloads(BGAudioHandler handler, List<InternalDownload> downloads) {
  Map<(String, String?), (bool, bool)> states(Map<(String, String?), InternalDownload> values) {
    return values.map((key, value) => MapEntry(key, (value.isComplete, value.numberOfDownloadedFiles > 0)));
  }

  final previous = states(handler._aaosBrowseDownloads);
  final next = <(String, String?), InternalDownload>{
    for (final download in downloads)
      if (download.item?.id != null) (download.item!.id, download.episode?.id): download,
  };
  final nextStates = states(next);
  final changed =
      previous.length != nextStates.length || previous.entries.any((entry) => nextStates[entry.key] != entry.value);

  handler._aaosBrowseDownloads
    ..clear()
    ..addAll(next);
  handler._aaosBrowseDownloadsReady = true;

  if (changed) {
    _aaosScheduleDownloadActionRefresh(handler);
  }
}

void _aaosUpdateActiveDownloads(BGAudioHandler handler, List<TaskRecord> tasks) {
  final active = <(String, String?)>{};
  final userId = handler._aaosDownloadsUserId;

  for (final task in tasks) {
    if (task.status != TaskStatus.enqueued &&
        task.status != TaskStatus.running &&
        task.status != TaskStatus.waitingToRetry &&
        task.status != TaskStatus.paused) {
      continue;
    }

    try {
      final metadata = jsonDecode(task.task.metaData) as Map<String, dynamic>;
      final itemId = metadata['itemId'] as String?;

      if (itemId != null && metadata['userId'] == userId) {
        active.add((itemId, metadata['episodeId'] as String?));
      }
    } catch (error) {
      logger('Unable to read browse download status: $error', tag: 'AAOSBrowse', level: InfoLevel.debug);
    }
  }

  if (active.length == handler._aaosBrowseActiveDownloads.length &&
      active.containsAll(handler._aaosBrowseActiveDownloads)) {
    return;
  }

  handler._aaosBrowseActiveDownloads
    ..clear()
    ..addAll(active);
  _aaosScheduleDownloadActionRefresh(handler);
}

Future<List<MediaItem>> _aaosAttachBrowseActions(BGAudioHandler handler, List<MediaItem> items, {int limit = 3}) async {
  if (limit <= 0 ||
      handler._isDisposing ||
      !items.any((item) => item.playable == true) ||
      !await _androidAutoIsAutomotiveSystem()) {
    return items;
  }

  final user = await handler._androidAutoCurrentUser();

  if (user == null || handler._aaosDownloadsUserId != user.id) {
    return items;
  }

  handler._aaosBrowseTasksSubscription ??= downloadHandler.taskQueueStream.listen((tasks) {
    _aaosUpdateActiveDownloads(handler, tasks);
  });
  _aaosUpdateActiveDownloads(handler, downloadHandler.taskQueueSnapshot);

  if (!handler._aaosBrowseDownloadsReady) {
    final downloads = await handler._ref.read(appDatabaseProvider).getAllStoredDownloadsByUser(user.id);

    if (handler._isDisposing || handler._aaosDownloadsUserId != user.id) {
      return items;
    }

    if (!handler._aaosBrowseDownloadsReady) {
      _aaosUpdateStoredDownloads(handler, downloads);
    }
  }

  return items
      .map((item) {
        final itemId = item.extras?['itemId'] as String?;

        if (item.playable != true || itemId == null) {
          return item;
        }

        final key = (itemId, item.extras?['episodeId'] as String?);
        final download = handler._aaosBrowseDownloads[key];
        final isDownloading = handler._aaosBrowseActiveDownloads.contains(key);
        final isPreparing = handler._aaosBrowsePreparingDownloads.contains((user.id, key.$1, key.$2));
        final canDelete = download != null || isDownloading;
        final actions = <String>[
          if (isDownloading && canDelete) _aaosBrowseDeleteAction,
          if (isDownloading || isPreparing)
            _aaosBrowseDownloadingAction
          else if (download?.isComplete != true)
            _aaosBrowseDownloadAction,
          if (!isDownloading && canDelete) _aaosBrowseDeleteAction,
        ];

        return item.copyWith(
          extras: <String, dynamic>{...?item.extras, _aaosBrowseActionIdsKey: actions.take(limit).toList()},
        );
      })
      .toList(growable: false);
}

Future<Map<String, dynamic>> _aaosHandleBrowseDownloadAction(
  BGAudioHandler handler,
  String action,
  Map<String, dynamic>? extras,
) async {
  final mediaId = extras?['mediaId'] as String?;

  Map<String, dynamic> result(String message, {bool error = false}) {
    return <String, dynamic>{'handled': true, 'error': error, 'message': message, 'refreshMediaId': mediaId};
  }

  if (handler._isDisposing || extras?['browseAction'] != true || !await _androidAutoIsAutomotiveSystem()) {
    return result('This action is unavailable.', error: true);
  }

  final user = await handler._androidAutoCurrentUser();
  final target = mediaId == null ? null : handler._androidAutoPlaybackTargetFromMediaId(mediaId);

  if (user == null || target == null || handler._ref.read(absApiProvider)?.user?.id != user.id) {
    return result('Sign in before managing downloads.', error: true);
  }

  if (action == _aaosBrowseDownloadingAction) {
    return result('The download is queued or running.');
  }

  final key = (user.id, target.itemId, target.episodeId);

  if (!handler._aaosBrowsePreparingDownloads.add(key)) {
    return result('A download action is already in progress.');
  }

  _aaosScheduleDownloadActionRefresh(handler);

  try {
    if (action == _aaosBrowseDownloadAction) {
      await downloadHandler.downloadFile(
        target.itemId,
        episodeId: target.episodeId,
        downloadType: 'audiobook',
        requiredUserId: user.id,
        requestNotificationPermission: false,
      );

      return result('Download queued.');
    }

    final currentItem = handler._currentMediaItem;

    if (currentItem?.local == true &&
        currentItem?.itemId == target.itemId &&
        currentItem?.episodeId == target.episodeId) {
      return result('Stop playback before deleting this download.', error: true);
    }

    final download = await handler._ref
        .read(appDatabaseProvider)
        .getStoredDownload(target.itemId, user.id, episodeId: target.episodeId);

    if (download == null) {
      await downloadHandler.cancelDownloadForItem(target.itemId, episodeId: target.episodeId, userId: user.id);

      return result('Download canceled.');
    }

    if (handler._ref.read(currentUserProvider).value?.id != user.id) {
      return result('The account changed. Try again.', error: true);
    }

    final deleted = await downloadHandler.deleteDownloadedItem(download, userId: user.id);

    return deleted.failedFiles == 0
        ? result('Download deleted.')
        : result('The download was removed, but some files could not be deleted.', error: true);
  } catch (error, stackTrace) {
    logger('Browse download action failed: $error\n$stackTrace', tag: 'AAOSBrowse', level: InfoLevel.warning);
    final message = error.toString().contains('Notifications permission')
        ? 'Allow notifications in app settings to download.'
        : 'Unable to update the download. Check Downloads in Settings.';

    return result(message, error: true);
  } finally {
    handler._aaosBrowsePreparingDownloads.remove(key);
    _aaosScheduleDownloadActionRefresh(handler);
  }
}
