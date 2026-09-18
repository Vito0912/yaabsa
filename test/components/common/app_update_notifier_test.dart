import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/components/common/app_update_notifier.dart';
import 'package:yaabsa/util/app_update_checker.dart';

void main() {
  testWidgets('shows only release information, View release, and Later', (tester) async {
    late BuildContext dialogContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            dialogContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final resultFuture = showAppUpdateDialog(
      dialogContext,
      candidate: AppUpdateCandidate(
        currentVersion: '1.11.0',
        latestVersion: '1.12.0',
        releaseUri: Uri.parse('https://github.com/Vito0912/yaabsa/releases/tag/v1.12.0'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New Yaabsa release'), findsOneWidget);
    expect(find.text('Version 1.12.0 is available. You are using 1.11.0.'), findsOneWidget);
    expect(find.text('View release'), findsOneWidget);
    expect(find.text('Later'), findsOneWidget);
    expect(find.text('Install'), findsNothing);
    expect(find.text('Download'), findsNothing);
    expect(find.text('Skip this version'), findsNothing);

    await tester.tap(find.text('Later'));
    await tester.pumpAndSettle();
    await resultFuture;

    expect(find.text('New Yaabsa release'), findsNothing);
  });
}
