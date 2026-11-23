import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/widgets/settings_control_status_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_slider_presentation.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/ui/previews/settings_previews.dart';

void main() {
  testWidgets('settings preview covers switch, loading, disabled, and slider states', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(640, 840);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const YaabsaPreviewApp(child: SettingsControlsPreview()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(SettingsSwitchPresentation), findsNWidgets(5));
    expect(find.byType(SwitchListTile), findsNWidgets(5));
    expect(find.byType(Checkbox), findsNothing);
    expect(find.byType(SettingsSliderPresentation<int>), findsOneWidget);
    expect(find.byType(SettingsControlStatusPresentation), findsNWidgets(2));
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Unable to load Unavailable remote setting',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Wi-Fi only'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile).first).value, isFalse);

    await tester.tap(find.text('Include cover artwork'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(3)).value, isTrue);
  });

  testWidgets('settings control status exposes loading and error states', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Column(
          children: [
            SettingsControlStatusPresentation(label: 'Loading option', state: SettingsControlLoadState.loading),
            SettingsControlStatusPresentation(label: 'Failed option', state: SettingsControlLoadState.error),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(YaabsaCircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Unable to load Failed option',
      ),
      findsOneWidget,
    );
  });

  testWidgets('settings slider presentation reports the selected value', (tester) async {
    int? selectedValue;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SettingsSliderPresentation<int>(
          label: 'Playback speed',
          values: const [1, 2, 3],
          valueLabels: const ['Slow', 'Normal', 'Fast'],
          value: 2,
          onChanged: (value) => selectedValue = value,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChanged!(2);
    expect(selectedValue, 3);
  });
}
