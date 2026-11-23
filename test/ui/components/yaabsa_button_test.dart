import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('regular and small variants preserve their separate visual sizes', (tester) async {
    for (final variant in YaabsaButtonVariant.values) {
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: Column(
            children: [
              YaabsaButton(label: const Text('Regular'), variant: variant, onPressed: () {}),
              YaabsaButton.small(label: const Text('Small'), variant: variant, onPressed: () {}),
              YaabsaButton.iconSmall(
                icon: const Icon(Icons.sort_rounded),
                tooltip: 'Sort',
                variant: variant,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      final buttons = find.byWidgetPredicate((widget) => widget is ButtonStyleButton);
      expect(buttons, findsNWidgets(3));
      final heights = <double>[];
      for (final button in buttons.evaluate()) {
        final buttonFinder = find.byWidget(button.widget);
        final material = find.descendant(of: buttonFinder, matching: find.byType(Material));
        heights.add(tester.getSize(material).height);
        expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(48));
      }
      expect(heights, [48, 40, 40]);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('loading blocks activation and retains the action label', (tester) async {
    var activations = 0;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaButton.small(
          label: const Text('Save'),
          isLoading: true,
          onPressed: () {
            activations++;
          },
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
    expect(find.byType(YaabsaCircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('Save'));
    expect(activations, 0);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  });

  testWidgets('small labeled buttons grow for enlarged text at narrow widths', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Center(
            child: SizedBox(
              width: 240,
              child: YaabsaButton.small(
                label: const Text('Create a new audiobook collection'),
                icon: const Icon(Icons.add_rounded),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(FilledButton);
    expect(tester.getSize(buttonFinder).height, greaterThan(48));
    expect(tester.getSize(buttonFinder).width, 240);
    expect(tester.takeException(), isNull);
  });

  testWidgets('icon-only action exposes its tooltip and forwards activation', (tester) async {
    var activations = 0;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaButton.iconSmall(
          icon: const Icon(Icons.sort_rounded),
          tooltip: 'Sort library',
          variant: YaabsaButtonVariant.outlined,
          onPressed: () {
            activations++;
          },
        ),
      ),
    );

    expect(find.byTooltip('Sort library'), findsOneWidget);
    await tester.tap(find.byTooltip('Sort library'));
    expect(activations, 1);
  });
}
