import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/list/response/library_list_page.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/playlist_membership.dart';

part 'playlist_lookup_provider.g.dart';

@riverpod
AsyncValue<BookPlaylistMemberships> bookPlaylistMemberships(Ref ref, ({String libraryId, String bookId}) key) {
  return ref
      .watch(playlistsProvider(key.libraryId))
      .whenData(
        (state) => BookPlaylistMemberships(
          playlists: state.items,
          libraryId: key.libraryId,
          bookId: key.bookId,
          error: state.error ?? state.nextPageError,
          hasMore: state.hasNextPage,
          isLoadingMore: state.isLoadingNextPage,
        ),
      );
}

@riverpod
Future<Playlist> playlistById(Ref ref, String libraryId, String id) async {
  final api = ref.watch(absApiProvider);
  if (api == null) {
    throw Exception('API not available.');
  }

  final index = playlistsProvider(libraryId);
  final hasKnown = ref.read(index.exists);
  final known = hasKnown ? ref.read(index).value : null;
  Playlist? cached;
  final candidates = (known?.items ?? const <Playlist>[]).followedBy(
    known?.pagination.bufferedItems ?? const <Playlist>[],
  );
  for (final item in candidates) {
    if (item.id == id) {
      cached = item;
      break;
    }
  }

  try {
    final item = (await api.getListApi().getPlaylist(
      id,
      extra: const {'noCache': true, 'cacheFallbackOnNetworkErrorOnly': true},
    )).data;
    if (item == null || item.libraryId != libraryId) {
      throw Exception('No playlist data received for this library.');
    }

    return item;
  } on DioException catch (error) {
    final status = error.response?.statusCode;
    if (cached != null && (status == null || status >= 500)) {
      return cached;
    }

    rethrow;
  }
}

Future<LibraryListPage<Playlist>> fetchPlaylistListPage(
  Ref ref,
  String libraryId,
  int page, {
  bool forceServer = false,
  bool requireServer = false,
}) async {
  final api = ref.read(absApiProvider);
  if (api == null) {
    throw Exception('API not available.');
  }

  final data = (await api.getListApi().getLibraryPlaylists(
    libraryId,
    page: page,
    forceServer: forceServer || requireServer,
    extra: requireServer ? const {'skipCacheOnError': true} : null,
  )).data;
  if (data == null) {
    throw const FormatException('Incomplete library list response.');
  }

  return data;
}
