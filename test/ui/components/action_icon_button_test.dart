import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('shared action button applies configured shapes and disabled state', (tester) async {
    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            YaabsaActionIconButton(
              icon: Icons.download_rounded,
              tooltip: 'Library download',
              onPressed: null,
              variant: YaabsaActionButtonVariant.filledTonal,
              shape: YaabsaActionButtonShape.rounded,
            ),
            YaabsaActionIconButton(
              icon: Icons.download_rounded,
              tooltip: 'Episode download',
              onPressed: null,
              variant: YaabsaActionButtonVariant.filledTonal,
              shape: YaabsaActionButtonShape.round,
            ),
          ],
        ),
      ),
    );

    final buttons = tester.widgetList<IconButton>(find.byType(IconButton)).toList();
    expect(buttons, hasLength(2));
    expect(buttons[0].style?.shape?.resolve(const {}), isA<RoundedRectangleBorder>());
    expect(buttons[1].style?.shape?.resolve(const {}), isA<CircleBorder>());
    expect(buttons.every((button) => button.onPressed == null), isTrue);
    expect(find.byTooltip('Library download'), findsOneWidget);
    expect(find.byTooltip('Episode download'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shared action button preserves long-press actions', (tester) async {
    var longPressCount = 0;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaActionIconButton(
          icon: Icons.bedtime_rounded,
          tooltip: 'Sleep timer',
          onPressed: () {},
          onLongPress: () => longPressCount++,
        ),
      ),
    );

    await tester.longPress(find.byTooltip('Sleep timer'));
    expect(longPressCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('danger actions use the shared red outlined rounded style', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaActionIconButton(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Delete item',
          onPressed: () {},
          tone: YaabsaActionTone.danger,
        ),
      ),
    );

    final button = tester.widget<IconButton>(find.byType(IconButton));
    final colorScheme = Theme.of(tester.element(find.byType(YaabsaActionIconButton))).colorScheme;

    expect(button.style?.shape?.resolve(const {}), isA<RoundedRectangleBorder>());
    expect(button.style?.foregroundColor?.resolve(const {}), colorScheme.error);
    expect(tester.takeException(), isNull);
  });

  testWidgets('delete actions share the trash icon, destructive tone, and icon-button shape', (tester) async {
    var deleteCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaDeleteIconButton(tooltip: 'Delete item', onPressed: () => deleteCount++),
      ),
    );

    final button = tester.widget<IconButton>(find.byType(IconButton));
    final icon = tester.widget<Icon>(find.descendant(of: find.byType(IconButton), matching: find.byType(Icon)));
    final colorScheme = Theme.of(tester.element(find.byType(YaabsaDeleteIconButton))).colorScheme;

    expect(button.tooltip, 'Delete item');
    expect(button.style?.shape?.resolve(const {}), isA<RoundedRectangleBorder>());
    expect(icon.icon, Icons.delete_outline_rounded);
    expect(icon.color, colorScheme.error);

    await tester.tap(find.byTooltip('Delete item'));
    expect(deleteCount, 1);
    expect(tester.takeException(), isNull);
  });
}
