import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/features/statistics/widgets/stats_ranked_panel.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('rank panel keeps list actions and its empty message', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var selectedCount = 0;
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SizedBox(
          width: 288,
          child: StatsRankedPanel(
            title: 'Top audiobook authors this year',
            icon: Icons.people_alt_rounded,
            entries: [
              StatsRankedEntry(label: 'Author One', value: 120, trailing: '2 hr', onTap: () => selectedCount++),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Top audiobook authors this year'), findsOneWidget);
    expect(find.text('Author One'), findsOneWidget);
    await tester.tap(find.text('Author One'));
    await tester.pumpAndSettle();
    expect(selectedCount, 1);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: SizedBox(
          width: 288,
          child: const StatsRankedPanel(
            title: 'Top authors',
            icon: Icons.people_alt_rounded,
            entries: [],
            emptyMessage: 'No authors found for this year.',
          ),
        ),
      ),
    );

    expect(find.text('No authors found for this year.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
