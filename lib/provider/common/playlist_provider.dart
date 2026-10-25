import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/util/playlist_membership.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class PlaylistsState {
  const PlaylistsState({
    this.items = const <Playlist>[],
    required this.libraryId,
    this.error,
    this.stackTrace,
    this.totalItems = 0,
  });

  final List<Playlist> items;
  final String libraryId;
  final Object? error;
  final StackTrace? stackTrace;
  final int totalItems;

  PlaylistsState copyWith({
    List<Playlist>? items,
    String? libraryId,
    Object? error,
    StackTrace? stackTrace,
    int? totalItems,
  }) {
    return PlaylistsState(
      items: items ?? this.items,
      libraryId: libraryId ?? this.libraryId,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

final playlistsProvider = AsyncNotifierProvider.family<PlaylistsNotifier, PlaylistsState, String>(
  PlaylistsNotifier.new,
);

/// Recompute only when playlist state changes, rather than on book/player
/// rebuilds. The underlying playlist list and HTTP cache remain shared.
final bookPlaylistMembershipsProvider = Provider.autoDispose
    .family<AsyncValue<BookPlaylistMemberships>, ({String libraryId, String bookId})>((ref, key) {
      return ref
          .watch(playlistsProvider(key.libraryId))
          .whenData(
            (state) => BookPlaylistMemberships(
              playlists: state.items,
              libraryId: key.libraryId,
              bookId: key.bookId,
              error: state.error,
            ),
          );
    });

class PlaylistsNotifier extends AsyncNotifier<PlaylistsState> {
  PlaylistsNotifier(this.libraryId);

  final String libraryId;
  Future<void>? _refreshInFlight;
  int _revision = 0;
  int _refreshRevision = 0;
  bool _refreshForcesServer = false;
  bool _refreshRequiresServer = false;

  Future<PlaylistsState> _fetchPlaylists({bool forceServer = false, bool requireServer = false}) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final response = await absApi.getListApi().getUserPlaylist(
      forceServer: forceServer || requireServer,
      extra: requireServer ? const {'skipCacheOnError': true} : null,
    );
    final data = response.data;
    if (data == null) {
      throw Exception('No playlists data received from API.');
    }

    final filteredPlaylists = data.items.where((item) => item.libraryId == libraryId).toList(growable: false)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return PlaylistsState(items: filteredPlaylists, libraryId: libraryId, totalItems: filteredPlaylists.length);
  }

  @override
  Future<PlaylistsState> build() async {
    return _fetchPlaylists();
  }

  Future<void> refresh({
    bool withLoading = true,
    bool forceServer = true,
    bool requireServer = false,
    bool invalidatePending = false,
  }) {
    if (!ref.mounted) return Future.value();
    // A known server change or explicit validation must not reuse an older response.
    if (invalidatePending) _revision++;
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      if (_refreshRevision == _revision &&
          (!(forceServer || requireServer) || _refreshForcesServer) &&
          (!requireServer || _refreshRequiresServer)) {
        return inFlight;
      }
      // A request started before a confirmed edit, or one that permits an
      // offline cache fallback, cannot satisfy a fresh synchronization request.
      return inFlight.then(
        (_) => refresh(withLoading: withLoading, forceServer: forceServer, requireServer: requireServer),
      );
    }
    _refreshRevision = _revision;
    _refreshForcesServer = forceServer || requireServer;
    _refreshRequiresServer = requireServer;
    final request = _refreshPlaylists(
      withLoading: withLoading,
      forceServer: forceServer,
      requireServer: requireServer,
      revision: _revision,
    );
    _refreshInFlight = request;
    return request.whenComplete(() => _refreshInFlight = null);
  }

  Future<void> _refreshPlaylists({
    required bool withLoading,
    required bool forceServer,
    required bool requireServer,
    required int revision,
  }) async {
    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchPlaylists(forceServer: forceServer, requireServer: requireServer);
      if (ref.mounted && revision == _revision) state = AsyncData(refreshed);
    } catch (e, s) {
      if (!ref.mounted || revision != _revision) return;
      final currentState = state.value;
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(error: e, stackTrace: s));
      } else {
        state = AsyncError(e, s);
      }
    }
  }

  /// Additions use the loaded snapshot and the server's updated playlist.
  /// Removals require a fresh snapshot before sending any mutations.
  /// Only send this book's ID so concurrent changes to other books survive.
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
    if (changes.isEmpty) return;

    final hasRemovals = changes.containsValue(false);
    if (hasRemovals) {
      final validation = refresh(withLoading: false, requireServer: true, invalidatePending: true);
      final validationRevision = _revision;
      await validation;
      if (validationRevision != _revision) {
        throw Exception('Playlists changed during validation. Reload and review the selections before retrying.');
      }
    }
    final loaded = state.value;
    if (loaded == null || loaded.error != null) {
      throw Exception('Reload playlists before editing their memberships.');
    }
    final currentById = {for (final playlist in loaded.items) playlist.id: playlist};
    final originalById = {for (final playlist in original) playlist.id: playlist};
    for (final edit in changes.entries) {
      final current = currentById[edit.key];
      if (current != null && !canEditPlaylistMembership(current, ref.read(currentUserProvider).value?.id)) {
        throw Exception('Playlist editing is not allowed.');
      }
      if (current == null || !samePlaylistMembershipRevision(originalById[edit.key]!, current)) {
        throw Exception('Playlists changed or membership is unknown. Review the updated selections and try again.');
      }
      if (!edit.value && !canRemovePlaylistMembership(current, bookId)) {
        throw Exception('Playlists cannot be empty. Keep at least one book in "${current.name}".');
      }
    }
    checkPermission();
    final api = ref.read(absApiProvider);
    if (api == null) throw Exception('API not available.');
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
          throw Exception('The server did not confirm the membership change.');
        }
        succeeded++;
        _revision++;
        // Publish confirmed responses immediately, including partial successes.
        final current = state.value!;
        state = AsyncData(
          PlaylistsState(
            libraryId: libraryId,
            items: current.items.map((item) => item.id == updated.id ? updated : item).toList(growable: false),
            totalItems: current.totalItems,
          ),
        );
      } catch (error) {
        failures.add('${playlist.name}: $error');
      }
    }

    if (!hasRemovals && failures.isEmpty) {
      // Do not keep Save blocked while reloading every playlist and its books.
      // Equivalent refreshes share work; older requests cannot overwrite this edit.
      unawaited(refresh(withLoading: false, forceServer: true, requireServer: true));
      return;
    }

    await refresh(withLoading: false, requireServer: true, invalidatePending: true);
    final syncError = state.value?.error ?? state.error;
    if (failures.isNotEmpty || syncError != null) {
      throw Exception(
        [
          '$succeeded of ${changes.length} playlist change(s) confirmed.',
          ...failures,
          if (syncError != null) 'Could not reload playlists. Retry loading before editing again: $syncError',
          'Review the updated selections before retrying.',
        ].join('\n'),
      );
    }
  }

  Future<Playlist> createPlaylist({
    required String name,
    String? description,
    List<Map<String, dynamic>> items = const <Map<String, dynamic>>[],
  }) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final createdResponse = await absApi.getListApi().createPlaylist(
      libraryId: libraryId,
      name: name,
      description: description,
      items: items,
    );

    final created = createdResponse.data;
    if (created == null) {
      throw Exception('No playlist data returned from create request.');
    }

    _revision++;
    await refresh(withLoading: false, forceServer: true);
    return created;
  }

  Future<Playlist> updatePlaylist(String playlistId, {required String name, String? description}) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final updatedResponse = await absApi.getListApi().updatePlaylist(playlistId, name: name, description: description);

    final updated = updatedResponse.data;
    if (updated == null) {
      throw Exception('No playlist data returned from update request.');
    }

    _revision++;
    await refresh(withLoading: false, forceServer: true);
    return updated;
  }

  Future<Playlist> addBooksToPlaylist(String playlistId, {required List<String> bookIds}) async {
    if (bookIds.isEmpty) {
      throw Exception('No books selected.');
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final updatedResponse = await absApi.getListApi().addItemsToPlaylist(
      playlistId,
      items: bookIds.map((bookId) => {'libraryItemId': bookId}).toList(growable: false),
    );

    final updated = updatedResponse.data;
    if (updated == null) {
      throw Exception('No playlist data returned from add request.');
    }

    _revision++;
    await refresh(withLoading: false, forceServer: true);
    return updated;
  }

  Future<Playlist> addPodcastEpisodesToPlaylist(
    String playlistId, {
    required String libraryItemId,
    required List<String> episodeIds,
  }) async {
    final normalizedEpisodeIds = _normalizeItemIds(episodeIds);
    if (libraryItemId.isEmpty || normalizedEpisodeIds.isEmpty) {
      throw Exception('No podcast episodes selected.');
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final updatedResponse = await absApi.getListApi().addItemsToPlaylist(
      playlistId,
      items: normalizedEpisodeIds
          .map((episodeId) => <String, dynamic>{'libraryItemId': libraryItemId, 'episodeId': episodeId})
          .toList(growable: false),
    );

    final updated = updatedResponse.data;
    if (updated == null) {
      throw Exception('No playlist data returned from add request.');
    }

    _revision++;
    await refresh(withLoading: false, forceServer: true);
    return updated;
  }

  Future<Playlist> removeBooksFromPlaylist(String playlistId, {required List<String> bookIds}) async {
    if (bookIds.isEmpty) {
      throw Exception('No books selected.');
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final updatedResponse = await absApi.getListApi().removeItemsFromPlaylist(
      playlistId,
      items: bookIds
          .map((bookId) => <String, dynamic>{'libraryItemId': bookId, 'episodeId': null})
          .toList(growable: false),
    );

    final updated = updatedResponse.data;
    if (updated == null) {
      throw Exception('No playlist data returned from remove request.');
    }

    _revision++;
    await refresh(withLoading: false, forceServer: true);
    return updated;
  }

  Future<Playlist> replaceBooksInPlaylist(
    String playlistId, {
    required List<String> currentBookIds,
    required List<String> desiredBookIds,
  }) async {
    final normalizedCurrent = _normalizeItemIds(currentBookIds);
    final normalizedDesired = _normalizeItemIds(desiredBookIds);

    if (normalizedDesired.isEmpty) {
      throw Exception('Playlists cannot be empty. Keep at least one book selected.');
    }

    if (_sameOrder(normalizedCurrent, normalizedDesired)) {
      await refresh(withLoading: false, forceServer: true);
      for (final playlist in state.value?.items ?? const <Playlist>[]) {
        if (playlist.id == playlistId) {
          return playlist;
        }
      }
      throw Exception('Playlist could not be refreshed.');
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final currentSet = normalizedCurrent.toSet();
    final desiredSet = normalizedDesired.toSet();

    final itemsToAdd = normalizedDesired.where((id) => !currentSet.contains(id)).toList(growable: false);
    final itemsToRemove = normalizedCurrent.where((id) => !desiredSet.contains(id)).toList(growable: false);

    if (itemsToAdd.isNotEmpty) {
      await absApi.getListApi().addItemsToPlaylist(
        playlistId,
        items: itemsToAdd.map((bookId) => <String, dynamic>{'libraryItemId': bookId}).toList(growable: false),
      );
    }

    if (itemsToRemove.isNotEmpty) {
      await absApi.getListApi().removeItemsFromPlaylist(
        playlistId,
        items: itemsToRemove
            .map((bookId) => <String, dynamic>{'libraryItemId': bookId, 'episodeId': null})
            .toList(growable: false),
      );
    }

    final updatedResponse = await absApi.getListApi().updatePlaylist(
      playlistId,
      items: normalizedDesired.map((bookId) => <String, dynamic>{'libraryItemId': bookId}).toList(growable: false),
    );

    _revision++;
    await refresh(withLoading: false, forceServer: true);

    final updated = updatedResponse.data;
    if (updated != null) {
      return updated;
    }

    for (final playlist in state.value?.items ?? const <Playlist>[]) {
      if (playlist.id == playlistId) {
        return playlist;
      }
    }

    throw Exception('No playlist data returned from replace request.');
  }

  Future<void> deletePlaylist(String playlistId) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final deleted = await absApi.getListApi().deletePlaylist(playlistId);
    if (!deleted) {
      throw Exception('Playlist delete request failed.');
    }

    _revision++;
    await refresh(withLoading: false, forceServer: true);
  }
}

List<String> _normalizeItemIds(List<String> ids) {
  final normalized = <String>[];
  final seen = <String>{};

  for (final id in ids) {
    if (id.isEmpty || !seen.add(id)) {
      continue;
    }
    normalized.add(id);
  }

  return normalized;
}

bool _sameOrder(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var i = 0; i < left.length; i++) {
    if (left[i] != right[i]) {
      return false;
    }
  }

  return true;
}
