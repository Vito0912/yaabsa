import 'package:yaabsa/api/list/response/library_list_page.dart';

export 'package:yaabsa/api/list/response/library_list_page.dart' show libraryListPageSize;

class LibraryListPagination<T> {
  const LibraryListPagination({
    this.pendingItems = const [],
    this.pendingOffset = 0,
    this.nextPage = 0,
    this.hasMoreFromServer = false,
    this.total = 0,
  });

  final List<T> pendingItems;
  final int pendingOffset;
  final int nextPage;
  final bool hasMoreFromServer;
  final int total;

  Iterable<T> get bufferedItems => pendingItems.skip(pendingOffset);

  bool get hasNextPage => pendingOffset < pendingItems.length || hasMoreFromServer;

  Future<({List<T> items, LibraryListPagination<T> pagination})> loadNext(
    Future<LibraryListPage<T>> Function(int page) fetch, {
    bool initial = false,
  }) async {
    var available = pendingItems;
    var offset = pendingOffset;
    var followingPage = nextPage;
    var moreFromServer = hasMoreFromServer;
    var totalItems = total;

    if (offset >= available.length && (initial || moreFromServer)) {
      final page = await fetch(nextPage);
      available = page.items;
      offset = 0;
      followingPage = page.nextPage;
      moreFromServer = page.hasMore;
      totalItems = page.total;
    }

    final count = (available.length - offset).clamp(0, libraryListPageSize);
    final end = offset + count;
    final buffered = end < available.length;
    return (
      items: available.sublist(offset, end),
      pagination: LibraryListPagination<T>(
        pendingItems: buffered ? available : const [],
        pendingOffset: buffered ? end : 0,
        nextPage: followingPage,
        hasMoreFromServer: moreFromServer,
        total: totalItems,
      ),
    );
  }
}
