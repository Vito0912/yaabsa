part of 'stats_provider.dart';

class _AnalyticsSession {
  const _AnalyticsSession({
    required this.listeningTime,
    required this.mediaType,
    required this.itemId,
    required this.title,
    required this.author,
    required this.authors,
    required this.timestamp,
  });

  factory _AnalyticsSession.fromSession(PlaybackSession session) {
    return _AnalyticsSession(
      listeningTime: _safeListeningTime(session.timeListening),
      mediaType: _resolveMediaType(session),
      itemId: session.libraryItemId.trim().isNotEmpty ? session.libraryItemId : session.id,
      title: _resolveItemTitle(session),
      author: _resolveItemAuthor(session),
      authors: _resolveAuthors(session),
      timestamp: _resolveSessionTimestamp(session),
    );
  }

  final double listeningTime;
  final String mediaType;
  final String itemId;
  final String title;
  final String author;
  final List<_ResolvedAuthor> authors;
  final DateTime? timestamp;
}

DateTime? _resolveSessionTimestamp(PlaybackSession session) {
  if (session.startedAt != null && session.startedAt! > 0) {
    return DateTime.fromMillisecondsSinceEpoch(session.startedAt!);
  }

  if (session.updatedAt != null && session.updatedAt! > 0) {
    return DateTime.fromMillisecondsSinceEpoch(session.updatedAt!);
  }

  final dateString = session.date;
  if (dateString != null && dateString.isNotEmpty) {
    return DateTime.tryParse(dateString);
  }

  return null;
}

String _resolveMediaType(PlaybackSession session) {
  final mediaType = session.mediaType?.trim().toLowerCase();
  if (mediaType == 'book') {
    return 'book';
  }

  if (mediaType == 'podcast') {
    return 'podcast';
  }

  return session.episodeId == null ? 'book' : 'podcast';
}

String _resolveItemTitle(PlaybackSession session) {
  final displayTitle = session.displayTitle?.trim();
  if (displayTitle != null && displayTitle.isNotEmpty) {
    return displayTitle;
  }

  final metadata = session.mediaMetadata;
  final bookTitle = metadata?.bookMetadata?.title.trim();
  if (bookTitle != null && bookTitle.isNotEmpty) {
    return bookTitle;
  }

  final podcastTitle = metadata?.podcastMetadata?.title?.trim();
  if (podcastTitle != null && podcastTitle.isNotEmpty) {
    return podcastTitle;
  }

  return _ItemAggregate.unknownTitle;
}

String _resolveItemAuthor(PlaybackSession session) {
  final displayAuthor = session.displayAuthor?.trim();
  if (displayAuthor != null && displayAuthor.isNotEmpty) {
    return displayAuthor;
  }

  final metadata = session.mediaMetadata;
  final bookAuthors = metadata?.bookMetadata?.authors;
  if (bookAuthors != null && bookAuthors.isNotEmpty) {
    final joined = bookAuthors.map((author) => author.name.trim()).where((name) => name.isNotEmpty).join(', ');
    if (joined.isNotEmpty) {
      return joined;
    }
  }

  final podcastAuthor = metadata?.podcastMetadata?.author?.trim();
  if (podcastAuthor != null && podcastAuthor.isNotEmpty) {
    return podcastAuthor;
  }

  return _ItemAggregate.unknownAuthor;
}

List<_ResolvedAuthor> _resolveAuthors(PlaybackSession session) {
  final metadata = session.mediaMetadata;

  final authors = <_ResolvedAuthor>[];

  final bookAuthors = metadata?.bookMetadata?.authors;
  if (bookAuthors != null) {
    for (final author in bookAuthors) {
      final name = author.name.trim();
      if (name.isNotEmpty) {
        authors.add(_ResolvedAuthor(id: author.id, name: name));
      }
    }
  }

  final podcastAuthor = metadata?.podcastMetadata?.author?.trim();
  if (podcastAuthor != null && podcastAuthor.isNotEmpty) {
    authors.add(_ResolvedAuthor(name: podcastAuthor));
  }

  if (authors.isNotEmpty) {
    return authors;
  }

  final displayAuthor = session.displayAuthor?.trim();
  if (displayAuthor != null && displayAuthor.isNotEmpty) {
    return displayAuthor
        .split(',')
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .map((name) => _ResolvedAuthor(name: name))
        .toList(growable: false);
  }

  return const <_ResolvedAuthor>[];
}
