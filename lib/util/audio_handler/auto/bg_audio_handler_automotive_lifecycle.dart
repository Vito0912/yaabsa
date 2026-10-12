part of '../bg_audio_handler.dart';

void _aaosBeginBrowseLoading(BGAudioHandler handler) {
  if (handler._isDisposing || handler._androidAutoBrowseCache.snapshot != null) {
    return;
  }

  final state = handler.playbackState.value;

  if (state.errorCode == null &&
      state.errorMessage == null &&
      (handler._currentMediaItem != null || state.processingState == AudioProcessingState.loading)) {
    return;
  }

  handler.playbackState.add(
    state.copyWith(
      processingState: handler._currentMediaItem == null ? AudioProcessingState.loading : state.processingState,
      errorCode: null,
      errorMessage: null,
    ),
  );
}

Future<void> _aaosWaitForBrowseReady(BGAudioHandler handler) async {
  final activeUserId = (await handler._ref.read(appDatabaseProvider).getGlobalSetting('activeUserId'))?.value.trim();

  if (handler._isDisposing || activeUserId == null || activeUserId.isEmpty) {
    return;
  }

  final ready = Completer<void>();
  final subscription = handler._ref.listen<ABSApi?>(absApiProvider, (previous, next) {
    if (!ready.isCompleted && next?.user?.id == activeUserId) {
      ready.complete();
    }
  }, fireImmediately: true);

  try {
    await ready.future.timeout(const Duration(seconds: 2), onTimeout: () {});
  } finally {
    subscription.close();
  }
}

Future<void> _androidAutoRefreshBrowseRoots(BGAudioHandler handler) async {
  if (handler._isDisposing || !await _androidAutoIsAutomotiveSystem()) {
    return;
  }

  for (final signal in handler._aaosChildrenSignals.values.toList(growable: false)) {
    if (!signal.isClosed) {
      signal.add(<String, dynamic>{});
    }
  }
}

void _aaosNotifySections(
  BGAudioHandler handler, {
  bool roots = false,
  bool continueListening = false,
  bool downloads = false,
  bool libraryMenus = false,
}) {
  if (handler._isDisposing) {
    return;
  }

  for (final entry in handler._aaosChildrenSignals.entries.toList(growable: false)) {
    final parentId = _androidAutoNormalizeSessionNodeId(entry.key);
    final tab = handler._androidAutoLibraryTabFromNode(parentId)?.tab;
    final shouldNotify =
        roots && parentId == AudioService.browsableRootId ||
        continueListening && parentId == _androidAutoContinueNodeId ||
        downloads && parentId == _androidAutoDownloadsNodeId ||
        libraryMenus &&
            (handler._androidAutoLibraryIdFromNode(parentId) != null || tab == _AndroidAutoLibraryTab.continueSeries);

    if (shouldNotify && !entry.value.isClosed) {
      entry.value.add(<String, dynamic>{});
    }
  }
}

