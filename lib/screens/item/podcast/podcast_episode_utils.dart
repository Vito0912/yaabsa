import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';

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
    return 'Untitled episode';
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

  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
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
      return 'All';
    case PodcastEpisodeProgressFilter.incomplete:
      return 'Incomplete';
    case PodcastEpisodeProgressFilter.inProgress:
      return 'In Progress';
    case PodcastEpisodeProgressFilter.complete:
      return 'Complete';
  }
}

String podcastEpisodeSortModeLabel(PodcastEpisodeSortMode mode) {
  switch (mode) {
    case PodcastEpisodeSortMode.newestFirst:
      return 'Newest';
    case PodcastEpisodeSortMode.oldestFirst:
      return 'Oldest';
    case PodcastEpisodeSortMode.titleAsc:
      return 'Title A-Z';
    case PodcastEpisodeSortMode.titleDesc:
      return 'Title Z-A';
  }
}
