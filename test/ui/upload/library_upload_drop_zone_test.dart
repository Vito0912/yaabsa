import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_drop_zone.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('drop zone actions wrap on narrow widths and invoke their callbacks', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 520);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var filePickCount = 0;
    var folderPickCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryUploadDropZone(
            supportsDragDrop: true,
            isDropHovering: false,
            enabled: true,
            onChooseFiles: () => filePickCount++,
            onChooseFolder: () => folderPickCount++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final filesRect = tester.getRect(find.text('Choose files'));
    final folderRect = tester.getRect(find.text('Choose folder'));
    expect(folderRect.top, greaterThan(filesRect.bottom));
    expect(find.text('Drop files or folders here, or choose them below.'), findsOneWidget);

    await tester.tap(find.text('Choose files'));
    await tester.tap(find.text('Choose folder'));

    expect(filePickCount, 1);
    expect(folderPickCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('drop zone buttons keep standard themed variants and disable together', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryUploadDropZone(
            supportsDragDrop: false,
            isDropHovering: true,
            enabled: false,
            onChooseFiles: _ignoreAction,
            onChooseFolder: _ignoreAction,
          ),
        ),
      ),
    );

    expect(find.text('Choose files or a folder below.'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
    expect(tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
}

void _ignoreAction() {}
