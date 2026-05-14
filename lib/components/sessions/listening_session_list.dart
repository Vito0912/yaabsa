import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/sessions/listening_session_tile.dart';
import 'package:yaabsa/components/sessions/listening_session_utils.dart';

class ListeningSessionList extends StatelessWidget {
  const ListeningSessionList({
    required this.sessions,
    super.key,
    this.emptyMessage = 'No listening sessions found.',
    this.onSessionTap,
    this.usernameForSession,
    this.showSelection = false,
    this.selectedSessionIds = const <String>{},
    this.onSelectionChanged,
  });

  final List<PlaybackSession> sessions;
  final String emptyMessage;
  final Future<void> Function(PlaybackSession session)? onSessionTap;
  final String? Function(PlaybackSession session)? usernameForSession;
  final bool showSelection;
  final Set<String> selectedSessionIds;
  final void Function(PlaybackSession session, bool selected)? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyMedium)),
      );
    }

    final sorted = List<PlaybackSession>.from(sessions)
      ..sort((a, b) => listeningSessionTimestampMs(b).compareTo(listeningSessionTimestampMs(a)));

    return ListView.builder(
      itemCount: sorted.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final session = sorted[index];
        return ListeningSessionTile(
          session: session,
          username: usernameForSession?.call(session),
          showDivider: index != sorted.length - 1,
          showSelection: showSelection,
          isSelected: selectedSessionIds.contains(session.id),
          onSelectionChanged: onSelectionChanged == null
              ? null
              : (selected) {
                  onSelectionChanged!(session, selected);
                },
          onTap: onSessionTap == null
              ? null
              : () async {
                  await onSessionTap!(session);
                },
        );
      },
    );
  }
}
