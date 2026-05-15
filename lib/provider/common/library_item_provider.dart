import 'dart:async';

import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library/request/library_sort.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/local_cover_path.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

final Map<String, LibraryItem> _pendingLibraryItemOverridesById = <String, LibraryItem>{};

void applyLibraryItemUpdateLocally({
  required ProviderContainer container,
  required LibraryItem item,
  required void Function() invalidateItemCache,
  LibraryItemsNotifier? listNotifier,
}) {
  _pendingLibraryItemOverridesById[item.id] = item;
  listNotifier?.applyLocalItemUpdate(item);
  invalidateItemCache();
  unawaited(_syncStoredDownloadItemSnapshot(container: container, item: item));
}

Future<void> _syncStoredDownloadItemSnapshot({required ProviderContainer container, required LibraryItem item}) async {
  try {
    final userId = container.read(currentUserProvider).value?.id ?? container.read(absApiProvider)?.user?.id;
    if (userId == null || userId.isEmpty) {
      return;
    }

    await container
        .read(appDatabaseProvider)
        .updateStoredDownloadItemSnapshot(itemId: item.id, userId: userId, item: item);
    await invalidateCachedLibraryItemEntries(container: container, itemId: item.id, libraryId: item.libraryId);
  } catch (e, s) {
    logger(
      'Failed to sync stored download item snapshot for ${item.id}: $e\n$s',
      tag: 'libraryItemProvider',
      level: InfoLevel.warning,
    );
  }
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
    final request = LibraryItemsRequest(
      limit: _itemsPerPage,
      page: page,
      sort: sort ?? currentVal?.sort,
      desc: desc ?? currentVal?.desc,
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
    return _fetchItems(
      libraryId,
      0,
      sort: initialSort,
      desc: initialDesc,
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
    var newSort = sort ?? (currentLoadedState != null ? currentLoadedState.sort : initialSort);
    var newDesc = desc ?? (currentLoadedState != null ? currentLoadedState.desc : initialDesc);

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
    final refreshSort = currentLoadedState != null ? currentLoadedState.sort : initialSort;
    final refreshDesc = currentLoadedState != null ? currentLoadedState.desc : initialDesc;
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

  void applyLocalItemUpdate(LibraryItem updatedItem) {
    final currentLoadedState = state.asData?.value;
    if (currentLoadedState == null) {
      return;
    }

    final existingIndex = currentLoadedState.items.indexWhere((item) => item.id == updatedItem.id);
    if (existingIndex < 0) {
      return;
    }

    final updatedItems = List<LibraryItem>.from(currentLoadedState.items);
    updatedItems[existingIndex] = updatedItem;
    state = AsyncData(currentLoadedState.copyWith(items: updatedItems));
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
  if (absApi == null || absApi.user == null) {
    throw Exception('User not authenticated or API not available.');
  }

  final pendingOverride = _pendingLibraryItemOverridesById.remove(itemId);
  if (pendingOverride != null) {
    logger('Returning pending local override for item $itemId', tag: 'libraryItemProvider', level: InfoLevel.debug);
    return pendingOverride;
  }

  final download = await db.getStoredDownload(itemId, absApi.user!.id, episodeId: episodeId);
  if (download != null && download.item != null) {
    final resolvedCoverPath = await resolveDisplayCoverPath(
      download.coverPath,
      cacheKey: '${absApi.user!.id}:$itemId:${episodeId ?? 'item'}',
    );

    logger('Returning local download for item $itemId', tag: 'libraryItemProvider', level: InfoLevel.debug);
    return _withLocalCoverPath(download.item!, resolvedCoverPath ?? download.coverPath);
  }

  try {
    final response = await absApi.getLibraryItemApi().getLibraryItem(itemId: itemId);
    final data = response.data;
    if (data == null) {
      throw Exception('No data received from API for item $itemId');
    }
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
