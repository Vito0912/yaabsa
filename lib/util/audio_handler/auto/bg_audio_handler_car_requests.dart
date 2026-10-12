part of '../bg_audio_handler.dart';

Future<T> _carBrowseRequest<T>(
  BGAudioHandler handler,
  String key,
  Future<T> Function() loader, {
  Duration maxAge = const Duration(seconds: 30),
  Duration timeout = const Duration(seconds: 6),
}) async {
  if (kIsWeb || !Platform.isAndroid) {
    return loader();
  }

  final now = DateTime.now();
  final cached = handler._carBrowseRequests[key];
  if (cached != null && now.difference(cached.startedAt) < maxAge) {
    return (await cached.future) as T;
  }

  final generation = handler._androidAutoBrowseCache.generation;
  final api = handler._ref.read(absApiProvider);
  late final Future<T> request;
  request = () async {
    try {
      if (Zone.current[#carBrowseRequest] == true && !await _androidAutoIsAutomotiveSystem()) {
        final type = await const MethodChannel('com.ryanheise.audio_service.client.methods')
            .invokeMethod<int>('getCarConnectionType');

        if (type != 2) {
          throw PlatformException(code: 'car_disconnected', message: 'Connect to Android Auto to browse.');
        }
      }

      final result = await loader().timeout(timeout);

      if (handler._isDisposing ||
          generation != handler._androidAutoBrowseCache.generation ||
          !identical(api, handler._ref.read(absApiProvider))) {
        throw const AndroidAutoBrowseStaleRequestException();
      }

      return result;
    } catch (_) {
      if (identical(handler._carBrowseRequests[key]?.future, request)) {
        handler._carBrowseRequests.remove(key);
      }

      rethrow;
    }
  }();

  handler._carBrowseRequests[key] = (startedAt: now, future: request);

  if (handler._carBrowseRequests.length > 128) {
    handler._carBrowseRequests.remove(handler._carBrowseRequests.keys.first);
  }

  return request;
}

extension _BGAudioHandlerCarRequests on BGAudioHandler {
  Future<List<Library>> _androidAutoFetchLibraries({String? include, bool rethrowOnError = false}) {
    return _carBrowseRequest(
      this,
      'libraries/$include/$rethrowOnError',
      () => _androidAutoFetchLibrariesLive(include: include, rethrowOnError: rethrowOnError),
    );
  }

  Future<List<MediaItem>> _androidAutoFetchContinueItems() {
    return _carBrowseRequest(this, 'continue', _androidAutoFetchContinueItemsLive);
  }

  Future<PersonalizedLibrary?> _androidAutoFetchPersonalizedLibrary(String libraryId) {
    return _carBrowseRequest(
      this,
      'personalized/$libraryId',
      () => _androidAutoFetchPersonalizedLibraryLive(libraryId),
    );
  }

  Future<LibraryFilterData?> _androidAutoFetchFilterData(String libraryId) {
    return _carBrowseRequest(this, 'filters/$libraryId', () => _androidAutoFetchFilterDataLive(libraryId));
  }

  Future<List<Collection>> _androidAutoFetchCollectionsForLibrary(String libraryId) {
    return _carBrowseRequest(
      this,
      'collections/$libraryId',
      () => _androidAutoFetchCollectionsForLibraryLive(libraryId),
    );
  }

  Future<List<Playlist>> _androidAutoFetchPlaylistsForLibrary(String libraryId) {
    return _carBrowseRequest(this, 'playlists/$libraryId', () => _androidAutoFetchPlaylistsForLibraryLive(libraryId));
  }

  Future<_AndroidAutoSeriesPage> _androidAutoFetchSeriesPageForLibrary(
    String libraryId,
    _AndroidAutoPagingOptions paging,
  ) {
    return _carBrowseRequest(
      this,
      'series/$libraryId/${paging.page}/${paging.pageSize}',
      () => _androidAutoFetchSeriesPageForLibraryLive(libraryId, paging),
    );
  }

  Future<_AndroidAutoLibraryItemsPage> _androidAutoFetchLibraryItemsPage({
    required String libraryId,
    required _AndroidAutoPagingOptions paging,
    String? sort,
    int? desc,
    String? filter,
    int? collapseseries,
    String? include,
  }) {
    final key = jsonEncode([
      'items',
      libraryId,
      paging.page,
      paging.pageSize,
      sort,
      desc,
      filter,
      collapseseries,
      include,
    ]);

    return _carBrowseRequest(
      this,
      key,
      () => _androidAutoFetchLibraryItemsPageLive(
        libraryId: libraryId,
        paging: paging,
        sort: sort,
        desc: desc,
        filter: filter,
        collapseseries: collapseseries,
        include: include,
      ),
    );
  }

  Future<List<LibraryItem>> _androidAutoFetchAllLibraryItems({
    required String libraryId,
    required String sort,
    required int desc,
    String? filter,
    int? collapseseries,
    String? include,
  }) {
    final key = jsonEncode(['all-items', libraryId, sort, desc, filter, collapseseries, include]);

    return _carBrowseRequest(
      this,
      key,
      () => _androidAutoFetchAllLibraryItemsLive(
        libraryId: libraryId,
        sort: sort,
        desc: desc,
        filter: filter,
        collapseseries: collapseseries,
        include: include,
      ),
      maxAge: const Duration(minutes: 5),
      timeout: const Duration(seconds: 30),
    );
  }
}
