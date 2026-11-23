import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/player/widgets/player_cast_presentation.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('cast presentations expose connection states and device action', (tester) async {
    var manageCount = 0;
    var connectCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Column(
          children: [
            PlayerCastButtonPresentation(connected: false, onPressed: () => connectCount++),
            PlayerCastButtonPresentation(connected: true, onPressed: () => manageCount++),
            PlayerCastStatusPresentation(fallbackTitle: 'The Distant Shore'),
            PlayerCastStatusPresentation(
              fallbackTitle: 'The Distant Shore',
              deviceName: 'Living Room Speaker',
              onPressed: () => manageCount++,
            ),
          ],
        ),
      ),
    );

    expect(find.byTooltip('Connect to a cast device'), findsOneWidget);
    expect(find.byTooltip('Manage cast device'), findsOneWidget);
    expect(find.text('The Distant Shore'), findsOneWidget);
    expect(find.text('Living Room Speaker'), findsOneWidget);

    await tester.tap(find.byTooltip('Connect to a cast device'));
    await tester.tap(find.byTooltip('Manage cast device'));
    await tester.tap(find.text('Living Room Speaker'));

    expect(connectCount, 1);
    expect(manageCount, 2);
    expect(tester.takeException(), isNull);
  });
}
