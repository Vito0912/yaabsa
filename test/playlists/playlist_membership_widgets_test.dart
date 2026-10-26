import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/book_playlist_membership_dialog.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/components/app/item/book_playlists_metadata.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/app/library/library_multi_select_actions.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/util/playlist_membership.dart';

import 'playlist_test_support.dart';

Widget metadata(WidgetRef ref, BuildContext context) => ItemMetadataCard(
  rows: [
    buildBookPlaylistsMetadataRow(
      context,
      playlists: ref.watch(bookPlaylistMembershipsProvider((libraryId: 'library', bookId: 'book'))),
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
                  onPressed: () => showBookPlaylistMembershipDialog(context: context, item: testBook),
                  child: const Text('Manage'),
                ),
                TextButton(
                  onPressed: () => addSelectedBooksToPlaylist(
                    context: context,
                    ref: ref,
                    libraryId: 'library',
                    currentUserId: 'user',
                    selectedBookIds: ['book', 'other'],
                    onSuccess: () {},
                  ),
                  child: const Text('Bulk add'),
                ),
                TextButton(
                  onPressed: () => addSelectedLibraryItemsToPlaylist(
                    context: context,
                    ref: ref,
                    libraryId: 'library',
                    currentUserId: 'user',
                    items: [
                      testBook,
                      testBook.copyWith(id: 'other'),
                    ],
                    onSuccess: () {},
                  ),
                  child: const Text('Library bulk add'),
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
  testWidgets('book management labels preserve the existing podcast add action', (tester) async {
    for (final manageMemberships in [false, true]) {
      ItemMoreAction? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemMoreActionsButton(
              onActionSelected: (action) async {
                selected = action;
              },
              showMarkAction: false,
              showAddToPlaylist: true,
              manageMemberships: manageMemberships,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      final label = manageMemberships ? 'Manage playlists' : 'Add To Playlist';
      expect(find.text(label), findsOneWidget);
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(selected, ItemMoreAction.addToPlaylist);
    }
  });

  testWidgets('last-item deletion requires confirmation and Cancel leaves all changes local', (tester) async {
    final server = PlaylistTestServer([
      playlist('Alpha', items: [bookEntry]),
      playlist('Beta', items: [bookEntry]),
      playlist('Additional'),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    await tester.tap(tile('Alpha'));
    await tester.tap(tile('Beta'));
    await tester.tap(tile('Additional'));
    await tester.pump();
    server.requests.clear();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Delete empty playlists?'), findsOneWidget);
    expect(find.textContaining('Alpha\nBeta'), findsOneWidget);
    expect(server.requests, isEmpty);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel').last);
    await tester.pumpAndSettle();
    expect(find.byType(BookPlaylistMembershipDialog), findsOneWidget);
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).value, isFalse);
    expect(server.requests, isEmpty);
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(BookPlaylistMembershipDialog), findsNothing);
    expect(server.playlists.map((entry) => entry.id), ['Additional']);
    expect(find.text('Additional'), findsOneWidget);
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('socket changes update visible metadata without reloading lists', (tester) async {
    final server = PlaylistTestServer([playlist('Alpha')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    server.requests.clear();
    final notifier = container.read(playlistsProvider('library').notifier);
    notifier.applyServerUpdate(playlist('Alpha', items: [bookEntry], revision: 2));
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('No playlists'), findsNothing);
    notifier.applyServerRemoval('Alpha');
    await tester.pumpAndSettle();
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('No playlists'), findsOneWidget);
    expect(server.requests, isEmpty);
  });

  testWidgets('metadata distinguishes loading, error, unknown and loaded empty', (tester) async {
    final states = <AsyncValue<PlaylistsState>>[
      const AsyncLoading(),
      AsyncError(Exception('Offline'), StackTrace.current),
      const AsyncData(PlaylistsState(libraryId: 'library')),
      AsyncData(PlaylistsState(libraryId: 'library', items: [playlist('unknown', items: null)])),
      AsyncData(PlaylistsState(libraryId: 'library', error: Exception('Refresh failed'))),
    ];
    for (var i = 0; i < states.length; i++) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ItemMetadataCard(
                rows: [
                  buildBookPlaylistsMetadataRow(
                    context,
                    playlists: states[i].whenData(
                      (state) => BookPlaylistMemberships(
                        playlists: state.items,
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
      expect(find.text('No playlists'), i == 2 ? findsOneWidget : findsNothing);
      if (i == 0) expect(find.text('Loading playlists…'), findsOneWidget);
      if (i == 1 || i == 4) expect(find.text('Could not load playlists. Retry'), findsOneWidget);
      if (i == 3) expect(find.text('Some playlists could not be checked. Retry'), findsOneWidget);
    }
  });

  testWidgets('memberships are linked, filtered by library and visible to a user without server update permission', (
    tester,
  ) async {
    final server = PlaylistTestServer([
      playlist('Alpha', items: [bookEntry, otherEntry]),
      playlist('Beta', items: [bookEntry]),
      playlist('Elsewhere', items: [bookEntry], libraryId: 'another'),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(body: Consumer(builder: (context, ref, _) => metadata(ref, context))),
        ),
        GoRoute(
          path: '/playlist/:id',
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
    final server = PlaylistTestServer([
      playlist('Alpha', items: [bookEntry, otherEntry]),
      playlist('Beta'),
    ]);
    final container = await server.container();
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
    final server = PlaylistTestServer([
      playlist('Alpha', items: [bookEntry, otherEntry]),
      playlist('Beta'),
    ]);
    final container = await server.container();
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
    expect(find.byType(BookPlaylistMembershipDialog), findsNothing);
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Playlists updated.'), findsOneWidget);
  });

  testWidgets('unknown and permission-restricted entries are disabled but sole-book removal is allowed', (
    tester,
  ) async {
    for (final allowed in [true, false]) {
      final server = PlaylistTestServer([
        playlist('Only', items: [bookEntry]),
        playlist('Unknown', items: null),
        playlist('Available'),
        playlist(
          'Partial',
          items: [
            bookEntry,
            const PlaylistItem(itemId: ''),
          ],
        ),
      ]);
      final container = await server.container(allowed: allowed);
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
    final server = PlaylistTestServer([
      playlist('Alpha', items: [bookEntry, otherEntry]),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    await tester.tap(tile('Alpha'));
    await tester.pump();
    server.playlists[0] = playlist('Alpha', items: [bookEntry], revision: 2);
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Playlists changed'), findsOneWidget);
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).value, isTrue);
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).onChanged, isNotNull);
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
  });

  testWidgets('another owner\'s playlist is visible but cannot be selected', (tester) async {
    final server = PlaylistTestServer([
      playlist('Mine'),
      playlist('Foreign', userId: 'someone', items: [bookEntry, otherEntry]),
    ]);
    final container = await server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    expect(find.text('Foreign'), findsOneWidget);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    expect(tester.widget<CheckboxListTile>(tile('Foreign')).value, isTrue);
    expect(tester.widget<CheckboxListTile>(tile('Foreign')).onChanged, isNull);
    expect(tester.widget<CheckboxListTile>(tile('Mine')).onChanged, isNotNull);
  });

  testWidgets('Reload waits for an existing background refresh before resetting selections', (tester) async {
    final server = PlaylistTestServer([playlist('Alpha')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    server.playlists[0] = playlist('Alpha', items: [bookEntry, otherEntry], revision: 2);
    final gate = Completer<void>();
    server.beforeRead = () => gate.future;
    final refresh = container
        .read(playlistsProvider('library').notifier)
        .refresh(withLoading: false, requireServer: true);
    await tester.tap(find.text('Reload'));
    await tester.pump();
    gate.complete();
    await tester.pumpAndSettle();
    await refresh;
    expect(tester.widget<CheckboxListTile>(tile('Alpha')).value, isTrue);
    expect(server.requests.where((request) => request.method == 'POST'), isEmpty);
  });

  testWidgets('many playlists use a scrollable lazy list on a small display', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final server = PlaylistTestServer(List.generate(500, (i) => playlist('Playlist ${i.toString().padLeft(3, '0')}')));
    final container = await server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    expect(find.byType(CheckboxListTile).evaluate().length, lessThan(50));
    await tester.scrollUntilVisible(
      find.text('Playlist 499'),
      500,
      maxScrolls: 100,
      scrollable: find
          .descendant(of: find.byType(BookPlaylistMembershipDialog), matching: find.byType(Scrollable))
          .last,
    );
    expect(find.text('Playlist 499'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bulk playlist picker still adds all selected book IDs', (tester) async {
    final server = PlaylistTestServer([playlist('Target')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    await tester.tap(find.text('Bulk add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Target'));
    await tester.pumpAndSettle();
    final request = server.requests.singleWhere((request) => request.method == 'POST');
    expect(request.path, '/api/playlists/Target/batch/add');
    expect(request.data, {
      'items': [
        {'libraryItemId': 'book'},
        {'libraryItemId': 'other'},
      ],
    });
    expect(server.playlists.single.items!.map((book) => book.itemId), ['book', 'other']);
    expect(find.byType(BookPlaylistMembershipDialog), findsNothing);
  });

  testWidgets('library bulk addition is synchronized after a refresh already in flight', (tester) async {
    final server = PlaylistTestServer([playlist('Target')]);
    final container = await server.container();
    addTearDown(container.dispose);
    await mount(tester, container);
    final gate = Completer<void>();
    server.beforeRead = () => gate.future;
    final refresh = container.read(playlistsProvider('library').notifier).refresh(withLoading: false);
    await tester.pump();
    await tester.tap(find.text('Library bulk add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Target'));
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(server.requests.where((request) => request.method == 'POST'), hasLength(1));
    gate.complete();
    await tester.pumpAndSettle();
    await refresh;
    expect(container.read(playlistsProvider('library')).requireValue.items.single.items, [bookEntry, otherEntry]);
    expect(find.text('Target'), findsOneWidget);
  });
}
