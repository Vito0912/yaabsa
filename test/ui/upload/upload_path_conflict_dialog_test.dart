import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/widgets/upload_path_conflict_dialog.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('upload path confirmation returns the selected action', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(640, 520);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final conflicts = List<String>.generate(
      12,
      (index) => 'Author $index/Series $index/Book title $index already exists or could not be checked.',
    );
    bool? result;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                return FilledButton(
                  onPressed: () async {
                    result = await showDialog<bool>(
                      context: context,
                      builder: (context) => UploadPathConflictDialog(conflicts: conflicts),
                    );
                  },
                  child: const Text('Review paths'),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Review paths'));
    await tester.pumpAndSettle();
    expect(find.text('Path check issues found'), findsOneWidget);
    expect(find.text('- Author 0/Series 0/Book title 0 already exists or could not be checked.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Continue anyway'));
    await tester.pumpAndSettle();
    expect(result, isTrue);

    await tester.tap(find.text('Review paths'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel upload'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
    expect(tester.takeException(), isNull);
  });
}
