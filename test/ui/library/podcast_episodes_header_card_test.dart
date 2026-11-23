import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episodes_header_card.dart';
import 'package:yaabsa/ui/components/inputs/field_decoration.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('episode search, filter and sort controls share height and input styling', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: PodcastEpisodesHeaderCard(
          totalEpisodeCount: 20,
          visibleEpisodeCount: 20,
          searchQuery: '',
          searchController: controller,
          progressFilter: PodcastEpisodeProgressFilter.all,
          sortMode: PodcastEpisodeSortMode.newestFirst,
          onSearchChanged: (_) {},
          onClearSearch: () {},
          onFilterChanged: (_) {},
          onSortChanged: (_) {},
        ),
      ),
    );

    final searchField = find.byType(YaabsaSearchField);
    final filterField = find.byType(YaabsaExpressiveDropdownField<PodcastEpisodeProgressFilter>);
    final sortField = find.byType(YaabsaExpressiveDropdownField<PodcastEpisodeSortMode>);
    final sizes = [searchField, filterField, sortField].map(tester.getSize).toList(growable: false);

    final searchInput = tester.widget<TextField>(find.descendant(of: searchField, matching: find.byType(TextField)));
    final searchSurface = find.descendant(of: searchField, matching: find.byType(InputDecorator));
    final filterSurface = find.descendant(of: filterField, matching: find.byType(Material)).first;
    final sortSurface = find.descendant(of: sortField, matching: find.byType(Material)).first;
    final searchBorder = searchInput.decoration!.enabledBorder! as OutlineInputBorder;
    final filterMenu = tester.widget<M3EDropdownMenu<PodcastEpisodeProgressFilter>>(
      find.byType(M3EDropdownMenu<PodcastEpisodeProgressFilter>),
    );
    final sortMenu = tester.widget<M3EDropdownMenu<PodcastEpisodeSortMode>>(
      find.byType(M3EDropdownMenu<PodcastEpisodeSortMode>),
    );

    expect(searchBorder.borderRadius, BorderRadius.circular(10));
    expect(filterMenu.fieldStyle.borderRadius, BorderRadius.circular(10));
    expect(sortMenu.fieldStyle.borderRadius, BorderRadius.circular(10));
    expect(sizes.map((size) => size.height).toSet(), hasLength(1), reason: 'Control heights differ: $sizes');
    expect(sizes.first.height, greaterThanOrEqualTo(YaabsaFieldDimensions.compactHeight));
    expect(
      tester.getSize(filterSurface).height,
      closeTo(tester.getSize(searchSurface).height, 0.5),
      reason: 'The filter border/background must match the actual search field surface height',
    );
    expect(
      tester.getSize(sortSurface).height,
      closeTo(tester.getSize(searchSurface).height, 0.5),
      reason: 'The sort border/background must match the actual search field surface height',
    );
    expect(tester.getSize(filterField).width, lessThan(tester.getSize(searchField).width));

    expect(tester.takeException(), isNull);
  });

  testWidgets('episode controls stay bounded inside a horizontal scroller', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: PodcastEpisodesHeaderCard(
            totalEpisodeCount: 20,
            visibleEpisodeCount: 20,
            searchQuery: '',
            searchController: controller,
            progressFilter: PodcastEpisodeProgressFilter.all,
            sortMode: PodcastEpisodeSortMode.newestFirst,
            onSearchChanged: (_) {},
            onClearSearch: () {},
            onFilterChanged: (_) {},
            onSortChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('episode controls reflow using available width and accessible text size', (tester) async {
    const sizes = [320.0, 390.0, 500.0, 600.0, 750.0, 800.0, 1280.0];
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in sizes) {
      for (final textScale in [1.0, 1.8]) {
        await tester.pumpWidget(
          YaabsaPreviewApp(
            child: MediaQuery(
              data: MediaQueryData(size: Size(width, 800), textScaler: TextScaler.linear(textScale)),
              child: SizedBox(
                width: width,
                child: PodcastEpisodesHeaderCard(
                  totalEpisodeCount: 20,
                  visibleEpisodeCount: 20,
                  searchQuery: '',
                  searchController: controller,
                  progressFilter: PodcastEpisodeProgressFilter.inProgress,
                  sortMode: PodcastEpisodeSortMode.oldestFirst,
                  onSearchChanged: (_) {},
                  onClearSearch: () {},
                  onFilterChanged: (_) {},
                  onSortChanged: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final search = tester.getSize(find.byType(YaabsaSearchField));
        final filterField = find.byType(YaabsaExpressiveDropdownField<PodcastEpisodeProgressFilter>);
        final sortField = find.byType(YaabsaExpressiveDropdownField<PodcastEpisodeSortMode>);
        final searchSurface = find.descendant(
          of: find.byType(YaabsaSearchField),
          matching: find.byType(InputDecorator),
        );
        final filterSurface = find.descendant(of: filterField, matching: find.byType(Material)).first;
        final sortSurface = find.descendant(of: sortField, matching: find.byType(Material)).first;

        expect(tester.takeException(), isNull, reason: '$width wide at ${textScale}x text');
        expect(_findFieldText('In Progress'), findsOneWidget);
        expect(_findFieldText('Oldest'), findsOneWidget);
        expect(find.textContaining('Filter:'), findsNothing);
        expect(find.textContaining('Sort:'), findsNothing);

        final filter = tester.getSize(filterField);
        final sort = tester.getSize(sortField);
        final searchSurfaceHeight = tester.getSize(searchSurface).height;
        expect(filter.height, search.height, reason: 'Filter should align at $width wide and ${textScale}x text');
        expect(sort.height, search.height, reason: 'Sort should align at $width wide and ${textScale}x text');
        expect(
          tester.getSize(filterSurface).height,
          closeTo(searchSurfaceHeight, 0.5),
          reason: 'Filter surface should align at $width wide and ${textScale}x text',
        );
        expect(
          tester.getSize(sortSurface).height,
          closeTo(searchSurfaceHeight, 0.5),
          reason: 'Sort surface should align at $width wide and ${textScale}x text',
        );
      }
    }
  });

  testWidgets('episode filter and sort dropdowns preserve controlled selections', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PodcastEpisodeProgressFilter? selectedFilter;
    PodcastEpisodeSortMode? selectedSort;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SizedBox(
          width: 800,
          child: PodcastEpisodesHeaderCard(
            totalEpisodeCount: 20,
            visibleEpisodeCount: 20,
            searchQuery: '',
            searchController: controller,
            progressFilter: PodcastEpisodeProgressFilter.all,
            sortMode: PodcastEpisodeSortMode.newestFirst,
            onSearchChanged: (_) {},
            onClearSearch: () {},
            onFilterChanged: (value) => selectedFilter = value,
            onSortChanged: (value) => selectedSort = value,
          ),
        ),
      ),
    );

    await tester.tap(_findFieldText('All').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Incomplete').last);
    await tester.pumpAndSettle();
    expect(selectedFilter, PodcastEpisodeProgressFilter.incomplete);

    await tester.tap(_findFieldText('Newest').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Title A-Z').last);
    await tester.pumpAndSettle();
    expect(selectedSort, PodcastEpisodeSortMode.titleAsc);
    expect(tester.takeException(), isNull);
  });
}

Finder _findFieldText(String label) {
  return find.text(label);
}
