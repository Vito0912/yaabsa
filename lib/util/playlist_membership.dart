import 'package:yaabsa/api/list/playlist.dart';

enum PlaylistMembership { present, absent, unknown }

class BookPlaylistMemberships {
  BookPlaylistMemberships({
    required Iterable<Playlist> playlists,
    required String libraryId,
    required String bookId,
    this.error,
    this.hasMore = false,
    this.isLoadingMore = false,
  }) {
    final containing = <Playlist>[];
    var unknown = false;
    for (final playlist in playlists) {
      if (playlist.libraryId != libraryId) {
        continue;
      }
      switch (playlistMembership(playlist, bookId)) {
        case PlaylistMembership.present:
          containing.add(playlist);
        case PlaylistMembership.unknown:
          unknown = true;
        case PlaylistMembership.absent:
          break;
      }
    }
    items = List.unmodifiable(containing);
    hasUnknown = unknown;
  }

  late final List<Playlist> items;
  late final bool hasUnknown;
  final Object? error;
  final bool hasMore;
  final bool isLoadingMore;
}

PlaylistMembership playlistMembership(Playlist playlist, String bookId) {
  final items = playlist.items;
  if (items == null) {
    return PlaylistMembership.unknown;
  }
  if (items.any((item) => item.itemId == bookId && item.episodeId == null)) {
    return PlaylistMembership.present;
  }
  return hasCompletePlaylistItems(playlist) ? PlaylistMembership.absent : PlaylistMembership.unknown;
}

/// Membership needs entry IDs, not the optional expanded book/episode metadata.
bool hasCompletePlaylistItems(Playlist playlist) {
  final items = playlist.items;
  return items != null &&
      items.every((item) => item.itemId.isNotEmpty && (item.episodeId == null || item.episodeId!.isNotEmpty)) &&
      items.map((item) => (item.itemId, item.episodeId)).toSet().length == items.length;
}

bool canEditPlaylistMembership(Playlist playlist, String? userId) =>
    userId != null && userId.isNotEmpty && (playlist.userId == null || playlist.userId == userId);

bool canRemovePlaylistMembership(Playlist playlist, String bookId) =>
    hasCompletePlaylistItems(playlist) && playlistMembership(playlist, bookId) == PlaylistMembership.present;

Map<String, bool> playlistMembershipChanges({
  required Iterable<Playlist> original,
  required String libraryId,
  required String bookId,
  required Set<String> selectedIds,
}) {
  final changes = <String, bool>{};
  for (final entry in original) {
    if (entry.libraryId != libraryId) {
      continue;
    }

    final membership = playlistMembership(entry, bookId);
    final selected = selectedIds.contains(entry.id);
    if (membership != PlaylistMembership.unknown && (membership == PlaylistMembership.present) != selected) {
      changes[entry.id] = selected;
    }
  }

  return changes;
}

bool samePlaylistMembershipRevision(Playlist original, Playlist current) {
  if (original.libraryId != current.libraryId ||
      original.userId != current.userId ||
      original.lastUpdate != current.lastUpdate ||
      !hasCompletePlaylistItems(original) ||
      !hasCompletePlaylistItems(current)) {
    return false;
  }
  final before = original.items!;
  final after = current.items!;
  if (before.length != after.length) {
    return false;
  }
  for (var index = 0; index < before.length; index++) {
    if (before[index].itemId != after[index].itemId || before[index].episodeId != after[index].episodeId) {
      return false;
    }
  }
  return true;
}
