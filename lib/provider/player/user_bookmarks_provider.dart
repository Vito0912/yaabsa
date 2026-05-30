import 'package:dio/dio.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/api/me/request/create_bookmark_request.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_bookmarks_provider.g.dart';

@Riverpod(keepAlive: true)
class UserBookmarksNotifier extends _$UserBookmarksNotifier {
  String _bookmarkKey(String itemId, int time) => '$itemId::$time';

  String? _activeUserId() {
    final currentUserId = ref.read(currentUserProvider).value?.id;
    if (currentUserId != null && currentUserId.isNotEmpty) {
      return currentUserId;
    }

    final apiUserId = ref.read(absApiProvider)?.user?.id;
    if (apiUserId != null && apiUserId.isNotEmpty) {
      return apiUserId;
    }

    return null;
  }

  bool _isNotFoundError(Object error) {
    return error is DioException && error.response?.statusCode == 404;
  }

  bool _isConnectivityError(Object error) {
    if (error is! DioException) {
      return false;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return true;
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
        return false;
    }
  }

  Future<List<StoredBookmarkSyncEntry>> _pendingEntriesForUser(String userId) async {
    try {
      return await ref.read(appDatabaseProvider).getStoredBookmarkSyncByUser(userId);
    } catch (e, s) {
      logger(
        'Failed to load pending bookmark sync entries for user $userId: $e\n$s',
        tag: 'UserBookmarksProvider',
        level: InfoLevel.warning,
      );
      return <StoredBookmarkSyncEntry>[];
    }
  }

  List<Bookmark> _applyPendingMutations(List<Bookmark> bookmarks, List<StoredBookmarkSyncEntry> pendingEntries) {
    final merged = <String, Bookmark>{};
    for (final bookmark in bookmarks) {
      merged[_bookmarkKey(bookmark.libraryItemId, bookmark.time)] = bookmark;
    }

    final sortedPending = [...pendingEntries]..sort((left, right) => left.updatedAt.compareTo(right.updatedAt));

    for (final pending in sortedPending) {
      if (pending.time <= 0) {
        continue;
      }

      final key = _bookmarkKey(pending.itemId, pending.time);
      if (pending.deleted) {
        merged.remove(key);
        continue;
      }

      final title = pending.title?.trim();
      if (title == null || title.isEmpty) {
        continue;
      }

      final existing = merged[key];
      merged[key] = Bookmark(
        libraryItemId: pending.itemId,
        title: title,
        time: pending.time,
        createdAt: existing?.createdAt ?? pending.updatedAt.millisecondsSinceEpoch,
      );
    }

    final mergedBookmarks = merged.values.toList(growable: false)
      ..sort((left, right) {
        final itemCompare = left.libraryItemId.compareTo(right.libraryItemId);
        if (itemCompare != 0) {
          return itemCompare;
        }
        return left.time.compareTo(right.time);
      });

    return mergedBookmarks;
  }

  Future<void> _queueBookmarkCreate({
    required String userId,
    required String itemId,
    required int time,
    required String title,
  }) {
    return ref
        .read(appDatabaseProvider)
        .upsertStoredBookmarkSync(
          userId: userId,
          itemId: itemId,
          time: time,
          title: title,
          deleted: false,
          updatedAt: DateTime.now(),
        );
  }

  Future<void> _queueBookmarkDelete({required String userId, required String itemId, required int time}) {
    return ref
        .read(appDatabaseProvider)
        .upsertStoredBookmarkSync(
          userId: userId,
          itemId: itemId,
          time: time,
          title: null,
          deleted: true,
          updatedAt: DateTime.now(),
        );
  }

