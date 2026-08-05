import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';

void main() {
  group('player presentation settings', () {
    test('saved layouts default to Custom without an explicit mode', () {
      expect(
        PlayerLayoutMode.fromSettingValue(null, hasSavedCustomLayout: true),
        PlayerLayoutMode.custom,
      );
      expect(
        PlayerLayoutMode.fromSettingValue(null, hasSavedCustomLayout: false),
        PlayerLayoutMode.adaptive,
      );
      expect(
        PlayerLayoutMode.fromSettingValue('adaptive', hasSavedCustomLayout: true),
        PlayerLayoutMode.adaptive,
      );
    });

    test('action configuration preserves order and removes duplicates', () {
      expect(
        decodePlayerActions(
          'queue,speed,queue,bookmarks',
          fallback: defaultFullPlayerActions,
        ),
        <PlayerActionType>[
          PlayerActionType.queue,
          PlayerActionType.speed,
          PlayerActionType.bookmarks,
        ],
      );
      expect(
        decodePlayerActions('', fallback: defaultMiniPlayerActions),
        isEmpty,
      );
    });
  });

  group('adaptive layout resolver', () {
    testWidgets('uses the short landscape composition for a rotated phone', (tester) async {
      final layout = await _resolveForSize(tester, const Size(844, 390));
      expect(layout, AdaptivePlayerLayout.compactLandscape);
    });

    testWidgets('uses the portrait composition for a narrow phone', (tester) async {
      final layout = await _resolveForSize(tester, const Size(390, 844));
      expect(layout, AdaptivePlayerLayout.compactPortrait);
    });

    testWidgets('uses the expanded composition only for a large desktop window', (tester) async {
      final layout = await _resolveForSize(tester, const Size(1440, 900));
      expect(layout, AdaptivePlayerLayout.expanded);
    });

    testWidgets('keeps a narrow desktop-sized window in the medium composition', (tester) async {
      final layout = await _resolveForSize(tester, const Size(1024, 768));
      expect(layout, AdaptivePlayerLayout.medium);
    });
  });
}

Future<AdaptivePlayerLayout> _resolveForSize(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  AdaptivePlayerLayout? resolved;
  await tester.pumpWidget(
    MaterialApp(
      home: LayoutBuilder(
        builder: (context, constraints) {
          resolved = resolveAdaptivePlayerLayout(context, constraints);
          return const SizedBox.shrink();
        },
      ),
    ),
  );

  return resolved!;
}
