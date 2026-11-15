import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('mobile finished item uses the shared unfinished action', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    ItemMoreAction? selectedAction;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: ItemMoreActionsButton(
            onActionSelected: (action) async {
              selectedAction = action;
            },
            showMarkAction: true,
            showMarkAsUnfinished: true,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark As Unfinished'));
    await tester.pumpAndSettle();

    expect(selectedAction, ItemMoreAction.markAsUnfinished);
    expect(tester.takeException(), isNull);
  });

  testWidgets('overflow button supports the shape of its owning action row', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemMoreActionsButton(onActionSelected: (_) async {}, shape: YaabsaActionButtonShape.rounded),
        ),
      ),
    );

    final button = tester.widget<IconButton>(find.byType(IconButton));
    expect(button.style?.shape?.resolve(const {}), isA<RoundedRectangleBorder>());
  });

  testWidgets('all item actions remain reachable in a short viewport', (tester) async {
    tester.view.physicalSize = const Size(400, 320);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    ItemMoreAction? selectedAction;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemMoreActionsButton(
            onActionSelected: (action) async {
              selectedAction = action;
            },
            showSelect: true,
            showEditItem: true,
            showQuickMatch: true,
            showManualMatch: true,
            showPinAction: true,
            showMarkAction: true,
            showAddToPlaylist: true,
            showAddToCollection: true,
            showDeleteItem: true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AlertDialog), findsOneWidget);

    final dialogScrollable = find.descendant(of: find.byType(AlertDialog), matching: find.byType(Scrollable));
    await tester.scrollUntilVisible(find.text('Play History'), 100, scrollable: dialogScrollable);
    expect(find.text('Play History'), findsOneWidget);

    await tester.tap(find.text('Play History'));
    await tester.pumpAndSettle();

    expect(selectedAction, ItemMoreAction.playHistory);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop item actions open an anchored baseline Material 3 menu', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    ItemMoreAction? selectedAction;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ItemMoreActionsButton(
              onActionSelected: (action) async {
                selectedAction = action;
              },
              showSelect: true,
              showEditItem: true,
              showQuickMatch: true,
              showManualMatch: true,
              showPinAction: true,
              showMarkAction: true,
              showMarkAsUnfinished: true,
              showAddToPlaylist: true,
              showAddToCollection: true,
              showDeleteItem: true,
              showSetProgress: true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(M3EMenuPopup<ItemMoreAction>), findsOneWidget);
    final menu = tester.widget<M3EMenuPopup<ItemMoreAction>>(find.byType(M3EMenuPopup<ItemMoreAction>));
    expect(menu.variant, M3EMenuVariant.baseline);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Add to'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Edit item'), findsNothing);
    expect(find.text('Delete Audiobook'), findsOneWidget);
    expect(tester.getRect(find.text('Play History')).bottom, lessThan(800));

    await tester.tap(find.text('Play History'));
    await tester.pumpAndSettle();

    expect(selectedAction, ItemMoreAction.playHistory);

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Edit item'), findsOneWidget);
    expect(find.text('Quick Match'), findsOneWidget);
    expect(find.text('Manual Match'), findsOneWidget);
    await tester.tap(find.text('Quick Match'));
    await tester.pumpAndSettle();

    expect(selectedAction, ItemMoreAction.quickMatch);

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to'));
    await tester.pumpAndSettle();

    expect(find.text('Add To Playlist'), findsOneWidget);
    expect(find.text('Add To Collection'), findsOneWidget);
    await tester.tap(find.text('Add To Collection'));
    await tester.pumpAndSettle();

    expect(selectedAction, ItemMoreAction.addToCollection);

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();

    expect(find.text('Mark As Finished'), findsOneWidget);
    expect(find.text('Mark As Unfinished'), findsOneWidget);
    expect(find.text('Set progress'), findsOneWidget);
    await tester.tap(find.text('Set progress'));
    await tester.pumpAndSettle();

    expect(selectedAction, ItemMoreAction.setProgress);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop progress submenu follows finished and started state', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final states = <({bool finished, bool hasProgress, int finishedActions, int unfinishedActions})>[
      (finished: false, hasProgress: false, finishedActions: 1, unfinishedActions: 0),
      (finished: true, hasProgress: true, finishedActions: 0, unfinishedActions: 1),
      (finished: false, hasProgress: true, finishedActions: 1, unfinishedActions: 1),
    ];

    for (final state in states) {
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ItemMoreActionsButton(
                onActionSelected: (_) async {},
                showMarkAction: true,
                showMarkAsFinished: !state.finished,
                showMarkAsUnfinished: state.hasProgress,
                showSetProgress: true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('More actions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      expect(find.text('Mark As Finished'), findsNWidgets(state.finishedActions));
      expect(find.text('Mark As Unfinished'), findsNWidgets(state.unfinishedActions));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });

  testWidgets('desktop item action menu scrolls in a short window', (tester) async {
    tester.view.physicalSize = const Size(1280, 320);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    ItemMoreAction? selectedAction;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ItemMoreActionsButton(
              onActionSelected: (action) async {
                selectedAction = action;
              },
              showSelect: true,
              showEditItem: true,
              showQuickMatch: true,
              showManualMatch: true,
              showPinAction: true,
              showMarkAction: true,
              showAddToPlaylist: true,
              showAddToCollection: true,
              showDeleteItem: true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();

    expect(find.byType(M3EMenuPopup<ItemMoreAction>), findsOneWidget);
    await tester.ensureVisible(find.text('Play History'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Play History'));
    await tester.pumpAndSettle();

    expect(selectedAction, ItemMoreAction.playHistory);
    expect(tester.takeException(), isNull);
  });
}
