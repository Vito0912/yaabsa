import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_models.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_form.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('metadata fields save controller values without parent change callbacks', (tester) async {
    LibraryItemEditorDiff? savedDiff;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryItemEditorForm(
            item: const LibraryItem(id: 'preview-item', ino: 'preview-item', media: null, libraryFiles: null),
            isSaving: false,
            onSave: (diff) async {
              savedDiff = diff;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'A new title');
    await tester.tap(find.text('Save').first);
    await tester.pumpAndSettle();

    expect(savedDiff, isNotNull);
    expect(savedDiff!.hasChanges, isTrue);
    expect(savedDiff!.request.metadata?.title, 'A new title');
    expect(tester.takeException(), isNull);
  });
}
