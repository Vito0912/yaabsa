import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/player/widgets/mini_player_cover.dart';
import 'package:yaabsa/ui/previews/mini_player_previews.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('mini player compact and desktop presentations fit their available widths', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [const Size(390, 180), const Size(980, 180), const Size(1920, 180)]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: Scaffold(body: MiniPlayerPresentationPreview(compact: size.width < 800)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('The Distant Shore: Stories from a Vanishing Coast'), findsOneWidget);
      expect(find.byTooltip('More player controls'), findsOneWidget);
      expect(find.byType(MiniPlayerCover), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'mini player width ${size.width}');
    }
  });
}
