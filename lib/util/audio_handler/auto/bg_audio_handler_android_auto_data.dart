part of '../bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoData on BGAudioHandler {
  Future<void> _androidAutoEnsureMediaProgress() async {
    final progressNotifier = _ref.read(mediaProgressProvider.notifier);
    final hadData = progressNotifier.isInitialized;
    try {
      await _ref.read(mediaProgressProvider.future).timeout(const Duration(seconds: 5), onTimeout: () {});
      if (!hadData) {
        logger(
          'media progress ready: entries=${_ref.read(mediaProgressProvider.notifier).progressCount}',
          tag: 'AAOSBrowse',
          level: InfoLevel.info,
        );
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

  Future<List<Library>> _androidAutoFetchLibrariesLive({String? include, bool rethrowOnError = false}) async {
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
      if (await _androidAutoIsAutomotiveSystem()) {
        rethrow;
      }
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

  Future<List<MediaItem>> _androidAutoFetchContinueItemsLive() async {
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

      unawaited(_androidAutoEnsureMediaProgress());
      final playableItems = _aaosContinueWithProgress(this, _androidAutoContinueMediaItems(data.libraryItems));
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

  Future<PersonalizedLibrary?> _androidAutoFetchPersonalizedLibraryLive(String libraryId) async {
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
      if (await _androidAutoIsAutomotiveSystem()) {
        rethrow;
      }
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
      if (await _androidAutoIsAutomotiveSystem()) {
        rethrow;
      }
      logger(
        'Failed to fetch Android Auto latest episodes for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return const <Episode>[];
    }
  }

  Future<LibraryFilterData?> _androidAutoFetchFilterDataLive(String libraryId) async {
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
      if (await _androidAutoIsAutomotiveSystem()) {
        rethrow;
      }
      logger(
        'Failed to fetch Android Auto filter data for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  Future<_AndroidAutoSeriesPage> _androidAutoFetchSeriesPageForLibraryLive(
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
      if (await _androidAutoIsAutomotiveSystem()) {
        rethrow;
      }
      logger('Failed to fetch Android Auto series for $libraryId: $e', tag: 'AudioHandler', level: InfoLevel.warning);
      return _AndroidAutoSeriesPage(series: const <Series>[], total: 0, page: paging.page, pageSize: paging.pageSize);
    }
  }

  Future<List<Collection>> _androidAutoFetchCollectionsForLibraryLive(String libraryId) async {
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
      if (await _androidAutoIsAutomotiveSystem()) {
        rethrow;
      }
      logger(
        'Failed to fetch Android Auto collections for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return const <Collection>[];
    }
  }

  Future<List<Playlist>> _androidAutoFetchPlaylistsForLibraryLive(String libraryId) async {
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
      if (await _androidAutoIsAutomotiveSystem()) {
        rethrow;
      }
      logger(
        'Failed to fetch Android Auto playlists for $libraryId: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return const <Playlist>[];
    }
  }

  Future<_AndroidAutoLibraryItemsPage> _androidAutoFetchLibraryItemsPageLive({
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

      if (await _androidAutoIsAutomotiveSystem()) {
        rethrow;
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

  Future<List<LibraryItem>> _androidAutoFetchAllLibraryItemsLive({
    required String libraryId,
    required String sort,
    required int desc,
    String? filter,
    int? collapseseries,
    String? include,
  }) async {
    Future<_AndroidAutoLibraryItemsPage> loadPage(int page, int pageSize) {
      return _androidAutoFetchLibraryItemsPage(
        libraryId: libraryId,
        paging: _AndroidAutoPagingOptions(page: page, pageSize: pageSize, hasExplicitPaging: true),
        sort: sort,
        desc: desc,
        filter: filter,
        collapseseries: collapseseries,
        include: include,
      );
    }

    final firstPage = await loadPage(0, _androidAutoMaxPageSize);
    final allItems = <LibraryItem>[...firstPage.items];
    final seen = firstPage.items.map((item) => item.id).toSet();
    if (!firstPage.hasMore || firstPage.items.isEmpty || firstPage.pageSize <= 0) {
      return allItems;
    }
    final totalPages = ((firstPage.total + firstPage.pageSize - 1) ~/ firstPage.pageSize).clamp(1, 500);
    for (var startPage = 1; startPage < totalPages; startPage += 4) {
      final pages = await Future.wait([
        for (var page = startPage; page < startPage + 4 && page < totalPages; page++)
          loadPage(page, firstPage.pageSize),
      ]);
      for (var index = 0; index < pages.length; index++) {
        final page = pages[index];
        if (page.items.isEmpty || page.page != startPage + index) {
          return allItems;
        }
        for (final item in page.items) {
          if (seen.add(item.id)) {
            allItems.add(item);
          }
        }
      }
    }
    return allItems;
  }
}
