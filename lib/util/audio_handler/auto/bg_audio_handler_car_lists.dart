part of '../bg_audio_handler.dart';

extension _BGAudioHandlerCarLists on BGAudioHandler {
  Future<List<MediaItem>?> _carPlayListRanges(String libraryId, _AndroidAutoLibraryTab tab) async {
    if (tab != _AndroidAutoLibraryTab.collections && tab != _AndroidAutoLibraryTab.playlists) {
      return null;
    }

    const paging = _AndroidAutoPagingOptions(page: 0, pageSize: carListPageSize, hasExplicitPaging: false);
    try {
      final kind = tab == _AndroidAutoLibraryTab.collections ? 'collections' : 'playlists';
      final int total;
      if (tab == _AndroidAutoLibraryTab.collections) {
        final page = await _androidAutoCollectionPage(libraryId, paging);
        total = page.total;
      } else {
        final page = await _androidAutoPlaylistPage(libraryId, paging);
        total = page.total;
      }
      if (total <= carListPageSize) {
        return [
          _androidAutoBrowsableItem(
            id: _CarBrowsePage(libraryId, kind, 0).id,
            title: tab.label,
            artUri: _androidAutoLibraryTabIconUri(tab),
            categoryStyle: true,
          ),
        ];
      }

      return _carListRanges(libraryId, kind, total);
    } catch (error) {
      logger('Failed to load CarPlay list ranges: $error', tag: 'AudioHandler', level: InfoLevel.warning);
      return [
        _androidAutoBrowsableItem(
          id: _androidAutoLibraryNodeId(libraryId),
          title: tab.label,
          subtitle: 'Unable to load. Select to retry.',
        ),
      ];
    }
  }

  _AndroidAutoPagingOptions _carListPaging(_AndroidAutoPagingOptions paging) {
    if (paging.hasExplicitPaging) {
      return paging;
    }

    return _AndroidAutoPagingOptions(page: 0, pageSize: carListPageSize, hasExplicitPaging: false);
  }

  List<MediaItem>? _carListRangeNodes<T>(
    String libraryId,
    String kind,
    LibraryListPage<T> page,
    _AndroidAutoPagingOptions paging,
  ) {
    if (paging.hasExplicitPaging || page.total <= carListPageSize) {
      return null;
    }

    return _carListRanges(libraryId, kind, page.total);
  }

  List<MediaItem> _carListRanges(String libraryId, String kind, int total) {
    final label = kind == 'collections' ? 'Collections' : 'Playlists';
    return carListRanges(total)
        .map((range) {
          return _androidAutoBrowsableItem(
            id: _CarBrowsePage(libraryId, kind, range.page).id,
            title: '$label ${range.first} to ${range.last}',
          );
        })
        .toList(growable: false);
  }

  Future<LibraryListPage<T>> _carListPage<T>(
    String libraryId,
    String kind,
    _AndroidAutoPagingOptions paging,
    Future<Response<LibraryListPage<T>>> Function(ABSApi api) load,
  ) {
    return _carBrowseRequest(this, '$kind/$libraryId/${paging.page}/${paging.pageSize}', () async {
      final api = _ref.read(absApiProvider);
      if (api == null) {
        throw StateError('Browse API is not ready');
      }

      final page = (await load(api)).data;
      if (page == null) {
        throw const FormatException('Incomplete library list response.');
      }

      return page;
    });
  }

  Future<LibraryListPage<Collection>> _androidAutoCollectionPage(String libraryId, _AndroidAutoPagingOptions paging) {
    return _carListPage(libraryId, 'collections', paging, (api) {
      return api.getListApi().getLibraryCollections(
        libraryId,
        page: paging.page,
        limit: paging.pageSize,
        trimToLimit: true,
        extra: const {'doNotCache': true},
      );
    });
  }

  Future<LibraryListPage<Playlist>> _androidAutoPlaylistPage(String libraryId, _AndroidAutoPagingOptions paging) {
    return _carListPage(libraryId, 'playlists', paging, (api) {
      return api.getListApi().getLibraryPlaylists(
        libraryId,
        page: paging.page,
        limit: paging.pageSize,
        trimToLimit: true,
        extra: const {'doNotCache': true},
      );
    });
  }

