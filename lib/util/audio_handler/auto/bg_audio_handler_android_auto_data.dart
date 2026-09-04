part of '../bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoData on BGAudioHandler {
  Future<void> _androidAutoEnsureMediaProgress() async {
    final hadData = _ref.read(mediaProgressProvider).asData != null;
    try {
      final progress = await _ref
          .read(mediaProgressProvider.future)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => _ref.read(mediaProgressProvider).asData?.value ?? const <String, MediaProgress>{},
          );
      if (!hadData) {
        logger('media progress ready: entries=${progress.length}', tag: 'AAOSBrowse', level: InfoLevel.info);
      }
    } catch (e, s) {
      logger('media progress unavailable: $e\n$s', tag: 'AAOSBrowse', level: InfoLevel.warning);
    }
  }

  String _androidAutoSafeServerAddress(ABSApi api) {
    final uri = Uri.tryParse(api.basePathOverride);
    if (uri == null || uri.host.isEmpty) {
      return '<invalid>';
    }
    final port = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$port';
  }

  Future<List<Library>> _androidAutoFetchLibraries({String? include, bool rethrowOnError = false}) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      if (rethrowOnError) {
        throw StateError('AAOS browse API is not ready');
      }
      return const <Library>[];
    }

    try {
      final response = await api.getLibraryApi().getLibraries(
        include: include,
        extra: const <String, dynamic>{'doNotCache': true},
      );
      final libraries = [...?response.data?.libraries]
        ..sort((left, right) => left.displayOrder.compareTo(right.displayOrder));
      return libraries;
    } catch (e) {
      logger('Failed to fetch Android Auto libraries: $e', tag: 'AAOSBrowse', level: InfoLevel.warning);
      if (rethrowOnError) {
        rethrow;
      }
      return const <Library>[];
    }
  }

  Future<List<Library>> _androidAutoFetchAndroidAutoLibraries() async {
    final api = _ref.read(absApiProvider);
    logger(
      'libraries request started: include=stats; '
      'server=${api == null ? '<none>' : _androidAutoSafeServerAddress(api)}; '
      'serverReachable=${_ref.read(serverReachabilityProvider)}',
      tag: 'AAOSBrowse',
      level: InfoLevel.info,
    );
    final libraries = await _androidAutoFetchLibraries(include: 'stats', rethrowOnError: true);
    final supportedTypeCount = libraries
        .where((library) => library.mediaType == 'book' || library.mediaType == 'podcast')
        .length;
    for (final library in libraries) {
      if ((library.mediaType == 'book' || library.mediaType == 'podcast') && library.stats?.numAudioFiles == null) {
        logger(
          'library skipped: id=${library.id}; mediaType=${library.mediaType}; missing numAudioFiles',
          tag: 'AAOSBrowse',
          level: InfoLevel.warning,
        );
      } else if (!isAndroidAutoAudioLibrary(library)) {
        logger(
          'library skipped: id=${library.id}; mediaType=${library.mediaType}; '
          'numAudioFiles=${library.stats?.numAudioFiles}',
          tag: 'AAOSBrowse',
          level: InfoLevel.debug,
        );
      }
    }
    final audioLibraries = filterAndroidAutoLibraries(libraries);
    logger(
      'libraries: returned=${libraries.length}; supportedType=$supportedTypeCount; withAudio=${audioLibraries.length}',
      tag: 'AAOSBrowse',
      level: InfoLevel.info,
    );
    return audioLibraries;
  }

  Future<List<MediaItem>> _androidAutoFetchContinueItems() async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      throw StateError('AAOS browse API is not ready');
    }

    try {
      logger(
        'items-in-progress request started: limit=25; '
        'server=${_androidAutoSafeServerAddress(api)}; '
        'serverReachable=${_ref.read(serverReachabilityProvider)}',
        tag: 'AAOSBrowse',
        level: InfoLevel.info,
      );
      final response = await api.getMeApi().getItemsInProgress(
        limit: 25,
        extra: const <String, dynamic>{'doNotCache': true},
      );
      final data = response.data;
      if (data == null) {
        throw StateError('AAOS items-in-progress response was empty');
      }

      await _androidAutoEnsureMediaProgress();
      final playableItems = _androidAutoContinueMediaItems(data.libraryItems);
      logger(
        'items-in-progress: serverItems=${data.libraryItems.length}; playableItems=${playableItems.length}',
        tag: 'AAOSBrowse',
        level: InfoLevel.info,
      );
      return playableItems;
    } catch (e, s) {
      final details = e is DioException ? 'type=${e.type}; message=${e.message}; cause=${e.error}' : e.toString();
      logger('items-in-progress failed: $details\n$s', tag: 'AAOSBrowse', level: InfoLevel.warning);
      rethrow;
    }
  }

  Future<PersonalizedLibrary?> _androidAutoFetchPersonalizedLibrary(String libraryId) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    try {
      final response = await api.getLibraryApi().getPersonalized(
        libraryId,
        extra: const <String, dynamic>{'doNotCache': true},
      );
      return response.data;
    } catch (e) {
      logger(
        'Failed to fetch Android Auto personalized data for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  Future<List<Episode>> _androidAutoFetchRecentEpisodesPage(String libraryId, _AndroidAutoPagingOptions paging) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return const <Episode>[];
    }

    try {
      final response = await api.getLibraryApi().getRecentEpisodes(
        libraryId,
        limit: paging.pageSize,
        page: paging.page,
        extra: const <String, dynamic>{'doNotCache': true},
      );
      return response.data?.episodes ?? const <Episode>[];
    } catch (e) {
      logger(
        'Failed to fetch Android Auto latest episodes for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return const <Episode>[];
    }
  }

  Future<LibraryFilterData?> _androidAutoFetchFilterData(String libraryId) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    try {
      final response = await api.getLibraryApi().getLibraryFilterData(
        libraryId,
        extra: const <String, dynamic>{'doNotCache': true},
      );
      return response.data?.filterData;
    } catch (e) {
      logger(
        'Failed to fetch Android Auto filter data for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  Future<_AndroidAutoSeriesPage> _androidAutoFetchSeriesPageForLibrary(
    String libraryId,
    _AndroidAutoPagingOptions paging,
  ) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return _AndroidAutoSeriesPage(series: const <Series>[], total: 0, page: paging.page, pageSize: paging.pageSize);
    }

    try {
      final response = await api.getLibraryApi().getLibrarySeries(
        libraryId,
        LibraryItemsRequest(limit: paging.pageSize, page: paging.page, sort: 'name', desc: 0),
        extra: const <String, dynamic>{'doNotCache': true},
      );
      final data = response.data;
      final series = data?.results ?? const <Series>[];
      return _AndroidAutoSeriesPage(
        series: series,
        total: data?.total ?? series.length,
        page: data?.page ?? paging.page,
        pageSize: data?.limit ?? paging.pageSize,
      );
    } catch (e) {
      logger('Failed to fetch Android Auto series for $libraryId: $e', tag: 'AudioHandler', level: InfoLevel.warning);
      return _AndroidAutoSeriesPage(series: const <Series>[], total: 0, page: paging.page, pageSize: paging.pageSize);
    }
  }

  Future<List<Collection>> _androidAutoFetchCollectionsForLibrary(String libraryId) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return const <Collection>[];
    }

    try {
      final response = await api.getListApi().getCollections(extra: const <String, dynamic>{'doNotCache': true});
      final items =
          (response.data?.items ?? const <Collection>[])
              .where((collection) => collection.libraryId == libraryId)
              .toList(growable: false)
            ..sort((left, right) => left.name.toLowerCase().compareTo(right.name.toLowerCase()));
      return items;
    } catch (e) {
      logger(
        'Failed to fetch Android Auto collections for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return const <Collection>[];
    }
  }

  Future<List<Playlist>> _androidAutoFetchPlaylistsForLibrary(String libraryId) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return const <Playlist>[];
    }

    try {
      final response = await api.getListApi().getUserPlaylist(extra: const <String, dynamic>{'doNotCache': true});
      final items =
          (response.data?.items ?? const <Playlist>[])
              .where((playlist) => playlist.libraryId == libraryId)
              .toList(growable: false)
            ..sort((left, right) => left.name.toLowerCase().compareTo(right.name.toLowerCase()));
      return items;
    } catch (e) {
      logger(
        'Failed to fetch Android Auto playlists for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return const <Playlist>[];
    }
  }

  Future<_AndroidAutoLibraryItemsPage> _androidAutoFetchLibraryItemsPage({
    required String libraryId,
    required _AndroidAutoPagingOptions paging,
    String? sort,
    int? desc,
    String? filter,
    int? collapseseries,
    String? include,
  }) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return _AndroidAutoLibraryItemsPage(
        items: const <LibraryItem>[],
        total: 0,
        page: paging.page,
        pageSize: paging.pageSize,
      );
    }

    Future<_AndroidAutoLibraryItemsPage> runRequest(String? effectiveSort) async {
      final request = LibraryItemsRequest(
        limit: paging.pageSize,
        page: paging.page,
        sort: effectiveSort,
        desc: desc,
        filter: normalizeLibraryFilterQuery(filter),
        collapseseries: collapseseries,
        include: include,
      );

      final response = await api.getLibraryApi().getLibraryItems(
        libraryId,
        request,
        extra: const <String, dynamic>{'doNotCache': true},
      );
      final data = response.data;
      final items = data?.results ?? const <LibraryItem>[];

      return _AndroidAutoLibraryItemsPage(
        items: items,
        total: data?.total ?? items.length,
        page: data?.page ?? paging.page,
        pageSize: data?.limit ?? paging.pageSize,
      );
    }

    try {
      return await runRequest(sort);
    } catch (e) {
      if (sort != null && sort != _androidAutoBookSortFieldToApiSort[_androidAutoSortFieldTitle]) {
        try {
          logger(
            'Retrying Android Auto library fetch for $libraryId with fallback title sort after sort "$sort" failed: $e',
            tag: 'AudioHandler',
            level: InfoLevel.warning,
          );
          return await runRequest(_androidAutoBookSortFieldToApiSort[_androidAutoSortFieldTitle]);
        } catch (_) {}
      }

      logger(
        'Failed to fetch Android Auto library items for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return _AndroidAutoLibraryItemsPage(
        items: const <LibraryItem>[],
        total: 0,
        page: paging.page,
        pageSize: paging.pageSize,
      );
    }
  }

  Future<List<LibraryItem>> _androidAutoFetchAllLibraryItems({
    required String libraryId,
    required String sort,
    required int desc,
    String? filter,
    int? collapseseries,
    String? include,
  }) async {
    final allItems = <LibraryItem>[];
    final seen = <String>{};
    var page = 0;

    while (page < 500) {
      final pageResult = await _androidAutoFetchLibraryItemsPage(
        libraryId: libraryId,
        paging: _AndroidAutoPagingOptions(page: page, pageSize: _androidAutoDefaultPageSize, hasExplicitPaging: true),
        sort: sort,
        desc: desc,
        filter: filter,
        collapseseries: collapseseries,
        include: include,
      );

      if (pageResult.items.isEmpty) {
        break;
      }

      for (final item in pageResult.items) {
        if (seen.add(item.id)) {
          allItems.add(item);
        }
      }

      if (!pageResult.hasMore) {
        break;
      }

      page += 1;
    }

    return allItems;
  }

  Future<InternalDownload?> _androidAutoStoredDownload(String itemId, {String? episodeId}) async {
    final user = await _androidAutoCurrentUser();
    if (user == null) {
      return null;
    }

    return _ref.read(appDatabaseProvider).getStoredDownload(itemId, user.id, episodeId: episodeId);
  }

  Future<User?> _androidAutoCurrentUser() async {
    final db = _ref.read(appDatabaseProvider);
    final activeUserId = (await db.getGlobalSetting('activeUserId'))?.value.trim();
    if (activeUserId == null || activeUserId.isEmpty) {
      return null;
    }

    final currentUserAsync = _ref.read(currentUserProvider);
    if (currentUserAsync.hasValue && currentUserAsync.value?.id == activeUserId) {
      return currentUserAsync.value;
    }

    try {
      final currentUser = await _ref.read(currentUserProvider.future);
      return currentUser?.id == activeUserId ? currentUser : null;
    } catch (_) {
      return null;
    }
  }

  Future<Library?> _androidAutoLibraryForId(String libraryId) async {
    final libraries = await _androidAutoFetchLibraries();
    for (final library in libraries) {
      if (library.id == libraryId) {
        return library;
      }
    }
    return null;
  }

  Future<bool> _androidAutoLibraryIsPodcast(String libraryId) async {
    final library = await _androidAutoLibraryForId(libraryId);
    return library?.mediaType == 'podcast';
  }

  Future<bool> _androidAutoLibrarySortDescending() async {
    final user = await _androidAutoCurrentUser();
    return _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(user?.id, SettingKeys.androidAutoLibrarySortDescending, defaultValue: false);
  }

  Future<bool> _androidAutoPodcastSortDescending() async {
    final user = await _androidAutoCurrentUser();
    return _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(user?.id, SettingKeys.androidAutoPodcastSortDescending, defaultValue: true);
  }

  Future<String> _androidAutoLibrarySortField() async {
    final user = await _androidAutoCurrentUser();
    final sortField = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(
          user?.id,
          SettingKeys.androidAutoLibrarySortField,
          defaultValue: _androidAutoSortFieldTitle,
        );

    if (!_androidAutoBookSortFieldToApiSort.containsKey(sortField)) {
      return _androidAutoSortFieldTitle;
    }

    return sortField;
  }

  Future<String> _androidAutoPodcastSortField() async {
    final user = await _androidAutoCurrentUser();
    final sortField = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(
          user?.id,
          SettingKeys.androidAutoPodcastSortField,
          defaultValue: _androidAutoSortFieldAdded,
        );

    if (!_androidAutoPodcastSortFieldToApiSort.containsKey(sortField)) {
      return _androidAutoSortFieldAdded;
    }

    return sortField;
  }

  Future<bool> _androidAutoSortDescendingForLibrary(String libraryId) async {
    if (await _androidAutoLibraryIsPodcast(libraryId)) {
      return _androidAutoPodcastSortDescending();
    }

    return _androidAutoLibrarySortDescending();
  }

  Future<String> _androidAutoLibrarySortApiField() async {
    final sortField = await _androidAutoLibrarySortField();
    return _androidAutoBookSortFieldToApiSort[sortField] ??
        _androidAutoBookSortFieldToApiSort[_androidAutoSortFieldTitle]!;
  }

  Future<String> _androidAutoPodcastSortApiField() async {
    final sortField = await _androidAutoPodcastSortField();
    return _androidAutoPodcastSortFieldToApiSort[sortField] ??
        _androidAutoPodcastSortFieldToApiSort[_androidAutoSortFieldAdded]!;
  }

  Future<String> _androidAutoSortApiFieldForLibrary(String libraryId) async {
    if (await _androidAutoLibraryIsPodcast(libraryId)) {
      return _androidAutoPodcastSortApiField();
    }

    return _androidAutoLibrarySortApiField();
  }

  Future<bool> _androidAutoGroupByLettersEnabled() async {
    final user = await _androidAutoCurrentUser();
    return _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(user?.id, SettingKeys.androidAutoGroupByLetters, defaultValue: true);
  }

  Future<bool> _androidAutoHasServerConnection() async {
    final status = _ref.read(serverStatusProvider);
    if (status.hasValue) {
      return status.value ?? false;
    }

    final api = _ref.read(absApiProvider);
    if (api == null) {
      return false;
    }

    try {
      await api.getMeApi().getPing();
      return true;
    } catch (_) {
      logger('Failed to ping server for Android Auto connection check', tag: 'AudioHandler', level: InfoLevel.warning);
      return false;
    }
  }
}
