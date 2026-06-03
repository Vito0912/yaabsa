import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';
import 'package:yaabsa/util/library_item_mutation_helpers.dart';

const int _seriesPerPage = 20;
const int _seriesBooksPerPage = 20;
const String _defaultSeriesBooksSort = 'sequence';
const int _defaultSeriesBooksDesc = 0;

final seriesByIdProvider = FutureProvider.family<Series, String>((ref, seriesId) async {
  final absApi = ref.watch(absApiProvider);

  ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
    if (next != null && mutationAffectsSeries(next, seriesId)) {
      ref.invalidateSelf();
    }
  });

  if (absApi == null) {
    throw Exception('User not authenticated or API not available.');
  }

  final response = await absApi.getLibraryApi().getSeriesById(seriesId);
  final data = response.data;
  if (data == null) {
    throw Exception('No series details data received from API.');
  }

  return data;
});

class SeriesState {
  const SeriesState({
    this.items = const <Series>[],
    required this.currentPage,
    required this.hasNextPage,
    required this.libraryId,
    this.sort,
    this.desc,
    this.filter,
    this.include,
    this.error,
    this.stackTrace,
    this.isLoadingNextPage = false,
    this.totalItems = 0,
  });

  final List<Series> items;
  final int currentPage;
  final bool hasNextPage;
  final String libraryId;
  final String? sort;
  final int? desc;
  final String? filter;
  final String? include;
  final Object? error;
  final StackTrace? stackTrace;
  final bool isLoadingNextPage;
  final int totalItems;

  SeriesState copyWith({
    List<Series>? items,
    int? currentPage,
    bool? hasNextPage,
    String? libraryId,
    String? sort,
    int? desc,
    String? filter,
    String? include,
    Object? error,
    StackTrace? stackTrace,
    bool? isLoadingNextPage,
    int? totalItems,
  }) {
    return SeriesState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      libraryId: libraryId ?? this.libraryId,
      sort: sort ?? this.sort,
      desc: desc ?? this.desc,
      filter: filter ?? this.filter,
      include: include ?? this.include,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

@immutable
class SeriesBooksArgs {
  const SeriesBooksArgs({required this.libraryId, required this.seriesId});

  final String libraryId;
  final String seriesId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SeriesBooksArgs && other.libraryId == libraryId && other.seriesId == seriesId;
  }

  @override
  int get hashCode => Object.hash(libraryId, seriesId);
}

class SeriesBooksState {
  const SeriesBooksState({
    this.items = const <LibraryItem>[],
    required this.currentPage,
    required this.hasNextPage,
    required this.libraryId,
    required this.seriesId,
    required this.totalItems,
    required this.sort,
    required this.desc,
    this.error,
    this.stackTrace,
    this.isLoadingNextPage = false,
  });

  final List<LibraryItem> items;
  final int currentPage;
  final bool hasNextPage;
  final String libraryId;
  final String seriesId;
  final int totalItems;
  final String sort;
  final int desc;
  final Object? error;
  final StackTrace? stackTrace;
  final bool isLoadingNextPage;

  SeriesBooksState copyWith({
    List<LibraryItem>? items,
    int? currentPage,
    bool? hasNextPage,
    String? libraryId,
    String? seriesId,
    int? totalItems,
    String? sort,
    int? desc,
    Object? error,
    StackTrace? stackTrace,
    bool? isLoadingNextPage,
  }) {
    return SeriesBooksState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      libraryId: libraryId ?? this.libraryId,
      seriesId: seriesId ?? this.seriesId,
      totalItems: totalItems ?? this.totalItems,
      sort: sort ?? this.sort,
      desc: desc ?? this.desc,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
    );
  }
}

final seriesBooksProvider = AsyncNotifierProvider.family<SeriesBooksNotifier, SeriesBooksState, SeriesBooksArgs>(
  SeriesBooksNotifier.new,
);

class SeriesBooksNotifier extends AsyncNotifier<SeriesBooksState> {
  SeriesBooksNotifier(this.args);

  final SeriesBooksArgs args;
  bool _isEnsuringIndex = false;

  Future<SeriesBooksState> _fetchPage(int page, {String? sort, int? desc, bool forceServer = false}) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final currentVal = state.asData?.value;
    final request = LibraryItemsRequest(
      limit: _seriesBooksPerPage,
      page: page,
      sort: sort ?? currentVal?.sort ?? _defaultSeriesBooksSort,
      desc: desc ?? currentVal?.desc ?? _defaultSeriesBooksDesc,
      filter: LibraryFilter.grouped(LibraryFilterGroup.series, args.seriesId).queryValue,
      collapseseries: 0,
    );

