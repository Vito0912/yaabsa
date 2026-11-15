import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_queue_actions.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('upload queue actions use the shared wrap layout and invoke callbacks', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 400);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var clearCount = 0;
    var startCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryUploadQueueActions(
            isUploading: false,
            hasQueuedItems: true,
            onClear: () => clearCount++,
            onStart: () => startCount++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('uploadQueueActionsWrap')), findsOneWidget);
    await tester.tap(find.text('Clear queue'));
    await tester.tap(find.text('Start upload'));

    expect(clearCount, 1);
    expect(startCount, 1);
  });

  testWidgets('uploading queue disables clear and start while keeping cancel available', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryUploadQueueActions(
            isUploading: true,
            hasQueuedItems: true,
            onClear: _ignoreAction,
            onCancel: _ignoreAction,
            onStart: _ignoreAction,
          ),
        ),
      ),
    );

    final clearButton = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Clear queue'));
    final startButton = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Start upload'));
    final cancelButton = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Cancel uploads'));

    expect(clearButton.onPressed, isNull);
    expect(startButton.onPressed, isNull);
    expect(cancelButton.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('upload queue actions use a single desktop row', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryUploadQueueActions(
            isUploading: true,
            hasQueuedItems: true,
            onClear: _ignoreAction,
            onCancel: _ignoreAction,
            onStart: _ignoreAction,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey<String>('uploadQueueActionsWrap')), findsOneWidget);
    final clearButtonRect = tester.getRect(find.widgetWithText(OutlinedButton, 'Clear queue'));
    final cancelButtonRect = tester.getRect(find.widgetWithText(FilledButton, 'Cancel uploads'));
    final startButtonRect = tester.getRect(find.widgetWithText(FilledButton, 'Start upload'));

    expect(clearButtonRect.top, cancelButtonRect.top);
    expect(cancelButtonRect.top, startButtonRect.top);
    expect(clearButtonRect.left, lessThan(cancelButtonRect.left));
    expect(cancelButtonRect.left, lessThan(startButtonRect.left));
    expect(tester.takeException(), isNull);
  });

  testWidgets('queue actions wrap based on local width inside a desktop window', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 350,
              child: LibraryUploadQueueActions(
                isUploading: true,
                hasQueuedItems: true,
                onClear: _ignoreAction,
                onCancel: _ignoreAction,
                onStart: _ignoreAction,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final clearButtonRect = tester.getRect(find.widgetWithText(OutlinedButton, 'Clear queue'));
    final cancelButtonRect = tester.getRect(find.widgetWithText(FilledButton, 'Cancel uploads'));
    final startButtonRect = tester.getRect(find.widgetWithText(FilledButton, 'Start upload'));

    final buttonRows = <double>{clearButtonRect.top, cancelButtonRect.top, startButtonRect.top};
    expect(buttonRows.length, greaterThan(1));
    expect(tester.takeException(), isNull);
  });
}

void _ignoreAction() {}
