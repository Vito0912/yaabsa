import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/lists/multi_select_list_card.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('multi-select list toggles entries and applies select all and clear all', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(520, 600);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final selectedIds = <String>{'books'};

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: YaabsaMultiSelectListCard(
                title: 'Libraries',
                options: _options,
                selectedIds: selectedIds,
                onSelectionChanged: (nextSelection) {
                  setState(() {
                    selectedIds
                      ..clear()
                      ..addAll(nextSelection);
                  });
                },
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1/3'), findsOneWidget);
    expect(find.text('Audiobooks'), findsOneWidget);
    expect(find.text('Book library'), findsOneWidget);

    await tester.tap(find.text('Podcasts'));
    await tester.pumpAndSettle();
    expect(find.text('2/3'), findsOneWidget);

    await tester.tap(find.text('Select all'));
    await tester.pumpAndSettle();
    expect(find.text('3/3'), findsOneWidget);
    expect(selectedIds, {'books', 'podcasts', 'series'});

    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();
    expect(find.text('0/3'), findsOneWidget);
    expect(selectedIds, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('multi-select list shows an empty state and disables selection actions', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Scaffold(
          body: YaabsaMultiSelectListCard(
            title: 'Libraries',
            options: [],
            selectedIds: <String>{},
            onSelectionChanged: _ignoreSelection,
            enabled: false,
            emptyMessage: 'No libraries available.',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final selectAll = tester.widget<TextButton>(find.widgetWithText(TextButton, 'Select all'));
    final clearAll = tester.widget<TextButton>(find.widgetWithText(TextButton, 'Clear all'));

    expect(find.text('0/0'), findsOneWidget);
    expect(find.text('No libraries available.'), findsOneWidget);
    expect(selectAll.onPressed, isNull);
    expect(clearAll.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
}

const _options = [
  YaabsaMultiSelectOption(id: 'books', label: 'Audiobooks', subtitle: 'Book library'),
  YaabsaMultiSelectOption(id: 'podcasts', label: 'Podcasts', subtitle: 'Podcast library'),
  YaabsaMultiSelectOption(id: 'series', label: 'A long series name that should stay readable'),
];

void _ignoreSelection(Set<String> selection) {}
