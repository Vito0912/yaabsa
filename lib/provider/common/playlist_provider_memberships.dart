part of 'playlist_provider.dart';

mixin _PlaylistMembershipMutations on _$PlaylistsNotifier {
  int get membershipRevision;

  void applyServerUpdate(Playlist item);

  void applyServerRemoval(String id);

  Future<void> refresh({
    bool withLoading = true,
    bool forceServer = true,
    bool requireServer = false,
    bool invalidatePending = false,
  });

  Future<void> updateBookMemberships({
    required String bookId,
    required List<Playlist> original,
    required Set<String> selectedIds,
  }) async {
    void checkPermission() {
      final userId = ref.read(currentUserProvider).value?.id;
      if (userId == null || userId.isEmpty) {
        throw Exception('Playlist editing is not allowed.');
      }
    }

    checkPermission();
    final changes = playlistMembershipChanges(
      original: original,
      libraryId: libraryId,
      bookId: bookId,
      selectedIds: selectedIds,
    );
    if (changes.isEmpty) {
      return;
    }

    final hasRemovals = changes.containsValue(false);
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw Exception('API not available.');
    }

    final loaded = state.value;
    if (loaded == null || loaded.error != null) {
      throw Exception('Reload playlists before editing.');
    }
    final currentById = {for (final item in loaded.items) item.id: item};
    try {
      if (hasRemovals) {
        final validationRevision = membershipRevision;
        for (final id in changes.keys) {
          final current = (await api.getListApi().getPlaylist(
            id,
            extra: const {'noCache': true, 'skipCacheOnError': true},
          )).data;
          if (!ref.mounted || validationRevision != membershipRevision) {
            throw Exception('Playlists changed during validation. Reload before retrying.');
          }
          if (current == null || current.libraryId != libraryId) {
            throw Exception('Could not validate the playlist.');
          }
          currentById[id] = current;
        }
      }
      final originalById = {for (final playlist in original) playlist.id: playlist};
      for (final edit in changes.entries) {
        final current = currentById[edit.key];
        if (current != null && !canEditPlaylistMembership(current, ref.read(currentUserProvider).value?.id)) {
          throw Exception('Playlist editing is not allowed.');
        }
        if (current == null || !samePlaylistMembershipRevision(originalById[edit.key]!, current)) {
          throw Exception(
            'Playlists changed or their contents are unavailable. Review the updated selections and try again.',
          );
        }
        if (!edit.value && !canRemovePlaylistMembership(current, bookId)) {
          throw Exception('Full item list unavailable for "${current.name}". Reload playlists before editing.');
        }
      }
    } catch (_) {
      if (ref.mounted) {
        await refresh(withLoading: false, requireServer: true, invalidatePending: true);
      }
      rethrow;
    }

    checkPermission();
    final failures = <String>[];
    var succeeded = 0;
    for (final edit in changes.entries) {
      final playlist = currentById[edit.key]!;
      try {
        checkPermission();
        if (!canEditPlaylistMembership(playlist, ref.read(currentUserProvider).value?.id)) {
          throw Exception('Playlist editing is not allowed.');
        }
        final response = edit.value
            ? await api.getListApi().addItemsToPlaylist(
                edit.key,
                items: [
                  {'libraryItemId': bookId},
                ],
              )
            : await api.getListApi().removeItemsFromPlaylist(
                edit.key,
                items: [
                  {'libraryItemId': bookId, 'episodeId': null},
                ],
              );
        final updated = response.data;
        if (updated == null ||
            updated.id != edit.key ||
            updated.libraryId != libraryId ||
            playlistMembership(updated, bookId) !=
                (edit.value ? PlaylistMembership.present : PlaylistMembership.absent)) {
          throw Exception('The server did not confirm the playlist changes.');
        }
        if (!ref.mounted) {
          throw Exception('The active user changed. Reload before editing.');
        }

        succeeded++;
        if (!edit.value && updated.items!.isEmpty) {
          applyServerRemoval(updated.id);
        } else {
          applyServerUpdate(updated);
        }
      } catch (error) {
        failures.add('${playlist.name}: $error');
      }
    }

    if (!hasRemovals && failures.isEmpty) {
      unawaited(refresh(withLoading: false, forceServer: true, requireServer: true));
      return;
    }

    if (!ref.mounted) {
      throw Exception('The active user changed. Reload before editing.');
    }

    await refresh(withLoading: false, requireServer: true, invalidatePending: true);
    final syncError = state.value?.error ?? state.error;
    if (failures.isNotEmpty || syncError != null) {
      throw Exception(
        [
          'Playlists updated: $succeeded of ${changes.length}.',
          ...failures,
          if (syncError != null) 'Could not reload playlists. Retry loading before editing again: $syncError',
          'Review the updated selections before retrying.',
        ].join('\n'),
      );
    }
  }
}
