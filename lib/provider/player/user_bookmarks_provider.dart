import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/api/me/request/create_bookmark_request.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_bookmarks_provider.g.dart';

@Riverpod(keepAlive: true)
class UserBookmarksNotifier extends _$UserBookmarksNotifier {
  @override
  Future<List<Bookmark>> build() async {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) {
      return const <Bookmark>[];
    }

    final localBookmarks = user.bookmarks ?? const <Bookmark>[];
    state = AsyncData(localBookmarks);

    try {
      return await _fetchBookmarks();
    } catch (e, s) {
      logger('Failed to fetch bookmarks during build: $e\n$s', tag: 'UserBookmarksProvider', level: InfoLevel.warning);
      return localBookmarks;
    }
  }

  Future<List<Bookmark>> _fetchBookmarks() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      return state.asData?.value ?? const <Bookmark>[];
    }

    final response = await api.getMeApi().getUser();
    final bookmarks = response.data?.bookmarks ?? const <Bookmark>[];
    state = AsyncData(bookmarks);
    return bookmarks;
  }

  Future<void> refresh() async {
    try {
      await _fetchBookmarks();
    } catch (e, s) {
      logger('Failed to refresh bookmarks: $e\n$s', tag: 'UserBookmarksProvider', level: InfoLevel.error);
    }
  }

  Future<Bookmark?> createBookmark({required String itemId, required int time, required String title}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw Exception('ABS API is unavailable for creating bookmark.');
    }

    final response = await api.getMeApi().createBookmark(
      itemId,
      createBookmarkRequest: CreateBookmarkRequest(time: time, title: title),
    );

    final createdBookmark = response.data;
    if (createdBookmark == null) {
      return null;
    }

    final bookmarks = state.asData?.value ?? const <Bookmark>[];
    final updated = <Bookmark>[];
    var replaced = false;

    for (final bookmark in bookmarks) {
      final isSameBookmark =
          bookmark.libraryItemId == createdBookmark.libraryItemId && bookmark.time == createdBookmark.time;
      if (isSameBookmark) {
        if (!replaced) {
          updated.add(createdBookmark);
          replaced = true;
        }
        continue;
      }
      updated.add(bookmark);
    }

    if (!replaced) {
      updated.add(createdBookmark);
    }

    state = AsyncData(updated);
    return createdBookmark;
  }

  Future<bool> deleteBookmark({required String itemId, required int time}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw Exception('ABS API is unavailable for deleting bookmark.');
    }

    final deleted = await api.getMeApi().deleteBookmark(itemId, time);
    if (!deleted) {
      return false;
    }

    final bookmarks = state.asData?.value ?? const <Bookmark>[];
    final updated = bookmarks
        .where((bookmark) => !(bookmark.libraryItemId == itemId && bookmark.time == time))
        .toList(growable: false);
    state = AsyncData(updated);
    return true;
  }
}
