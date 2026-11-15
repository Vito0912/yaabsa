import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/common/tables/expressive_action_list.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/components/common/tables/expressive_tile_list.dart';
import 'package:yaabsa/components/common/expressive_tab_view.dart';
import 'package:yaabsa/components/sessions/listening_session_list.dart';
import 'package:yaabsa/components/sessions/listening_sessions_pagination_controls.dart';

import 'preview_fixtures.dart';
import 'preview_theme.dart';

@Preview(name: 'Reusable lists and tables / light', size: Size(960, 820), wrapper: yaabsaPreviewLight)
@Preview(name: 'Reusable lists and tables / dark', size: Size(960, 820), wrapper: yaabsaPreviewDark)
@Preview(name: 'Reusable lists and tables / AMOLED', size: Size(960, 820), wrapper: yaabsaPreviewAmoled)
Widget reusableListControlsPreview() => const ReusableListControlsPreview();

class ReusableListControlsPreview extends StatelessWidget {
  const ReusableListControlsPreview({super.key});

  static const _rows = [
    _PreviewListRow(id: 'current', title: 'The Distant Shore', subtitle: 'Mira Ellery'),
    _PreviewListRow(id: 'queued', title: 'Winter at Low Tide', subtitle: 'Jonas Vale'),
  ];

  static const _actions = [
    ExpressiveListAction<_PreviewListRow>(
      icon: Icons.play_arrow_rounded,
      tooltip: 'Play',
      tone: ExpressiveListActionTone.primary,
      onPressed: _ignoreListRowAction,
    ),
    ExpressiveListAction<_PreviewListRow>(
      icon: Icons.delete_outline_rounded,
      tooltip: 'Remove',
      tone: ExpressiveListActionTone.danger,
      onPressed: _ignoreListRowAction,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Responsive table', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ExpressiveActionTable<_PreviewListRow>(
          rows: _rows,
          rowId: (row) => row.id,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          columns: const [
            ExpressiveTableColumn(
              id: 'title',
              label: 'Title',
              cellBuilder: _titleCell,
              mobileCellBuilder: _titleCell,
              width: 240,
            ),
            ExpressiveTableColumn(id: 'author', label: 'Author', cellBuilder: _authorCell, width: 180),
          ],
          actions: [
            ExpressiveTableAction(
              icon: Icons.play_arrow_rounded,
              tooltip: 'Play',
              tone: ExpressiveTableActionTone.primary,
              onPressed: _ignoreListRowAction,
            ),
            ExpressiveTableAction(
              icon: Icons.delete_outline_rounded,
              tooltip: 'Remove',
              tone: ExpressiveTableActionTone.danger,
              onPressed: _ignoreListRowAction,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Label and value rows', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ExpressiveActionList<_PreviewListRow>(
          rows: _rows,
          rowId: (row) => row.id,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          fields: const [
            ExpressiveListField(id: 'title', label: 'Title', valueBuilder: _titleCell),
            ExpressiveListField(id: 'author', label: 'Author', valueBuilder: _authorCell),
          ],
          actions: _actions,
        ),
        const SizedBox(height: 24),
        Text('Compact selectable rows', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ExpressiveTileList<_PreviewListRow>(
          items: _rows,
          itemId: (row) => row.id,
          titleBuilder: (row) => row.title,
          subtitleBuilder: (row) => row.subtitle,
          leadingIconBuilder: (_) => Icons.menu_book_rounded,
          isSelected: (row) => row.id == 'current',
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          actions: const [
            ExpressiveTileAction(
              icon: Icons.delete_outline_rounded,
              tooltip: 'Remove',
              tone: ExpressiveTileActionTone.danger,
              onPressed: _ignoreListRowAction,
            ),
          ],
        ),
      ],
    );
  }
}

class _PreviewListRow {
  const _PreviewListRow({required this.id, required this.title, required this.subtitle});

  final String id;
  final String title;
  final String subtitle;
}

Widget _titleCell(BuildContext context, _PreviewListRow row) => Text(row.title);

Widget _authorCell(BuildContext context, _PreviewListRow row) => Text(row.subtitle);

Future<void> _ignoreListRowAction(_PreviewListRow row) async {}

@Preview(name: 'Listening sessions / empty / light', size: Size(520, 520), wrapper: yaabsaPreviewLight)
@Preview(name: 'Listening sessions / empty / dark', size: Size(520, 520), wrapper: yaabsaPreviewDark)
@Preview(name: 'Listening sessions / empty / AMOLED', size: Size(520, 520), wrapper: yaabsaPreviewAmoled)
Widget listeningSessionsEmptyPreview() => const ListeningSessionsPagePreview();

@Preview(name: 'Listening sessions / populated / desktop light', size: Size(1280, 620), wrapper: yaabsaPreviewLight)
@Preview(name: 'Listening sessions / populated / desktop dark', size: Size(1280, 620), wrapper: yaabsaPreviewDark)
@Preview(name: 'Listening sessions / populated / desktop AMOLED', size: Size(1280, 620), wrapper: yaabsaPreviewAmoled)
Widget listeningSessionsPopulatedPreview() => const ListeningSessionsPagePreview(showPopulated: true);

class ListeningSessionsPagePreview extends StatelessWidget {
  const ListeningSessionsPagePreview({super.key, this.showPopulated = false});

  final bool showPopulated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 1200 ? 24.0 : 12.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Aesop's Fables, Volume 12 (Fables 276-284)",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ExpressiveTabView(
                          initialIndex: 1,
                          tabBarScrollable: false,
                          tabBarPadding: EdgeInsets.zero,
                          tabs: [
                            const ExpressiveTabViewItem(
                              id: 'activity',
                              label: 'Activity',
                              child: Center(child: Text('No listening activity found.')),
                            ),
                            ExpressiveTabViewItem(id: 'sessions', label: 'Sessions', child: _buildSessionsTab()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSessionsTab() {
    final sessions = showPopulated ? previewPlaybackSessions() : const <PlaybackSession>[];

    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      children: [
        ListeningSessionsPaginationControls(
          page: showPopulated ? 1 : 0,
          numPages: showPopulated ? 4 : 1,
          total: showPopulated ? 82 : 0,
          itemsPerPage: 20,
          onItemsPerPageChanged: (_) {},
          onPrevious: showPopulated ? () {} : null,
          onNext: showPopulated ? () {} : null,
        ),
        const SizedBox(height: 12),
        ListeningSessionTable(sessions: sessions),
      ],
    );
  }
}
