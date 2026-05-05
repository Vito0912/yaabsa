import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/list/playlist.dart';
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

class PlaylistsNotifier extends AsyncNotifier<PlaylistsState> {
  PlaylistsNotifier(this.libraryId);

  final String libraryId;

  Future<PlaylistsState> _fetchPlaylists({bool forceServer = false}) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final response = await absApi.getListApi().getUserPlaylist(forceServer: forceServer);
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

  Future<void> refresh({bool withLoading = true, bool forceServer = true}) async {
    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchPlaylists(forceServer: forceServer);
      state = AsyncData(refreshed);
    } catch (e, s) {
      final currentState = state.value;
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(error: e, stackTrace: s));
      } else {
        state = AsyncError(e, s);
      }
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
