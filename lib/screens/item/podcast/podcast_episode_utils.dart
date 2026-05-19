import 'package:yaabsa/api/library_items/episode.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/generated/l10n.dart';

enum PodcastEpisodeProgressFilter { all, incomplete, inProgress, complete }

enum PodcastEpisodeSortMode { newestFirst, oldestFirst, titleAsc, titleDesc }

bool podcastEpisodeCompleted(MediaProgress? progress) {
  if (progress == null) {
    return false;
  }
  return progress.isFinished || progress.progress >= 0.999;
}

bool podcastEpisodeInProgress(MediaProgress? progress) {
  if (progress == null) {
    return false;
  }
  return !podcastEpisodeCompleted(progress) && progress.progress > 0;
}

String podcastEpisodeTitle(Episode episode) {
  final title = episode.title;
  if (title == null || title.trim().isEmpty) {
    return S.current.screensItemPodcastPodcastEpisodeUtilsUntitledEpisode;
  }
  return title.trim();
}

String? podcastEpisodeSubtitle(Episode episode) {
  final subtitle = episode.subtitle;
  if (subtitle == null || subtitle.trim().isEmpty) {
    return null;
  }
  return subtitle.trim();
}

String? podcastFormatEpisodeDate(Episode episode) {
  DateTime? date;

  if (episode.publishedAt != null && episode.publishedAt! > 0) {
    date = DateTime.fromMillisecondsSinceEpoch(episode.publishedAt!);
  }

  date ??= DateTime.tryParse(episode.pubDate ?? '');
  if (date == null) {
    return null;
  }

  return DateFormat.yMd(Intl.getCurrentLocale()).format(date);
}

String? podcastEpisodeDescriptionPreview(Episode episode) {
  final fullText = podcastEpisodeDescriptionFullText(episode);
  if (fullText.isEmpty) {
    return null;
  }

  for (final line in fullText.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }

  return null;
}

String podcastEpisodeDescriptionFullText(Episode episode) {
  final description = episode.description;
  if (description == null || description.trim().isEmpty) {
    return '';
  }

  var text = description;
  text = text.replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '\n');
  text = text.replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n');
  text = text.replaceAll(RegExp(r'<li\s*>', caseSensitive: false), '• ');
  text = text.replaceAll(RegExp(r'</li\s*>', caseSensitive: false), '\n');
  text = text.replaceAll(RegExp(r'<[^>]*>'), '');
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  text = text.replaceAll(RegExp(r'[\t\r ]+'), ' ');
  return text.trim();
}

String podcastEpisodeProgressFilterLabel(PodcastEpisodeProgressFilter filter) {
  switch (filter) {
    case PodcastEpisodeProgressFilter.all:
      return S.current.screensItemPodcastPodcastEpisodeUtilsAll;
    case PodcastEpisodeProgressFilter.incomplete:
      return S.current.screensItemPodcastPodcastEpisodeUtilsIncomplete;
    case PodcastEpisodeProgressFilter.inProgress:
      return S.current.screensItemPodcastPodcastEpisodeUtilsInProgress;
    case PodcastEpisodeProgressFilter.complete:
      return S.current.screensItemPodcastPodcastEpisodeUtilsComplete;
  }
}

String podcastEpisodeSortModeLabel(PodcastEpisodeSortMode mode) {
  switch (mode) {
    case PodcastEpisodeSortMode.newestFirst:
      return S.current.screensItemPodcastPodcastEpisodeUtilsNewest;
    case PodcastEpisodeSortMode.oldestFirst:
      return S.current.screensItemPodcastPodcastEpisodeUtilsOldest;
    case PodcastEpisodeSortMode.titleAsc:
      return S.current.screensItemPodcastPodcastEpisodeUtilsTitleAZ;
    case PodcastEpisodeSortMode.titleDesc:
      return S.current.screensItemPodcastPodcastEpisodeUtilsTitleZA;
  }
}
