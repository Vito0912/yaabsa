import 'package:yaabsa/api/library/author_details.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/library_author.dart';
import 'package:yaabsa/api/library/request/library_author_sort.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';
import 'package:yaabsa/util/library_item_mutation_helpers.dart';

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

  Future<LibraryAuthorsState> _fetchAuthors(
    int page, {
    String? sort,
    int? desc,
    String? include,
    bool forceServer = false,
  }) async {
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

    final response = await absApi.getLibraryApi().getLibraryAuthors(
      libraryId,
      request,
      extra: forceServer ? {'noCache': true} : null,
    );
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

  Future<void> _refetch({
    String? sort,
    int? desc,
    String? include,
    bool withLoading = false,
    bool forceServer = false,
  }) async {
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
        forceServer: forceServer,
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
    ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
      if (next == null) {
        return;
      }

      if (next.libraryId != null && next.libraryId != libraryId) {
        return;
      }

      final currentState = state.asData?.value;
      if (currentState == null) return;

      bool affectsList = mutationAffectsAuthorsList(next);
      if (!affectsList) return;

      final pagesToRefresh = <int>{};
      final prevAuthors = next.previousItem?.media?.bookMedia?.metadata.authors ?? [];
      final newAuthors = next.item?.media?.bookMedia?.metadata.authors ?? [];
      final prevPodAuthor = next.previousItem?.media?.podcastMedia?.metadata.author;
      final newPodAuthor = next.item?.media?.podcastMedia?.metadata.author;

      for (int i = 0; i < currentState.items.length; i++) {
        final author = currentState.items[i];

        final wasInAuthor =
            prevAuthors.any((a) => a.id == author.id) || (prevPodAuthor != null && prevPodAuthor == author.name);
        final isInAuthor =
            newAuthors.any((a) => a.id == author.id) || (newPodAuthor != null && newPodAuthor == author.name);

        if (wasInAuthor || isInAuthor) {
          pagesToRefresh.add(i ~/ _authorsPerPage);
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

    return _fetchAuthors(0, sort: initialSort, desc: initialDesc, include: initialInclude);
  }

  Future<void> _refetchSpecificPage(int page) async {
    final currentState = state.asData?.value;
    if (currentState == null) return;

    final absApi = ref.read(absApiProvider);
    if (absApi == null) return;

    try {
      final request = LibraryItemsRequest(
        limit: _authorsPerPage,
        page: page,
        sort: currentState.sort ?? defaultAuthorSortWireValue,
        desc: currentState.desc ?? defaultAuthorSortDesc,
        include: currentState.include ?? defaultLibraryAuthorInclude,
      );

      final response = await absApi.getLibraryApi().getLibraryAuthors(
        currentState.libraryId,
        request,
        extra: {'noCache': true},
      );

      final data = response.data;
      if (data == null) return;

      final fetchedItems = data.results;
      final newItems = List<LibraryAuthor>.from(currentState.items);
      final startIndex = page * _authorsPerPage;

      if (startIndex < newItems.length) {
        final endIndex = (startIndex + _authorsPerPage).clamp(0, newItems.length);
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

  Future<void> refresh({bool withLoading = true, bool forceServer = false}) async {
    await _refetch(withLoading: withLoading, forceServer: forceServer);
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
class LibraryAuthorDetails extends _$LibraryAuthorDetails {
  @override
  Future<AuthorDetails> build(String authorId) async {
    final absApi = ref.watch(absApiProvider);

    ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
      if (next != null && mutationAffectsAuthor(next, authorId)) {
        ref.invalidateSelf();
      }
    });

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
}