  void _upsertBookmarkInState(Bookmark bookmark) {
    final bookmarks = state.asData?.value ?? const <Bookmark>[];
    final updated = <Bookmark>[];
    var replaced = false;

    for (final existing in bookmarks) {
      final isSameBookmark = existing.libraryItemId == bookmark.libraryItemId && existing.time == bookmark.time;
      if (isSameBookmark) {
        if (!replaced) {
          updated.add(bookmark);
          replaced = true;
        }
        continue;
      }
      updated.add(existing);
    }

    if (!replaced) {
      updated.add(bookmark);
    }

    state = AsyncData(updated);
  }

  void _removeBookmarkFromState({required String itemId, required int time}) {
    final bookmarks = state.asData?.value ?? const <Bookmark>[];
    final updated = bookmarks
        .where((bookmark) => !(bookmark.libraryItemId == itemId && bookmark.time == time))
        .toList(growable: false);
    state = AsyncData(updated);
  }

  @override
  Future<List<Bookmark>> build() async {
    final canReachServer = ref.watch(serverReachabilityProvider);
    final user = ref.watch(currentUserProvider).value;
    if (user == null) {
      return const <Bookmark>[];
    }

    final localBookmarks = user.bookmarks ?? const <Bookmark>[];
    final pendingEntries = await _pendingEntriesForUser(user.id);
    final optimisticLocal = _applyPendingMutations(localBookmarks, pendingEntries);
    state = AsyncData(optimisticLocal);

    if (canReachServer) {
      try {
        await syncPendingMutations(userId: user.id);
      } catch (e, s) {
        logger(
          'Failed to sync pending bookmark mutations during build: $e\n$s',
          tag: 'UserBookmarksProvider',
          level: InfoLevel.warning,
        );
      }
    }

    try {
      return await _fetchBookmarks(userId: user.id);
    } catch (e, s) {
      logger('Failed to fetch bookmarks during build: $e\n$s', tag: 'UserBookmarksProvider', level: InfoLevel.warning);
      return optimisticLocal;
    }
  }

  Future<List<Bookmark>> _fetchBookmarks({required String userId}) async {
    final pendingEntries = await _pendingEntriesForUser(userId);
    final api = ref.read(absApiProvider);
    if (api == null) {
      final bookmarks = state.asData?.value ?? const <Bookmark>[];
      final merged = _applyPendingMutations(bookmarks, pendingEntries);
      state = AsyncData(merged);
      return merged;
    }

    final response = await api.getMeApi().getUser();
    final remoteBookmarks = response.data?.bookmarks ?? const <Bookmark>[];
    final merged = _applyPendingMutations(remoteBookmarks, pendingEntries);
    state = AsyncData(merged);
    return merged;
  }

  Future<void> refresh() async {
    final userId = _activeUserId();
    if (userId == null) {
      state = const AsyncData(<Bookmark>[]);
      return;
    }

    try {
      await syncPendingMutations(userId: userId);
      await _fetchBookmarks(userId: userId);
    } catch (e, s) {
      logger('Failed to refresh bookmarks: $e\n$s', tag: 'UserBookmarksProvider', level: InfoLevel.error);
    }
  }

