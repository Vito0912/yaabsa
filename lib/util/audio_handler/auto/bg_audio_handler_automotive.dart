part of '../bg_audio_handler.dart';

Future<void> _aaosHandleApiChanged(BGAudioHandler handler) async {
  if (handler._isDisposing || !await _androidAutoIsAutomotiveSystem()) {
    return;
  }

  final api = handler._ref.read(absApiProvider);

  if (api == null) {
    await _androidAutoRefreshBrowseRoots(handler);
    return;
  }

  await _androidAutoAuthenticationChanged(handler, authenticated: true);
}

Future<void> _aaosObserveContent(BGAudioHandler handler, String? userId) async {
  handler._aaosLibraryMutationSubscription ??= handler._ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (
    previous,
    next,
  ) {
    if (next != null && next != previous) {
      unawaited(_aaosScheduleContentRefresh(handler));
    }
  });

  if (handler._aaosDownloadsUserId == userId) {
    return;
  }

  handler._aaosDownloadsUserId = userId;
  handler._aaosBrowseDownloadsReady = false;
  handler._aaosBrowseDownloads.clear();
  _aaosUpdateActiveDownloads(handler, downloadHandler.taskQueueSnapshot);
  final previousSubscription = handler._aaosDownloadsSubscription;
  handler._aaosDownloadsSubscription = null;
  await previousSubscription?.cancel();

  if (userId == null || handler._isDisposing || handler._aaosDownloadsUserId != userId) {
    return;
  }

  handler._aaosDownloadsSubscription = handler._ref
      .read(appDatabaseProvider)
      .watchStoredDownloadsByUser(userId)
      .listen(
        (downloads) {
          if (handler._isDisposing || handler._aaosDownloadsUserId != userId) {
            return;
          }

          _aaosUpdateStoredDownloads(handler, downloads);
          unawaited(_aaosRefreshDownloads(handler, userId));
        },
        onError: (Object error, StackTrace stackTrace) {
          logger('Download browse refresh failed: $error\n$stackTrace', tag: 'AAOSBrowse', level: InfoLevel.warning);
        },
      );
}

Future<void> _aaosRefreshDownloads(BGAudioHandler handler, String userId) async {
  final generation = handler._androidAutoBrowseCache.generation;

  try {
    const paging = _AndroidAutoPagingOptions(page: 0, pageSize: _androidAutoDefaultPageSize, hasExplicitPaging: false);
    final downloads = await handler._androidAutoDownloadItems(paging);
    final snapshot = handler._androidAutoBrowseCache.snapshot;

    if (handler._isDisposing ||
        generation != handler._androidAutoBrowseCache.generation ||
        handler._aaosDownloadsUserId != userId ||
        snapshot == null ||
        _androidAutoMediaItemListsEqual(snapshot.downloadItems, downloads)) {
      return;
    }

    final continueItems = snapshot.remoteContentUnavailable ? _aaosContinueFromDownloads(handler, downloads) : null;
    handler._androidAutoBrowseCache.updateSnapshot(
      snapshot.copyWith(downloadItems: downloads, continueItems: continueItems),
    );
    handler._androidAutoPrimedChildren.remove(_androidAutoDownloadsNodeId);
    handler._androidAutoPrimedChildren.remove(_androidAutoContinueNodeId);

    _aaosNotifySections(
      handler,
      roots:
          snapshot.downloadItems.isEmpty != downloads.isEmpty ||
          continueItems != null && snapshot.continueItems.isEmpty != continueItems.isEmpty,
      downloads: true,
      continueListening: continueItems != null,
    );
  } catch (error, stackTrace) {
    logger('Download browse refresh failed: $error\n$stackTrace', tag: 'AAOSBrowse', level: InfoLevel.warning);
  }
}

Future<void> _aaosScheduleContentRefresh(BGAudioHandler handler, {bool notify = true}) async {
  if (handler._isDisposing || !await _androidAutoIsAutomotiveSystem()) {
    return;
  }

  _androidAutoInvalidateBrowseState(handler, notify: false);

  if (!notify) {
    return;
  }

  handler._aaosContentRefreshTimer?.cancel();
  handler._aaosContentRefreshTimer = Timer(const Duration(milliseconds: 500), () async {
    if (handler._isDisposing) {
      return;
    }

    try {
      await _androidAutoPrepareBrowse(handler);
    } catch (error, stackTrace) {
      logger('Content browse refresh failed: $error\n$stackTrace', tag: 'AAOSBrowse', level: InfoLevel.warning);
    }

    await _androidAutoRefreshBrowseRoots(handler);
  });
}

void _aaosScheduleRetry(BGAudioHandler handler) {
  if (handler._isDisposing) {
    return;
  }

  handler._aaosRetryTimer?.cancel();
  handler._aaosRetryTimer = Timer(const Duration(seconds: 15), () {
    if (!handler._isDisposing) {
      unawaited(_aaosScheduleContentRefresh(handler));
    }
  });
}

