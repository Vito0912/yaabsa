part of 'bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoMedia on BGAudioHandler {
  List<MediaItem> _androidAutoMediaItemsFromLibraryItems(List<LibraryItem> items, {required String subtitlePrefix}) {
    final mediaItems = <MediaItem>[];
    final seen = <String>{};

    for (final item in items) {
      if (!_androidAutoIsPlayableAudioItem(item)) {
        continue;
      }

      final mediaId = _androidAutoItemPlaybackId(item.id);
      if (!seen.add(mediaId)) {
        continue;
      }

      mediaItems.add(_androidAutoPlayableFromLibraryItem(item, mediaId: mediaId, subtitlePrefix: subtitlePrefix));
    }

    return mediaItems;
  }

  bool _androidAutoIsPlayableAudioItem(LibraryItem item) {
    final media = item.media;
    if (media == null) {
      return false;
    }

    if (item.mediaType == 'podcast') {
      final episodes = media.podcastMedia?.episodes ?? const <Episode>[];
      for (final episode in episodes) {
        if (episode.audioFile != null) {
          return true;
        }
      }
      return false;
    }

    return media.hasAudio;
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

    if (!_androidAutoIsPlayableAudioItem(item)) {
      return null;
    }

    return _androidAutoPlayableFromLibraryItem(
      item,
      mediaId: _androidAutoItemPlaybackId(item.id),
      subtitlePrefix: 'Downloaded',
      artUriOverride: artUri,
    );
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

    return _androidAutoPlayableItem(
      id: mediaId,
      title: item.title,
      subtitle: subtitle,
      artist: item.authorString,
      artUri: artUriOverride ?? _androidAutoCoverUri(item),
      duration: _androidAutoDurationFromSeconds(item.media?.duration()),
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

    final subtitle = (episode.subtitle != null && episode.subtitle!.trim().isNotEmpty)
        ? episode.subtitle!.trim()
        : subtitlePrefix == null || subtitlePrefix.trim().isEmpty
        ? item.title
        : '${subtitlePrefix.trim()} - ${item.title}';

    return _androidAutoPlayableItem(
      id: mediaIdOverride ?? _androidAutoEpisodePlaybackId(item.id, episode.id),
      title: episodeTitle,
      subtitle: subtitle,
      artist: item.authorString,
      artUri: artUriOverride ?? _androidAutoCoverUri(item),
      duration: _androidAutoDurationFromSeconds(episode.audioFile?.duration),
      extras: <String, dynamic>{
        'itemId': item.id,
        'episodeId': episode.id,
        if (item.libraryId != null) 'libraryId': item.libraryId,
      },
    );
  }

  Uri? _androidAutoCoverUri(LibraryItem item) {
    if (!item.hasCover) {
      return null;
    }

    final api = _ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    return api.getLibraryItemApi().getCoverUri(item.id);
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
