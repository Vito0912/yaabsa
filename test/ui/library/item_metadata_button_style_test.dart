import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/app/item/item_media_file_section.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/ui/theme/component_styles.dart';

void main() {
  testWidgets('media path and metadata actions use shared button variants', (tester) async {
    var pathActionCount = 0;
    var metadataActionCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MediaFilePathModeButton(
              showAbsolutePaths: false,
              onPressed: () {
                pathActionCount++;
              },
            ),
            ItemMetadataCard(
              rows: [
                ItemMetadataRowData(
                  label: 'Authors',
                  values: [
                    ItemLinkValue(
                      label: 'Alexandra von Hohenfels',
                      onTap: () {
                        metadataActionCount++;
                      },
                    ),
                  ],
                ),
              ],
              useCard: false,
            ),
          ],
        ),
      ),
    );

    final pathButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Relative paths'), matching: find.byType(TextButton)).first,
    );
    final metadataButton = tester.widget<TextButton>(
      find.ancestor(of: find.text('Alexandra von Hohenfels'), matching: find.byType(TextButton)).first,
    );

    expect(pathButton.style, YaabsaButtonStyles.compactFilePathAction);
    expect(metadataButton.style, YaabsaButtonStyles.inlineMetadataLink);

    await tester.tap(find.text('Relative paths'));
    await tester.tap(find.text('Alexandra von Hohenfels'));

    expect(pathActionCount, 1);
    expect(metadataActionCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow media file section keeps its compact path action accessible', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: ItemMediaFileSection(itemId: 'preview-book', title: 'Audio files (4)', files: []),
      ),
    );

    expect(find.byTooltip('Relative paths'), findsOneWidget);
    expect(
      find.byWidgetPredicate((widget) => widget is Semantics && widget.properties.label == 'Relative paths'),
      findsOneWidget,
    );
    expect(find.text('Relative paths'), findsNothing);
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Absolute paths'), findsOneWidget);
    expect(
      find.byWidgetPredicate((widget) => widget is Semantics && widget.properties.label == 'Absolute paths'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
