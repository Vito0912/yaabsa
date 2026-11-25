import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/features/library/widgets/library_item_card.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/util/l10n.dart';

void main() {
  testWidgets('library presentation forwards activation and long press', (tester) async {
    var tapCount = 0;
    var longPressCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: yaabsaLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 220,
            child: LibraryItemCard(
              cover: const AspectRatio(aspectRatio: 0.7, child: ColoredBox(color: Colors.teal)),
              title: 'The Distant Shore',
              subtitle: const Text('M. Ellery'),
              onTap: () => tapCount++,
              onLongPress: () => longPressCount++,
            ),
          ),
        ),
      ),
    );

    expect(find.text('The Distant Shore'), findsOneWidget);
    expect(find.text('M. Ellery'), findsOneWidget);

    await tester.tap(find.byType(LibraryItemCard));
    await tester.pumpAndSettle();
    await tester.longPress(find.byType(LibraryItemCard));
    await tester.pumpAndSettle();

    expect(tapCount, 1);
    expect(longPressCount, 1);
  });

  testWidgets('collapsed selection card can suppress activation without losing its content', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: yaabsaLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: LibraryItemCard(
            cover: const SizedBox(width: 150, height: 210),
            title: 'A collection',
            canActivate: false,
            onTap: () => tapCount++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(LibraryItemCard));
    await tester.pumpAndSettle();

    expect(tapCount, 0);
    expect(find.text('A collection'), findsOneWidget);
  });

  testWidgets('desktop secondary click forwards the pointer position to the context menu', (tester) async {
    Offset? contextMenuPosition;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: yaabsaLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: LibraryItemCard(
            cover: const SizedBox(width: 180, height: 180),
            title: 'The Distant Shore',
            isDesktop: true,
            onContextMenu: (position) => contextMenuPosition = position,
          ),
        ),
      ),
    );

    final cardCenter = tester.getCenter(find.byType(LibraryItemCard));
    final gesture = await tester.startGesture(
      cardCenter,
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await gesture.up();
    await tester.pumpAndSettle();

    expect(contextMenuPosition, isNotNull);
    expect(contextMenuPosition!.dx, cardCenter.dx);
    expect(contextMenuPosition!.dy, cardCenter.dy);
  });

  testWidgets('desktop secondary click opens the shared Material 3 item action menu', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    ItemMoreAction? selectedAction;
    final actions = ItemMoreActionsButton(
      onActionSelected: (action) async {
        selectedAction = action;
      },
      showMarkAction: true,
      showSetProgress: true,
      showEditItem: true,
    );

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return Align(
                alignment: Alignment.topLeft,
                child: LibraryItemCard(
                  cover: const SizedBox(width: 180, height: 180),
                  title: 'The Distant Shore',
                  isDesktop: true,
                  onContextMenu: (position) {
                    unawaited(actions.showAt(context: context, globalPosition: position));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(LibraryItemCard)),
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.byType(M3EMenuPopup<ItemMoreAction>), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    await tester.tap(find.text('Progress'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark As Finished'));
    await tester.pumpAndSettle();

    expect(selectedAction, ItemMoreAction.markAsFinished);
    expect(tester.takeException(), isNull);
  });
}