  Future<int> syncPendingMutations({String? userId}) async {
    final effectiveUserId = userId ?? _activeUserId();
    if (effectiveUserId == null || effectiveUserId.isEmpty) {
      return 0;
    }

    if (!ref.read(serverReachabilityProvider)) {
      return 0;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      return 0;
    }

    final db = ref.read(appDatabaseProvider);
    final pendingEntries = await _pendingEntriesForUser(effectiveUserId);
    if (pendingEntries.isEmpty) {
      return 0;
    }

    final sortedPending = [...pendingEntries]..sort((left, right) => left.updatedAt.compareTo(right.updatedAt));
    var syncedCount = 0;

    for (final pending in sortedPending) {
      if (pending.time <= 0) {
        await db.deleteStoredBookmarkSync(pending.userId, pending.itemId, pending.time);
        continue;
      }

      try {
        if (pending.deleted) {
          final deleted = await api.getMeApi().deleteBookmark(pending.itemId, pending.time);
          if (!deleted) {
            continue;
          }
        } else {
          final title = pending.title?.trim();
          if (title == null || title.isEmpty) {
            await db.deleteStoredBookmarkSync(pending.userId, pending.itemId, pending.time);
            continue;
          }

          final response = await api.getMeApi().createBookmark(
            pending.itemId,
            createBookmarkRequest: CreateBookmarkRequest(time: pending.time, title: title),
          );

          if (response.data == null) {
            continue;
          }
        }

        await db.deleteStoredBookmarkSync(pending.userId, pending.itemId, pending.time);
        syncedCount++;
      } catch (e, s) {
        if (_isNotFoundError(e)) {
          await db.deleteStoredBookmarkSync(pending.userId, pending.itemId, pending.time);
          syncedCount++;
          continue;
        }

        logger(
          'Failed to sync pending bookmark mutation for ${pending.itemId}@${pending.time}: $e\n$s',
          tag: 'UserBookmarksProvider',
          level: InfoLevel.warning,
        );

        if (_isConnectivityError(e)) {
          break;
        }
      }
    }

    return syncedCount;
  }

  Future<Bookmark?> createBookmark({required String itemId, required int time, required String title}) async {
    final trimmedTitle = title.trim();
    if (time <= 0 || trimmedTitle.isEmpty) {
      return null;
    }

    final optimisticBookmark = Bookmark(
      libraryItemId: itemId,
      title: trimmedTitle,
      time: time,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _upsertBookmarkInState(optimisticBookmark);

    final userId = _activeUserId();
    if (userId != null) {
      await _queueBookmarkCreate(userId: userId, itemId: itemId, time: time, title: trimmedTitle);
    }

    final api = ref.read(absApiProvider);
    final canReachServer = ref.read(serverReachabilityProvider);
    if (api == null || !canReachServer) {
      return optimisticBookmark;
    }

    try {
      final response = await api.getMeApi().createBookmark(
        itemId,
        createBookmarkRequest: CreateBookmarkRequest(time: time, title: trimmedTitle),
      );

      final createdBookmark = response.data;
      if (createdBookmark == null) {
        return optimisticBookmark;
      }

      if (userId != null) {
        await ref.read(appDatabaseProvider).deleteStoredBookmarkSync(userId, itemId, time);
      }

      _upsertBookmarkInState(createdBookmark);
      return createdBookmark;
    } catch (e, s) {
      if (_isNotFoundError(e)) {
        if (userId != null) {
          await ref.read(appDatabaseProvider).deleteStoredBookmarkSync(userId, itemId, time);
        }
        _removeBookmarkFromState(itemId: itemId, time: time);
        return null;
      }

      logger('Failed to create bookmark remotely, keeping queued mutation: $e\n$s', tag: 'UserBookmarksProvider');
      return optimisticBookmark;
    }
  }

  Future<bool> deleteBookmark({required String itemId, required int time}) async {
    if (time <= 0) {
      return false;
    }

    _removeBookmarkFromState(itemId: itemId, time: time);

    final userId = _activeUserId();
    if (userId != null) {
      await _queueBookmarkDelete(userId: userId, itemId: itemId, time: time);
    }

    final api = ref.read(absApiProvider);
    final canReachServer = ref.read(serverReachabilityProvider);
    if (api == null || !canReachServer) {
      return true;
    }

    try {
      final deleted = await api.getMeApi().deleteBookmark(itemId, time);
      if (deleted && userId != null) {
        await ref.read(appDatabaseProvider).deleteStoredBookmarkSync(userId, itemId, time);
      }
      return true;
    } catch (e, s) {
      if (_isNotFoundError(e)) {
        if (userId != null) {
          await ref.read(appDatabaseProvider).deleteStoredBookmarkSync(userId, itemId, time);
        }
        return true;
      }

      logger('Failed to delete bookmark remotely, keeping queued mutation: $e\n$s', tag: 'UserBookmarksProvider');
      return true;
    }
  }
}
