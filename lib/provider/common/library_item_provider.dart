import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library/request/library_sort.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/local_cover_path.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';

part 'library_item_provider.freezed.dart';
part 'library_item_provider.g.dart';

const int _itemsPerPage = 20;

@freezed
abstract class LibraryItemState with _$LibraryItemState {
  const factory LibraryItemState({
    @Default([]) List<LibraryItem> items,
    required int currentPage,
    required bool hasNextPage,
    String? libraryId,
    String? sort,
    int? desc,
    String? filter,
    int? collapseseries,
    String? include,
    Object? error,
    StackTrace? stackTrace,
    @Default(false) bool isLoadingNextPage,
    @Default(0) int totalItems,
  }) = _LibraryItemState;
}

const defaultLibraryItemsRequest = LibraryItemsRequest(limit: _itemsPerPage, page: 0);
final Map<String, LibraryItem> _liveLibraryItemSnapshotById = <String, LibraryItem>{};
final Set<String> _removedLibraryItemIds = <String>{};

LibraryItem? getLiveLibraryItemSnapshot(String itemId) {
  return _liveLibraryItemSnapshotById[itemId];
}

@Riverpod(keepAlive: true)
class LibraryItemsNotifier extends _$LibraryItemsNotifier {
  bool _isEnsuringIndex = false;

  Future<LibraryItemState> _fetchItems(
    String libraryId,
    int page, {
    String? sort,
    int? desc,
    String? filter,
    bool useCurrentFilterFallback = true,
    int? collapseseries,
    String? include,
  }) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final currentVal = state.asData?.value;
    final resolvedSort = sort ?? currentVal?.sort ?? defaultLibrarySortWireValue;
    final resolvedDesc = desc ?? currentVal?.desc ?? defaultLibrarySortDesc;
    final request = LibraryItemsRequest(
      limit: _itemsPerPage,
      page: page,
      sort: resolvedSort,
      desc: resolvedDesc,
      filter: normalizeLibraryFilterQuery(useCurrentFilterFallback ? (filter ?? currentVal?.filter) : filter),
      collapseseries: collapseseries ?? currentVal?.collapseseries,
      include: include ?? currentVal?.include,
    );

