import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/provider/common/library_list_pagination.dart';

class CollectionsState {
  const CollectionsState({
    this.items = const <Collection>[],
    required this.libraryId,
    this.error,
    this.stackTrace,
    this.totalItems = 0,
    this.pagination = const LibraryListPagination<Collection>(),
    this.isLoadingNextPage = false,
    this.nextPageError,
  });

  final List<Collection> items;
  final String libraryId;
  final Object? error;
  final StackTrace? stackTrace;
  final int totalItems;
  final LibraryListPagination<Collection> pagination;
  final bool isLoadingNextPage;
  final Object? nextPageError;

  bool get hasNextPage => pagination.hasNextPage;

  CollectionsState copyWith({
    List<Collection>? items,
    String? libraryId,
    Object? error,
    StackTrace? stackTrace,
    int? totalItems,
    LibraryListPagination<Collection>? pagination,
    bool? isLoadingNextPage,
    Object? nextPageError,
    bool clearError = false,
    bool clearNextPageError = false,
  }) {
    return CollectionsState(
      items: items ?? this.items,
      libraryId: libraryId ?? this.libraryId,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
      totalItems: totalItems ?? this.totalItems,
      pagination: pagination ?? this.pagination,
      isLoadingNextPage: isLoadingNextPage ?? this.isLoadingNextPage,
      nextPageError: clearNextPageError ? null : nextPageError ?? this.nextPageError,
    );
  }
}
