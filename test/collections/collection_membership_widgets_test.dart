import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/book_collection_membership_dialog.dart';
import 'package:yaabsa/components/app/item/book_collections_metadata.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/app/library/library_multi_select_actions.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/util/collection_membership.dart';

import 'collection_test_support.dart';

Widget metadata(WidgetRef ref, BuildContext context) => ItemMetadataCard(
  rows: [
    buildBookCollectionsMetadataRow(
      context,
      collections: ref.watch(bookCollectionMembershipsProvider((libraryId: 'library', bookId: 'book'))),
      onRetry: () {},
    ),
  ],
  inlineValues: true,
);

Future<void> mount(WidgetTester tester, ProviderContainer container) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) => Column(
              children: [
                metadata(ref, context),
                TextButton(
                  onPressed: () => showBookCollectionMembershipDialog(context: context, item: testBook),
                  child: const Text('Manage'),
                ),
                TextButton(
                  onPressed: () => addSelectedBooksToCollection(
                    context: context,
                    ref: ref,
                    libraryId: 'library',
                    selectedBookIds: ['book', 'other'],
                    onSuccess: () {},
                  ),
                  child: const Text('Bulk add'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder tile(String title) => find.ancestor(of: find.text(title), matching: find.byType(CheckboxListTile));

void main() {
  testWidgets('socket changes update visible metadata without reloading lists', (tester) async {
    final server = CollectionTestServer([collection('Alpha')]);
    final container = server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    server.requests.clear();
    final notifier = container.read(collectionsProvider('library').notifier);
    notifier.applyServerUpdate(collection('Alpha', books: [testBook], revision: 2));
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('No collections'), findsNothing);
    notifier.applyServerRemoval('Alpha');
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('No collections'), findsOneWidget);
    expect(server.requests, isEmpty);
  });

  testWidgets('metadata distinguishes loading, error, unknown and loaded empty', (tester) async {
    final states = <AsyncValue<CollectionsState>>[
      const AsyncLoading(),
      AsyncError(Exception('Offline'), StackTrace.current),
      const AsyncData(CollectionsState(libraryId: 'library')),
      AsyncData(CollectionsState(libraryId: 'library', items: [collection('unknown', books: null)])),
      AsyncData(CollectionsState(libraryId: 'library', error: Exception('Refresh failed'))),
    ];
    for (var i = 0; i < states.length; i++) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ItemMetadataCard(
                rows: [
                  buildBookCollectionsMetadataRow(
                    context,
                    collections: states[i].whenData(
                      (state) => BookCollectionMemberships(
                        collections: state.items,
                        libraryId: 'library',
                        bookId: 'book',
                        error: state.error,
                      ),
                    ),
                    onRetry: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      expect(find.text('No collections'), i == 2 ? findsOneWidget : findsNothing);
      if (i == 0) expect(find.text('Loading collections…'), findsOneWidget);
      if (i == 1 || i == 4) expect(find.text('Could not load collections. Retry'), findsOneWidget);
      if (i == 3) expect(find.text('Some collections could not be checked. Retry'), findsOneWidget);
    }
  });

  testWidgets('memberships are linked, filtered by library and visible without editing permission', (tester) async {
    final server = CollectionTestServer([
      collection('Alpha', books: [testBook, otherBook]),
      collection('Beta', books: [testBook]),
      collection('Elsewhere', books: [testBook], libraryId: 'another'),
    ]);
    final container = server.container(allowed: false);
    addTearDown(container.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(body: Consumer(builder: (context, ref, _) => metadata(ref, context))),
        ),
        GoRoute(
          path: '/collection/:id',
          builder: (_, state) =>
              Scaffold(body: Text('Opened ${state.pathParameters['id']} in ${state.uri.queryParameters['libraryId']}')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Elsewhere'), findsNothing);
    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    expect(find.text('Opened Alpha in library'), findsOneWidget);
  });

  testWidgets('multi-selection is local and Cancel sends no mutations', (tester) async {
    final server = CollectionTestServer([
      collection('Alpha', books: [testBook, otherBook]),
      collection('Beta'),
    ]);
    final container = server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    expect(server.requests.where((request) => request.method == 'GET').length, 1);
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).value, isTrue);
    expect(tester.widget<CheckboxListTile>(tile('Beta')).value, isFalse);
    await tester.tap(tile('Alpha'));
    await tester.tap(tile('Beta'));
    await tester.pump();
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).value, isFalse);
    expect(tester.widget<CheckboxListTile>(tile('Beta')).value, isTrue);
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('save disables controls during submission and updates metadata', (tester) async {
    final server = CollectionTestServer([
      collection('Alpha', books: [testBook, otherBook]),
      collection('Beta'),
    ]);
    final container = server.container();
    addTearDown(container.dispose);
    final gate = Completer<void>();
    server.beforeMutation = () => gate.future;
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    await tester.tap(tile('Alpha'));
    await tester.tap(tile('Beta'));
    await tester.pump();
    await tester.tap(find.text('Save changes'));
    await tester.pump();
    expect(tester.widget<TextButton>(find.widgetWithText(TextButton, 'Cancel')).onPressed, isNull);
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Saving…')).onPressed, isNull);
    gate.complete();
    await tester.pumpAndSettle();
    expect(find.byType(BookCollectionMembershipDialog), findsNothing);
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Collections updated.'), findsOneWidget);
  });

  testWidgets('sole-book removal is allowed while unknown and permission-restricted entries are disabled', (
    tester,
  ) async {
    for (final allowed in [true, false]) {
      final server = CollectionTestServer([
        collection('Only', books: [testBook]),
        collection('Unknown', books: null),
        collection('Available'),
        collection('Partial', books: [testBook]).copyWith(numBooks: 3),
      ]);
      final container = server.container(allowed: allowed);
      await mount(tester, container);
      await tester.tap(find.text('Manage'));
      await tester.pumpAndSettle();
      expect(tester.widget<CheckboxListTile>(tile('Only')).onChanged, allowed ? isNotNull : isNull);
      expect(tester.widget<CheckboxListTile>(tile('Unknown')).onChanged, isNull);
      expect(tester.widget<CheckboxListTile>(tile('Unknown')).value, isNull);
      expect(tester.widget<CheckboxListTile>(tile('Partial')).value, isTrue);
      expect(tester.widget<CheckboxListTile>(tile('Partial')).onChanged, isNull);
      expect(tester.widget<CheckboxListTile>(tile('Available')).onChanged, allowed ? isNotNull : isNull);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    }
  });

  testWidgets('conflict rebases selections and keeps the dialog open', (tester) async {
    final server = CollectionTestServer([
      collection('Alpha', books: [testBook, otherBook]),
    ]);
    final container = server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    await tester.tap(tile('Alpha'));
    await tester.pump();
    server.collections[0] = collection('Alpha', books: [testBook], revision: 2);
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Collections changed'), findsOneWidget);
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).value, isTrue);
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).onChanged, isNotNull);
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
  });

  testWidgets('Reload waits for an existing background refresh before resetting selections', (tester) async {
    final server = CollectionTestServer([collection('Alpha')]);
    final container = server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    server.collections[0] = collection('Alpha', books: [testBook, otherBook], revision: 2);
    final gate = Completer<void>();
    server.beforeRead = () => gate.future;
    final refresh = container
        .read(collectionsProvider('library').notifier)
        .refresh(withLoading: false, requireServer: true);
    await tester.tap(find.text('Reload'));
    await tester.pump();
    gate.complete();
    await tester.pumpAndSettle();
    await refresh;
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).value, isTrue);
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
  });

  testWidgets('many collections use a scrollable lazy list on a small display', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final server = CollectionTestServer(
      List.generate(500, (i) => collection('Collection ${i.toString().padLeft(3, '0')}')),
    );
    final container = server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    expect(find.byType(CheckboxListTile).evaluate().length, lessThan(50));
    await tester.scrollUntilVisible(
      find.text('Collection 499'),
      500,
      maxScrolls: 100,
      scrollable: find
          .descendant(of: find.byType(BookCollectionMembershipDialog), matching: find.byType(Scrollable))
          .last,
    );
    expect(find.text('Collection 499'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bulk collection picker still adds all selected book IDs', (tester) async {
    final server = CollectionTestServer([collection('Target')]);
    final container = server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Bulk add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Target'));
    await tester.pumpAndSettle();
    final request = server.requests.singleWhere((request) => request.method == 'POST');
    expect(request.path, '/api/collections/Target/batch/add');
    expect(request.data, {
      'books': ['book', 'other'],
    });
    expect(server.collections.single.items!.map((book) => book.id), ['book', 'other']);
    expect(find.byType(BookCollectionMembershipDialog), findsNothing);
  });
}