    try {
      final response = await absApi.getLibraryApi().getLibraryItems(libraryId, request);
      final data = response.data;
      if (data == null) {
        throw Exception('No data received from API');
      }

      final totalResults = data.total ?? 0;
      final List<LibraryItem> newItems = page == 0
          ? List<LibraryItem>.from(data.results)
          : <LibraryItem>[...(currentVal?.items ?? <LibraryItem>[]), ...data.results];

      return LibraryItemState(
        items: newItems,
        currentPage: page,
        hasNextPage: totalResults > newItems.length,
        libraryId: libraryId,
        sort: request.sort,
        desc: request.desc,
        filter: request.filter,
        collapseseries: request.collapseseries,
        include: request.include,
        totalItems: totalResults,
        isLoadingNextPage: false,
      );
    } catch (e, s) {
      throw Exception('Failed to fetch library items: $e, Stack: $s');
    }
  }

  @override
  Future<LibraryItemState> build(
    String libraryId, {
    String? initialSort,
    int? initialDesc,
    String? initialFilter,
    int? initialCollapseSeries,
    String? initialInclude,
  }) async {
    ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
      if (next == null) {
        return;
      }

      _applyLibraryItemMutation(next);
    });

    return _fetchItems(
      libraryId,
      0,
      sort: initialSort ?? defaultLibrarySortWireValue,
      desc: initialDesc ?? defaultLibrarySortDesc,
      filter: initialFilter,
      collapseseries: initialCollapseSeries,
      include: initialInclude,
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (currentState == null ||
        !currentState.hasNextPage ||
        currentState.isLoadingNextPage ||
        currentState.libraryId == null) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingNextPage: true));

    try {
      final nextPageData = await _fetchItems(
        currentState.libraryId!,
        currentState.currentPage + 1,
        sort: currentState.sort,
        desc: currentState.desc,
        filter: currentState.filter,
        collapseseries: currentState.collapseseries,
        include: currentState.include,
      );
      state = AsyncData(nextPageData);
    } catch (e, s) {
      state = AsyncData(currentState.copyWith(isLoadingNextPage: false, error: e, stackTrace: s));
    }
  }

  Future<void> ensureLoadedForIndex(int index) async {
    if (index < 0 || _isEnsuringIndex) {
      return;
    }

    _isEnsuringIndex = true;
    try {
      while (true) {
        final currentState = state.value;
        if (currentState == null ||
            currentState.libraryId == null ||
            !currentState.hasNextPage ||
            currentState.isLoadingNextPage ||
            index < currentState.items.length) {
          break;
        }

        await fetchNextPage();
      }
    } finally {
      _isEnsuringIndex = false;
    }
  }

  void _applyLibraryItemMutation(LibraryItemMutation mutation) {
    final currentLoadedState = state.asData?.value;
    if (currentLoadedState == null) {
      return;
    }

    final stateLibraryId = currentLoadedState.libraryId ?? libraryId;
    final mutationLibraryId = mutation.libraryId?.trim();
    final hasLibraryMismatch =
        mutationLibraryId != null &&
        mutationLibraryId.isNotEmpty &&
        stateLibraryId.isNotEmpty &&
        mutationLibraryId != stateLibraryId;

    final existingIndex = currentLoadedState.items.indexWhere((item) => item.id == mutation.itemId);
    if (hasLibraryMismatch && existingIndex == -1) {
      return;
    }

    final nextItems = List<LibraryItem>.from(currentLoadedState.items);
    var nextTotal = currentLoadedState.totalItems;
    var didChange = false;

    switch (mutation.type) {
      case LibraryItemMutationType.added:
        final item = mutation.item;
        if (item == null || hasLibraryMismatch) {
          return;
        }

        if (existingIndex >= 0) {
          nextItems[existingIndex] = item;
          didChange = true;
          break;
        }

        if (!_shouldInsertAddedItem(currentLoadedState)) {
          return;
        }

        nextItems.insert(0, item);
        nextTotal += 1;
        didChange = true;
        break;
      case LibraryItemMutationType.updated:
        final item = mutation.item;
        if (item == null || existingIndex == -1) {
          return;
        }

        nextItems[existingIndex] = item;
        didChange = true;
        break;
      case LibraryItemMutationType.removed:
        if (existingIndex == -1) {
          return;
        }

        nextItems.removeAt(existingIndex);
        nextTotal = nextTotal > 0 ? nextTotal - 1 : 0;
        didChange = true;
        break;
    }

    if (!didChange) {
      return;
    }

    state = AsyncData(
      currentLoadedState.copyWith(
        items: nextItems,
        totalItems: nextTotal,
        hasNextPage: nextTotal > nextItems.length,
        error: null,
        stackTrace: null,
      ),
    );
  }

  bool _shouldInsertAddedItem(LibraryItemState currentLoadedState) {
    final activeFilter = currentLoadedState.filter?.trim();
    if (activeFilter != null && activeFilter.isNotEmpty) {
      return false;
    }

    final activeSort = currentLoadedState.sort ?? defaultLibrarySortWireValue;
    final activeDesc = currentLoadedState.desc ?? defaultLibrarySortDesc;
    return activeSort == defaultLibrarySortWireValue && activeDesc == 1;
  }

  Future<void> _updateAndRefetch({
    String? sort,
    int? desc,
    String? filter,
    int? collapseseries,
    String? include,
    bool clearFilter = false,
  }) async {
    final currentLoadedState = state.asData?.value;
    final targetLibraryId = currentLoadedState?.libraryId ?? libraryId;

    final newFilter = clearFilter
        ? null
        : (filter ?? (currentLoadedState != null ? currentLoadedState.filter : initialFilter));
    var newSort =
        sort ?? (currentLoadedState != null ? currentLoadedState.sort : initialSort) ?? defaultLibrarySortWireValue;
    var newDesc =
        desc ?? (currentLoadedState != null ? currentLoadedState.desc : initialDesc) ?? defaultLibrarySortDesc;

    if (newSort == LibrarySortValue.sequence.wireValue && !_isSeriesFilterQuery(newFilter)) {
      newSort = defaultLibrarySortWireValue;
      newDesc = defaultLibrarySortDesc;
    }

    final newCollapseSeries =
        collapseseries ?? (currentLoadedState != null ? currentLoadedState.collapseseries : initialCollapseSeries);
    final newInclude = include ?? (currentLoadedState != null ? currentLoadedState.include : initialInclude);

    if (currentLoadedState == null) {
      state = const AsyncValue.loading();
    }

    try {
      final newState = await _fetchItems(
        targetLibraryId,
        0,
        sort: newSort,
        desc: newDesc,
        filter: newFilter,
        useCurrentFilterFallback: false,
        collapseseries: newCollapseSeries,
        include: newInclude,
      );
      state = AsyncData(newState);
    } catch (e, s) {
      if (currentLoadedState != null) {
        state = AsyncData(currentLoadedState.copyWith(error: e, stackTrace: s));
      } else {
        state = AsyncError<LibraryItemState>(e, s);
      }
    }
  }

  Future<void> setSort(String newSort, {int? newDesc}) async {
    await _updateAndRefetch(sort: newSort, desc: newDesc);
  }

  Future<void> setFilter(String newFilter) async {
    await _updateAndRefetch(filter: newFilter);
  }

  Future<void> clearFilter() async {
    await _updateAndRefetch(clearFilter: true);
  }

  Future<void> setCollapseSeries(int newCollapseSeries) async {
    await _updateAndRefetch(collapseseries: newCollapseSeries);
  }

  Future<void> setInclude(String newInclude) async {
    await _updateAndRefetch(include: newInclude);
  }

  Future<void> refresh() async {
    final currentLoadedState = state.asData?.value;
    final targetLibraryId = currentLoadedState?.libraryId ?? libraryId;
    final refreshSort =
        (currentLoadedState != null ? currentLoadedState.sort : initialSort) ?? defaultLibrarySortWireValue;
    final refreshDesc = (currentLoadedState != null ? currentLoadedState.desc : initialDesc) ?? defaultLibrarySortDesc;
    final refreshFilter = currentLoadedState != null ? currentLoadedState.filter : initialFilter;
    final refreshCollapseSeries = currentLoadedState != null
        ? currentLoadedState.collapseseries
        : initialCollapseSeries;
    final refreshInclude = currentLoadedState != null ? currentLoadedState.include : initialInclude;

    if (currentLoadedState == null) {
      state = const AsyncValue.loading();
    }

    try {
      final newState = await _fetchItems(
        targetLibraryId,
        0,
        sort: refreshSort,
        desc: refreshDesc,
        filter: refreshFilter,
        useCurrentFilterFallback: false,
        collapseseries: refreshCollapseSeries,
        include: refreshInclude,
      );
      state = AsyncData(newState);
    } catch (e, s) {
      if (currentLoadedState != null) {
        state = AsyncData(currentLoadedState.copyWith(error: e, stackTrace: s));
      } else {
        state = AsyncError(e, s);
      }
    }
  }
}

