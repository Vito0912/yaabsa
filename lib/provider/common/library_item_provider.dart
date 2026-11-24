import 'dart:async';

import 'package:dio/dio.dart';
import 'package:yaabsa/util/lru_cache.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library/request/library_sort.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/local_cover_path.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';

part 'library_item_provider.freezed.dart';
part 'library_item_provider.g.dart';
part 'library_item_details.dart';
part 'library_item_mutations.dart';

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
final Map<String, LibraryItem> _liveLibraryItemSnapshotById = LruCache<String, LibraryItem>();
final Set<String> _removedLibraryItemIds = <String>{};

LibraryItem? getLiveLibraryItemSnapshot(String itemId) {
  return _liveLibraryItemSnapshotById[itemId];
}

@riverpod
class LibraryItemsNotifier extends _$LibraryItemsNotifier {
  bool _isEnsuringIndex = false;
  bool _replacingItems = false;
  bool _recordingMutations = false;
  int _requestGeneration = 0;
  CancelToken? _requestToken;
  LibraryItemState? _requestedState;
  final Map<String, LibraryItemMutation> _pendingMutations = {};

  int _beginRequest() {
    _requestToken?.cancel('Library request superseded');
    _requestToken = CancelToken();
    _pendingMutations.clear();
    _recordingMutations = true;
    return ++_requestGeneration;
  }

  bool _isCurrentRequest(int generation) {
    return ref.mounted && generation == _requestGeneration;
  }

  LibraryItemState _resolvePendingMutations(LibraryItemState next) {
    _recordingMutations = false;
    final mutations = _pendingMutations.values.toList(growable: false);
    _pendingMutations.clear();
    var resolved = next;
    for (final mutation in mutations) {
      final result = _mutateLibraryItems(resolved, mutation, libraryId: libraryId);
      if (result.reload) {
        final operationRef = ref;
        Future.microtask(() {
          if (operationRef.mounted) {
            operationRef.invalidateSelf();
          }
        });
      }
      resolved = result.state ?? resolved;
    }
    return resolved;
  }

  void _publishItems(LibraryItemState next) {
    state = AsyncData(_resolvePendingMutations(next));
  }

  Future<LibraryItemState> _fetchItems(
    String libraryId,
    int page, {
    String? sort,
    int? desc,
    String? filter,
    bool useCurrentFilterFallback = true,
    bool forceServer = false,
    int? collapseseries,
    String? include,
  }) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final requestToken = _requestToken;
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
      final response = await absApi.getLibraryApi().getLibraryItems(
        libraryId,
        request,
        cancelToken: requestToken,
        extra: forceServer || request.filter == 'issues' ? const <String, dynamic>{'doNotCache': true} : null,
      );
      final cancellation = requestToken?.cancelError;
      if (cancellation != null) {
        throw cancellation;
      }
      final data = response.data;
      if (data == null) {
        throw Exception('No data received from API');
      }

      final totalResults = data.total ?? 0;
      final latestItems = state.asData?.value.items ?? currentVal?.items ?? <LibraryItem>[];
      final List<LibraryItem> newItems = page == 0
          ? List<LibraryItem>.from(data.results)
          : <LibraryItem>[...latestItems, ...data.results];

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
    _beginRequest();
    _replacingItems = false;
    _requestedState = null;

    final retention = ref.keepAlive();
    Timer? retentionTimer;
    ref.onCancel(() {
      retentionTimer = Timer(const Duration(minutes: 10), retention.close);
    });
    ref.onResume(() => retentionTimer?.cancel());
    ref.onDispose(() {
      retentionTimer?.cancel();
    });
    ref.onDispose(() {
      _requestGeneration++;
      _requestToken?.cancel('Library provider disposed');
    });
    ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
      if (next == null) {
        return;
      }

