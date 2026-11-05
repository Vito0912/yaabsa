import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/provider/common/library_list_pagination.dart';

class PlaylistsState {
  const PlaylistsState({
    this.items = const <Playlist>[],
    required this.libraryId,
    this.error,
    this.stackTrace,
    this.totalItems = 0,
    this.pagination = const LibraryListPagination<Playlist>(),
    this.isLoadingNextPage = false,
    this.nextPageError,
  });

  final List<Playlist> items;
  final String libraryId;
  final Object? error;
  final StackTrace? stackTrace;
  final int totalItems;
  final LibraryListPagination<Playlist> pagination;
  final bool isLoadingNextPage;
  final Object? nextPageError;

  bool get hasNextPage => pagination.hasNextPage;

  PlaylistsState copyWith({
    List<Playlist>? items,
    String? libraryId,
    Object? error,
    StackTrace? stackTrace,
    int? totalItems,
    LibraryListPagination<Playlist>? pagination,
    bool? isLoadingNextPage,
    Object? nextPageError,
    bool clearError = false,
    bool clearNextPageError = false,
  }) {
    return PlaylistsState(
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