bool _isSeriesFilterQuery(String? filter) {
  final parsed = parseGroupedLibraryFilterQuery(filter);
  return parsed?.group == LibraryFilterGroup.series;
}

@riverpod
Future<LibraryItem> libraryItem(Ref ref, String itemId, {String? episodeId}) async {
  final absApi = ref.watch(absApiProvider);
  final db = ref.read(appDatabaseProvider);

  ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
    if (next == null) {
      return;
    }

    switch (next.type) {
      case LibraryItemMutationType.added:
      case LibraryItemMutationType.updated:
        final nextItem = next.item;
        if (nextItem == null) {
          return;
        }

        _liveLibraryItemSnapshotById[nextItem.id] = nextItem;
        _removedLibraryItemIds.remove(nextItem.id);
        break;
      case LibraryItemMutationType.removed:
        _liveLibraryItemSnapshotById.remove(next.itemId);
        _removedLibraryItemIds.add(next.itemId);
        break;
    }

    if (next.itemId == itemId) {
      ref.invalidateSelf();
    }
  });

  if (_removedLibraryItemIds.contains(itemId)) {
    throw StateError('Library item $itemId was removed.');
  }

  final liveSnapshot = _liveLibraryItemSnapshotById[itemId];
  if (liveSnapshot != null) {
    return liveSnapshot;
  }

  if (absApi == null || absApi.user == null) {
    throw Exception('User not authenticated or API not available.');
  }

  final download = await db.getStoredDownload(itemId, absApi.user!.id, episodeId: episodeId);
  if (download != null && download.item != null) {
    final resolvedCoverPath = await resolveDisplayCoverPath(
      download.coverPath,
      cacheKey: '${absApi.user!.id}:$itemId:${episodeId ?? 'item'}',
    );

    logger('Returning local download for item $itemId', tag: 'libraryItemProvider', level: InfoLevel.debug);
    final localItem = _withLocalCoverPath(download.item!, resolvedCoverPath ?? download.coverPath);
    _liveLibraryItemSnapshotById[itemId] = localItem;
    _removedLibraryItemIds.remove(itemId);
    return localItem;
  }

  try {
    final response = await absApi.getLibraryItemApi().getLibraryItem(itemId: itemId);
    final data = response.data;
    if (data == null) {
      throw Exception('No data received from API for item $itemId');
    }

    _liveLibraryItemSnapshotById[itemId] = data;
    _removedLibraryItemIds.remove(itemId);
    return data;
  } catch (e) {
    throw Exception('Failed to fetch library item $itemId: $e');
  }
}

LibraryItem _withLocalCoverPath(LibraryItem item, String? coverPathOverride) {
  final normalizedCoverPath = coverPathOverride?.trim();
  if (normalizedCoverPath == null || normalizedCoverPath.isEmpty) {
    return item;
  }

  final media = item.media;
  if (media == null) {
    return item;
  }

  final bookMedia = media.bookMedia;
  if (bookMedia != null) {
    if (bookMedia.coverPath == normalizedCoverPath) {
      return item;
    }

    return item.copyWith(
      media: media.copyWith(bookMedia: bookMedia.copyWith(coverPath: normalizedCoverPath)),
    );
  }

  final podcastMedia = media.podcastMedia;
  if (podcastMedia != null) {
    if (podcastMedia.coverPath == normalizedCoverPath) {
      return item;
    }

    return item.copyWith(
      media: media.copyWith(podcastMedia: podcastMedia.copyWith(coverPath: normalizedCoverPath)),
    );
  }

  return item;
}

@Riverpod(keepAlive: true)
Stream<Set<String>> completedDownloadItemIds(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    return Stream<Set<String>>.value(<String>{});
  }

  final db = ref.watch(appDatabaseProvider);
  return db.watchCompletedDownloadItemIdsByUser(user.id);
}