Future<void> _aaosRefreshContinue(BGAudioHandler handler) async {
  if (handler._isDisposing || !await _androidAutoIsAutomotiveSystem()) {
    return;
  }

  final activeRefresh = handler._aaosContinueRefreshFuture;

  if (activeRefresh != null) {
    await activeRefresh;
    _androidAutoScheduleContinueRefresh(handler);
    return;
  }

  final refresh = () async {
    final generation = handler._androidAutoBrowseCache.generation;

    try {
      if (handler._androidAutoBrowseCache.snapshot == null) {
        await _androidAutoPrepareBrowse(handler);
        await _androidAutoRefreshBrowseRoots(handler);
        return;
      }

      handler._carBrowseRequests.remove('continue');
      handler._carBrowseRequests.removeWhere(
        (key, _) => key.startsWith('personalized/') || key.startsWith('tab/') && key.contains('/continue-series/'),
      );

      final previousSnapshot = handler._androidAutoBrowseCache.snapshot!;
      final nextItems = handler._ref.read(serverReachabilityProvider)
          ? await handler._androidAutoFetchContinueItems()
          : _aaosContinueFromDownloads(handler, previousSnapshot.downloadItems);
      final snapshot = handler._androidAutoBrowseCache.snapshot;

      if (handler._isDisposing || generation != handler._androidAutoBrowseCache.generation || snapshot == null) {
        return;
      }

      handler._androidAutoBrowseCache.updateSnapshot(snapshot.copyWith(continueItems: nextItems));
      handler._androidAutoPrimedChildren.remove(_androidAutoContinueNodeId);

      _aaosNotifySections(
        handler,
        roots:
            snapshot.continueItems.isEmpty != nextItems.isEmpty ||
            automotiveContinueSupportsGrid(snapshot.continueItems) != automotiveContinueSupportsGrid(nextItems),
        continueListening: true,
        libraryMenus: true,
      );
    } catch (error, stackTrace) {
      if (generation == handler._androidAutoBrowseCache.generation) {
        _aaosScheduleRetry(handler);
      }

      logger('Continue browse refresh failed: $error\n$stackTrace', tag: 'AAOSBrowse', level: InfoLevel.warning);
    }
  }();

  handler._aaosContinueRefreshFuture = refresh;

  try {
    await refresh;
  } finally {
    if (identical(handler._aaosContinueRefreshFuture, refresh)) {
      handler._aaosContinueRefreshFuture = null;
    }
  }
}

List<MediaItem> _aaosContinueFromDownloads(BGAudioHandler handler, List<MediaItem> downloads) {
  final progress = handler._ref.read(mediaProgressProvider.notifier);

  final items = downloads
      .where((item) {
        final itemId = item.extras?['itemId'] as String?;

        if (itemId == null) {
          return false;
        }

        final entry = progress.progressForKey(mediaProgressKey(itemId, item.extras?['episodeId'] as String?));
        return entry != null && entry.currentTime > 0 && !entry.isFinished && entry.hideFromContinueListening != true;
      })
      .toList(growable: false);

  return _aaosContinueWithProgress(handler, items);
}

List<MediaItem> _aaosContinueWithProgress(BGAudioHandler handler, List<MediaItem> items) {
  final progress = handler._ref.read(mediaProgressProvider.notifier);

  return items
      .map<MediaItem?>((item) {
        final itemId = item.extras?['itemId'] as String?;
        final episodeId = item.extras?['episodeId'] as String?;
        final entry = itemId == null ? null : progress.progressForKey(mediaProgressKey(itemId, episodeId));
        final hasProgress = entry != null && entry.progress.isFinite;

        if (entry?.isFinished == true || entry?.hideFromContinueListening == true) {
          return null;
        }

        if (!hasProgress) {
          return item.copyWith(extras: <String, dynamic>{...?item.extras, automotiveContinueProgressKnownKey: false});
        }

        return item.copyWith(
          extras: <String, dynamic>{
            ...?item.extras,
            ...handler._androidAutoCompletionExtras(itemId: itemId!, episodeId: episodeId),
            automotiveContinueProgressKnownKey: true,
          },
        );
      })
      .whereType<MediaItem>()
      .toList(growable: false);
}

class _CarBrowsePage {
  const _CarBrowsePage(this.libraryId, this.kind, this.page);

  final String libraryId;
  final String kind;
  final int page;

  String get id => 'aa/page/${Uri.encodeComponent(jsonEncode([libraryId, kind, page]))}';
}

