import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/ui/previews/library_grid_preview.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/util/globals.dart' as globals;

void main() {
  testWidgets('library UI Lab grid stays lazy, scrolls, and does not navigate on preview taps', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final audioHandlerInitializedBeforePreview = globals.isAudioHandlerInitialized;

    await tester.pumpWidget(const YaabsaPreviewApp(child: LibraryGridLabPreview()));
    await tester.pumpAndSettle();

    final initialCardCount = find.byType(LibraryItemWidget).evaluate().length;
    expect(initialCardCount, greaterThan(0));
    expect(initialCardCount, lessThan(libraryGridPreviewItemCount));

    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    await tester.drag(find.byType(Scrollable), const Offset(0, -560));
    await tester.pumpAndSettle();

    expect(scrollable.position.pixels, greaterThan(0));
    expect(find.byType(LibraryItemWidget).evaluate().length, lessThan(libraryGridPreviewItemCount));

    await tester.tap(find.byType(LibraryItemWidget).first);
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(globals.isAudioHandlerInitialized, audioHandlerInitializedBeforePreview);
  });
}
