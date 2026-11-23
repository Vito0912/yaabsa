import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/statistics/widgets/stats_expandable_panel.dart';
import 'package:yaabsa/features/statistics/widgets/stats_navigation_panel.dart';
import 'package:yaabsa/features/statistics/widgets/stats_panel_header.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('navigation and expandable panels use the shared header presentation', (tester) async {
    var navigationCount = 0;
    var isExpanded = false;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Material(
              child: Column(
                children: [
                  StatsNavigationPanel(
                    title: 'Advanced analytics',
                    icon: Icons.query_stats_rounded,
                    onTap: () => navigationCount++,
                  ),
                  StatsExpandablePanel(
                    title: 'Listening streaks',
                    icon: Icons.local_fire_department_outlined,
                    expanded: isExpanded,
                    onExpansionChanged: (value) => setState(() => isExpanded = value),
                    child: const Text('Longest streak: 18 days.'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(StatsPanelHeader), findsNWidgets(2));

    await tester.tap(find.text('Advanced analytics'));
    await tester.tap(find.text('Listening streaks'));
    await tester.pumpAndSettle();

    expect(navigationCount, 1);
    expect(find.text('Longest streak: 18 days.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
