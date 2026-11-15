import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_bulk_field.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('upload bulk field stacks its themed button in a narrow panel', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final controller = TextEditingController(text: 'Mira Ellery');
    addTearDown(controller.dispose);
    var applyCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: LibraryUploadBulkField(
              label: 'Author for all items',
              applyLabel: 'Apply author',
              controller: controller,
              onApply: () => applyCount++,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(StyledTextField), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Apply author'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Apply author'));
    expect(applyCount, 1);
  });

  testWidgets('upload bulk field keeps the editor and action together when wide', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryUploadBulkField(
            label: 'Series for all items',
            applyLabel: 'Apply series',
            controller: controller,
            onApply: () {},
          ),
        ),
      ),
    );

    expect(find.descendant(of: find.byType(LibraryUploadBulkField), matching: find.byType(Row)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
