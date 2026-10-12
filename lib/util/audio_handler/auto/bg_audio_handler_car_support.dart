part of '../bg_audio_handler.dart';

const String _androidAutoContinueNodeId = 'aa/continue';
const String _androidAutoRecentNodeId = 'aa/recent';
const String _androidAutoLibrariesNodeId = 'aa/libraries';
const String _androidAutoDownloadsNodeId = 'aa/downloads';
const String _androidAutoAutomotiveFeatureFlag = 'android.hardware.type.automotive';
const String _androidAutoBrowseSessionMarker = '/auth-session-';

bool? _androidAutoIsAutomotiveSystemCache;

String _androidAutoSessionNodeId(BGAudioHandler handler, String nodeId) {
  return '$nodeId$_androidAutoBrowseSessionMarker${handler._androidAutoBrowseSession}';
}

String _androidAutoNormalizeSessionNodeId(String nodeId) {
  for (final rootNodeId in const <String>[
    _androidAutoContinueNodeId,
    _androidAutoRecentNodeId,
    _androidAutoLibrariesNodeId,
    _androidAutoDownloadsNodeId,
  ]) {
    if (nodeId.startsWith('$rootNodeId$_androidAutoBrowseSessionMarker')) {
      return rootNodeId;
    }
  }
  return nodeId;
}

const String _androidAutoCompletionStatusExtrasKey = 'android.media.extra.PLAYBACK_STATUS';
const String _androidAutoCompletionPercentageExtrasKey = 'androidx.media.MediaItem.Extras.COMPLETION_PERCENTAGE';
const int _androidAutoCompletionStatusNotPlayed = 0;
const int _androidAutoCompletionStatusPartiallyPlayed = 1;
const int _androidAutoCompletionStatusFullyPlayed = 2;

const int _androidAutoDefaultPageSize = 100;
const int _androidAutoMaxPageSize = 200;
const int _androidAutoSearchResultsPerLibrary = 4;
const int _androidAutoLetterGroupingThreshold = 30;
const int _androidAutoAuthenticationRequiredErrorCode = 3;
const String _androidAutoAuthenticationRequiredMessage = 'Authentication required';
const String _androidAutoUnauthenticatedContentUnavailableMessage = 'No content is avaiable if not signed in.';
const String _androidAutoUnauthenticatedSignInHintMessage = 'You can sign in via the settings';

const String _androidAutoSortFieldTitle = 'title';
const String _androidAutoSortFieldAuthor = 'author';
const String _androidAutoSortFieldAdded = 'added';

const Map<String, String> _androidAutoBookSortFieldToApiSort = <String, String>{
  _androidAutoSortFieldTitle: 'media.metadata.title',
  _androidAutoSortFieldAuthor: 'media.metadata.authorName',
  _androidAutoSortFieldAdded: 'addedAt',
};

const Map<String, String> _androidAutoPodcastSortFieldToApiSort = <String, String>{
  _androidAutoSortFieldTitle: 'media.metadata.title',
  _androidAutoSortFieldAuthor: 'media.metadata.author',
  _androidAutoSortFieldAdded: 'addedAt',
};

class _AndroidAutoPagingOptions {
  const _AndroidAutoPagingOptions({required this.page, required this.pageSize, required this.hasExplicitPaging});

  final int page;
  final int pageSize;
  final bool hasExplicitPaging;

  int get startIndex => page * pageSize;
}

class _AndroidAutoPlaybackTarget {
  const _AndroidAutoPlaybackTarget({required this.itemId, this.episodeId});

  final String itemId;
  final String? episodeId;
}

enum _AndroidAutoAuthenticationState { authenticated, initializing, authRequired }

class _AndroidAutoLibraryItemsPage {
  const _AndroidAutoLibraryItemsPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<LibraryItem> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => ((page + 1) * pageSize) < total;
}

class _AndroidAutoSeriesPage {
  const _AndroidAutoSeriesPage({required this.series, required this.total, required this.page, required this.pageSize});

  final List<Series> series;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => ((page + 1) * pageSize) < total;
}

enum _AndroidAutoLibraryTab {
  all,
  recentlyAdded,
  latestEpisodes,
  authors,
  series,
  collections,
  playlists,
  discovery,
  continueSeries,
  narrators,
}

