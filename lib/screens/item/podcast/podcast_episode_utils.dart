import 'package:intl/intl.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/util/l10n.dart';

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

String? podcastEpisodeTitle(Episode episode) {
  final title = episode.title;
  if (title == null || title.trim().isEmpty) {
    return null;
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

String? podcastFormatEpisodeDate(Episode episode, {required String localeName}) {
  DateTime? date;

  if (episode.publishedAt != null && episode.publishedAt! > 0) {
    date = DateTime.fromMillisecondsSinceEpoch(episode.publishedAt!);
  }

  date ??= DateTime.tryParse(episode.pubDate ?? '');
  if (date == null) {
    return null;
  }

  return DateFormat.yMMMd(localeName).format(date);
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

String podcastEpisodeProgressFilterLabel(PodcastEpisodeProgressFilter filter, AppLocalizations l10n) {
  switch (filter) {
    case PodcastEpisodeProgressFilter.all:
      return l10n.filterAll;
    case PodcastEpisodeProgressFilter.incomplete:
      return l10n.statusIncomplete;
    case PodcastEpisodeProgressFilter.inProgress:
      return l10n.statusInProgress;
    case PodcastEpisodeProgressFilter.complete:
      return l10n.statusComplete;
  }
}

String podcastEpisodeSortModeLabel(PodcastEpisodeSortMode mode, AppLocalizations l10n) {
  switch (mode) {
    case PodcastEpisodeSortMode.newestFirst:
      return l10n.sortNewestFirst;
    case PodcastEpisodeSortMode.oldestFirst:
      return l10n.sortOldestFirst;
    case PodcastEpisodeSortMode.titleAsc:
      return l10n.sortTitleAscending;
    case PodcastEpisodeSortMode.titleDesc:
      return l10n.sortTitleDescending;
  }
}
