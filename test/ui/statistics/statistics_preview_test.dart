import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/statistics/widgets/stats_activity_range_chart.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/ui/previews/statistics_previews.dart';
import 'package:yaabsa/ui/previews/preview_fixtures.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  for (final size in const [
    Size(320, 640),
    Size(390, 844),
    Size(800, 1100),
    Size(1100, 800),
    Size(1280, 800),
    Size(1600, 900),
    Size(800, 450),
  ]) {
    testWidgets('statistics dashboard fits $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const YaabsaPreviewApp(child: StatisticsDashboardPreview()));
      await tester.pumpAndSettle();

      for (final section in ['Your listening', 'Listening over time', 'Activity map', 'Most played']) {
        final sectionTitle = find.text(section);
        await tester.scrollUntilVisible(sectionTitle, 300, scrollable: find.byType(Scrollable).first);
        await tester.pumpAndSettle();

        expect(sectionTitle, findsOneWidget);
        expect(tester.takeException(), isNull, reason: section);
      }
    });
  }

  testWidgets('activity chart range can be changed with deterministic preview data', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: StatsActivityRangeChart(activity: previewListeningActivity(), referenceDate: previewReferenceDate),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Total over the last 30 days'), findsOneWidget);

    await tester.tap(find.text('7d'));
    await tester.pumpAndSettle();

    expect(find.text('Total over the last 7 days'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('statistics retry states share feedback presentation and invoke refresh', (tester) async {
    var refreshCount = 0;

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: Scaffold(body: StatisticsAsyncErrorStatesPreview(onRefresh: () => refreshCount++)),
      ),
    );

    expect(find.text('Failed to load listening activity.'), findsOneWidget);
    expect(find.text('Listening totals unavailable'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_rounded), findsNWidgets(2));
    await tester.tap(find.text('Retry Activity'));
    await tester.ensureVisible(find.text('Retry activity totals'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry activity totals'));

    expect(refreshCount, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('activity totals preview uses the fixed fixture date', (tester) async {
    await tester.pumpWidget(const YaabsaPreviewApp(child: StatisticsActivityTotalsPreview()));
    final expectedWeeklyTotal = formatListeningSeconds(
      previewListeningActivity().totalForLastDays(7, reference: previewReferenceDate),
    );

    expect(expectedWeeklyTotal, isNot('0 min'));
    expect(find.text(expectedWeeklyTotal), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
