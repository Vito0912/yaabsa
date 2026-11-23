import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/player/widgets/sleep_timer_custom_input.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('Set surface matches the field at different widths and text scales', (tester) async {
    final controller = TextEditingController(text: '15');
    addTearDown(controller.dispose);

    for (final width in [320.0, 560.0]) {
      for (final scale in [1.0, 2.0]) {
        for (final chapterMode in [false, true]) {
          await tester.pumpWidget(
            YaabsaPreviewApp(
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: Center(
                  child: SizedBox(
                    width: width,
                    child: SleepTimerCustomInput(
                      controller: controller,
                      chapterMode: chapterMode,
                      onChanged: (_) {},
                      onSet: () {},
                    ),
                  ),
                ),
              ),
            ),
          );

          final fieldContainer = InputDecorator.containerOf(tester.element(find.byType(EditableText)))!;
          final fieldRect = fieldContainer.localToGlobal(Offset.zero) & fieldContainer.size;
          final buttonMaterial = find.descendant(of: find.byType(FilledButton), matching: find.byType(Material));
          final buttonRect = tester.getRect(buttonMaterial);
          expect(buttonRect.top, fieldRect.top);
          expect(buttonRect.bottom, fieldRect.bottom);
          expect(tester.takeException(), isNull);
        }
      }
    }
  });
}
