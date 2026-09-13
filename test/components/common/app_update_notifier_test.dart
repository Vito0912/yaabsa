import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/components/common/app_update_notifier.dart';

void main() {
  testWidgets('shows release information with a release link but no install action', (tester) async {
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
      currentVersion: '1.11.0',
      latestVersion: '1.12.0',
    );
    await tester.pumpAndSettle();

    expect(find.text('New Yaabsa release'), findsOneWidget);
    expect(find.textContaining('Version 1.12.0 has been released. You are using 1.11.0.'), findsOneWidget);
    expect(find.textContaining('Store availability may lag behind upstream releases.'), findsOneWidget);
    expect(find.text('View release'), findsOneWidget);
    expect(find.text('Skip this version'), findsOneWidget);
    expect(find.text('Later'), findsOneWidget);
    expect(find.text('Install'), findsNothing);

    await tester.tap(find.text('Later'));
    await tester.pumpAndSettle();

    expect(await resultFuture, AppUpdateDialogAction.later);
  });

  testWidgets('returns skipVersion when the user skips the release', (tester) async {
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
      currentVersion: '1.11.0',
      latestVersion: '1.12.0',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip this version'));
    await tester.pumpAndSettle();

    expect(await resultFuture, AppUpdateDialogAction.skipVersion);
  });
}
