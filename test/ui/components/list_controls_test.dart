import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/tables/expressive_action_list.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/components/common/tables/expressive_tile_list.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/feedback/empty_state_card.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('action list, table and tile list use the shared empty presentation', (tester) async {
    final controls = <Widget>[
      ExpressiveActionList<_Row>(rows: const [], fields: const [], rowId: (row) => row.id, emptyTitle: 'No books'),
      ExpressiveActionTable<_Row>(rows: const [], columns: const [], rowId: (row) => row.id, emptyTitle: 'No books'),
      ExpressiveTileList<_Row>(
        items: const [],
        itemId: (row) => row.id,
        titleBuilder: (row) => row.title,
        emptyTitle: 'No books',
      ),
    ];

    for (var index = 0; index < controls.length; index++) {
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: Scaffold(body: SizedBox(height: 300, child: controls[index])),
        ),
      );

      expect(find.byType(YaabsaEmptyStateCard), findsOneWidget);
      expect(find.text('No books'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('shared list action keeps its tooltip, tone and callback', (tester) async {
    _Row? invoked;
    const row = _Row(id: 'book-1', title: 'The Distant Shore');

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: SizedBox(height: 300, child: _ListWithAction(onRemove: (value) async => invoked = value)),
        ),
      ),
    );

    final action = find.byType(YaabsaActionIconButton);
    expect(action, findsOneWidget);
    expect(tester.widget<YaabsaActionIconButton>(action).tone, YaabsaActionTone.danger);
    expect(find.byTooltip('Remove book'), findsOneWidget);

    await tester.tap(find.byTooltip('Remove book'));
    await tester.pump();

    expect(invoked, row);
  });
}

class _Row {
  const _Row({required this.id, required this.title});

  final String id;
  final String title;

  @override
  bool operator ==(Object other) => other is _Row && other.id == id && other.title == title;

  @override
  int get hashCode => Object.hash(id, title);
}

class _ListWithAction extends StatelessWidget {
  const _ListWithAction({required this.onRemove});

  static const _row = _Row(id: 'book-1', title: 'The Distant Shore');

  final Future<void> Function(_Row) onRemove;

  @override
  Widget build(BuildContext context) {
    return ExpressiveActionList<_Row>(
      rows: const [_row],
      fields: const [ExpressiveListField(id: 'title', label: 'Title', valueBuilder: _title)],
      rowId: (row) => row.id,
      actions: [
        ExpressiveListAction(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Remove book',
          tone: ExpressiveListActionTone.danger,
          onPressed: onRemove,
        ),
      ],
    );
  }
}

Widget _title(BuildContext context, _Row row) => Text(row.title);
