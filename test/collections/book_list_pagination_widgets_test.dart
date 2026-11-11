import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/components/app/item/book_list_membership_dialog.dart';

void main() {
  testWidgets('removing loaded rows still offers later pages instead of reporting an empty library', (tester) async {
    var entries = ['a'];
    var loads = 0;
    late VoidCallback removeRows;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            removeRows = () {
              setState(() {
                entries = [];
              });
            };
            return Scaffold(
              body: BookListMembershipDialog<String>(
                entries: AsyncData(entries),
                allowed: true,
                plural: 'collections',
                bookTitle: 'Book',
                id: (entry) => entry,
                name: (entry) => entry,
                membership: (_) => false,
                disabledReason: (_) => null,
                hasNextPage: true,
                onLoadMore: () async {
                  loads++;
                },
                onReload: () async {},
                onSave: (_, _) async {},
              ),
            );
          },
        ),
      ),
    );

    removeRows();
    await tester.pumpAndSettle();
    expect(find.text('No collections found in this library.'), findsNothing);
    await tester.tap(find.text('Load more'));
    await tester.pump();
    expect(loads, greaterThan(0));
  });

  testWidgets('scrolling appends entries and preserves selections from earlier pages', (tester) async {
    var entries = List.generate(5, (index) => '$index');
    var loads = 0;
    List<String>? savedOriginal;
    Set<String>? savedSelected;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return BookListMembershipDialog<String>(
                            entries: AsyncData(entries),
                            allowed: true,
                            plural: 'collections',
                            bookTitle: 'Book',
                            id: (entry) => entry,
                            name: (entry) => 'List $entry',
                            membership: (entry) => entry == '6',
                            disabledReason: (_) => null,
                            hasNextPage: entries.length == 5,
                            onLoadMore: () async {
                              loads++;
                              setState(() {
                                entries = List.generate(10, (index) => '$index');
                              });
                            },
                            onReload: () async {},
                            onSave: (original, selected) async {
                              savedOriginal = original;
                              savedSelected = selected;
                            },
                          );
                        },
                      );
                    },
                  );
                },
                child: const Text('Manage'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('List 0'));
    await tester.pump();

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(loads, 1);

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(savedOriginal, hasLength(10));
    expect(savedSelected, {'0', '6'});
  });
}