Future<void> _androidAutoAuthenticationChanged(BGAudioHandler handler, {required bool authenticated}) async {
  if (handler._isDisposing || !await _androidAutoIsAutomotiveSystem()) {
    return;
  }

  logger(
    '[AAOS] auth changed: authenticated=$authenticated; refreshing roots',
    tag: 'AudioHandler',
    level: InfoLevel.info,
  );

  if (authenticated) {
    _aaosBeginBrowseLoading(handler);

    final currentUser = await handler._androidAutoCurrentUser();
    final currentApi = handler._ref.read(absApiProvider);
    final userChanged = currentUser != null && handler._androidAutoBrowseUserId != currentUser.id;
    final apiChanged = currentApi != null && !identical(handler._androidAutoBrowseApi, currentApi);

    if (currentUser != null && (userChanged || apiChanged)) {
      _androidAutoInvalidateBrowseState(handler, notify: false);
      handler._androidAutoBrowseUserId = currentUser.id;
      handler._androidAutoBrowseApi = currentApi;
      handler._androidAutoBrowseSession += 1;

      await _aaosObserveContent(handler, currentUser.id);

      logger(
        '[AAOS] started authenticated browse session ${handler._androidAutoBrowseSession}',
        tag: 'AudioHandler',
        level: InfoLevel.info,
      );
    }

    _aaosBeginBrowseLoading(handler);

    try {
      await _androidAutoPrepareBrowse(handler);

      if (await _androidAutoAuthenticationState(handler) == _AndroidAutoAuthenticationState.authenticated) {
        await _androidAutoClearAuthenticationRequiredState(handler);
      }
    } catch (error, stackTrace) {
      logger(
        '[AAOS] browse bootstrap failed after authentication: $error\n$stackTrace',
        tag: 'AAOSBrowse',
        level: InfoLevel.warning,
      );
    }
  } else {
    final activeUserId = (await handler._ref.read(appDatabaseProvider).getGlobalSetting('activeUserId'))?.value.trim();

    if (activeUserId != null && activeUserId.isNotEmpty) {
      return;
    }

    _androidAutoInvalidateBrowseState(handler, notify: false);
    handler._androidAutoBrowseUserId = null;
    handler._androidAutoBrowseApi = null;
    await _aaosObserveContent(handler, null);
    _androidAutoSetAuthenticationRequiredStateIfNeeded(handler);
  }

  await _androidAutoRefreshBrowseRoots(handler);
}

Future<void> _androidAutoHandleServerReachabilityChanged(BGAudioHandler handler) async {
  if (!await _androidAutoIsAutomotiveSystem()) {
    return;
  }

  logger('server became reachable; refreshing browse state', tag: 'AAOSBrowse', level: InfoLevel.info);
  handler._ref.invalidate(mediaProgressProvider);
  _androidAutoInvalidateBrowseState(handler, notify: false);

  try {
    await _androidAutoPrepareBrowse(handler);
  } catch (error, stackTrace) {
    logger(
      'browse refresh after server recovery failed: $error\n$stackTrace',
      tag: 'AAOSBrowse',
      level: InfoLevel.warning,
    );
  }

  await _androidAutoRefreshBrowseRoots(handler);
}

Future<void> _androidAutoPrepareBrowse(BGAudioHandler handler) async {
  if (!await _androidAutoIsAutomotiveSystem()) {
    return;
  }

  if (handler._androidAutoPreparedForNextLaunch) {
    return;
  }

  final activePreparation = handler._androidAutoBrowsePreparationFuture;
  if (activePreparation != null) {
    await activePreparation;
    return;
  }

  final requestGeneration = handler._androidAutoBrowseCache.generation;
  late final Future<void> preparation;
  preparation = () async {
    final authenticationState = await _androidAutoAuthenticationState(handler);

    if (requestGeneration != handler._androidAutoBrowseCache.generation || handler._isDisposing) {
      throw const AndroidAutoBrowseStaleRequestException();
    }

    logger('prepare authenticationState=${authenticationState.name}', tag: 'AAOSBrowse', level: InfoLevel.info);

    if (authenticationState == _AndroidAutoAuthenticationState.initializing) {
      handler._androidAutoBrowseCache.setState(const AndroidAutoBrowseInitializing<AndroidAutoBrowseSnapshot>());
      logger('API not ready', tag: 'AAOSBrowse', level: InfoLevel.debug);
      throw PlatformException(code: 'browse_not_ready', message: 'Loading your library');
    }
    if (authenticationState == _AndroidAutoAuthenticationState.authRequired) {
      handler._androidAutoBrowseCache.setState(const AndroidAutoBrowseAuthRequired<AndroidAutoBrowseSnapshot>());
      handler._androidAutoPrimedChildren.clear();
      _androidAutoSetAuthenticationRequiredStateIfNeeded(handler);
      return;
    }

    logger('bootstrap started', tag: 'AAOSBrowse', level: InfoLevel.info);
    final snapshot = await _androidAutoGetBrowseSnapshot(handler);
    const paging = _AndroidAutoPagingOptions(page: 0, pageSize: _androidAutoDefaultPageSize, hasExplicitPaging: false);
    if (requestGeneration != handler._androidAutoBrowseCache.generation || handler._isDisposing) {
      throw const AndroidAutoBrowseStaleRequestException();
    }
    final libraries = snapshot.audioLibraries;
    final libraryNodes = await handler._androidAutoLibraryNodes(paging, libraries: libraries);

    final primedChildren = <String, List<MediaItem>>{
      _androidAutoContinueNodeId: snapshot.continueItems,
      _androidAutoLibrariesNodeId: libraryNodes,
      _androidAutoDownloadsNodeId: snapshot.downloadItems,
    };

    if (requestGeneration != handler._androidAutoBrowseCache.generation || handler._isDisposing) {
      throw const AndroidAutoBrowseStaleRequestException();
    }
    handler._androidAutoPrimedChildren
      ..clear()
      ..addAll(primedChildren);
    handler._androidAutoPreparedForNextLaunch = true;
    await handler._updatePlaybackState();
    logger(
      'root ready: libraries=${libraries.length}; continue=${snapshot.continueItems.length}',
      tag: 'AAOSBrowse',
      level: InfoLevel.info,
    );
  }();
  handler._androidAutoBrowsePreparationFuture = preparation;

  try {
    await preparation;
  } finally {
    if (identical(handler._androidAutoBrowsePreparationFuture, preparation)) {
      handler._androidAutoBrowsePreparationFuture = null;
    }
  }
}

