import 'package:yaabsa/api/library/author_details.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/library_author.dart';
import 'package:yaabsa/api/library/request/library_author_sort.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

part 'library_author_provider.g.dart';

const int _authorsPerPage = 32;
const String defaultLibraryAuthorInclude = 'rssfeed,numEpisodesIncomplete,share';
const String defaultAuthorDetailsInclude = 'items,series';

@immutable
class LibraryAuthorsState {
  const LibraryAuthorsState({
    this.items = const <LibraryAuthor>[],
    required this.currentPage,
    required this.hasNextPage,
    required this.libraryId,
    this.sort,
    this.desc,
    this.include,
    this.error,
    this.stackTrace,
    this.isLoadingNextPage = false,
    this.totalItems = 0,
  });

  final List<LibraryAuthor> items;
  final int currentPage;
  final bool hasNextPage;
  final String libraryId;
  final String? sort;
  final int? desc;
  final String? include;
  final Object? error;
  final StackTrace? stackTrace;
  final bool isLoadingNextPage;
  final int totalItems;

  LibraryAuthorsState copyWith({
    List<LibraryAuthor>? items,
    int? currentPage,
    bool? hasNextPage,
    String? libraryId,
    String? sort,
    int? desc,
    String? include,
    Object? error,
    StackTrace? stackTrace,
    bool? isLoadingNextPage,
    int? totalItems,
  }) {
    return LibraryAuthorsState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      libraryId: libraryId ?? this.libraryId,
      sort: sort ?? this.sort,
      desc: desc ?? this.desc,
      include: include ?? this.include,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

@Riverpod(keepAlive: true)
class LibraryAuthorsNotifier extends _$LibraryAuthorsNotifier {
  bool _isEnsuringIndex = false;

  Future<LibraryAuthorsState> _fetchAuthors(int page, {String? sort, int? desc, String? include}) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final currentVal = state.asData?.value;
    final request = LibraryItemsRequest(
      limit: _authorsPerPage,
      page: page,
      sort: sort ?? currentVal?.sort,
      desc: desc ?? currentVal?.desc,
      include: include ?? currentVal?.include,
    );

    final response = await absApi.getLibraryApi().getLibraryAuthors(libraryId, request);
    final data = response.data;
    if (data == null) {
      throw Exception('No author data received from API.');
    }

    final fetchedAuthors = data.results
        .where((author) => author.id.trim().isNotEmpty && author.name.trim().isNotEmpty)
        .toList(growable: false);
    final totalResults = data.total;
    final newItems = page == 0
        ? fetchedAuthors
        : <LibraryAuthor>[...(currentVal?.items ?? const <LibraryAuthor>[]), ...fetchedAuthors];

    return LibraryAuthorsState(
      items: newItems,
      currentPage: page,
      hasNextPage: totalResults > newItems.length,
      libraryId: libraryId,
      sort: request.sort,
      desc: request.desc,
      include: request.include,
      totalItems: totalResults,
      isLoadingNextPage: false,
    );
  }

  Future<void> _refetch({String? sort, int? desc, String? include, bool withLoading = false}) async {
    final currentState = state.value;
    if (currentState == null) {
      return;
    }

    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchAuthors(
        0,
        sort: sort ?? currentState.sort,
        desc: desc ?? currentState.desc,
        include: include ?? currentState.include,
      );
      state = AsyncData(refreshed);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  @override
  Future<LibraryAuthorsState> build(
    String libraryId, {
    String initialSort = defaultAuthorSortWireValue,
    int initialDesc = defaultAuthorSortDesc,
    String? initialInclude = defaultLibraryAuthorInclude,
  }) async {
    return _fetchAuthors(0, sort: initialSort, desc: initialDesc, include: initialInclude);
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (currentState == null || !currentState.hasNextPage || currentState.isLoadingNextPage) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingNextPage: true));

    try {
      final nextPage = await _fetchAuthors(
        currentState.currentPage + 1,
        sort: currentState.sort,
        desc: currentState.desc,
        include: currentState.include,
      );
      state = AsyncData(nextPage);
    } catch (e, s) {
      state = AsyncData(currentState.copyWith(isLoadingNextPage: false, error: e, stackTrace: s));
    }
  }

  Future<void> refresh({bool withLoading = true}) async {
    await _refetch(withLoading: withLoading);
  }

  Future<void> setSort(String newSort, {int? newDesc}) async {
    await _refetch(sort: newSort, desc: newDesc);
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

@riverpod
Future<AuthorDetails> libraryAuthor(Ref ref, String authorId) async {
  final absApi = ref.watch(absApiProvider);
  if (absApi == null) {
    throw Exception('User not authenticated or API not available.');
  }

  final response = await absApi.getLibraryApi().getAuthorById(authorId, include: defaultAuthorDetailsInclude);
  final data = response.data;
  if (data == null) {
    throw Exception('No author details received from API for author $authorId.');
  }

  return data;
}
