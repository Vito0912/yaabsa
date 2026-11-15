import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/features/upload/widgets/item_upload_file_queue.dart';
import 'package:yaabsa/ui/previews/preview_fixtures.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('file queue shows every filename directly and removes individual files', (tester) async {
    const files = [
      UploadPickedFile(
        absolutePath: '/files/part1.mp3',
        relativePath: 'part1.mp3',
        fileName: 'part1.mp3',
        kind: UploadFileKind.item,
      ),
      UploadPickedFile(
        absolutePath: '/files/subtitles.srt',
        relativePath: 'subtitles.srt',
        fileName: 'subtitles.srt',
        kind: UploadFileKind.other,
      ),
    ];
    final item = previewUploadItemDraft().copyWith(
      itemFiles: [files.first],
      otherFiles: [files.last],
      clearPendingMetadata: true,
      clearMessage: true,
    );
    UploadPickedFile? removed;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: ItemUploadFileQueue(
            items: [item],
            enabled: true,
            onRemoveFile: (itemId, file) {
              removed = file;
            },
          ),
        ),
      ),
    );
    expect(find.text('part1.mp3'), findsOneWidget);
    expect(find.text('subtitles.srt'), findsOneWidget);
    expect(find.text('Files (2)'), findsNothing);
    await tester.tap(find.byTooltip('Remove subtitles.srt'));
    expect(removed, same(files.last));
    expect(tester.takeException(), isNull);
  });
}
