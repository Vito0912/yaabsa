import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/player/widgets/playback_speed_sheet.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('playback speed sheet applies custom values within supported bounds', (tester) async {
    double? appliedSpeed;

    await tester.pumpWidget(
      YaabsaPreviewApp(child: PlaybackSpeedSheet(initialSpeed: 1.2, onApplySpeed: (speed) => appliedSpeed = speed)),
    );

    await tester.enterText(find.byType(TextField), '4.0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(appliedSpeed, 3.0);
    expect(find.text('3.0x'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