Future<_AndroidAutoAuthenticationState> _androidAutoAuthenticationState(BGAudioHandler handler) async {
  final currentUser = await handler._androidAutoCurrentUser();

  if (currentUser == null) {
    final activeUserId = (await handler._ref.read(appDatabaseProvider).getGlobalSetting('activeUserId'))?.value.trim();

    final userState = handler._ref.read(currentUserProvider);

    if (activeUserId != null &&
        activeUserId.isNotEmpty &&
        (userState.isLoading || userState.value != null && userState.value?.id != activeUserId)) {
      return _AndroidAutoAuthenticationState.initializing;
    }

    return _AndroidAutoAuthenticationState.authRequired;
  }

  final api = handler._ref.read(absApiProvider);
  if (api == null) {
    return _AndroidAutoAuthenticationState.initializing;
  }

  return api.user?.id == currentUser.id
      ? _AndroidAutoAuthenticationState.authenticated
      : _AndroidAutoAuthenticationState.initializing;
}

Future<AndroidAutoBrowseSnapshot> _androidAutoGetBrowseSnapshot(BGAudioHandler handler, {bool forceRefresh = false}) {
  return handler._androidAutoBrowseCache.getSnapshot(
    (requestGeneration) => _androidAutoLoadBrowseSnapshot(handler, requestGeneration),
    forceRefresh: forceRefresh,
  );
}

