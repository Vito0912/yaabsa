import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_sort.dart';
import 'package:yaabsa/components/app/library/library_filter_sheet.dart';
import 'package:yaabsa/components/app/library/library_sort_sheet.dart';
import 'package:yaabsa/features/library/widgets/library_control_sheet.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('sort sheet keeps selection and reverses direction on a repeated selection', (tester) async {
    await tester.pumpWidget(const _LibrarySortHarness());

    await tester.tap(find.text('Open sort'));
    await tester.pumpAndSettle();
    expect(find.text('Sort'), findsOneWidget);
    expect(find.text('Sort Library'), findsNothing);
    expect(find.text('Choose a field. Tap it again to change the direction.'), findsNothing);
    await tester.tap(find.text('Title'));
    await tester.pumpAndSettle();
    expect(find.text('media.metadata.title:1'), findsOneWidget);

    await tester.tap(find.text('Open sort'));
    await tester.pumpAndSettle();
    expect(find.text('DESC'), findsOneWidget);
    await tester.tap(find.text('Title'));
    await tester.pumpAndSettle();

    expect(find.text('media.metadata.title:0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('library sort sheet retains random sort without a direction indicator', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const _LibrarySortHarness());
    await tester.tap(find.text('Open sort'));
    await tester.pumpAndSettle();
    final sortList = find.descendant(of: find.byType(LibraryControlSheet), matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(find.text('Randomly'), 240, scrollable: sortList);
    await tester.tap(find.text('Randomly'));
    await tester.pumpAndSettle();

    expect(find.text('random:1'), findsOneWidget);
    await tester.tap(find.text('Open sort'));
    await tester.pumpAndSettle();
    final reopenedSortList = find
        .descendant(of: find.byType(LibraryControlSheet), matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(find.text('Randomly'), 240, scrollable: reopenedSortList);
    expect(find.text('Randomly'), findsOneWidget);
    expect(find.text('ASC'), findsNothing);
    expect(find.text('DESC'), findsNothing);
  });

  testWidgets('filter sheet preserves special filters and the clear action', (tester) async {
    await tester.pumpWidget(const _LibraryFilterHarness(initialFilter: 'issues'));
    await tester.tap(find.text('Open filter'));
    await tester.pumpAndSettle();

    expect(find.text('Filter'), findsOneWidget);
    expect(find.text('Filter Library'), findsNothing);
    expect(find.text('Choose a filter, or clear the current selection.'), findsNothing);
    expect(find.text('Clear'), findsOneWidget);
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();
    expect(find.text('filter:'), findsOneWidget);

    await tester.tap(find.text('Open filter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Special'));
    await tester.pumpAndSettle();
    expect(find.text('Issues'), findsOneWidget);
    expect(find.text('Feed Open'), findsOneWidget);
    await tester.tap(find.text('Feed Open'));
    await tester.pumpAndSettle();

    expect(find.text('filter:feed-open'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('book filter supports searchable named filters and no-series selection', (tester) async {
    final filterData = LibraryFilterData(
      authors: [
        for (var index = 0; index < 15; index++)
          LibraryFilterNamedEntity(id: 'author-$index', name: 'Writer ${index.toString().padLeft(2, '0')}'),
      ],
      series: const [LibraryFilterNamedEntity(id: 'series-one', name: 'The Tidemark Stories')],
      genres: const ['Fantasy'],
      tags: const ['Award winner'],
      languages: const ['English'],
      narrators: const ['Elena Mar'],
    );
    await tester.pumpWidget(_LibraryFilterHarness(filterData: filterData));
    await tester.tap(find.text('Open filter'));
    await tester.pumpAndSettle();

    final sections = find.descendant(of: find.byType(LibraryControlSheet), matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(find.text('Authors'), 240, scrollable: sections);
    await tester.tap(find.text('Authors'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Writer 14');
    await tester.pumpAndSettle();
    expect(find.text('Writer 14'), findsNWidgets(2));
    expect(find.text('Writer 01'), findsNothing);
    await tester.tap(find.descendant(of: find.byType(ChoiceChip), matching: find.text('Writer 14')));
    await tester.pumpAndSettle();
    expect(
      find.text('filter:${LibraryFilter.grouped(LibraryFilterGroup.authors, 'author-14').queryValue}'),
      findsOneWidget,
    );

    await tester.tap(find.text('Open filter'));
    await tester.pumpAndSettle();
    final filterSections = find
        .descendant(of: find.byType(LibraryControlSheet), matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(find.text('Series'), 240, scrollable: filterSections);
    await tester.tap(find.text('Series'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No series'));
    await tester.pumpAndSettle();
    expect(
      find.text('filter:${LibraryFilter.grouped(LibraryFilterGroup.series, 'no-series').queryValue}'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('podcast filter omits book-only categories and fits a narrow viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const _LibraryFilterHarness(
        libraryMediaType: 'podcast',
        filterData: LibraryFilterData(genres: ['Mystery'], languages: ['English']),
      ),
    );
    await tester.tap(find.text('Open filter'));
    await tester.pumpAndSettle();
    expect(find.byType(LibraryControlSheet), findsOneWidget);
    expect(tester.takeException(), isNull);

    final sections = find.descendant(of: find.byType(LibraryControlSheet), matching: find.byType(Scrollable)).first;
    await tester.scrollUntilVisible(find.text('Languages'), 200, scrollable: sections);
    await tester.drag(sections, const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Progress'), findsNothing);
    expect(find.text('Missing Metadata'), findsNothing);
    expect(find.text('Tracks'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _LibrarySortHarness extends StatefulWidget {
  const _LibrarySortHarness();

  @override
  State<_LibrarySortHarness> createState() => _LibrarySortHarnessState();
}

class _LibrarySortHarnessState extends State<_LibrarySortHarness> {
  String? _sort;
  int? _descending;

  @override
  Widget build(BuildContext context) {
    final label = _sort == null ? 'default' : '$_sort:$_descending';

    return YaabsaPreviewApp(
      child: Builder(
        builder: (context) => Column(
          children: [
            Text(label),
            FilledButton(onPressed: () => _openSheet(context), child: const Text('Open sort')),
          ],
        ),
      ),
    );
  }

  Future<void> _openSheet(BuildContext context) async {
    final result = await showModalBottomSheet<LibrarySortSelection>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => LibrarySortSheet(
        libraryMediaType: 'book',
        activeFilter: null,
        activeSort: _sort,
        activeSortDesc: _descending,
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _sort = result.sort;
      _descending = result.desc;
    });
  }
}

class _LibraryFilterHarness extends StatefulWidget {
  const _LibraryFilterHarness({this.initialFilter, this.filterData, this.libraryMediaType = 'book'});

  final String? initialFilter;
  final LibraryFilterData? filterData;
  final String libraryMediaType;

  @override
  State<_LibraryFilterHarness> createState() => _LibraryFilterHarnessState();
}

class _LibraryFilterHarnessState extends State<_LibraryFilterHarness> {
  late String? _filter = widget.initialFilter;

  @override
  Widget build(BuildContext context) {
    return YaabsaPreviewApp(
      child: Builder(
        builder: (context) => Column(
          children: [
            Text('filter:${_filter ?? 'null'}'),
            FilledButton(onPressed: () => _openSheet(context), child: const Text('Open filter')),
          ],
        ),
      ),
    );
  }

  Future<void> _openSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => LibraryFilterSheet(
        libraryMediaType: widget.libraryMediaType,
        activeFilter: _filter,
        filterData: widget.filterData,
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _filter = result;
    });
  }
}
