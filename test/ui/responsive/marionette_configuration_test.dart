import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/previews/marionette_configuration.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('Marionette recognizes YAABSA dropdowns by label', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaDropdownField<String>(
          label: 'Sort by',
          value: 'Title',
          items: const [DropdownMenuItem(value: 'Title', child: Text('Title'))],
          onChanged: (_) {},
        ),
      ),
    );

    final element = tester.element(find.byType(YaabsaDropdownField<String>));
    final configuration = uiLabMarionetteConfiguration;

    expect(configuration.isElementInteractive(element), isTrue);
    expect(configuration.extractTextFromWidget(element), 'Sort by');
    expect(configuration.logCollector, isNotNull);
  });
}
