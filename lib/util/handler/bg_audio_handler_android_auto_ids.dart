part of 'bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoIds on BGAudioHandler {
  _AndroidAutoPlaybackTarget? _androidAutoPlaybackTargetFromMediaId(String mediaId) {
    final segments = _androidAutoSegments(mediaId);

    if (segments.length == 4 && segments[0] == 'aa' && segments[1] == 'play' && segments[2] == 'item') {
      return _AndroidAutoPlaybackTarget(itemId: Uri.decodeComponent(segments[3]));
    }

    if (segments.length == 5 && segments[0] == 'aa' && segments[1] == 'play' && segments[2] == 'episode') {
      return _AndroidAutoPlaybackTarget(
        itemId: Uri.decodeComponent(segments[3]),
        episodeId: Uri.decodeComponent(segments[4]),
      );
    }

    return null;
  }

  _AndroidAutoPagingOptions _androidAutoPagingFromOptions(Map<String, dynamic>? options) {
    final page = _androidAutoReadInt(options, const <String>['android.media.browse.extra.PAGE', 'page']);
    final pageSize = _androidAutoReadInt(options, const <String>[
      'android.media.browse.extra.PAGE_SIZE',
      'pageSize',
      'limit',
    ]);

    return _AndroidAutoPagingOptions(
      page: (page ?? 0) < 0 ? 0 : (page ?? 0),
      pageSize: _clampInt(pageSize ?? _androidAutoDefaultPageSize, 1, _androidAutoMaxPageSize),
      hasExplicitPaging: page != null || pageSize != null,
    );
  }

  int? _androidAutoReadInt(Map<String, dynamic>? map, List<String> keys) {
    if (map == null) {
      return null;
    }

    for (final key in keys) {
      final value = map[key];
      if (value is int) {
        return value;
      }
      if (value is double) {
        return value.round();
      }
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }

    return null;
  }

  List<T> _androidAutoApplyPaging<T>(List<T> items, _AndroidAutoPagingOptions paging) {
    if (items.isEmpty) {
      return List<T>.empty(growable: false);
    }

    final start = paging.startIndex;
    if (start >= items.length) {
      return List<T>.empty(growable: false);
    }

    final end = start + paging.pageSize;
    return items.sublist(start, end > items.length ? items.length : end);
  }

  int _clampInt(int value, int min, int max) {
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }

  String _androidAutoRecentLibraryNodeId(String libraryId) {
    return 'aa/recent/${Uri.encodeComponent(libraryId)}';
  }

  String _androidAutoLibraryNodeId(String libraryId) {
    return 'aa/library/${Uri.encodeComponent(libraryId)}';
  }

  String _androidAutoLibraryTabNodeId(String libraryId, _AndroidAutoLibraryTab tab) {
    return '${_androidAutoLibraryNodeId(libraryId)}/tab/${tab.key}';
  }

  String _androidAutoAllPageNodeId(String libraryId, int page) {
    return '${_androidAutoLibraryNodeId(libraryId)}/tab/all/page/$page';
  }

  String _androidAutoAllLetterNodeId(String libraryId, String letter) {
    return '${_androidAutoLibraryNodeId(libraryId)}/tab/all/letter/${Uri.encodeComponent(letter)}';
  }

  String _androidAutoAuthorNodeId(String libraryId, String authorId) {
    return '${_androidAutoLibraryNodeId(libraryId)}/author/${Uri.encodeComponent(authorId)}';
  }

  String _androidAutoSeriesNodeId(String libraryId, String seriesId) {
    return '${_androidAutoLibraryNodeId(libraryId)}/series/${Uri.encodeComponent(seriesId)}';
  }

  String _androidAutoCollectionNodeId(String libraryId, String collectionId) {
    return '${_androidAutoLibraryNodeId(libraryId)}/collection/${Uri.encodeComponent(collectionId)}';
  }

  String _androidAutoPlaylistNodeId(String libraryId, String playlistId) {
    return '${_androidAutoLibraryNodeId(libraryId)}/playlist/${Uri.encodeComponent(playlistId)}';
  }

  String _androidAutoNarratorNodeId(String libraryId, String narrator) {
    return '${_androidAutoLibraryNodeId(libraryId)}/narrator/${Uri.encodeComponent(narrator)}';
  }

  String _androidAutoItemPlaybackId(String itemId) {
    return 'aa/play/item/${Uri.encodeComponent(itemId)}';
  }

  String _androidAutoEpisodePlaybackId(String itemId, String episodeId) {
    return 'aa/play/episode/${Uri.encodeComponent(itemId)}/${Uri.encodeComponent(episodeId)}';
  }

  String? _androidAutoRecentLibraryIdFromNode(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length == 3 && segments[0] == 'aa' && segments[1] == 'recent') {
      return Uri.decodeComponent(segments[2]);
    }
    return null;
  }

  String? _androidAutoLibraryIdFromNode(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length == 3 && segments[0] == 'aa' && segments[1] == 'library') {
      return Uri.decodeComponent(segments[2]);
    }
    return null;
  }

  ({String libraryId, int page})? _androidAutoAllPageNodeFromId(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length != 7 ||
        segments[0] != 'aa' ||
        segments[1] != 'library' ||
        segments[3] != 'tab' ||
        segments[4] != 'all' ||
        segments[5] != 'page') {
      return null;
    }

    final page = int.tryParse(segments[6]);
    if (page == null || page < 0) {
      return null;
    }

    return (libraryId: Uri.decodeComponent(segments[2]), page: page);
  }

  ({String libraryId, String letter})? _androidAutoAllLetterNodeFromId(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length != 7 ||
        segments[0] != 'aa' ||
        segments[1] != 'library' ||
        segments[3] != 'tab' ||
        segments[4] != 'all' ||
        segments[5] != 'letter') {
      return null;
    }

    final letter = Uri.decodeComponent(segments[6]).trim();
    if (letter.isEmpty) {
      return null;
    }

    return (libraryId: Uri.decodeComponent(segments[2]), letter: letter);
  }

  ({String libraryId, _AndroidAutoLibraryTab tab})? _androidAutoLibraryTabFromNode(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length != 5 || segments[0] != 'aa' || segments[1] != 'library' || segments[3] != 'tab') {
      return null;
    }

    final tab = _AndroidAutoLibraryTabX.tryParse(segments[4]);
    if (tab == null) {
      return null;
    }

    return (libraryId: Uri.decodeComponent(segments[2]), tab: tab);
  }

  ({String libraryId, String authorId})? _androidAutoAuthorNodeFromId(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length != 5 || segments[0] != 'aa' || segments[1] != 'library' || segments[3] != 'author') {
      return null;
    }

    return (libraryId: Uri.decodeComponent(segments[2]), authorId: Uri.decodeComponent(segments[4]));
  }

  ({String libraryId, String seriesId})? _androidAutoSeriesNodeFromId(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length != 5 || segments[0] != 'aa' || segments[1] != 'library' || segments[3] != 'series') {
      return null;
    }

    return (libraryId: Uri.decodeComponent(segments[2]), seriesId: Uri.decodeComponent(segments[4]));
  }

  ({String libraryId, String collectionId})? _androidAutoCollectionNodeFromId(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length != 5 || segments[0] != 'aa' || segments[1] != 'library' || segments[3] != 'collection') {
      return null;
    }

    return (libraryId: Uri.decodeComponent(segments[2]), collectionId: Uri.decodeComponent(segments[4]));
  }

  ({String libraryId, String playlistId})? _androidAutoPlaylistNodeFromId(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length != 5 || segments[0] != 'aa' || segments[1] != 'library' || segments[3] != 'playlist') {
      return null;
    }

    return (libraryId: Uri.decodeComponent(segments[2]), playlistId: Uri.decodeComponent(segments[4]));
  }

  ({String libraryId, String narrator})? _androidAutoNarratorNodeFromId(String mediaId) {
    final segments = _androidAutoSegments(mediaId);
    if (segments.length != 5 || segments[0] != 'aa' || segments[1] != 'library' || segments[3] != 'narrator') {
      return null;
    }

    return (libraryId: Uri.decodeComponent(segments[2]), narrator: Uri.decodeComponent(segments[4]));
  }

  List<String> _androidAutoSegments(String value) {
    return value.split('/').where((segment) => segment.isNotEmpty).toList(growable: false);
  }
}
