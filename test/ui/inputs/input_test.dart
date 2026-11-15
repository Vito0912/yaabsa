import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('credential fields retain focus, selection, autofill and callbacks', (tester) async {
    final controller = TextEditingController();
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    String? submitted;

    Widget build() => YaabsaPreviewApp(
      child: StyledTextField(
        label: 'Password',
        controller: controller,
        focusNode: focus,
        obscureText: true,
        autofillHints: const [AutofillHints.password],
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) => submitted = value,
      ),
    );

    await tester.pumpWidget(build());
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'example-secret');
    await tester.pumpWidget(build());
    expect(focus.hasFocus, isTrue);
    expect(controller.text, 'example-secret');
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
    expect(field.autocorrect, isFalse);
    expect(field.enableSuggestions, isFalse);
    expect(field.autofillHints, contains(AutofillHints.password));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, 'example-secret');
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('form validation, numeric filtering and save remain functional', (tester) async {
    final key = GlobalKey<FormState>();
    String? saved;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Form(
          key: key,
          child: StyledTextFormField(
            label: 'Count',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => value == null || value.isEmpty ? 'Enter a count' : null,
            onSaved: (value) => saved = value,
          ),
        ),
      ),
    );
    expect(key.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Enter a count'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'a12');
    expect(key.currentState!.validate(), isTrue);
    key.currentState!.save();
    expect(saved, '12');
  });

  testWidgets('search clear reflects programmatic edits and notifies the owner', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    String? changed;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaSearchField(controller: controller, onChanged: (value) => changed = value),
      ),
    );
    expect(find.byTooltip('Clear search'), findsNothing);
    controller.text = 'Shore';
    await tester.pump();
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(changed, '');
    expect(find.byTooltip('Clear search'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('disabled and read-only fields do not accept edits', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Column(
          children: [
            StyledTextField(label: 'Disabled', enabled: false),
            StyledTextFormField(label: 'Read only', initialValue: 'Retained', readOnly: true),
          ],
        ),
      ),
    );
    final fields = tester.widgetList<TextField>(find.byType(TextField)).toList();
    expect(fields.first.enabled, isFalse);
    expect(fields.last.readOnly, isTrue);
    expect(find.text('Retained'), findsOneWidget);
  });

  testWidgets('dropdown selection is forwarded to the controlled owner', (tester) async {
    String? selected = 'Title';
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return YaabsaDropdownField<String>(
              label: 'Sort',
              value: selected,
              focusNode: focusNode,
              items: const [
                DropdownMenuItem(value: 'Title', child: Text('Title')),
                DropdownMenuItem(value: 'Author', child: Text('Author')),
              ],
              onChanged: (value) => setState(() => selected = value),
            );
          },
        ),
      ),
    );
    await tester.tap(find.byType(M3EDropdownMenu<String>).hitTestable());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Author').last);
    await tester.pumpAndSettle();
    expect(selected, 'Author');
    expect(tester.takeException(), isNull);
  });

  testWidgets('dropdown reflects owner value changes before local interaction', (tester) async {
    String? selected = 'Title';
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    Widget build() => YaabsaPreviewApp(
      child: YaabsaDropdownField<String>(
        label: 'Sort',
        value: selected,
        focusNode: focusNode,
        items: const [
          DropdownMenuItem(value: 'Title', child: Text('Title')),
          DropdownMenuItem(value: 'Author', child: Text('Author')),
        ],
        onChanged: (_) {},
      ),
    );

    await tester.pumpWidget(build());
    focusNode.requestFocus();
    await tester.pump();
    selected = 'Author';
    await tester.pumpWidget(build());
    await tester.pumpAndSettle();

    expect(focusNode.hasFocus, isTrue);
    expect(find.text('Author').first, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dropdown field decoration keeps the shared field appearance', (tester) async {
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

    final dropdown = tester.widget<M3EDropdownMenu<String>>(find.byType(M3EDropdownMenu<String>));

    expect(dropdown.fieldStyle.backgroundColor, isNotNull);
    expect(dropdown.fieldStyle.borderRadius, BorderRadius.circular(10));
    expect(
      dropdown.fieldStyle.backgroundColor,
      Theme.of(tester.element(find.byType(M3EDropdownMenu<String>))).colorScheme.surfaceContainer,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('standard text and dropdown fields align when placed in a row', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Row(
          children: [
            const Expanded(child: StyledTextField(hintText: 'Name')),
            const SizedBox(width: 8),
            Expanded(
              child: YaabsaDropdownField<String>(
                label: 'Type',
                value: 'Book',
                items: const [DropdownMenuItem(value: 'Book', child: Text('Book'))],
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
    );

    final textField = find.byType(TextField);
    final dropdown = find.byType(YaabsaDropdownField<String>);
    expect(textField, findsOneWidget);
    expect(dropdown, findsOneWidget);
    final heights = [tester.getSize(textField).height, tester.getSize(dropdown).height];

    expect(heights, [YaabsaFieldDimensions.standardHeight, YaabsaFieldDimensions.standardHeight]);
    expect(tester.takeException(), isNull);
  });
}
