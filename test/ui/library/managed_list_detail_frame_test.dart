import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/list_management_header.dart';
import 'package:yaabsa/features/library/widgets/library_item_card.dart';
import 'package:yaabsa/features/library/widgets/managed_list_detail_frame.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('shared collection and playlist frame presents common detail metadata and empty state', (tester) async {
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: ManagedListDetailFrame(
          title: 'A long collection title that wraps without covering the page actions',
          description: 'Books for slower evenings and long walks.',
          statusMessage: 'One playlist entry could not be loaded.',
          emptyTitle: 'No books in this collection',
          emptyMessage: 'Add books to this collection to see them here.',
          emptyIcon: Icons.collections_bookmark_outlined,
          scrollController: scrollController,
          onRefresh: () async {},
          itemCount: 0,
          itemBuilder: (context, index) => const SizedBox.shrink(),
          headerActions: const IconButton(onPressed: _ignoreAction, icon: Icon(Icons.more_vert_rounded)),
        ),
      ),
    );

    expect(find.text('Books for slower evenings and long walks.'), findsOneWidget);
    expect(find.text('One playlist entry could not be loaded.'), findsOneWidget);
    expect(find.text('No books in this collection'), findsOneWidget);
    expect(find.text('Add books to this collection to see them here.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shared collection and playlist grid fits phone and desktop widths', (tester) async {
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);

    for (final size in [const Size(320, 640), const Size(390, 844), const Size(1280, 800)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: ManagedListDetailFrame(
            title: 'The Tidemark Stories',
            description: 'An intentionally long description with enough words to wrap in a narrow phone window.',
            emptyTitle: 'No items',
            emptyMessage: 'Add items to see them here.',
            emptyIcon: Icons.playlist_play_rounded,
            scrollController: scrollController,
            onRefresh: () async {},
            itemCount: 4,
            itemBuilder: (context, index) => LibraryItemCard(
              cover: AspectRatio(
                aspectRatio: 0.68,
                child: ColoredBox(color: Theme.of(context).colorScheme.primaryContainer),
              ),
              title: 'Book ${index + 1}',
              subtitle: const Text('Mira Ellery'),
              onTap: _ignoreAction,
            ),
            headerActions: Wrap(
              children: [
                IconButton(onPressed: _ignoreAction, icon: const Icon(Icons.shuffle_rounded)),
                IconButton(onPressed: _ignoreAction, icon: const Icon(Icons.more_vert_rounded)),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'The detail frame should fit $size.');
    }

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets('collection and playlist landing actions remain labeled without page headings', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    for (final (title, createLabel) in [('Collections', 'New collection'), ('Playlists', 'New playlist')]) {
      for (final width in [320.0, 390.0, 511.0, 512.0, 800.0, 928.0]) {
        tester.view.physicalSize = Size(width, 640);
        await tester.pumpWidget(
          YaabsaPreviewApp(
            child: ListManagementHeader(title: null, createLabel: createLabel, onCreate: _ignoreAction),
          ),
        );
        await tester.pumpAndSettle();

        final createButton = find.widgetWithText(FilledButton, createLabel);
        final buttonRect = tester.getRect(createButton);

        expect(createButton, findsOneWidget);
        expect(find.text(title), findsNothing);
        expect(buttonRect.width, lessThanOrEqualTo(width - 32));

        final exception = tester.takeException();
        expect(exception, isNull, reason: 'The list header should fit $width logical pixels. $exception');
      }
    }
  });
}

void _ignoreAction() {}
