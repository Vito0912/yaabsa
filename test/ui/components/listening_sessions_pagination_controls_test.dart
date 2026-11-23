import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/sessions/listening_sessions_pagination_controls.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('page size and navigation use shared compact controls', (tester) async {
    tester.view.physicalSize = const Size(520, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var nextPagePressed = false;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SizedBox(
          width: 520,
          child: ListeningSessionsPaginationControls(
            page: 0,
            numPages: 3,
            total: 42,
            itemsPerPage: 20,
            onItemsPerPageChanged: (_) {},
            onPrevious: () {},
            onNext: () => nextPagePressed = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final pageSizeField = find.byType(YaabsaExpressiveDropdown<int>);
    expect(tester.getSize(pageSizeField).height, 48);
    expect(tester.getSize(pageSizeField).width, 88);
    expect(find.byType(YaabsaActionIconButton), findsNWidgets(2));
    expect(tester.getSize(find.byType(YaabsaActionIconButton).first).height, tester.getSize(pageSizeField).height);
    final nextPageButton = find.descendant(
      of: find.byType(YaabsaActionIconButton).last,
      matching: find.byType(IconButton),
    );
    final nextButton = tester.widget<IconButton>(nextPageButton);
    expect(nextButton.onPressed, isNotNull);
    expect(nextButton.style?.shape?.resolve(const {}), isA<RoundedRectangleBorder>());

    await tester.tap(find.byTooltip('Next page'));
    expect(nextPagePressed, isTrue);

    await tester.tap(find.text('20'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('50').last);
    await tester.pumpAndSettle();

    expect(find.text('50'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('session pagination stays usable with large text at compact widths', (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [280.0, 320.0, 390.0, 520.0, 800.0]) {
      final height = width == 800 ? 450.0 : 800.0;
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: MediaQuery(
            data: MediaQueryData(size: Size(width, height), textScaler: const TextScaler.linear(1.8)),
            child: SizedBox(
              width: width,
              child: ListeningSessionsPaginationControls(
                page: 0,
                numPages: 1,
                total: 0,
                itemsPerPage: 20,
                onItemsPerPageChanged: (_) {},
                onPrevious: null,
                onNext: null,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: '$width logical pixels at 1.8× text');
      expect(find.text('Per page:'), findsOneWidget);
      expect(find.byType(YaabsaActionIconButton), findsNWidgets(2));
      expect(tester.getSize(find.byType(YaabsaExpressiveDropdown<int>)).height, greaterThanOrEqualTo(48));
      expect(tester.getRect(find.text('Total: 0')).left, greaterThanOrEqualTo(8));
    }
  });
}
