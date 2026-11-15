import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_item_card.dart';
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/previews/preview_fixtures.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('upload item card uses standard themed actions and invokes callbacks', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(480, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var fetchCount = 0;
    var removeCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryUploadItemCard(
            item: previewUploadItemDraft(),
            enabled: true,
            canFetchMetadata: true,
            onChanged: _ignoreUploadItemChange,
            onRemove: () => removeCount++,
            onFetchMetadata: () => fetchCount++,
            onAcceptPendingMetadata: _ignoreAction,
            onRejectPendingMetadata: _ignoreAction,
            authorSuggestions: const ['Mira Ellery'],
            seriesSuggestions: const ['The Tidemark Stories'],
          ),
        ),
      ),
    );

    expect(find.widgetWithText(OutlinedButton, 'Fetch metadata'), findsOneWidget);
    expect(find.text('Suggested metadata'), findsOneWidget);
    expect(find.text('A metadata suggestion is ready to review.'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Fetch metadata'));
    await tester.tap(find.byTooltip('Remove upload item'));

    expect(fetchCount, 1);
    expect(removeCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('upload item inline header centers its title field and outlined actions', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(504, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: LibraryUploadItemCard(
              item: previewUploadItemDraft(),
              enabled: true,
              canFetchMetadata: true,
              onChanged: _ignoreUploadItemChange,
              onRemove: _ignoreAction,
              onFetchMetadata: _ignoreAction,
              onAcceptPendingMetadata: _ignoreAction,
              onRejectPendingMetadata: _ignoreAction,
              authorSuggestions: const ['Mira Ellery'],
              seriesSuggestions: const ['The Tidemark Stories'],
            ),
          ),
        ),
      ),
    );

    final titleField = find.byWidgetPredicate((widget) => widget is StyledTextField && widget.label == 'Title');
    final fetchButton = find.widgetWithText(OutlinedButton, 'Fetch metadata');
    final deleteButton = find.byType(YaabsaDeleteIconButton);

    expect(find.byKey(const ValueKey<String>('uploadItemHeaderInline')), findsOneWidget);
    expect(tester.getRect(titleField).center.dy, closeTo(tester.getRect(fetchButton).center.dy, 0.5));
    expect(tester.getRect(titleField).center.dy, closeTo(tester.getRect(deleteButton).center.dy, 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('upload item shows metadata errors in red and hides suggestion success text', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(640, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final item = previewUploadItemDraft().copyWith(
      status: UploadItemStatus.ready,
      message: 'No metadata result found for this item.',
    );
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: LibraryUploadItemCard(
            item: item,
            enabled: true,
            canFetchMetadata: true,
            onChanged: _ignoreUploadItemChange,
            onRemove: _ignoreAction,
            onFetchMetadata: _ignoreAction,
            onAcceptPendingMetadata: _ignoreAction,
            onRejectPendingMetadata: _ignoreAction,
            authorSuggestions: const ['Mira Ellery'],
            seriesSuggestions: const ['The Tidemark Stories'],
          ),
        ),
      ),
    );

    final message = tester.widget<Text>(find.text('No metadata result found for this item.'));
    final colorScheme = Theme.of(tester.element(find.byType(LibraryUploadItemCard))).colorScheme;

    expect(message.style?.color, colorScheme.error);
    expect(tester.takeException(), isNull);
  });

  testWidgets('upload item metadata fields adapt to the card width', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [320.0, 390.0, 480.0, 503.0, 504.0, 520.0, 800.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: LibraryUploadItemCard(
                item: previewUploadItemDraft(),
                enabled: true,
                canFetchMetadata: true,
                onChanged: _ignoreUploadItemChange,
                onRemove: _ignoreAction,
                onFetchMetadata: _ignoreAction,
                onAcceptPendingMetadata: _ignoreAction,
                onRejectPendingMetadata: _ignoreAction,
                authorSuggestions: const ['Mira Ellery'],
                seriesSuggestions: const ['The Tidemark Stories'],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final isInline = width >= 504;
      final expectedLayout = isInline ? findsNothing : findsOneWidget;
      expect(find.byKey(const ValueKey<String>('uploadItemHeaderStacked')), expectedLayout);
      expect(find.byKey(const ValueKey<String>('uploadItemHeaderInline')), isInline ? findsOneWidget : findsNothing);
      expect(find.byKey(const ValueKey<String>('uploadItemMetadataFieldsStacked')), expectedLayout);
      expect(
        find.byKey(const ValueKey<String>('uploadItemMetadataFieldsInline')),
        isInline ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull, reason: 'Upload item card at $width logical pixels');
    }
  });

  testWidgets('upload item card keeps its responsive layout together at enlarged text', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    for (final width in [720.0, 728.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: LibraryUploadItemCard(
                item: previewUploadItemDraft(),
                enabled: true,
                canFetchMetadata: true,
                onChanged: _ignoreUploadItemChange,
                onRemove: _ignoreAction,
                onFetchMetadata: _ignoreAction,
                onAcceptPendingMetadata: _ignoreAction,
                onRejectPendingMetadata: _ignoreAction,
                authorSuggestions: const ['Mira Ellery'],
                seriesSuggestions: const ['The Tidemark Stories'],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final isInline = width >= 724;
      expect(find.byKey(const ValueKey<String>('uploadItemHeaderInline')), isInline ? findsOneWidget : findsNothing);
      expect(
        find.byKey(const ValueKey<String>('uploadItemMetadataFieldsInline')),
        isInline ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull, reason: 'Upload item card with enlarged text at $width logical pixels');
    }
  });
}

void _ignoreUploadItemChange(UploadItemDraft _) {}

void _ignoreAction() {}
