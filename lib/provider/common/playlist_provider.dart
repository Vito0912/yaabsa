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

  Future<PlaylistsState> _fetchPlaylists() async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final response = await absApi.getListApi().getUserPlaylist();
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

  Future<void> refresh({bool withLoading = true}) async {
    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchPlaylists();
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
}
