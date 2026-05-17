part of 'bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoMedia on BGAudioHandler {
  List<MediaItem> _androidAutoMediaItemsFromLibraryItems(List<LibraryItem> items, {required String subtitlePrefix}) {
    final mediaItems = <MediaItem>[];
    final seen = <String>{};

    for (final item in items) {
      final mediaItem = _androidAutoMediaEntryFromLibraryItem(item, subtitlePrefix: subtitlePrefix);
      if (mediaItem == null) {
        continue;
      }

      if (!seen.add(mediaItem.id)) {
        continue;
      }

      mediaItems.add(mediaItem);
    }

    return mediaItems;
  }

  MediaItem? _androidAutoMediaEntryFromLibraryItem(LibraryItem item, {String? subtitlePrefix, Uri? artUriOverride}) {
    if (!_androidAutoIsSupportedAudioItem(item)) {
      return null;
    }

    if (_androidAutoIsPodcastLibraryItem(item)) {
      return _androidAutoPodcastBrowsableFromLibraryItem(
        item,
        subtitlePrefix: subtitlePrefix,
        artUriOverride: artUriOverride,
      );
    }

    if (!_androidAutoIsPlayableAudioItem(item)) {
      return null;
    }

    return _androidAutoPlayableFromLibraryItem(
      item,
      mediaId: _androidAutoItemPlaybackId(item.id),
      subtitlePrefix: subtitlePrefix,
      artUriOverride: artUriOverride,
    );
  }

  bool _androidAutoIsPodcastLibraryItem(LibraryItem item) {
    return item.mediaType == 'podcast' || item.media?.podcastMedia != null;
  }

  bool _androidAutoIsSupportedAudioItem(LibraryItem item) {
    final media = item.media;
    if (_androidAutoIsPodcastLibraryItem(item)) {
      return media != null;
    }

    if (media == null) {
      return false;
    }

    return media.hasAudio;
  }

  bool _androidAutoIsPlayableAudioItem(LibraryItem item) {
    final media = item.media;
    if (media == null) {
      return false;
    }

    if (_androidAutoIsPodcastLibraryItem(item)) {
      return false;
    }

    return media.hasAudio;
  }

  List<Episode> _androidAutoPlayablePodcastEpisodes(LibraryItem item) {
    final episodes = item.media?.podcastMedia?.episodes ?? const <Episode>[];
    return episodes.where((episode) => episode.audioFile != null).toList(growable: false);
  }

  Future<List<Episode>> _androidAutoOrderedPlayablePodcastEpisodes(LibraryItem item) async {
    final episodes = _androidAutoPlayablePodcastEpisodes(item).toList(growable: true);
    if (episodes.isEmpty) {
      return const <Episode>[];
    }

    episodes.sort(_androidAutoPodcastEpisodeNewestFirstComparator);

    final descending = await _androidAutoPodcastSortDescending();
    if (!descending) {
      return episodes.reversed.toList(growable: false);
    }

    return episodes;
  }

  int _androidAutoPodcastEpisodeNewestFirstComparator(Episode left, Episode right) {
    final byTimestamp = _androidAutoPodcastEpisodeSortTimestamp(
      right,
    ).compareTo(_androidAutoPodcastEpisodeSortTimestamp(left));
    if (byTimestamp != 0) {
      return byTimestamp;
    }

    final byIndex = (right.index ?? -1).compareTo(left.index ?? -1);
    if (byIndex != 0) {
      return byIndex;
    }

    final leftTitle = (left.title ?? '').trim().toLowerCase();
    final rightTitle = (right.title ?? '').trim().toLowerCase();
    return rightTitle.compareTo(leftTitle);
  }

  int _androidAutoPodcastEpisodeSortTimestamp(Episode episode) {
    return episode.publishedAt ?? episode.addedAt ?? episode.updatedAt ?? 0;
  }

  Episode? _androidAutoEpisodeForItem(LibraryItem item, String episodeId) {
    final episodes = item.media?.podcastMedia?.episodes ?? const <Episode>[];
    for (final episode in episodes) {
      if (episode.id == episodeId) {
        return episode;
      }
    }
    return null;
  }

  String _androidAutoDownloadTitle(InternalDownload download) {
    final episodeTitle = download.episode?.title?.trim();
    if (episodeTitle != null && episodeTitle.isNotEmpty) {
      return episodeTitle;
    }

    final itemTitle = download.item?.title.trim();
    if (itemTitle != null && itemTitle.isNotEmpty) {
      return itemTitle;
    }

    return 'Downloaded media';
  }

  MediaItem? _androidAutoPlayableFromDownload(InternalDownload download) {
    final item = download.item;
    if (item == null) {
      return null;
    }

    final artUri = _androidAutoUriFromPathOrUri(download.coverPath);

    if (download.episode != null) {
      final episode = download.episode!;
      if (episode.audioFile == null) {
        return null;
      }

      return _androidAutoPlayableFromEpisode(
        item: item,
        episode: episode,
        subtitlePrefix: 'Downloaded',
        artUriOverride: artUri,
      );
    }

    return _androidAutoMediaEntryFromLibraryItem(item, subtitlePrefix: 'Downloaded', artUriOverride: artUri);
  }

  MediaItem _androidAutoBrowsableItem({
    required String id,
    required String title,
    String? subtitle,
    Uri? artUri,
    bool categoryStyle = false,
    Map<String, dynamic>? extras,
  }) {
    return MediaItem(
      id: id,
      title: title,
      displayTitle: title,
      displaySubtitle: subtitle,
      artUri: artUri,
      playable: false,
      extras: <String, dynamic>{
        AndroidContentStyle.browsableHintKey: categoryStyle
            ? AndroidContentStyle.categoryListItemHintValue
            : AndroidContentStyle.listItemHintValue,
        if (extras != null) ...extras,
      },
    );
  }

  MediaItem _androidAutoPlayableItem({
    required String id,
    required String title,
    String? subtitle,
    String? artist,
    Uri? artUri,
    Duration? duration,
    Map<String, dynamic>? extras,
  }) {
    return MediaItem(
      id: id,
      title: title,
      displayTitle: title,
      displaySubtitle: subtitle,
      artist: artist,
      artUri: artUri,
      duration: duration,
      playable: true,
      extras: <String, dynamic>{
        AndroidContentStyle.playableHintKey: AndroidContentStyle.listItemHintValue,
        if (extras != null) ...extras,
      },
    );
  }

  MediaItem _androidAutoPlayableFromLibraryItem(
    LibraryItem item, {
    required String mediaId,
    String? subtitlePrefix,
    Uri? artUriOverride,
  }) {
    final subtitleParts = <String>[
      if (subtitlePrefix != null && subtitlePrefix.trim().isNotEmpty) subtitlePrefix.trim(),
      if (item.authorString != null && item.authorString!.trim().isNotEmpty) item.authorString!.trim(),
    ];

    final subtitle = subtitleParts.isEmpty ? item.subtitle : subtitleParts.join(' - ');
    final completionExtras = _androidAutoIsPodcastLibraryItem(item)
        ? const <String, dynamic>{}
        : _androidAutoCompletionExtras(itemId: item.id);

    return _androidAutoPlayableItem(
      id: mediaId,
      title: item.title,
      subtitle: subtitle,
      artist: item.authorString,
      artUri: artUriOverride ?? _androidAutoCoverUri(item),
      duration: _androidAutoDurationFromSeconds(item.media?.duration()),
      extras: <String, dynamic>{
        ...completionExtras,
        'itemId': item.id,
        if (item.libraryId != null) 'libraryId': item.libraryId,
      },
    );
  }

  MediaItem _androidAutoPodcastBrowsableFromLibraryItem(
    LibraryItem item, {
    String? subtitlePrefix,
    Uri? artUriOverride,
  }) {
    final subtitleParts = <String>[
      if (subtitlePrefix != null && subtitlePrefix.trim().isNotEmpty) subtitlePrefix.trim(),
      if (item.authorString != null && item.authorString!.trim().isNotEmpty) item.authorString!.trim(),
    ];

    final subtitle = subtitleParts.isEmpty ? item.subtitle : subtitleParts.join(' - ');

    return _androidAutoBrowsableItem(
      id: _androidAutoPodcastNodeId(item.id),
      title: item.title,
      subtitle: subtitle,
      artUri: artUriOverride ?? _androidAutoCoverUri(item),
      extras: <String, dynamic>{'itemId': item.id, if (item.libraryId != null) 'libraryId': item.libraryId},
    );
  }

  MediaItem _androidAutoPlayableFromEpisode({
    required LibraryItem item,
    required Episode episode,
    String? mediaIdOverride,
    String? subtitlePrefix,
    Uri? artUriOverride,
  }) {
    final episodeTitle = (episode.title != null && episode.title!.trim().isNotEmpty)
        ? episode.title!.trim()
        : item.title;

    final hasPrefix = subtitlePrefix != null && subtitlePrefix.trim().isNotEmpty;
    final subtitle = (episode.subtitle != null && episode.subtitle!.trim().isNotEmpty)
        ? episode.subtitle!.trim()
        : hasPrefix
        ? '${subtitlePrefix.trim()} - ${item.title}'
        : _androidAutoIsPodcastLibraryItem(item)
        ? null
        : item.title;
    final completionExtras = _androidAutoCompletionExtras(itemId: item.id, episodeId: episode.id);

    return _androidAutoPlayableItem(
      id: mediaIdOverride ?? _androidAutoEpisodePlaybackId(item.id, episode.id),
      title: episodeTitle,
      subtitle: subtitle,
      artist: item.authorString,
      artUri: artUriOverride ?? _androidAutoCoverUri(item),
      duration: _androidAutoDurationFromSeconds(episode.audioFile?.duration),
      extras: <String, dynamic>{
        ...completionExtras,
        'itemId': item.id,
        'episodeId': episode.id,
        if (item.libraryId != null) 'libraryId': item.libraryId,
      },
    );
  }

  Map<String, dynamic> _androidAutoCompletionExtras({required String itemId, String? episodeId}) {
    final progressMap = _ref.read(mediaProgressProvider).value ?? const <String, MediaProgress>{};
    final progress = progressMap[mediaProgressKey(itemId, episodeId)];
    if (progress == null) {
      return <String, dynamic>{_androidAutoCompletionStatusExtrasKey: _androidAutoCompletionStatusNotPlayed};
    }

    final normalizedProgress = progress.progress.clamp(0.0, 1.0).toDouble();
    if (progress.isFinished || normalizedProgress >= 0.999) {
      return <String, dynamic>{
        _androidAutoCompletionStatusExtrasKey: _androidAutoCompletionStatusFullyPlayed,
        _androidAutoCompletionPercentageExtrasKey: 1.0,
      };
    }

    if (normalizedProgress <= 0) {
      return <String, dynamic>{_androidAutoCompletionStatusExtrasKey: _androidAutoCompletionStatusNotPlayed};
    }

    return <String, dynamic>{
      _androidAutoCompletionStatusExtrasKey: _androidAutoCompletionStatusPartiallyPlayed,
      _androidAutoCompletionPercentageExtrasKey: normalizedProgress,
    };
  }

  Uri? _androidAutoCoverUri(LibraryItem item) {
    if (!item.hasCover) {
      return null;
    }

    final api = _ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    final coverUri = api.getLibraryItemApi().getCoverUri(item.id, item: item);
    final scheme = coverUri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return coverUri;
    }

    final token = _ref.read(currentUserProvider).value?.preferredAuthToken?.trim();
    if (token == null || token.isEmpty) {
      return coverUri;
    }

    final nextQuery = <String, String>{...coverUri.queryParameters};
    nextQuery.putIfAbsent('token', () => token);
    return coverUri.replace(queryParameters: nextQuery);
  }

  Uri? _androidAutoUriFromPathOrUri(String? pathOrUri) {
    if (pathOrUri == null) {
      return null;
    }

    final trimmed = pathOrUri.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.scheme.isNotEmpty) {
      return parsed;
    }

    return Uri.file(trimmed);
  }

  Duration? _androidAutoDurationFromSeconds(double? seconds) {
    if (seconds == null || seconds.isNaN || seconds.isInfinite || seconds <= 0) {
      return null;
    }

    return Duration(microseconds: (seconds * Duration.microsecondsPerSecond).round());
  }
}
