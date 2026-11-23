import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/dialogs/dialog_actions.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('dialog actions invoke cancel and confirm callbacks', (tester) async {
    var cancelCount = 0;
    var actionCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Center(
          child: AlertDialog(
            title: const Text('Save changes?'),
            actions: [
              YaabsaDialogActions(
                actionLabel: 'Save changes',
                actionIcon: Icons.save_outlined,
                onCancel: () => cancelCount++,
                onAction: () => actionCount++,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Cancel'));
    await tester.tap(find.text('Save changes'));

    expect(cancelCount, 1);
    expect(actionCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('busy destructive dialog action disables confirmation but leaves cancel enabled', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: YaabsaDialogActions(
          actionLabel: 'Delete item',
          actionIcon: Icons.delete_outline_rounded,
          onCancel: _ignoreAction,
          onAction: _ignoreAction,
          destructive: true,
          isLoading: true,
        ),
      ),
    );

    final action = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Delete item'));
    final cancel = tester.widget<TextButton>(find.widgetWithText(TextButton, 'Cancel'));

    expect(action.onPressed, isNull);
    expect(cancel.onPressed, isNotNull);
    expect(find.byType(YaabsaCircularProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _ignoreAction() {}
