import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/ui/previews/upload_previews.dart';

void main() {
  testWidgets('advanced options avoid a mixed stacked/side-by-side layout', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _pumpAtSize(tester, const Size(320, 640));
    expect(find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')), findsNothing);
    expect(find.byKey(const ValueKey<String>('uploadBulkFieldStacked')), findsNWidgets(2));

    await _pumpAtSize(tester, const Size(800, 1100));
    expect(find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')), findsNothing);
    expect(find.byKey(const ValueKey<String>('uploadBulkFieldInline')), findsNWidgets(2));

    await _pumpAtSize(tester, const Size(900, 650));
    expect(find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')), findsNothing);
    expect(find.byKey(const ValueKey<String>('uploadBulkFieldInline')), findsNWidgets(2));

    await _pumpAtSize(tester, const Size(1054, 800));
    expect(find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')), findsNothing);
    expect(find.byKey(const ValueKey<String>('uploadBulkFieldInline')), findsNWidgets(2));

    await _pumpAtSize(tester, const Size(1086, 800));
    expect(find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('uploadBulkFieldInline')), findsNWidgets(2));
    expect(find.byKey(const ValueKey<String>('uploadBulkFieldStacked')), findsNothing);

    await _pumpAtSize(tester, const Size(1600, 900));
    expect(find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('uploadBulkFieldInline')), findsNWidgets(2));
    expect(find.byKey(const ValueKey<String>('uploadBulkFieldStacked')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bulk apply button aligns with the field top edge', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 600);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const YaabsaPreviewApp(child: Scaffold(body: UploadAdvancedOptionsPreview())));
    await tester.pumpAndSettle();

    final fieldRect = tester.getRect(find.byType(StyledTextField).first);
    final buttonRect = tester.getRect(find.widgetWithText(FilledButton, 'Apply author'));
    expect(buttonRect.top, fieldRect.top);
    expect(tester.takeException(), isNull);
  });

  testWidgets('real upload workspace keeps advanced options coherent around its breakpoint', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [740.0, 780.0, 789.0, 790.0, 800.0, 1054.0, 1086.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(const YaabsaPreviewApp(child: UploadWorkspacePreview()));
      await tester.pumpAndSettle();

      final shouldUseColumns = width >= 790;
      expect(
        find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')),
        shouldUseColumns ? findsOneWidget : findsNothing,
        reason: 'Advanced options at $width logical pixels',
      );
      expect(find.byKey(const ValueKey<String>('uploadBulkFieldInline')), findsNWidgets(2));
      expect(find.byKey(const ValueKey<String>('uploadBulkFieldStacked')), findsNothing);

      if (shouldUseColumns) {
        final fieldRect = tester.getRect(find.byType(StyledTextField).first);
        final buttonRect = tester.getRect(find.widgetWithText(FilledButton, 'Apply author'));
        expect(buttonRect.top, fieldRect.top, reason: 'Author field and action at $width logical pixels');
      }

      expect(tester.takeException(), isNull, reason: 'Upload workspace at $width logical pixels');
    }
  });
}

Future<void> _pumpAtSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  await tester.pumpWidget(
    const YaabsaPreviewApp(
      child: Scaffold(
        body: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: UploadAdvancedOptionsPreview()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}