  Future<List<T>> _androidAutoAllLists<T>(String libraryId, String kind, Future<List<T>> Function(ABSApi api) load) {
    return _carBrowseRequest(this, '$kind/$libraryId/all', () {
      final api = _ref.read(absApiProvider);
      if (api == null) {
        throw StateError('Browse API is not ready');
      }

      return load(api);
    }, timeout: const Duration(seconds: 30));
  }

  Future<T?> _carListById<T>(
    String libraryId,
    String id,
    String kind,
    Future<Response<T>> Function(ABSApi api) load,
    String Function(T item) libraryOf,
  ) {
    return _carBrowseRequest(this, '$kind/$libraryId/$id', () async {
      final api = _ref.read(absApiProvider);
      if (api == null) {
        throw StateError('Browse API is not ready');
      }

      final T? item;
      try {
        item = (await load(api)).data;
      } on DioException catch (error) {
        final status = error.response?.statusCode;
        if (status == 403 || status == 404) {
          return null;
        }

        rethrow;
      }

      if (item == null || libraryOf(item) != libraryId) {
        return null;
      }

      return item;
    });
  }

  Future<Collection?> _androidAutoCollectionById(String libraryId, String id) {
    return _carListById(
      libraryId,
      id,
      'collection',
      (api) => api.getListApi().getCollection(id, extra: const {'doNotCache': true}),
      (Collection item) => item.libraryId,
    );
  }

  Future<Playlist?> _androidAutoPlaylistById(String libraryId, String id) {
    return _carListById(
      libraryId,
      id,
      'playlist',
      (api) => api.getListApi().getPlaylist(id, extra: const {'doNotCache': true}),
      (Playlist item) => item.libraryId,
    );
  }

  Future<List<MediaItem>> _androidAutoCollectionNodes(String libraryId, _AndroidAutoPagingOptions paging) async {
    final isAutomotive = await _androidAutoIsAutomotiveSystem();
    final List<Collection> collections;
    if (isAutomotive || paging.hasExplicitPaging) {
      final effectivePaging = _carListPaging(paging);
      final page = await _androidAutoCollectionPage(libraryId, effectivePaging);
      final ranges = _carListRangeNodes(libraryId, 'collections', page, effectivePaging);
      if (ranges != null) {
        return ranges;
      }

      collections = page.items;
    } else {
      collections = await _androidAutoAllLists(
        libraryId,
        'collections',
        (api) => api.getListApi().getAllLibraryCollections(libraryId, extra: const {'doNotCache': true}),
      );
    }

    final displayableCollections = isAutomotive
        ? collections
              .where(
                (collection) => _androidAutoMediaItemsFromLibraryItems(
                  collection.items ?? const <LibraryItem>[],
                  subtitlePrefix: '',
                ).isNotEmpty,
              )
              .toList(growable: false)
        : collections;
    return displayableCollections
        .map(
          (collection) => _androidAutoBrowsableItem(
            id: _androidAutoCollectionNodeId(libraryId, collection.id),
            title: collection.name,
          ),
        )
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoPlaylistNodes(String libraryId, _AndroidAutoPagingOptions paging) async {
    final isAutomotive = await _androidAutoIsAutomotiveSystem();
    final List<Playlist> playlists;
    if (isAutomotive || paging.hasExplicitPaging) {
      final effectivePaging = _carListPaging(paging);
      final page = await _androidAutoPlaylistPage(libraryId, effectivePaging);
      final ranges = _carListRangeNodes(libraryId, 'playlists', page, effectivePaging);
      if (ranges != null) {
        return ranges;
      }

      playlists = page.items;
    } else {
      playlists = await _androidAutoAllLists(
        libraryId,
        'playlists',
        (api) => api.getListApi().getAllLibraryPlaylists(libraryId, extra: const {'doNotCache': true}),
      );
    }

    final displayablePlaylists = isAutomotive
        ? playlists
              .where(
                (playlist) => (playlist.items ?? const []).any(
                  (entry) =>
                      entry.libraryItem != null &&
                      _androidAutoIsSupportedAudioItem(entry.libraryItem!) &&
                      (entry.episodeId != null
                          ? entry.episode?.audioFile != null
                          : _androidAutoMediaEntryFromLibraryItem(entry.libraryItem!) != null),
                ),
              )
              .toList(growable: false)
        : playlists;
    return displayablePlaylists
        .map(
          (playlist) =>
              _androidAutoBrowsableItem(id: _androidAutoPlaylistNodeId(libraryId, playlist.id), title: playlist.name),
        )
        .toList(growable: false);
  }
}