    final response = await absApi.getLibraryApi().getLibraryItems(
      args.libraryId,
      request,
      extra: forceServer ? {'noCache': true} : null,
    );
    final data = response.data;
    if (data == null) {
      throw Exception('No series books data received from API.');
    }

    final totalResults = data.total ?? 0;
    final fetchedItems = data.results;

    final newItems = page == 0
        ? List<LibraryItem>.from(fetchedItems)
        : <LibraryItem>[...(currentVal?.items ?? const <LibraryItem>[]), ...fetchedItems];

    return SeriesBooksState(
      items: newItems,
      currentPage: page,
      hasNextPage: totalResults > newItems.length,
      libraryId: args.libraryId,
      seriesId: args.seriesId,
      totalItems: totalResults,
      sort: request.sort ?? _defaultSeriesBooksSort,
      desc: request.desc ?? _defaultSeriesBooksDesc,
      isLoadingNextPage: false,
    );
  }

  @override
  Future<SeriesBooksState> build() async {
    ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
      if (next == null) {
        return;
      }

      if (next.libraryId != null && next.libraryId != args.libraryId) {
        return;
      }

      final currentState = state.asData?.value;
      if (currentState == null) return;

      final affectsThis = mutationAffectsSeries(next, args.seriesId);
      if (!affectsThis) return;

      final index = currentState.items.indexWhere((i) => i.id == next.itemId);

      if (index != -1) {
        final page = index ~/ _seriesBooksPerPage;
        _refetchSpecificPage(page);
      } else if (next.type == LibraryItemMutationType.added || next.type == LibraryItemMutationType.updated) {
        _refetchSpecificPage(0);
      }
    });

    return _fetchPage(0, sort: _defaultSeriesBooksSort, desc: _defaultSeriesBooksDesc);
  }

  Future<void> _refetchSpecificPage(int page) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final absApi = ref.read(absApiProvider);
    if (absApi == null) return;

    try {
      final request = LibraryItemsRequest(
        limit: _seriesBooksPerPage,
        page: page,
        sort: currentState.sort,
        desc: currentState.desc,
        filter: LibraryFilter.grouped(LibraryFilterGroup.series, args.seriesId).queryValue,
        collapseseries: 0,
      );

      final response = await absApi.getLibraryApi().getLibraryItems(args.libraryId, request, extra: {'noCache': true});

      final data = response.data;
      if (data == null) return;

      final fetchedItems = data.results;
      final newItems = List<LibraryItem>.from(currentState.items);
      final startIndex = page * _seriesBooksPerPage;

      if (startIndex < newItems.length) {
        final endIndex = (startIndex + _seriesBooksPerPage).clamp(0, newItems.length);
        newItems.replaceRange(startIndex, endIndex, fetchedItems);
      } else if (startIndex == newItems.length) {
        newItems.addAll(fetchedItems);
      }

      state = AsyncData(currentState.copyWith(items: newItems, totalItems: data.total ?? currentState.totalItems));
    } catch (_) {}
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (currentState == null || !currentState.hasNextPage || currentState.isLoadingNextPage) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingNextPage: true));

    try {
      final nextPage = await _fetchPage(currentState.currentPage + 1, sort: currentState.sort, desc: currentState.desc);
      state = AsyncData(nextPage);
    } catch (e, s) {
      state = AsyncData(currentState.copyWith(isLoadingNextPage: false, error: e, stackTrace: s));
    }
  }

  Future<void> refresh({bool withLoading = true, bool forceServer = false}) async {
    final currentState = state.value;
    if (currentState == null) return;

    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchPage(0, sort: currentState.sort, desc: currentState.desc, forceServer: forceServer);
      state = AsyncData(refreshed);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> setSort(String newSort, {int? newDesc}) async {
    final currentState = state.value;
    if (currentState == null) {
      return;
    }

    final resolvedDesc = newDesc ?? currentState.desc;
    if (currentState.sort == newSort && currentState.desc == resolvedDesc) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingNextPage: true));

    try {
      final sorted = await _fetchPage(0, sort: newSort, desc: resolvedDesc);
      state = AsyncData(sorted);
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
}

final seriesProvider = AsyncNotifierProvider.family<SeriesNotifier, SeriesState, String>(SeriesNotifier.new);

class SeriesNotifier extends AsyncNotifier<SeriesState> {
  SeriesNotifier(this.libraryId);

