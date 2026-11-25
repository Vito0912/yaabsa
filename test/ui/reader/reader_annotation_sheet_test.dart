import 'package:flutter_test/flutter_test.dart';
import 'package:foliate_reader/foliate_reader.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/reader/widgets/reader_epub_annotation_sheet.dart';
import 'package:yaabsa/util/l10n.dart';

void main() {
  testWidgets('deleting from annotation details returns the delete action', (tester) async {
    ReaderAnnotationSheetAction? result;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: yaabsaLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () async {
                  result = await showReaderEpubAnnotationSheet(
                    context,
                    FoliateAnnotation(value: 'Selected passage', color: '#FFEB3B', note: 'Keep this note'),
                  );
                },
                child: const Text('Open annotation'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open annotation'));
    await tester.pumpAndSettle();

    expect(find.text('Keep this note'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete annotation'));
    await tester.pumpAndSettle();

    expect(result?.type, ReaderAnnotationSheetActionType.delete);
    expect(tester.takeException(), isNull);
  });
}