extension _AndroidAutoLibraryTabX on _AndroidAutoLibraryTab {
  String get key {
    switch (this) {
      case _AndroidAutoLibraryTab.all:
        return 'all';
      case _AndroidAutoLibraryTab.recentlyAdded:
        return 'recently-added';
      case _AndroidAutoLibraryTab.latestEpisodes:
        return 'latest-episodes';
      case _AndroidAutoLibraryTab.authors:
        return 'authors';
      case _AndroidAutoLibraryTab.series:
        return 'series';
      case _AndroidAutoLibraryTab.collections:
        return 'collections';
      case _AndroidAutoLibraryTab.playlists:
        return 'playlists';
      case _AndroidAutoLibraryTab.discovery:
        return 'discovery';
      case _AndroidAutoLibraryTab.continueSeries:
        return 'continue-series';
      case _AndroidAutoLibraryTab.narrators:
        return 'narrators';
    }
  }

  String get label {
    switch (this) {
      case _AndroidAutoLibraryTab.all:
        return 'All';
      case _AndroidAutoLibraryTab.recentlyAdded:
        return 'Recently Added';
      case _AndroidAutoLibraryTab.latestEpisodes:
        return 'Latest Episodes';
      case _AndroidAutoLibraryTab.authors:
        return 'Authors';
      case _AndroidAutoLibraryTab.series:
        return 'Series';
      case _AndroidAutoLibraryTab.collections:
        return 'Collections';
      case _AndroidAutoLibraryTab.playlists:
        return 'Playlists';
      case _AndroidAutoLibraryTab.discovery:
        return 'Discovery';
      case _AndroidAutoLibraryTab.continueSeries:
        return 'Continue Series';
      case _AndroidAutoLibraryTab.narrators:
        return 'Narrators';
    }
  }

  String? get subtitle {
    switch (this) {
      case _AndroidAutoLibraryTab.all:
        return 'This can take a while to load';
      default:
        return null;
    }
  }

  static _AndroidAutoLibraryTab? tryParse(String key) {
    for (final tab in _AndroidAutoLibraryTab.values) {
      if (tab.key == key) {
        return tab;
      }
    }
    return null;
  }
}

Future<bool> _androidAutoIsAutomotiveSystem() async {
  if (kIsWeb || !Platform.isAndroid) {
    return false;
  }

  final cached = _androidAutoIsAutomotiveSystemCache;
  if (cached != null) {
    return cached;
  }

  try {
    final connectionType = await const MethodChannel('com.ryanheise.audio_service.client.methods')
        .invokeMethod<int>('getCarConnectionType')
        .timeout(const Duration(seconds: 2));

    if (connectionType != null) {
      final isAutomotive = connectionType == 1;
      _androidAutoIsAutomotiveSystemCache = isAutomotive;
      return isAutomotive;
    }
  } catch (error) {
    logger('Native car detection unavailable: $error', tag: 'AudioHandler', level: InfoLevel.debug);
  }

  try {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final isAutomotive = androidInfo.systemFeatures.contains(_androidAutoAutomotiveFeatureFlag);
    _androidAutoIsAutomotiveSystemCache = isAutomotive;
    return isAutomotive;
  } catch (error) {
    logger(
      'Failed to detect automotive system for car browse root: $error',
      tag: 'AudioHandler',
      level: InfoLevel.warning,
    );
    _androidAutoIsAutomotiveSystemCache = false;
    return false;
  }
}

void _androidAutoSetAuthenticationRequiredStateIfNeeded(BGAudioHandler handler) {
  final currentState = handler.playbackState.value;
  if (currentState.errorCode == _androidAutoAuthenticationRequiredErrorCode) {
    return;
  }

  logger('[AAOS] authentication required', tag: 'AudioHandler', level: InfoLevel.info);
  handler.playbackState.add(
    currentState.copyWith(
      controls: const <MediaControl>[],
      systemActions: const <MediaAction>{},
      androidCompactActionIndices: const <int>[],
      processingState: AudioProcessingState.error,
      playing: false,
      errorCode: _androidAutoAuthenticationRequiredErrorCode,
      errorMessage: _androidAutoAuthenticationRequiredMessage,
    ),
  );
}

Future<void> _androidAutoClearAuthenticationRequiredState(BGAudioHandler handler) async {
  if (handler.playbackState.value.errorCode != _androidAutoAuthenticationRequiredErrorCode) {
    return;
  }

  await handler._updatePlaybackState();
  logger('[AAOS] authentication requirement cleared', tag: 'AudioHandler', level: InfoLevel.info);
}
