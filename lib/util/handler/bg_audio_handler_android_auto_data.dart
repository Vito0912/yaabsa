part of 'bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoData on BGAudioHandler {
  Future<List<Library>> _androidAutoFetchLibraries() async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return const <Library>[];
    }

    try {
      final response = await api.getLibraryApi().getLibraries();
      final libraries = [...?response.data?.libraries]
        ..sort((left, right) => left.displayOrder.compareTo(right.displayOrder));
      return libraries;
    } catch (e) {
      logger('Failed to fetch Android Auto libraries: $e', tag: 'AudioHandler', level: InfoLevel.warning);
      return const <Library>[];
    }
  }

  Future<PersonalizedLibrary?> _androidAutoFetchPersonalizedLibrary(String libraryId) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    try {
      final response = await api.getLibraryApi().getPersonalized(libraryId);
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

  Future<LibraryFilterData?> _androidAutoFetchFilterData(String libraryId) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    try {
      final response = await api.getLibraryApi().getLibraryFilterData(libraryId);
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

  Future<List<Series>> _androidAutoFetchSeriesForLibrary(String libraryId, _AndroidAutoPagingOptions paging) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return const <Series>[];
    }

    try {
      final response = await api.getLibraryApi().getLibrarySeries(
        libraryId,
        LibraryItemsRequest(limit: paging.pageSize, page: paging.page, sort: 'name', desc: 0),
      );
      return response.data?.results ?? const <Series>[];
    } catch (e) {
      logger('Failed to fetch Android Auto series for $libraryId: $e', tag: 'AudioHandler', level: InfoLevel.warning);
      return const <Series>[];
    }
  }

  Future<List<Collection>> _androidAutoFetchCollectionsForLibrary(String libraryId) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      return const <Collection>[];
    }

    try {
      final response = await api.getListApi().getCollections();
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
      final response = await api.getListApi().getUserPlaylist();
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

      final response = await api.getLibraryApi().getLibraryItems(libraryId, request);
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
      if (sort != null && sort != _androidAutoSortFieldToApiSort[_androidAutoSortFieldTitle]) {
        try {
          logger(
            'Retrying Android Auto library fetch for $libraryId with fallback title sort after sort "$sort" failed: $e',
            tag: 'AudioHandler',
            level: InfoLevel.warning,
          );
          return await runRequest(_androidAutoSortFieldToApiSort[_androidAutoSortFieldTitle]);
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

  Future<List<LibraryItem>> _androidAutoFetchLibraryItems({
    required String libraryId,
    required _AndroidAutoPagingOptions paging,
    String? sort,
    int? desc,
    String? filter,
    int? collapseseries,
    String? include,
  }) async {
    final page = await _androidAutoFetchLibraryItemsPage(
      libraryId: libraryId,
      paging: paging,
      sort: sort,
      desc: desc,
      filter: filter,
      collapseseries: collapseseries,
      include: include,
    );
    return page.items;
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
    final currentUserAsync = _ref.read(currentUserProvider);
    if (currentUserAsync.hasValue) {
      return currentUserAsync.value;
    }

    try {
      return await _ref.read(currentUserProvider.future);
    } catch (_) {
      return null;
    }
  }

  Future<bool> _androidAutoLibrarySortDescending() async {
    final user = await _androidAutoCurrentUser();
    return _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(user?.id, SettingKeys.androidAutoLibrarySortDescending, defaultValue: false);
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

    if (!_androidAutoSortFieldToApiSort.containsKey(sortField)) {
      return _androidAutoSortFieldTitle;
    }

    return sortField;
  }

  Future<String> _androidAutoLibrarySortApiField() async {
    final sortField = await _androidAutoLibrarySortField();
    return _androidAutoSortFieldToApiSort[sortField] ?? _androidAutoSortFieldToApiSort[_androidAutoSortFieldTitle]!;
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

  Future<String> _androidAutoLibraryNameForId(String libraryId) async {
    final libraries = await _androidAutoFetchLibraries();
    for (final library in libraries) {
      if (library.id == libraryId) {
        return library.name;
      }
    }
    return 'Library';
  }
}
