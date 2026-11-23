import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('surface card applies shared padding, color, border, and radius', (tester) async {
    const borderColor = Colors.deepPurple;
    const cardColor = Colors.amber;

    await tester.pumpWidget(
      const YaabsaPreviewApp(
        child: YaabsaSurfaceCard(
          padding: EdgeInsets.all(12),
          color: cardColor,
          borderColor: borderColor,
          borderRadius: 14,
          child: Text('Reusable content'),
        ),
      ),
    );

    final materialFinder = find.descendant(of: find.byType(YaabsaSurfaceCard), matching: find.byType(Material));
    final material = tester.widget<Material>(materialFinder);
    expect(material.color, cardColor);
    expect(material.clipBehavior, Clip.antiAlias);

    final shape = material.shape! as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(14));
    expect(shape.side.color, borderColor);
    final cardPadding = tester.widget<Padding>(
      find.descendant(of: find.byType(YaabsaSurfaceCard), matching: find.byType(Padding)),
    );
    expect(cardPadding.padding, const EdgeInsets.all(12));
    expect(find.text('Reusable content'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
