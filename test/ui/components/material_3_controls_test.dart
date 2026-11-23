import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('indeterminate loading and determinate progress use Material 3 Expressive indicators', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            YaabsaLoadingIndicator(size: 48),
            YaabsaCircularProgressIndicator(value: 0.72, size: 48),
            YaabsaLinearProgressIndicator(value: 0.38),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(M3ELoadingIndicator), findsOneWidget);
    expect(find.byType(M3EProgressIndicator), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('small inline loading indicators fit their parent constraints', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2)),
      ),
    );
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(M3EProgressIndicator), findsOneWidget);
    expect(find.byType(M3ELoadingIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('page loading indicator uses the larger M3 Expressive size', (tester) async {
    await tester.pumpWidget(const YaabsaPreviewApp(child: Center(child: YaabsaCircularProgressIndicator())));

    expect(tester.getSize(find.byType(M3ELoadingIndicator)), const Size(56, 56));
    expect(tester.takeException(), isNull);
  });

  testWidgets('determinate circular progress keeps its standard size', (tester) async {
    await tester.pumpWidget(const YaabsaPreviewApp(child: Center(child: YaabsaCircularProgressIndicator(value: 0.5))));

    expect(tester.getSize(find.byType(M3EProgressIndicator)), const Size(40, 40));
    expect(tester.takeException(), isNull);
  });

  testWidgets('custom context menu triggers add no extra padding', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaContextMenuButton<String>(
          itemBuilder: _emptyMenuItems,
          child: const SizedBox(width: 40, height: 40),
        ),
      ),
    );

    expect(tester.getSize(find.byType(InkWell)), const Size(40, 40));
    expect(tester.takeException(), isNull);
  });

  testWidgets('context menu opens, selects actions and reports dismissal', (tester) async {
    String? selectedAction;
    var canceled = false;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaContextMenuButton<String>(
          tooltip: 'More actions',
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (value) => selectedAction = value,
          onCanceled: () => canceled = true,
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    expect(find.byType(M3EMenuItem), findsNWidgets(2));
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(selectedAction, 'edit');
    expect(canceled, isFalse);

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(canceled, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('context menu content scrolls within a short viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 220);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var selectedAction = '';

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Align(
          alignment: Alignment.topLeft,
          child: YaabsaContextMenuButton<String>(
            key: const ValueKey('scrolling-menu'),
            tooltip: 'More actions',
            constraints: const BoxConstraints(maxHeight: 112),
            onSelected: (value) => selectedAction = value,
            itemBuilder: (context) => [
              for (var index = 0; index < 8; index++) PopupMenuItem(value: 'item-$index', child: Text('Item $index')),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
    final menuList = tester.widget<ListView>(find.byType(ListView));
    final controller = menuList.controller!;
    final initialScrollOffset = controller.offset;
    await tester.drag(find.byType(ListView), const Offset(0, -160));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(initialScrollOffset));

    expect(selectedAction, isEmpty);
    expect(tester.takeException(), isNull);
  });
}

List<PopupMenuEntry<String>> _emptyMenuItems(BuildContext context) => const [];
