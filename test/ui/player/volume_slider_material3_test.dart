import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart' show M3ESlider;
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/volume_slider_panel.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  for (final axis in Axis.values) {
    for (final volume in [0.0, 0.7, 1.0, 2.0]) {
      testWidgets('$axis volume $volume displays the actual percentage', (tester) async {
        await tester.pumpWidget(
          YaabsaPreviewApp(
            child: VolumeSliderPresentation(axis: axis, volume: volume, maxVolume: 2, onChanged: (_) {}),
          ),
        );

        final slider = tester.widget<M3ESlider>(find.byType(M3ESlider));
        final expectedLabel = '${(volume * 100).round()}%';
        expect(slider.label, expectedLabel);
        expect(slider.semanticFormatterCallback!(slider.value), expectedLabel);
        expect(tester.takeException(), isNull);
      });
    }
  }

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

  testWidgets('vertical unity marker follows the track position before M3E flips it', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: VolumeSliderPresentation(axis: Axis.vertical, volume: 1, maxVolume: 2, onChanged: (_) {}),
      ),
    );

    final slider = tester.widget<M3ESlider>(find.byType(M3ESlider));
    final marker = find.byKey(const ValueKey('volume-unity-marker'));
    final markerSize = tester.getSize(marker);
    final markerY = markerSize.height * slider.value;

    expect(slider.topToBottom, isFalse);
    expect(slider.label, '100%');
    expect(
      tester.renderObject(marker),
      paints..rect(rect: Rect.fromCenter(center: Offset(markerSize.width / 2, markerY), width: 8, height: 2)),
    );
  });
}
