import 'package:audio_service/audio_service.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

const String androidAutoContinueNodeId = 'aa/continue';
const String androidAutoRecentNodeId = 'aa/recent';
const String androidAutoLibrariesNodeId = 'aa/libraries';

class AndroidAutoBrowseSnapshot {
  AndroidAutoBrowseSnapshot({required List<MediaItem> continueItems, required List<Library> audioLibraries})
    : continueItems = List.unmodifiable(continueItems),
      audioLibraries = List.unmodifiable(audioLibraries);

  final List<MediaItem> continueItems;
  final List<Library> audioLibraries;
}

sealed class AndroidAutoBrowseResult<T> {
  const AndroidAutoBrowseResult();
}

final class AndroidAutoBrowseReady<T> extends AndroidAutoBrowseResult<T> {
  const AndroidAutoBrowseReady(this.value);

  final T value;
}

final class AndroidAutoBrowseInitializing<T> extends AndroidAutoBrowseResult<T> {
  const AndroidAutoBrowseInitializing();
}

final class AndroidAutoBrowseAuthRequired<T> extends AndroidAutoBrowseResult<T> {
  const AndroidAutoBrowseAuthRequired();
}

final class AndroidAutoBrowseFailure<T> extends AndroidAutoBrowseResult<T> {
  const AndroidAutoBrowseFailure(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

class AndroidAutoBrowseStaleRequestException implements Exception {
  const AndroidAutoBrowseStaleRequestException();
}

class AndroidAutoBrowseSnapshotCache {
  AndroidAutoBrowseSnapshot? get snapshot => _snapshot;
  AndroidAutoBrowseResult<AndroidAutoBrowseSnapshot> get state => _state;
  int get generation => _generation;

  Future<AndroidAutoBrowseSnapshot> getSnapshot(
    Future<AndroidAutoBrowseSnapshot> Function(int generation) loader, {
    bool forceRefresh = false,
  }) {
    final cachedSnapshot = _snapshot;
    if (!forceRefresh && cachedSnapshot != null) {
      return Future.value(cachedSnapshot);
    }

    final activeLoad = _load;
    if (activeLoad != null) {
      return activeLoad;
    }

    final requestGeneration = _generation;
    late final Future<AndroidAutoBrowseSnapshot> load;
    load = () async {
      _state = const AndroidAutoBrowseInitializing<AndroidAutoBrowseSnapshot>();
      try {
        final nextSnapshot = await loader(requestGeneration);
        if (requestGeneration != _generation) {
          throw const AndroidAutoBrowseStaleRequestException();
        }
        _snapshot = nextSnapshot;
        _state = AndroidAutoBrowseReady<AndroidAutoBrowseSnapshot>(nextSnapshot);
        return nextSnapshot;
      } catch (error, stackTrace) {
        _state = AndroidAutoBrowseFailure<AndroidAutoBrowseSnapshot>(error, stackTrace);
        if (error is AndroidAutoBrowseStaleRequestException) {
          rethrow;
        }

        final lastSuccessfulSnapshot = _snapshot;
        if (lastSuccessfulSnapshot != null && requestGeneration == _generation) {
          return lastSuccessfulSnapshot;
        }
        rethrow;
      } finally {
        if (identical(_load, load)) {
          _load = null;
        }
      }
    }();
    _load = load;
    return load;
  }

  void invalidate() {
    _generation += 1;
    _snapshot = null;
    _load = null;
    _state = const AndroidAutoBrowseInitializing<AndroidAutoBrowseSnapshot>();
  }

  void setState(AndroidAutoBrowseResult<AndroidAutoBrowseSnapshot> nextState) {
    _state = nextState;
  }

  void updateSnapshot(AndroidAutoBrowseSnapshot nextSnapshot) {
    _snapshot = nextSnapshot;
    _state = AndroidAutoBrowseReady<AndroidAutoBrowseSnapshot>(nextSnapshot);
  }

  AndroidAutoBrowseSnapshot? _snapshot;
  Future<AndroidAutoBrowseSnapshot>? _load;
  AndroidAutoBrowseResult<AndroidAutoBrowseSnapshot> _state =
      const AndroidAutoBrowseInitializing<AndroidAutoBrowseSnapshot>();
  int _generation = 0;
}

bool isAndroidAutoAudioLibrary(Library library) {
  final supportedType = library.mediaType == 'book' || library.mediaType == 'podcast';
  final numAudioFiles = library.stats?.numAudioFiles;
  return supportedType && numAudioFiles != null && numAudioFiles > 0;
}

List<Library> filterAndroidAutoLibraries(Iterable<Library> libraries) {
  return libraries.where(isAndroidAutoAudioLibrary).toList(growable: false);
}

List<MediaItem> buildAndroidAutoRoot(
  AndroidAutoBrowseSnapshot snapshot, {
  int? session,
  Uri? Function(String nodeId)? artUriForNode,
}) {
  String nodeId(String id) {
    if (session == null) {
      return id;
    }
    return '$id/auth-session-$session';
  }

  Uri? artUri(String id) {
    return artUriForNode?.call(id) ?? Uri.parse('content://android.auto.drawable/$id');
  }

  return <MediaItem>[
    if (snapshot.continueItems.isNotEmpty)
      _androidAutoBrowsableRootItem(
        id: nodeId(androidAutoContinueNodeId),
        title: 'Continue',
        artUri: artUri('continue_ic'),
      ),
    if (snapshot.audioLibraries.isNotEmpty) ...[
      _androidAutoBrowsableRootItem(id: nodeId(androidAutoLibrariesNodeId), title: 'Libraries', artUri: artUri('apps')),
      _androidAutoBrowsableRootItem(id: nodeId(androidAutoRecentNodeId), title: 'Recent', artUri: artUri('recent')),
    ],
  ];
}

List<T> mapAndroidAutoContinueItems<T>(
  Iterable<LibraryItem> items, {
  required T? Function(LibraryItem item) mapAudiobook,
  required T? Function(LibraryItem item, Episode episode) mapPodcastEpisode,
  required String Function(LibraryItem source, Episode? episode, T item) idOf,
}) {
  final mappedItems = <T>[];
  final seenIds = <String>{};

  for (final item in items) {
    final recentEpisode = item.recentEpisode;
    final mapped = recentEpisode != null
        ? mapPodcastEpisode(item, recentEpisode)
        : _isAndroidAutoPodcastItem(item)
        ? null
        : mapAudiobook(item);
    if (mapped == null || !seenIds.add(idOf(item, recentEpisode, mapped))) {
      continue;
    }
    mappedItems.add(mapped);
  }

  return mappedItems;
}

bool _isAndroidAutoPodcastItem(LibraryItem item) {
  return item.mediaType == 'podcast' || item.media?.podcastMedia != null;
}

MediaItem _androidAutoBrowsableRootItem({required String id, required String title, Uri? artUri}) {
  return MediaItem(
    id: id,
    title: title,
    displayTitle: title,
    artUri: artUri,
    playable: false,
    extras: const <String, dynamic>{'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2},
  );
}
