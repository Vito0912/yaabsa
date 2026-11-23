import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/reader/widgets/reader_annotation_details_presentation.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('reader annotation details use shared actions and selectable note text', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var editRequested = false;
    var deleteRequested = false;
    var closeRequested = false;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: ReaderAnnotationDetailsPresentation(
            note: 'A useful note for the reader.',
            onEdit: () => editRequested = true,
            onDelete: () => deleteRequested = true,
            onClose: () => closeRequested = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SelectableText), findsOneWidget);
    expect(find.text('A useful note for the reader.'), findsOneWidget);
    expect(find.text('Note'), findsNothing);
    expect(find.byTooltip('Edit annotation'), findsOneWidget);
    expect(find.byTooltip('Delete annotation'), findsOneWidget);

    final iconButtonFinder = find.byType(IconButton);
    final closeButtonFinder = find.widgetWithText(FilledButton, 'Close');
    expect(iconButtonFinder, findsNWidgets(2));
    expect(tester.getSize(iconButtonFinder.at(0)), const Size(48, 48));
    expect(tester.getSize(iconButtonFinder.at(1)), const Size(48, 48));
    expect(tester.getSize(closeButtonFinder).height, 48);

    final deleteRect = tester.getRect(find.byTooltip('Delete annotation'));
    final editRect = tester.getRect(find.byTooltip('Edit annotation'));
    final closeRect = tester.getRect(closeButtonFinder);
    expect(deleteRect.right, lessThan(editRect.left));
    expect(editRect.right, lessThan(closeRect.left));
    expect(closeRect.right, closeTo(370, 1));

    await tester.tap(find.byTooltip('Edit annotation'));
    await tester.pump();
    expect(editRequested, isTrue);

    await tester.tap(find.byTooltip('Delete annotation'));
    await tester.pump();
    expect(deleteRequested, isTrue);

    await tester.tap(find.text('Close'));
    await tester.pump();
    expect(closeRequested, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reader annotation details render the empty-note state at large text scale', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Scaffold(
          body: ReaderAnnotationDetailsPresentation(
            note: ' ',
            onEdit: _ignoreAction,
            onDelete: _ignoreAction,
            onClose: _ignoreAction,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No note added'), findsOneWidget);
    expect(find.byTooltip('Delete annotation'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _ignoreAction() {}
