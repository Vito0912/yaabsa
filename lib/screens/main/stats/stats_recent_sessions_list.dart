import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class StatsRecentSessionsList extends StatelessWidget {
  const StatsRecentSessionsList({super.key, required this.sessions, this.maxItems = 8});

  final List<PlaybackSession> sessions;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Text('No recent sessions available.', style: Theme.of(context).textTheme.bodyMedium);
    }

    final sorted = List<PlaybackSession>.from(sessions)..sort((a, b) => _sessionTimeMs(b).compareTo(_sessionTimeMs(a)));
    final visible = sorted.take(maxItems).toList(growable: false);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final session = visible[index];
        final title = _titleFor(session);
        final subtitleParts = <String>[];

        final author = _authorFor(session);
        if (author.isNotEmpty) {
          subtitleParts.add(author);
        }

        subtitleParts.add(formatDateTimeLabel(_sessionDate(session)));

        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(subtitleParts.join(' • '), maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Text(formatListeningSeconds(session.timeListening)),
        );
      },
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemCount: visible.length,
    );
  }

  String _titleFor(PlaybackSession session) {
    final displayTitle = session.displayTitle?.trim();
    if (displayTitle != null && displayTitle.isNotEmpty) {
      return displayTitle;
    }

    return session.mediaMetadata?.bookMetadata?.title ??
        session.mediaMetadata?.podcastMetadata?.title ??
        'Unknown Item';
  }

  String _authorFor(PlaybackSession session) {
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

  DateTime? _sessionDate(PlaybackSession session) {
    if (session.startedAt != null && session.startedAt! > 0) {
      return DateTime.fromMillisecondsSinceEpoch(session.startedAt!);
    }

    if (session.updatedAt != null && session.updatedAt! > 0) {
      return DateTime.fromMillisecondsSinceEpoch(session.updatedAt!);
    }

    final date = session.date;
    if (date == null || date.isEmpty) {
      return null;
    }

    return DateTime.tryParse(date);
  }

  int _sessionTimeMs(PlaybackSession session) {
    return _sessionDate(session)?.millisecondsSinceEpoch ?? 0;
  }
}
