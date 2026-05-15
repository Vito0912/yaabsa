import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

String listeningSessionTitle(PlaybackSession session) {
  final displayTitle = session.displayTitle?.trim();
  if (displayTitle != null && displayTitle.isNotEmpty) {
    return displayTitle;
  }

  return session.mediaMetadata?.bookMetadata?.title ??
      session.mediaMetadata?.podcastMetadata?.title ??
      session.libraryItem?.title ??
      'Unknown Item';
}

String listeningSessionAuthor(PlaybackSession session) {
  final displayAuthor = session.displayAuthor?.trim();
  if (displayAuthor != null && displayAuthor.isNotEmpty) {
    return displayAuthor;
  }

  final podcastAuthor = session.mediaMetadata?.podcastMetadata?.author?.trim();
  if (podcastAuthor != null && podcastAuthor.isNotEmpty) {
    return podcastAuthor;
  }

  final authors = session.mediaMetadata?.bookMetadata?.authors;
  if (authors != null && authors.isNotEmpty) {
    return authors.map((entry) => entry.name).join(', ');
  }

  return '';
}

DateTime? listeningSessionDateTime(PlaybackSession session) {
  if (session.updatedAt != null && session.updatedAt! > 0) {
    return DateTime.fromMillisecondsSinceEpoch(session.updatedAt!);
  }

  if (session.startedAt != null && session.startedAt! > 0) {
    return DateTime.fromMillisecondsSinceEpoch(session.startedAt!);
  }

  final date = session.date;
  if (date == null || date.isEmpty) {
    return null;
  }

  return DateTime.tryParse(date);
}

int listeningSessionTimestampMs(PlaybackSession session) {
  return listeningSessionDateTime(session)?.millisecondsSinceEpoch ?? 0;
}

String listeningSessionListeningTimeLabel(PlaybackSession session) {
  return formatListeningSeconds(session.timeListening);
}

String listeningSessionProgressLabel(PlaybackSession session) {
  final current = session.currentTime;
  final duration = session.duration;

  if (current == null || current <= 0 || duration == null || duration <= 0) {
    return '';
  }

  final progress = ((current / duration) * 100).clamp(0, 100).round();
  return '$progress%';
}

String listeningSessionDeviceLabel(PlaybackSession session) {
  final deviceInfo = session.deviceInfo;
  if (deviceInfo == null) {
    return '';
  }

  final clientName = deviceInfo.clientName?.trim();
  if (clientName != null && clientName.isNotEmpty) {
    return clientName;
  }

  final model = deviceInfo.model?.trim();
  if (model != null && model.isNotEmpty) {
    return model;
  }

  final manufacturer = deviceInfo.manufacturer?.trim();
  if (manufacturer != null && manufacturer.isNotEmpty) {
    return manufacturer;
  }

  return '';
}
