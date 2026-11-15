import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('standard switch tile forwards its value and callback', (tester) async {
    var changedValue = false;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: YaabsaSwitchTile(
            value: false,
            title: const Text('Use secure connection'),
            subtitle: const Text('Encrypt traffic to the server'),
            onChanged: (value) => changedValue = value,
          ),
        ),
      ),
    );

    expect(find.text('Use secure connection'), findsOneWidget);
    expect(find.text('Encrypt traffic to the server'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(changedValue, isTrue);
  });

  testWidgets('adaptive switch tile preserves the platform control', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(useMaterial3: true, platform: TargetPlatform.iOS),
        home: const Scaffold(
          body: YaabsaSwitchTile.adaptive(
            value: true,
            title: Text('Enable notifications'),
            onChanged: _ignoreChangedValue,
          ),
        ),
      ),
    );

    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(tester.widget<YaabsaSwitchTile>(find.byType(YaabsaSwitchTile)).adaptive, isTrue);
    expect(tester.takeException(), isNull);
  });
}

void _ignoreChangedValue(bool value) {}
