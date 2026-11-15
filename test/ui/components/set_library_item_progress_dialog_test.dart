import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/set_library_item_progress_dialog.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('time input keeps progress synchronized and the started date can be changed', (tester) async {
    SetLibraryItemProgressSelection? selection;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () async {
                  selection = await showSetLibraryItemProgressDialog(
                    context: context,
                    initialProgress: 0.5,
                    durationSeconds: 7200,
                    initialStartedDate: DateTime(2024, 1, 15),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('50% complete'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, '01:00:00');

    await tester.enterText(find.byType(TextField), '00:30:00');
    await tester.pumpAndSettle();
    expect(find.text('25% complete'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_today_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(CalendarDatePicker), matching: find.text('20')));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(selection?.progress, 0.25);
    expect(selection?.startedDate, DateTime(2024, 1, 20));
    expect(selection?.finishedDate, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('full duration enables the finished date and returns finished progress', (tester) async {
    SetLibraryItemProgressSelection? selection;
    final today = DateUtils.dateOnly(DateTime.now());

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () async {
                  selection = await showSetLibraryItemProgressDialog(
                    context: context,
                    initialProgress: 0.5,
                    durationSeconds: 7200,
                    initialStartedDate: DateTime(2024, 1, 15),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '02:00:00');
    await tester.pumpAndSettle();
    expect(find.text('100% complete'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.event_available_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(CalendarDatePicker), matching: find.text(today.day.toString())));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(selection?.progress, 1);
    expect(selection?.startedDate, DateTime(2024, 1, 15));
    expect(selection?.finishedDate, today);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invalid or overlong time prevents saving', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return FilledButton(
                onPressed: () async {
                  await showSetLibraryItemProgressDialog(
                    context: context,
                    initialProgress: 0,
                    durationSeconds: 3600,
                    initialStartedDate: DateTime(2026, 1, 1),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '01:30:00');
    await tester.pumpAndSettle();

    final saveButton = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'));
    expect(saveButton.onPressed, isNull);
    expect(find.text('Time cannot exceed 01:00:00.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
