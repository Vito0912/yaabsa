import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/ui/previews/upload_previews.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_queue_actions.dart';

void main() {
  testWidgets('empty upload queue uses an icon-led shared state without a cleared subtitle', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const YaabsaPreviewApp(child: UploadWorkspacePreview()));
    await tester.pumpAndSettle();

    final emptyState = find.byKey(const ValueKey<String>('uploadQueueEmptyState'));
    final queueActions = find.byType(LibraryUploadQueueActions);
    expect(emptyState, findsOneWidget);
    expect(queueActions, findsOneWidget);
    expect(tester.getTopLeft(emptyState).dy - tester.getBottomLeft(queueActions).dy, greaterThanOrEqualTo(10));
    expect(tester.getRect(emptyState).bottom, lessThanOrEqualTo(800));
    expect(find.byIcon(Icons.drive_folder_upload_outlined), findsOneWidget);
    expect(find.text('Your queue is empty'), findsOneWidget);
    expect(find.text('Choose files or a folder above to get started.'), findsNothing);
    expect(find.text('Upload queue is empty. Add files or folders using the drop area above.'), findsNothing);

    await tester.ensureVisible(find.text('Clear queue'));
    await tester.tap(find.text('Clear queue'));
    await tester.pumpAndSettle();

    expect(find.text('Upload queue cleared.'), findsNothing);
    expect(emptyState, findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(320, 640);
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    await tester.pumpWidget(const YaabsaPreviewApp(child: UploadWorkspacePreview()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.drive_folder_upload_outlined), findsOneWidget);
    expect(find.text('Your queue is empty'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
