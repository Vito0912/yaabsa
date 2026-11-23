import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/components/app/library/library_filter_toolbar.dart';
import 'package:yaabsa/components/app/series/series_detail_header.dart';
import 'package:yaabsa/components/common/list_management_header.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('library filter and sort buttons have compact surfaces and padded touch targets', (tester) async {
    for (final activeFilter in <String?>[null, 'issues']) {
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: LibraryFilterToolbar(
            libraryMediaType: 'book',
            activeFilter: activeFilter,
            activeSort: null,
            activeSortDesc: null,
            filterDataAsync: const AsyncData<LibraryFilterData?>(null),
            onFilterSelected: (_) async {},
            onSortSelected: (_) async {},
            onClearFilter: () async {},
          ),
        ),
      );

      for (final button in find.byType(OutlinedButton).evaluate()) {
        final buttonFinder = find.byWidget(button.widget);
        final materialFinder = find.descendant(of: buttonFinder, matching: find.byType(Material));
        expect(tester.getSize(buttonFinder).height, 48);
        expect(tester.getSize(materialFinder).height, 40);
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('collection and playlist creation buttons use compact surfaces', (tester) async {
    for (final label in ['New collection', 'New playlist']) {
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: ListManagementHeader(createLabel: label, onCreate: () {}),
        ),
      );

      final buttonFinder = find.byType(FilledButton);
      final materialFinder = find.descendant(of: buttonFinder, matching: find.byType(Material));
      expect(tester.getSize(buttonFinder).height, 48);
      expect(tester.getSize(materialFinder).height, 40);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('mobile series detail keeps the shared sort button color and height without its label', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SeriesDetailHeader(onBack: () {}, onSortPressed: () {}, sortLabel: 'Title A-Z', title: 'Series name'),
      ),
    );

    final sortButton = find.byType(OutlinedButton);
    expect(sortButton, findsOneWidget);
    expect(find.text('Title A-Z'), findsNothing);
    expect(tester.getSize(sortButton), const Size(48, 48));
    _expectSortIconUsesThemePrimary(tester, sortButton);
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrator library header keeps only the inline sort action', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: LibraryFilterToolbar(
          libraryMediaType: 'book',
          activeFilter: 'narrator=sample',
          activeSort: null,
          activeSortDesc: null,
          filterDataAsync: const AsyncData<LibraryFilterData?>(null),
          onFilterSelected: (_) async {},
          onSortSelected: (_) async {},
          onClearFilter: () async {},
          title: 'Narrator name',
          onBack: () {},
        ),
      ),
    );

    expect(find.text('Narrator name'), findsOneWidget);
    final sortButton = find.byType(OutlinedButton);
    expect(sortButton, findsOneWidget);
    expect(tester.getSize(sortButton), const Size(48, 48));
    expect(find.text('Filter'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop narrator library header keeps the labeled sort button inline', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: LibraryFilterToolbar(
          libraryMediaType: 'book',
          activeFilter: 'narrator=sample',
          activeSort: null,
          activeSortDesc: null,
          filterDataAsync: const AsyncData<LibraryFilterData?>(null),
          onFilterSelected: (_) async {},
          onSortSelected: (_) async {},
          onClearFilter: () async {},
          title: 'Narrator name',
          onBack: () {},
        ),
      ),
    );

    expect(find.text('Narrator name'), findsOneWidget);
    final sortButton = find.byType(OutlinedButton);
    expect(sortButton, findsOneWidget);
    expect(find.text('Added At (DESC)'), findsOneWidget);
    expect(tester.getSize(sortButton).height, 48);
    _expectSortIconUsesThemePrimary(tester, sortButton);
    expect(find.text('Filter'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop series detail keeps the labeled shared sort button', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SeriesDetailHeader(onBack: () {}, onSortPressed: () {}, sortLabel: 'Title A-Z', title: 'Series name'),
      ),
    );

    final sortButton = find.byType(OutlinedButton);
    expect(sortButton, findsOneWidget);
    expect(find.text('Title A-Z'), findsOneWidget);
    expect(tester.getSize(sortButton).height, 48);
    _expectSortIconUsesThemePrimary(tester, sortButton);
    expect(tester.takeException(), isNull);
  });

  testWidgets('series and narrator sort buttons match the library toolbar height', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: LibraryFilterToolbar(
          libraryMediaType: 'book',
          activeFilter: null,
          activeSort: null,
          activeSortDesc: null,
          filterDataAsync: const AsyncData<LibraryFilterData?>(null),
          onFilterSelected: (_) async {},
          onSortSelected: (_) async {},
          onClearFilter: () async {},
        ),
      ),
    );

    final librarySortHeight = tester.getSize(find.byType(OutlinedButton).last).height;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SeriesDetailHeader(onBack: () {}, onSortPressed: () {}, sortLabel: 'Title A-Z', title: 'Series name'),
      ),
    );

    final seriesSortHeight = tester.getSize(find.byType(OutlinedButton)).height;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: LibraryFilterToolbar(
          libraryMediaType: 'book',
          activeFilter: 'narrator=sample',
          activeSort: null,
          activeSortDesc: null,
          filterDataAsync: const AsyncData<LibraryFilterData?>(null),
          onFilterSelected: (_) async {},
          onSortSelected: (_) async {},
          onClearFilter: () async {},
          title: 'Narrator name',
          onBack: () {},
        ),
      ),
    );

    final narratorSortHeight = tester.getSize(find.byType(OutlinedButton)).height;

    expect(seriesSortHeight, librarySortHeight);
    expect(narratorSortHeight, librarySortHeight);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile series and narrator sort controls match library height', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: LibraryFilterToolbar(
          libraryMediaType: 'book',
          activeFilter: null,
          activeSort: null,
          activeSortDesc: null,
          filterDataAsync: const AsyncData<LibraryFilterData?>(null),
          onFilterSelected: (_) async {},
          onSortSelected: (_) async {},
          onClearFilter: () async {},
        ),
      ),
    );

    final librarySortHeight = tester.getSize(find.byType(OutlinedButton).last).height;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SeriesDetailHeader(onBack: () {}, onSortPressed: () {}, sortLabel: 'Title A-Z', title: 'Series name'),
      ),
    );

    final seriesSortHeight = tester.getSize(find.byType(OutlinedButton)).height;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: LibraryFilterToolbar(
          libraryMediaType: 'book',
          activeFilter: 'narrator=sample',
          activeSort: null,
          activeSortDesc: null,
          filterDataAsync: const AsyncData<LibraryFilterData?>(null),
          onFilterSelected: (_) async {},
          onSortSelected: (_) async {},
          onClearFilter: () async {},
          title: 'Narrator name',
          onBack: () {},
        ),
      ),
    );

    final narratorSortHeight = tester.getSize(find.byType(OutlinedButton)).height;

    expect(seriesSortHeight, librarySortHeight);
    expect(narratorSortHeight, librarySortHeight);
    expect(tester.takeException(), isNull);
  });
}

void _expectSortIconUsesThemePrimary(WidgetTester tester, Finder buttonFinder) {
  final iconFinder = find.descendant(of: buttonFinder, matching: find.byIcon(Icons.sort_rounded));
  final button = tester.widget<OutlinedButton>(buttonFinder);
  final colorScheme = Theme.of(tester.element(buttonFinder)).colorScheme;
  final enabledStates = <WidgetState>{};

  expect(IconTheme.of(tester.element(iconFinder)).color, colorScheme.primary);
  expect(button.style?.foregroundColor?.resolve(enabledStates), colorScheme.primary);
  expect(button.style?.side, isNull);

  final materialFinder = find.descendant(of: buttonFinder, matching: find.byType(Material));
  final material = tester.widget<Material>(materialFinder);
  final shape = material.shape! as OutlinedBorder;
  expect(shape.side.color, colorScheme.outline);
  expect(tester.getSize(materialFinder).height, 40);
}