_CarBrowsePage? _aaosPageNode(String id) {
  if (!id.startsWith('aa/page/')) {
    return null;
  }

  try {
    final values = jsonDecode(Uri.decodeComponent(id.substring('aa/page/'.length))) as List<dynamic>;
    final page = values[2] as int;

    if (page < 0) {
      return null;
    }

    return _CarBrowsePage(values[0] as String, values[1] as String, page);
  } catch (_) {
    return null;
  }
}

Future<List<MediaItem>> _aaosLoadPage(BGAudioHandler handler, _CarBrowsePage node) async {
  final paging = _AndroidAutoPagingOptions(
    page: node.page,
    pageSize: _androidAutoDefaultPageSize,
    hasExplicitPaging: false,
  );

  if (node.kind == 'series') {
    return _aaosSeriesPage(handler, node.libraryId, paging);
  }

  if (node.kind == 'all' ||
      node.kind == 'recently-added' ||
      node.kind.startsWith('author/') ||
      node.kind.startsWith('series-items/') ||
      node.kind.startsWith('narrator/')) {
    return _aaosAllItemsPage(handler, node.libraryId, paging, kind: node.kind);
  }

  return const <MediaItem>[];
}

Future<List<MediaItem>> _aaosAllItemsPage(
  BGAudioHandler handler,
  String libraryId,
  _AndroidAutoPagingOptions paging, {
  String kind = 'all',
}) async {
  String? filter;

  if (kind.startsWith('author/')) {
    filter = LibraryFilter.grouped(LibraryFilterGroup.authors, kind.substring('author/'.length)).queryValue;
  } else if (kind.startsWith('series-items/')) {
    filter = LibraryFilter.grouped(LibraryFilterGroup.series, kind.substring('series-items/'.length)).queryValue;
  } else if (kind.startsWith('narrator/')) {
    filter = LibraryFilter.grouped(LibraryFilterGroup.narrators, kind.substring('narrator/'.length)).queryValue;
  }

  final page = await handler._androidAutoFetchLibraryItemsPage(
    libraryId: libraryId,
    paging: paging,
    sort: kind == 'recently-added'
        ? 'addedAt'
        : kind.startsWith('series-items/')
        ? 'sequence'
        : await handler._androidAutoSortApiFieldForLibrary(libraryId),
    filter: filter,
    desc: kind == 'recently-added' || await handler._androidAutoSortDescendingForLibrary(libraryId) ? 1 : 0,
    collapseseries: 0,
  );

  final items = kind == 'recently-added'
      ? page.items.where(handler._androidAutoHasAvailableAudio).toList(growable: false)
      : page.items;

  return [
    ...handler._androidAutoMediaItemsFromLibraryItems(items, subtitlePrefix: ''),
    if (!paging.hasExplicitPaging && page.hasMore && page.items.isNotEmpty && page.page == paging.page)
      handler._androidAutoBrowsableItem(id: _CarBrowsePage(libraryId, kind, page.page + 1).id, title: 'More'),
  ];
}

Future<List<MediaItem>> _aaosSeriesPage(
  BGAudioHandler handler,
  String libraryId,
  _AndroidAutoPagingOptions paging,
) async {
  final page = await handler._androidAutoFetchSeriesPageForLibrary(libraryId, paging);

  return [
    ...page.series.map(
      (series) => handler._androidAutoBrowsableItem(
        id: handler._androidAutoSeriesNodeId(libraryId, series.id),
        title: series.name,
      ),
    ),
    if (!paging.hasExplicitPaging && page.hasMore && page.series.isNotEmpty && page.page == paging.page)
      handler._androidAutoBrowsableItem(id: _CarBrowsePage(libraryId, 'series', page.page + 1).id, title: 'More'),
  ];
}

Future<List<MediaItem>> _aaosLibraryTabNodes(BGAudioHandler handler, String libraryId) async {
  final tabs = await handler._androidAutoTabsForLibrary(libraryId);
  const paging = _AndroidAutoPagingOptions(page: 0, pageSize: _androidAutoDefaultPageSize, hasExplicitPaging: false);

  final nodes = await Future.wait(
    tabs.map((tab) async {
      String? subtitle;

      try {
        final children = await handler._androidAutoLibraryTabChildren(libraryId, tab, paging);

        if (children.isEmpty) {
          return null;
        }

        if (tab == _AndroidAutoLibraryTab.recentlyAdded && children.every((item) => _aaosPageNode(item.id) != null)) {
          return null;
        }
      } catch (error) {
        if (error is AndroidAutoBrowseStaleRequestException) {
          rethrow;
        }

        subtitle = 'Unable to load. Try again.';
      }

      return handler._androidAutoBrowsableItem(
        id: handler._androidAutoLibraryTabNodeId(libraryId, tab),
        title: tab.label,
        subtitle: subtitle,
        artUri: handler._androidAutoLibraryTabIconUri(tab),
        categoryStyle: true,
      );
    }),
  );

  return nodes.whereType<MediaItem>().toList(growable: false);
}
