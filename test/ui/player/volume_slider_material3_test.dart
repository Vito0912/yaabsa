import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart' show M3ESlider;
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/volume_slider_panel.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('horizontal volume control uses the Material 3 Expressive slider', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: VolumeSliderPresentation(axis: Axis.horizontal, volume: 0.7, maxVolume: 2, onChanged: (_) {}),
      ),
    );

    final slider = find.byType(M3ESlider);
    expect(slider, findsOneWidget);
    expect(Theme.of(tester.element(slider)).useMaterial3, isTrue);
    expect(tester.widget<M3ESlider>(slider).onChanged, isNotNull);
    expect(tester.widget<M3ESlider>(slider).axis, Axis.horizontal);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vertical volume control uses the Material 3 Expressive slider', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: VolumeSliderPresentation(axis: Axis.vertical, volume: 0.7, maxVolume: 2, onChanged: (_) {}),
      ),
    );

    final slider = find.byType(M3ESlider);
    expect(slider, findsOneWidget);
    expect(Theme.of(tester.element(slider)).useMaterial3, isTrue);
    expect(tester.widget<M3ESlider>(slider).onChanged, isNotNull);
    expect(tester.widget<M3ESlider>(slider).axis, Axis.vertical);
    expect(tester.takeException(), isNull);
  });
}