Future<AndroidAutoBrowseSnapshot> _androidAutoLoadBrowseSnapshot(BGAudioHandler handler, int requestGeneration) async {
  final requestApi = handler._ref.read(absApiProvider);

  try {
    final authenticationState = await _androidAutoAuthenticationState(handler);

    if (requestGeneration != handler._androidAutoBrowseCache.generation || handler._isDisposing) {
      throw const AndroidAutoBrowseStaleRequestException();
    }

    logger(
      'bootstrap authenticationState=${authenticationState.name}; generation=$requestGeneration',
      tag: 'AAOSBrowse',
      level: InfoLevel.info,
    );
    if (authenticationState == _AndroidAutoAuthenticationState.initializing) {
      logger('API not ready', tag: 'AAOSBrowse', level: InfoLevel.debug);
      throw PlatformException(code: 'browse_not_ready', message: 'Loading your library');
    }
    if (authenticationState == _AndroidAutoAuthenticationState.authRequired) {
      handler._androidAutoBrowseCache.setState(const AndroidAutoBrowseAuthRequired<AndroidAutoBrowseSnapshot>());
      throw PlatformException(code: 'authentication_expired', message: _androidAutoAuthenticationRequiredMessage);
    }

    var remoteContentUnavailable = false;
    Future<T> remoteOrFallback<T>(Future<T> Function() load, T fallback) async {
      try {
        return await load();
      } catch (error) {
        if (error is AndroidAutoBrowseStaleRequestException) {
          rethrow;
        }
        remoteContentUnavailable = true;
        return fallback;
      }
    }

    const paging = _AndroidAutoPagingOptions(page: 0, pageSize: _androidAutoDefaultPageSize, hasExplicitPaging: false);
    final results = await Future.wait<Object>([
      remoteOrFallback(handler._androidAutoFetchContinueItems, const <MediaItem>[]),
      remoteOrFallback(handler._androidAutoFetchAndroidAutoLibraries, const <Library>[]),
      handler._androidAutoDownloadItems(paging),
    ]);

    if (requestGeneration != handler._androidAutoBrowseCache.generation ||
        !identical(requestApi, handler._ref.read(absApiProvider)) ||
        handler._isDisposing) {
      throw const AndroidAutoBrowseStaleRequestException();
    }

    final snapshot = AndroidAutoBrowseSnapshot(
      continueItems: remoteContentUnavailable && (results[0] as List<MediaItem>).isEmpty
          ? _aaosContinueFromDownloads(handler, results[2] as List<MediaItem>)
          : results[0] as List<MediaItem>,
      audioLibraries: results[1] as List<Library>,
      downloadItems: results[2] as List<MediaItem>,
      remoteContentUnavailable: remoteContentUnavailable,
    );
    if (remoteContentUnavailable) {
      _aaosScheduleRetry(handler);
    }
    handler._androidAutoPreparedForNextLaunch = false;
    handler._androidAutoPrimedChildren.clear();
    return snapshot;
  } catch (error, stackTrace) {
    if (error is! AndroidAutoBrowseStaleRequestException) {
      logger('bootstrap failed: $error\n$stackTrace', tag: 'AAOSBrowse', level: InfoLevel.warning);
    }
    rethrow;
  }
}

void _androidAutoInvalidateBrowseState(BGAudioHandler handler, {bool notify = true}) {
  if (kIsWeb || !Platform.isAndroid) {
    return;
  }

  handler._androidAutoBrowseCache.invalidate();
  handler._carBrowseRequests.clear();

  handler._aaosRetryTimer?.cancel();
  handler._androidAutoBrowsePreparationFuture = null;
  handler._androidAutoPreparedForNextLaunch = false;
  handler._androidAutoPrimedChildren.clear();

  logger(
    'browse state invalidated: generation=${handler._androidAutoBrowseCache.generation}',
    tag: 'AAOSBrowse',
    level: InfoLevel.debug,
  );
  if (notify) {
    unawaited(_androidAutoRefreshBrowseRoots(handler));
  }
}

void _androidAutoScheduleContinueRefresh(BGAudioHandler handler) {
  if (handler._isDisposing || _androidAutoIsAutomotiveSystemCache != true) {
    return;
  }
  handler._androidAutoContinueRefreshDebounce?.cancel();
  handler._androidAutoContinueRefreshDebounce = Timer(const Duration(seconds: 2), () {
    unawaited(_aaosRefreshContinue(handler));
  });
}

bool _androidAutoMediaItemListsEqual(List<MediaItem> left, List<MediaItem> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    final leftItem = left[index];
    final rightItem = right[index];
    if (leftItem.id != rightItem.id ||
        leftItem.title != rightItem.title ||
        leftItem.displaySubtitle != rightItem.displaySubtitle ||
        leftItem.playable != rightItem.playable ||
        leftItem.extras?[_androidAutoCompletionStatusExtrasKey] !=
            rightItem.extras?[_androidAutoCompletionStatusExtrasKey] ||
        leftItem.extras?[_androidAutoCompletionPercentageExtrasKey] !=
            rightItem.extras?[_androidAutoCompletionPercentageExtrasKey]) {
      return false;
    }
  }
  return true;
}