  final String libraryId;
  bool _isEnsuringIndex = false;

  Future<SeriesState> _fetchSeries(
    int page, {
    String? sort,
    int? desc,
    String? filter,
    String? include,
    bool forceServer = false,
  }) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final currentVal = state.asData?.value;
    final request = LibraryItemsRequest(
      limit: _seriesPerPage,
      page: page,
      sort: sort ?? currentVal?.sort,
      desc: desc ?? currentVal?.desc,
      filter: normalizeLibraryFilterQuery(filter ?? currentVal?.filter),
      include: include ?? currentVal?.include,
    );

    final response = await absApi.getLibraryApi().getLibrarySeries(
      libraryId,
      request,
      extra: forceServer ? {'noCache': true} : null,
    );
    final data = response.data;
    if (data == null) {
      throw Exception('No series data received from API.');
    }

    final totalResults = data.total;
    final fetchedSeries = data.results;

    final newItems = page == 0
        ? List<Series>.from(fetchedSeries)
        : <Series>[...(currentVal?.items ?? const <Series>[]), ...fetchedSeries];

    return SeriesState(
      items: newItems,
      currentPage: page,
      hasNextPage: totalResults > newItems.length,
      libraryId: libraryId,
      sort: request.sort,
      desc: request.desc,
      filter: request.filter,
      include: request.include,
      totalItems: totalResults,
      isLoadingNextPage: false,
    );
  }

  @override
  Future<SeriesState> build() async {
    ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
      if (next == null) {
        return;
      }

      if (next.libraryId != null && next.libraryId != libraryId) {
        return;
      }

      final currentState = state.asData?.value;
      if (currentState == null) return;

      bool affectsList = mutationAffectsSeriesList(next);
      if (!affectsList) return;

      final pagesToRefresh = <int>{};

      for (int i = 0; i < currentState.items.length; i++) {
        final series = currentState.items[i];
        if (mutationAffectsSeries(next, series.id)) {
          pagesToRefresh.add(i ~/ _seriesPerPage);
        }
      }

      if (pagesToRefresh.isNotEmpty) {
        for (final page in pagesToRefresh) {
          _refetchSpecificPage(page);
        }
      } else if (next.type == LibraryItemMutationType.added || next.type == LibraryItemMutationType.updated) {
        _refetchSpecificPage(0);
      }
    });

    return _fetchSeries(0, sort: 'name', desc: 0);
  }

  Future<void> _refetchSpecificPage(int page) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final absApi = ref.read(absApiProvider);
    if (absApi == null) return;

    try {
      final request = LibraryItemsRequest(
        limit: _seriesPerPage,
        page: page,
        sort: currentState.sort,
        desc: currentState.desc,
        filter: normalizeLibraryFilterQuery(currentState.filter),
        include: currentState.include,
      );

      final response = await absApi.getLibraryApi().getLibrarySeries(libraryId, request, extra: {'noCache': true});

      final data = response.data;
      if (data == null) return;

      final fetchedItems = data.results;
      final newItems = List<Series>.from(currentState.items);
      final startIndex = page * _seriesPerPage;

      if (startIndex < newItems.length) {
        final endIndex = (startIndex + _seriesPerPage).clamp(0, newItems.length);
        newItems.replaceRange(startIndex, endIndex, fetchedItems);
      } else if (startIndex == newItems.length) {
        newItems.addAll(fetchedItems);
      }

      state = AsyncData(currentState.copyWith(items: newItems, totalItems: data.total));
    } catch (_) {}
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (currentState == null || !currentState.hasNextPage || currentState.isLoadingNextPage) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingNextPage: true));

    try {
      final nextPage = await _fetchSeries(
        currentState.currentPage + 1,
        sort: currentState.sort,
        desc: currentState.desc,
        filter: currentState.filter,
        include: currentState.include,
      );
      state = AsyncData(nextPage);
    } catch (e, s) {
      state = AsyncData(currentState.copyWith(isLoadingNextPage: false, error: e, stackTrace: s));
    }
  }

  Future<void> refresh({bool withLoading = true, bool forceServer = false}) async {
    final currentState = state.value;
    if (currentState == null) return;

    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchSeries(
        0,
        sort: currentState.sort,
        desc: currentState.desc,
        filter: currentState.filter,
        include: currentState.include,
        forceServer: forceServer,
      );
      state = AsyncData(refreshed);
    } catch (e, s) {
      state = AsyncError(e, s);
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
}
