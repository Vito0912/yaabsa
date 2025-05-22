import 'package:buchshelfly/api/library/request/library_items_request.dart';
import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
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

@Riverpod(keepAlive: true)
class LibraryItemNotifier extends _$LibraryItemNotifier {
  LibraryItemsRequest _constructRequest(String libraryId, int page, {LibraryItemState? S}) {
    final stateForParams = S ?? state.valueOrNull;
    return LibraryItemsRequest(
      limit: _itemsPerPage,
      page: page,
      sort: stateForParams?.sort,
      desc: stateForParams?.desc,
      filter: stateForParams?.filter,
      collapseseries: stateForParams?.collapseseries,
      include: stateForParams?.include,
    );
  }

  Future<LibraryItemState> _fetchItems(
    String libraryId,
    int page, {
    String? sort,
    int? desc,
    String? filter,
    int? collapseseries,
    String? include,
  }) async {
    final absApi = ref.watch(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final currentVal = state.valueOrNull;
    final request = LibraryItemsRequest(
      limit: _itemsPerPage,
      page: page,
      sort: sort ?? currentVal?.sort,
      desc: desc ?? currentVal?.desc,
      filter: filter ?? currentVal?.filter,
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
      final List<LibraryItem> newItems =
          page == 0
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

  Future<void> _updateAndRefetch({
    String? sort,
    int? desc,
    String? filter,
    int? collapseseries,
    String? include,
    bool clearFilter = false,
  }) async {
    final currentLoadedState = state.valueOrNull;
    if (currentLoadedState == null || currentLoadedState.libraryId == null) {
      return;
    }

    final newSort = sort ?? currentLoadedState.sort;
    final newDesc = desc ?? currentLoadedState.desc;
    final newFilter = clearFilter ? null : (filter ?? currentLoadedState.filter);
    final newCollapseSeries = collapseseries ?? currentLoadedState.collapseseries;
    final newInclude = include ?? currentLoadedState.include;

    state = AsyncLoading<LibraryItemState>().copyWithPrevious(state);

    try {
      final newState = await _fetchItems(
        currentLoadedState.libraryId!,
        0,
        sort: newSort,
        desc: newDesc,
        filter: newFilter,
        collapseseries: newCollapseSeries,
        include: newInclude,
      );
      state = AsyncData(newState);
    } catch (e, s) {
      state = AsyncError<LibraryItemState>(e, s).copyWithPrevious(state);
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
    final currentLoadedState = state.valueOrNull;
    if (currentLoadedState == null || currentLoadedState.libraryId == null) {
      return;
    }

    state = const AsyncValue.loading();
    try {
      final newState = await _fetchItems(
        currentLoadedState.libraryId!,
        0,
        sort: currentLoadedState.sort,
        desc: currentLoadedState.desc,
        filter: currentLoadedState.filter,
        collapseseries: currentLoadedState.collapseseries,
        include: currentLoadedState.include,
      );
      state = AsyncData(newState);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
