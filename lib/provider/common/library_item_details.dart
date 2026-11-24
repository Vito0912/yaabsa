part of 'library_item_provider.dart';

@riverpod
Future<LibraryItem> libraryItem(Ref ref, String itemId, {String? episodeId}) async {
  final absApi = ref.watch(absApiProvider);
  final db = ref.read(appDatabaseProvider);

  ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
    if (next == null) {
      return;
    }

    switch (next.type) {
      case LibraryItemMutationType.added:
      case LibraryItemMutationType.updated:
        final nextItem = next.item;
        if (nextItem == null) {
          return;
        }

        _liveLibraryItemSnapshotById[nextItem.id] = nextItem;
        _removedLibraryItemIds.remove(nextItem.id);
        break;
      case LibraryItemMutationType.removed:
        _liveLibraryItemSnapshotById.remove(next.itemId);
        _removedLibraryItemIds.add(next.itemId);
        break;
    }

    if (next.itemId == itemId) {
      ref.invalidateSelf();
    }
  });

  if (_removedLibraryItemIds.contains(itemId)) {
    throw StateError('Library item $itemId was removed.');
  }

  final liveSnapshot = _liveLibraryItemSnapshotById[itemId];
  final liveSnapshotHasRequestedEpisode =
      episodeId == null ||
      (liveSnapshot?.media?.podcastMedia?.episodes ?? const <Episode>[]).any((episode) => episode.id == episodeId);
  if (liveSnapshot != null && liveSnapshotHasRequestedEpisode) {
    return liveSnapshot;
  }

  if (absApi == null || absApi.user == null) {
    throw Exception('User not authenticated or API not available.');
  }

  final download = await db.getStoredDownload(itemId, absApi.user!.id, episodeId: episodeId, allowIncomplete: true);
  if (download != null && download.item != null) {
    final resolvedCoverPath = await resolveDisplayCoverPath(
      download.coverPath,
      cacheKey: '${absApi.user!.id}:$itemId:${episodeId ?? 'item'}',
    );

    logger('Returning local download for item $itemId', tag: 'libraryItemProvider', level: InfoLevel.debug);
    final localItem = _withLocalCoverPath(download.item!, resolvedCoverPath ?? download.coverPath);
    _liveLibraryItemSnapshotById[itemId] = localItem;
    _removedLibraryItemIds.remove(itemId);
    return localItem;
  }

  try {
    final response = await absApi.getLibraryItemApi().getLibraryItem(itemId: itemId);
    final data = response.data;
    if (data == null) {
      throw Exception('No data received from API for item $itemId');
    }

    _liveLibraryItemSnapshotById[itemId] = data;
    _removedLibraryItemIds.remove(itemId);
    return data;
  } catch (e) {
    throw Exception('Failed to fetch library item $itemId: $e');
  }
}

LibraryItem _withLocalCoverPath(LibraryItem item, String? coverPathOverride) {
  final normalizedCoverPath = coverPathOverride?.trim();
  if (normalizedCoverPath == null || normalizedCoverPath.isEmpty) {
    return item;
  }

  final media = item.media;
  if (media == null) {
    return item;
  }

  final bookMedia = media.bookMedia;
  if (bookMedia != null) {
    if (bookMedia.coverPath == normalizedCoverPath) {
      return item;
    }

    return item.copyWith(
      media: media.copyWith(bookMedia: bookMedia.copyWith(coverPath: normalizedCoverPath)),
    );
  }

  final podcastMedia = media.podcastMedia;
  if (podcastMedia != null) {
    if (podcastMedia.coverPath == normalizedCoverPath) {
      return item;
    }

    return item.copyWith(
      media: media.copyWith(podcastMedia: podcastMedia.copyWith(coverPath: normalizedCoverPath)),
    );
  }

  return item;
}

@Riverpod(keepAlive: true)
Stream<Set<String>> completedDownloadItemIds(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    return Stream<Set<String>>.value(<String>{});
  }

  final db = ref.watch(appDatabaseProvider);
  return db.watchCompletedDownloadItemIdsByUser(user.id);
}

@riverpod
bool completedDownloadForItem(Ref ref, String itemId, {String? episodeId}) {
  final completedId = episodeId ?? itemId;
  return ref.watch(
    completedDownloadItemIdsProvider.select((asyncIds) => asyncIds.asData?.value.contains(completedId) ?? false),
  );
}
