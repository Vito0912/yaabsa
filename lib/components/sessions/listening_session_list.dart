import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/components/sessions/listening_session_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/l10n.dart';

class ListeningSessionTable extends StatelessWidget {
  const ListeningSessionTable({
    required this.sessions,
    super.key,
    this.emptyMessage,
    this.onSessionTap,
    this.usernameForSession,
    this.showSelection = false,
    this.selectedSessionIds = const <String>{},
    this.onSelectionChanged,
    this.actions = const [],
    this.actionsColumnWidth = 118,
  });

  final List<PlaybackSession> sessions;
  final String? emptyMessage;
  final Future<void> Function(PlaybackSession session)? onSessionTap;
  final String? Function(PlaybackSession session)? usernameForSession;
  final bool showSelection;
  final Set<String> selectedSessionIds;
  final void Function(PlaybackSession session, bool selected)? onSelectionChanged;
  final List<ExpressiveTableAction<PlaybackSession>> actions;
  final double actionsColumnWidth;

  @override
  Widget build(BuildContext context) {
    final sorted = List<PlaybackSession>.from(sessions)
      ..sort((a, b) => listeningSessionTimestampMs(b).compareTo(listeningSessionTimestampMs(a)));

    return ExpressiveActionTable<PlaybackSession>(
      rows: sorted,
      rowId: (session) => session.id,
      actions: actions,
      actionsColumnWidth: actionsColumnWidth,
      onRowTap: onSessionTap,
      emptyTitle: emptyMessage ?? context.l10n.sessionNoResults,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      showSelection: showSelection,
      selectedRowIds: selectedSessionIds,
      onSelectionChanged: onSelectionChanged == null
          ? null
          : (session, selected) => onSelectionChanged!(session, selected),
      columns: [
        ExpressiveTableColumn<PlaybackSession>(
          id: 'title',
          label: context.l10n.fieldTitle,
          width: 220,
          cellBuilder: (context, session) =>
              Text(listeningSessionTitle(session), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<PlaybackSession>(
          id: 'author',
          label: context.l10n.fieldAuthor,
          width: 160,
          showOnMobile: false,
          cellBuilder: (context, session) =>
              Text(listeningSessionAuthor(session), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        if (usernameForSession != null)
          ExpressiveTableColumn<PlaybackSession>(
            id: 'user',
            label: context.l10n.fieldUser,
            width: 140,
            cellBuilder: (context, session) =>
                Text(usernameForSession!(session) ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
          ),

        ExpressiveTableColumn<PlaybackSession>(
          id: 'device',
          label: context.l10n.fieldDevice,
          width: 100,
          showOnMobile: false,
          cellBuilder: (context, session) =>
              Text(listeningSessionDeviceLabel(session), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<PlaybackSession>(
          id: 'date',
          label: context.l10n.fieldDate,
          width: 100,
          tooltipBuilder: (session) {
            final dt = listeningSessionDateTime(session);
            return dt != null ? formatDateTimeLabel(dt) : null;
          },
          cellBuilder: (context, session) {
            final dt = listeningSessionDateTime(session);
            return Text(
              dt != null ? timeago.format(dt, locale: Localizations.localeOf(context).languageCode) : '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        ExpressiveTableColumn<PlaybackSession>(
          id: 'time',
          label: context.l10n.fieldTime,
          width: 100,
          alignment: ExpressiveTableCellAlignment.end,
          cellBuilder: (context, session) =>
              Text(listeningSessionListeningTimeLabel(session), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<PlaybackSession>(
          id: 'progress',
          label: context.l10n.fieldProgress,
          width: 100,
          showOnMobile: false,
          alignment: ExpressiveTableCellAlignment.end,
          cellBuilder: (context, session) {
            final progressLabel = listeningSessionProgressLabel(session);
            if (progressLabel.isEmpty) {
              return const SizedBox.shrink();
            }
            return Text(progressLabel, maxLines: 2, overflow: TextOverflow.ellipsis);
          },
        ),
      ],
    );
  }
}