      _applyLibraryItemMutation(next);
    });

    final generation = _requestGeneration;
    try {
      final initial = await _fetchItems(
        libraryId,
        0,
        sort: initialSort ?? defaultLibrarySortWireValue,
        desc: initialDesc ?? defaultLibrarySortDesc,
        filter: initialFilter,
        collapseseries: initialCollapseSeries,
        include: initialInclude,
      );
      if (!_isCurrentRequest(generation)) {
        return initial;
      }
      return _resolvePendingMutations(initial);
    } finally {
      if (_isCurrentRequest(generation)) {
        _recordingMutations = false;
        _pendingMutations.clear();
      }
    }
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (_replacingItems ||
        currentState == null ||
        !currentState.hasNextPage ||
        currentState.isLoadingNextPage ||
        currentState.libraryId == null) {
      return;
    }

    final generation = _beginRequest();
    state = AsyncData(currentState.copyWith(isLoadingNextPage: true, error: null, stackTrace: null));

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
      if (_isCurrentRequest(generation)) {
        _publishItems(nextPageData);
      }
    } catch (e, s) {
      if (_isCurrentRequest(generation)) {
        _recordingMutations = false;
        _pendingMutations.clear();
        final latest = state.value ?? currentState;
        state = AsyncData(latest.copyWith(isLoadingNextPage: false, error: e, stackTrace: s));
      }
    }
  }

  Future<void> ensureLoadedForIndex(int index) async {
    if (index < 0 || _isEnsuringIndex) {
      return;
    }

    _isEnsuringIndex = true;
    try {
      while (ref.mounted) {
        final currentState = state.value;
        if (currentState == null ||
            currentState.error != null ||
            currentState.libraryId == null ||
            !currentState.hasNextPage ||
            currentState.isLoadingNextPage ||
            index < currentState.items.length) {
          break;
        }

        final previousPage = currentState.currentPage;
        final generation = _requestGeneration;
        await fetchNextPage();
        if (!ref.mounted) {
          break;
        }
        final next = state.value;
        if (next == null || next.error != null || next.currentPage <= previousPage) {
          break;
        }
        if (_replacingItems || _requestGeneration != generation + 1) {
          break;
        }
      }
    } finally {
      _isEnsuringIndex = false;
    }
  }

  void _applyLibraryItemMutation(LibraryItemMutation mutation) {
    if (_recordingMutations) {
      _pendingMutations[mutation.itemId] = mutation;
    }
    final current = state.asData?.value;
    if (current == null) {
      return;
    }

    final result = _mutateLibraryItems(current, mutation, libraryId: libraryId);
    if (result.reload) {
      ref.invalidateSelf();
      return;
    }
    final next = result.state;
    if (next != null) {
      state = AsyncData(next);
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
    final visibleState = state.asData?.value;
    final currentLoadedState = _requestedState ?? visibleState;
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

    final generation = _beginRequest();
    _replacingItems = true;
    _requestedState = (currentLoadedState ?? LibraryItemState(currentPage: 0, hasNextPage: false)).copyWith(
      libraryId: targetLibraryId,
      sort: newSort,
      desc: newDesc,
      filter: newFilter,
      collapseseries: newCollapseSeries,
      include: newInclude,
    );

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
      if (!_isCurrentRequest(generation)) {
        return;
      }
      _publishItems(newState);
    } catch (e, s) {
      if (!_isCurrentRequest(generation)) {
        return;
      }
      if (visibleState != null) {
        state = AsyncData(visibleState.copyWith(isLoadingNextPage: false, error: e, stackTrace: s));
      } else {
        state = AsyncError<LibraryItemState>(e, s);
      }
    } finally {
      if (_isCurrentRequest(generation)) {
        _recordingMutations = false;
        _pendingMutations.clear();
        _replacingItems = false;
        _requestedState = null;
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
    final visibleState = state.asData?.value;
    final currentLoadedState = _requestedState ?? visibleState;
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

    final generation = _beginRequest();
    _replacingItems = true;
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
        forceServer: true,
      );
      if (!_isCurrentRequest(generation)) {
        return;
      }
      _publishItems(newState);
    } catch (e, s) {
      if (!_isCurrentRequest(generation)) {
        return;
      }
      if (visibleState != null) {
        state = AsyncData(visibleState.copyWith(isLoadingNextPage: false, error: e, stackTrace: s));
      } else {
        state = AsyncError(e, s);
      }
    } finally {
      if (_isCurrentRequest(generation)) {
        _recordingMutations = false;
        _pendingMutations.clear();
        _replacingItems = false;
        _requestedState = null;
      }
    }
  }
}

bool _isSeriesFilterQuery(String? filter) {
  final parsed = parseGroupedLibraryFilterQuery(filter);
  return parsed?.group == LibraryFilterGroup.series;
}
