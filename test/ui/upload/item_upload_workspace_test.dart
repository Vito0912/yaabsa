import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/ui/previews/upload_previews.dart';
import 'package:yaabsa/features/upload/library_upload_panel.dart';

void main() {
  testWidgets('existing book workspace accepts files and hides folder and metadata controls', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [390.0, 900.0]) {
      tester.view.physicalSize = Size(width, 1000);
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(size: Size(width, 1000), textScaler: TextScaler.linear(1.8)),
              child: const UploadWorkspacePreview(addToBook: true),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(LibraryUploadPanel), findsOneWidget);
      final dialogRect = tester.getRect(find.byType(AlertDialog));
      final panelRect = tester.getRect(find.byType(LibraryUploadPanel));
      expect(dialogRect.width, lessThanOrEqualTo(width));
      expect(panelRect.height, lessThan(1000));
      expect(find.textContaining('Add files to'), findsNothing);
      expect(find.text('Choose files'), findsOneWidget);
      expect(find.text('Choose folder'), findsNothing);
      expect(find.text('Your queue is empty'), findsNothing);
      expect(find.text('Fetch metadata'), findsNothing);
      expect(find.text('Start upload'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
