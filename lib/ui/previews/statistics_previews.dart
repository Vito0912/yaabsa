import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/stats/days_of_week.dart';
import 'package:yaabsa/api/library/stats/year_in_review_stats.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/models/advanced_listening_analytics_state.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/models/advanced_loading_progress_info.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/features/statistics/widgets/stats_activity_totals_card.dart';
import 'package:yaabsa/features/statistics/widgets/stats_achievements_section.dart';
import 'package:yaabsa/features/statistics/widgets/stats_advanced_dashboard.dart';
import 'package:yaabsa/features/statistics/widgets/stats_activity_heatmap.dart';
import 'package:yaabsa/features/statistics/widgets/stats_activity_range_chart.dart';
import 'package:yaabsa/features/statistics/widgets/stats_activity_section.dart';
import 'package:yaabsa/features/statistics/widgets/stats_recent_sessions_list.dart';
import 'package:yaabsa/features/statistics/widgets/stats_summary_grid.dart';
import 'package:yaabsa/features/statistics/widgets/stats_weekday_breakdown.dart';
import 'package:yaabsa/features/statistics/widgets/stats_year_rewind_section.dart';
import 'package:yaabsa/features/statistics/widgets/stats_expandable_panel.dart';
import 'package:yaabsa/features/statistics/widgets/stats_navigation_panel.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';

import 'preview_fixtures.dart';
import 'preview_theme.dart';

@Preview(name: 'Statistics advanced dashboard / light', size: Size(960, 1400), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics advanced dashboard / dark', size: Size(960, 1400), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics advanced dashboard / AMOLED', size: Size(960, 1400), wrapper: yaabsaPreviewAmoled)
Widget statisticsAdvancedDashboardPreview() => const StatisticsAdvancedDashboardPreview();

@Preview(name: 'Statistics achievements / light', size: Size(960, 900), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics achievements / dark', size: Size(960, 900), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics achievements / AMOLED', size: Size(960, 900), wrapper: yaabsaPreviewAmoled)
Widget statisticsAchievementsPreview() => const StatisticsAchievementsPreview();

@Preview(name: 'Year in review / light', size: Size(960, 900), wrapper: yaabsaPreviewLight)
@Preview(name: 'Year in review / dark', size: Size(960, 900), wrapper: yaabsaPreviewDark)
@Preview(name: 'Year in review / AMOLED', size: Size(960, 900), wrapper: yaabsaPreviewAmoled)
Widget statisticsYearRewindPreview() => const StatisticsYearRewindPreview();

@Preview(name: 'Activity totals / light', size: Size(720, 320), wrapper: yaabsaPreviewLight)
@Preview(name: 'Activity totals / dark', size: Size(720, 320), wrapper: yaabsaPreviewDark)
@Preview(name: 'Activity totals / AMOLED', size: Size(720, 320), wrapper: yaabsaPreviewAmoled)
Widget statisticsActivityTotalsPreview() => const StatisticsActivityTotalsPreview();

@Preview(name: 'Recent sessions and weekdays / light', size: Size(720, 1300), wrapper: yaabsaPreviewLight)
@Preview(name: 'Recent sessions and weekdays / dark', size: Size(720, 1300), wrapper: yaabsaPreviewDark)
@Preview(name: 'Recent sessions and weekdays / AMOLED', size: Size(720, 1300), wrapper: yaabsaPreviewAmoled)
Widget statisticsSessionsAndWeekdaysPreview() => const StatisticsSessionsAndWeekdaysPreview();

@Preview(name: 'Statistics dashboard / light', size: Size(960, 1200), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics dashboard / dark', size: Size(960, 1200), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics dashboard / AMOLED', size: Size(960, 1200), wrapper: yaabsaPreviewAmoled)
Widget statisticsDashboardPreview() => const StatisticsDashboardPreview();

@Preview(name: 'Statistics metrics / light', size: Size(960, 440), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics metrics / dark', size: Size(960, 440), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics metrics / AMOLED', size: Size(960, 440), wrapper: yaabsaPreviewAmoled)
Widget statisticsMetricsPreview() => const StatisticsMetricsPreview();

@Preview(name: 'Statistics chart / 7 days / light', size: Size(960, 500), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics chart / 7 days / dark', size: Size(960, 500), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics chart / 7 days / AMOLED', size: Size(960, 500), wrapper: yaabsaPreviewAmoled)
Widget statisticsSevenDayChartPreview() => const StatisticsRangeChartPreview(initialRange: 7);

@Preview(name: 'Statistics chart / one year / light', size: Size(960, 500), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics chart / one year / dark', size: Size(960, 500), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics chart / one year / AMOLED', size: Size(960, 500), wrapper: yaabsaPreviewAmoled)
Widget statisticsYearChartPreview() => const StatisticsRangeChartPreview(initialRange: 365);

@Preview(name: 'Activity map / recent / light', size: Size(520, 1080), wrapper: yaabsaPreviewLight)
@Preview(name: 'Activity map / recent / dark', size: Size(520, 1080), wrapper: yaabsaPreviewDark)
@Preview(name: 'Activity map / recent / AMOLED', size: Size(520, 1080), wrapper: yaabsaPreviewAmoled)
Widget statisticsRecentHeatmapPreview() => const StatisticsHeatmapPreview(days: 84);

@Preview(name: 'Activity map / year / light', size: Size(960, 420), wrapper: yaabsaPreviewLight)
@Preview(name: 'Activity map / year / dark', size: Size(960, 420), wrapper: yaabsaPreviewDark)
@Preview(name: 'Activity map / year / AMOLED', size: Size(960, 420), wrapper: yaabsaPreviewAmoled)
Widget statisticsYearHeatmapPreview() => const StatisticsHeatmapPreview(days: 365);

@Preview(name: 'Ranked listening / light', size: Size(720, 620), wrapper: yaabsaPreviewLight)
@Preview(name: 'Ranked listening / dark', size: Size(720, 620), wrapper: yaabsaPreviewDark)
@Preview(name: 'Ranked listening / AMOLED', size: Size(720, 620), wrapper: yaabsaPreviewAmoled)
Widget statisticsRankingPreview() => const StatisticsRankedPreview();

@Preview(name: 'Empty statistics / light', size: Size(560, 320), wrapper: yaabsaPreviewLight)
@Preview(name: 'Empty statistics / dark', size: Size(560, 320), wrapper: yaabsaPreviewDark)
@Preview(name: 'Empty statistics / AMOLED', size: Size(560, 320), wrapper: yaabsaPreviewAmoled)
Widget statisticsEmptyPreview() => const StatisticsEmptyPreview();

@Preview(name: 'Statistics messages / light', size: Size(560, 520), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics messages / dark', size: Size(560, 520), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics messages / AMOLED', size: Size(560, 520), wrapper: yaabsaPreviewAmoled)
Widget statisticsMessagesPreview() => const StatisticsMessagesPreview();

@Preview(name: 'Statistics async error states / light', size: Size(640, 900), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics async error states / dark', size: Size(640, 900), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics async error states / AMOLED', size: Size(640, 900), wrapper: yaabsaPreviewAmoled)
Widget statisticsAsyncErrorStatesPreview() => const StatisticsAsyncErrorStatesPreview();

@Preview(name: 'Reusable surface cards / light', size: Size(600, 420), wrapper: yaabsaPreviewLight)
@Preview(name: 'Reusable surface cards / dark', size: Size(600, 420), wrapper: yaabsaPreviewDark)
@Preview(name: 'Reusable surface cards / AMOLED', size: Size(600, 420), wrapper: yaabsaPreviewAmoled)
Widget statisticsSurfaceCardsPreview() => const StatisticsSurfaceCardsPreview();

@Preview(name: 'Statistics panel controls / light', size: Size(560, 220), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics panel controls / dark', size: Size(560, 220), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics panel controls / AMOLED', size: Size(560, 220), wrapper: yaabsaPreviewAmoled)
Widget statisticsPanelControlsPreview() => const StatisticsPanelControlsPreview();

@Preview(name: 'Statistics dashboard / compact / light', size: Size(390, 1450), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics dashboard / compact / dark', size: Size(390, 1450), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics dashboard / compact / AMOLED', size: Size(390, 1450), wrapper: yaabsaPreviewAmoled)
Widget statisticsCompactDashboardPreview() => const StatisticsCompactDashboardPreview();

@Preview(name: 'Statistics loading states / light', size: Size(720, 1080), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics loading states / dark', size: Size(720, 1080), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics loading states / AMOLED', size: Size(720, 1080), wrapper: yaabsaPreviewAmoled)
Widget statisticsLoadingStatesPreview() => const StatisticsLoadingStatesPreview();

@Preview(name: 'Statistics without activity / light', size: Size(640, 1080), wrapper: yaabsaPreviewLight)
@Preview(name: 'Statistics without activity / dark', size: Size(640, 1080), wrapper: yaabsaPreviewDark)
@Preview(name: 'Statistics without activity / AMOLED', size: Size(640, 1080), wrapper: yaabsaPreviewAmoled)
Widget statisticsNoActivityPreview() => const StatisticsNoActivityPreview();

class StatisticsSurfaceCardsPreview extends StatelessWidget {
  const StatisticsSurfaceCardsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YaabsaSurfaceCard(child: Text('Listening activity chart', style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(height: 16),
          YaabsaSurfaceCard(
            padding: const EdgeInsets.all(12),
            borderRadius: 12,
            color: Colors.transparent,
            borderColor: colors.outlineVariant,
            child: Text('Top listening days', style: Theme.of(context).textTheme.titleSmall),
          ),
          const SizedBox(height: 16),
          YaabsaSurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderRadius: 16,
            color: colors.secondaryContainer,
            child: Text('Timer active · 15 min remaining', style: Theme.of(context).textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}

class StatisticsPanelControlsPreview extends StatefulWidget {
  const StatisticsPanelControlsPreview({super.key});

  @override
  State<StatisticsPanelControlsPreview> createState() => _StatisticsPanelControlsPreviewState();
}

class _StatisticsPanelControlsPreviewState extends State<StatisticsPanelControlsPreview> {
  bool _isStreakPanelExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsNavigationPanel(title: 'Advanced analytics', icon: Icons.query_stats_rounded, onTap: () {}),
          const SizedBox(height: 12),
          StatsExpandablePanel(
            title: 'Listening streaks',
            icon: Icons.local_fire_department_outlined,
            expanded: _isStreakPanelExpanded,
            onExpansionChanged: (expanded) => setState(() => _isStreakPanelExpanded = expanded),
            child: const Align(alignment: Alignment.centerLeft, child: Text('Your longest streak is 18 days.')),
          ),
        ],
      ),
    );
  }
}

class StatisticsCompactDashboardPreview extends StatelessWidget {
  const StatisticsCompactDashboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(12), child: StatisticsDashboardPreview());
  }
}

class StatisticsLoadingStatesPreview extends StatelessWidget {
  const StatisticsLoadingStatesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    const activityLoading = AsyncLoading<ListeningActivityStats>();
    const advancedProgress = AdvancedLoadingProgressInfo(
      loadedPages: 3,
      totalPages: 8,
      loadedSessions: 42,
      totalSessions: 82,
    );
    final analyticsLoading = AdvancedListeningAnalyticsState(isLoading: true, progress: advancedProgress);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        StatsSection(
          title: 'Listening activity',
          icon: Icons.show_chart_rounded,
          child: StatsActivitySection(activityAsync: activityLoading, onRefresh: () {}),
        ),
        const SizedBox(height: 12),
        StatsSection(
          title: 'Listening totals',
          icon: Icons.calendar_view_month_rounded,
          child: StatsActivityTotalsCard(activityAsync: activityLoading, onRefresh: () {}),
        ),
        const SizedBox(height: 12),
        StatsSection(
          title: 'Detailed analytics',
          icon: Icons.query_stats_rounded,
          child: StatsAdvancedDashboard(
            statsAsync: const AsyncLoading<AdvancedListeningStats>(),
            loadingProgress: advancedProgress,
            onRefresh: () {},
          ),
        ),
        const SizedBox(height: 12),
        StatsSection(
          title: 'Achievements',
          icon: Icons.emoji_events_outlined,
          child: StatsAchievementsSection(
            stats: previewUserListeningStats(),
            sessionAnalytics: analyticsLoading,
            onRetrySessionAnalytics: () {},
          ),
        ),
      ],
    );
  }
}

class StatisticsNoActivityPreview extends StatelessWidget {
  const StatisticsNoActivityPreview({super.key});

  @override
  Widget build(BuildContext context) {
    const emptyActivity = ListeningActivityStats.empty();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        StatsSection(
          title: 'Listening over time',
          icon: Icons.show_chart_rounded,
          child: StatsActivityRangeChart(activity: emptyActivity, referenceDate: previewReferenceDate, initialRange: 7),
        ),
        const SizedBox(height: 12),
        StatsSection(
          title: 'Listening by weekday',
          icon: Icons.view_week_rounded,
          child: StatsWeekdayBreakdown(dayOfWeek: null),
        ),
        const SizedBox(height: 12),
        StatsSection(
          title: 'Recent sessions',
          icon: Icons.history_rounded,
          child: StatsRecentSessionsList(sessions: const []),
        ),
        const SizedBox(height: 12),
        StatsSection(
          title: 'Most played',
          icon: Icons.leaderboard_rounded,
          child: StatsRankedList(entries: const [], emptyMessage: 'Listen to something to start a ranking.'),
        ),
      ],
    );
  }
}

class StatisticsMetricsPreview extends StatelessWidget {
  const StatisticsMetricsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: StatsSection(
        title: 'Your listening',
        subtitle: 'Summary for the current year',
        icon: Icons.headphones_rounded,
        child: const StatsMetricGrid(
          metrics: [
            StatsMetric(
              label: 'Listening time',
              value: '126 hr 40 min',
              icon: Icons.headphones_rounded,
              emphasized: true,
            ),
            StatsMetric(label: 'Books finished', value: '18', icon: Icons.menu_book_rounded),
            StatsMetric(label: 'Active days', value: '142', icon: Icons.today_rounded),
            StatsMetric(
              label: 'Longest streak',
              value: '12 days',
              icon: Icons.local_fire_department_rounded,
              supportingText: 'Best in April',
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsRangeChartPreview extends StatelessWidget {
  const StatisticsRangeChartPreview({super.key, required this.initialRange});

  final int initialRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: StatsSection(
        title: 'Listening over time',
        subtitle: 'Daily duration',
        icon: Icons.show_chart_rounded,
        child: StatsActivityRangeChart(
          activity: previewListeningActivity(),
          referenceDate: previewReferenceDate,
          initialRange: initialRange,
        ),
      ),
    );
  }
}

class StatisticsHeatmapPreview extends StatelessWidget {
  const StatisticsHeatmapPreview({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: StatsSection(
        title: days >= 365 ? 'Listening activity this year' : 'Recent listening activity',
        icon: Icons.calendar_month_rounded,
        child: StatsActivityHeatmap(
          activity: previewListeningActivity(),
          days: days,
          referenceDate: previewReferenceDate,
        ),
      ),
    );
  }
}

class StatisticsRankedPreview extends StatelessWidget {
  const StatisticsRankedPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: StatsSection(
        title: 'Most played',
        icon: Icons.leaderboard_rounded,
        child: StatsRankedList(
          showRanks: true,
          entries: [
            StatsRankedEntry(label: 'The Distant Shore', value: 72000, trailing: '20 hr'),
            StatsRankedEntry(label: 'Winter at Low Tide', value: 58900, trailing: '16 hr'),
            StatsRankedEntry(label: 'Field Notes', value: 42800, trailing: '11 hr'),
            StatsRankedEntry(label: 'The Atlas of Rain', value: 31100, trailing: '8 hr'),
            StatsRankedEntry(label: 'Last Light', value: 26500, trailing: '7 hr'),
            StatsRankedEntry(label: 'Northbound', value: 19200, trailing: '5 hr'),
          ],
        ),
      ),
    );
  }
}

class StatisticsEmptyPreview extends StatelessWidget {
  const StatisticsEmptyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: StatsSection(
        title: 'Listening history',
        icon: Icons.history_rounded,
        child: StatsRankedList(entries: [], emptyMessage: 'Your listening history will appear here.'),
      ),
    );
  }
}

class StatisticsMessagesPreview extends StatelessWidget {
  const StatisticsMessagesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          StatsMessage(
            title: 'No listening history yet',
            message: 'Listen to something and your activity will be shown here.',
            icon: Icons.headphones_outlined,
          ),
          Divider(),
          StatsMessage(
            title: 'Statistics unavailable',
            message: 'Try again in a moment.',
            icon: Icons.cloud_off_rounded,
            action: TextButton(onPressed: () {}, child: Text('Retry')),
          ),
        ],
      ),
    );
  }
}

class StatisticsAsyncErrorStatesPreview extends StatelessWidget {
  const StatisticsAsyncErrorStatesPreview({super.key, this.onRefresh});

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final refresh = onRefresh ?? () {};
    final error = AsyncError<ListeningActivityStats>(StateError('The sample service is offline'), StackTrace.current);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StatsSection(
          title: 'Listening activity',
          icon: Icons.show_chart_rounded,
          child: StatsActivitySection(activityAsync: error, onRefresh: refresh),
        ),
        const SizedBox(height: 16),
        StatsSection(
          title: 'Listening totals',
          icon: Icons.calendar_view_month_rounded,
          child: StatsActivityTotalsCard(activityAsync: error, onRefresh: refresh),
        ),
      ],
    );
  }
}

class StatisticsDashboardPreview extends StatelessWidget {
  const StatisticsDashboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final activity = previewListeningActivity();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const StatsSection(
          title: 'Your listening',
          subtitle: 'A sample from this year',
          icon: Icons.headphones_rounded,
          child: StatsMetricGrid(
            metrics: [
              StatsMetric(
                label: 'Listening time',
                value: '126 hr 40 min',
                icon: Icons.headphones_rounded,
                emphasized: true,
              ),
              StatsMetric(label: 'Books finished', value: '18', icon: Icons.menu_book_rounded),
              StatsMetric(label: 'Active days', value: '142', icon: Icons.today_rounded),
              StatsMetric(label: 'Longest streak', value: '12 days', icon: Icons.local_fire_department_rounded),
            ],
          ),
        ),
        const SizedBox(height: 16),
        StatsSection(
          title: 'Listening over time',
          subtitle: 'Daily listening duration',
          icon: Icons.show_chart_rounded,
          child: StatsActivityRangeChart(activity: activity, referenceDate: previewReferenceDate, initialRange: 30),
        ),
        const SizedBox(height: 16),
        StatsSection(
          title: 'Activity map',
          subtitle: 'Recent listening days',
          icon: Icons.calendar_month_rounded,
          child: StatsActivityHeatmap(activity: activity, days: 84, referenceDate: previewReferenceDate),
        ),
        const SizedBox(height: 16),
        const StatsSection(
          title: 'Most played',
          icon: Icons.leaderboard_rounded,
          child: StatsRankedList(
            showRanks: true,
            entries: [
              StatsRankedEntry(label: 'The Distant Shore', value: 72000, trailing: '20 hr'),
              StatsRankedEntry(label: 'Winter at Low Tide', value: 58900, trailing: '16 hr'),
              StatsRankedEntry(label: 'Field Notes', value: 42800, trailing: '11 hr'),
              StatsRankedEntry(label: 'The Atlas of Rain', value: 31100, trailing: '8 hr'),
              StatsRankedEntry(label: 'Last Light', value: 26500, trailing: '7 hr'),
              StatsRankedEntry(label: 'Northbound', value: 19200, trailing: '5 hr'),
            ],
          ),
        ),
      ],
    );
  }
}

class StatisticsAdvancedDashboardPreview extends StatelessWidget {
  const StatisticsAdvancedDashboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StatsSection(
          title: 'Detailed listening analytics',
          icon: Icons.query_stats_rounded,
          child: StatsAdvancedDashboard(
            statsAsync: AsyncData<AdvancedListeningStats>(previewAdvancedListeningStats()),
            onRefresh: () {},
          ),
        ),
      ],
    );
  }
}

class StatisticsAchievementsPreview extends StatelessWidget {
  const StatisticsAchievementsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StatsSection(
          title: 'Listening achievements',
          subtitle: 'Milestones from your listening history',
          icon: Icons.emoji_events_outlined,
          child: StatsAchievementsSection(
            stats: previewUserListeningStats(),
            sessionAnalytics: AdvancedListeningAnalyticsState(stats: previewAdvancedListeningStats()),
            onRetrySessionAnalytics: () {},
          ),
        ),
      ],
    );
  }
}

class StatisticsYearRewindPreview extends StatelessWidget {
  const StatisticsYearRewindPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StatsSection(
          title: 'Year in review',
          subtitle: 'A look back at your listening',
          icon: Icons.auto_awesome_rounded,
          child: StatsYearRewindSection(
            selectedYear: 2026,
            availableYears: const [2024, 2025, 2026],
            onYearSelected: (_) {},
            onRefresh: () {},
            statsAsync: AsyncData<YearInReviewStats?>(previewYearInReviewStats()),
          ),
        ),
      ],
    );
  }
}

class StatisticsActivityTotalsPreview extends StatelessWidget {
  const StatisticsActivityTotalsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StatsSection(
          title: 'Listening totals',
          subtitle: 'Recent activity at a glance',
          icon: Icons.calendar_view_month_rounded,
          child: StatsActivityTotalsCard(
            activityAsync: AsyncData(previewListeningActivity()),
            onRefresh: () {},
            referenceDate: previewReferenceDate,
          ),
        ),
      ],
    );
  }
}

class StatisticsSessionsAndWeekdaysPreview extends StatelessWidget {
  const StatisticsSessionsAndWeekdaysPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        StatsSection(
          title: 'Recent sessions',
          icon: Icons.history_rounded,
          child: StatsRecentSessionsList(sessions: previewPlaybackSessions(), maxItems: 3),
        ),
        const SizedBox(height: 16),
        StatsSection(
          title: 'Listening by weekday',
          icon: Icons.view_week_rounded,
          child: StatsWeekdayBreakdown(
            dayOfWeek: const DaysOfWeek(
              monday: 21600,
              tuesday: 14400,
              wednesday: 28800,
              thursday: 18000,
              friday: 32400,
              saturday: 39600,
              sunday: 46800,
            ),
          ),
        ),
        const SizedBox(height: 16),
        StatsSection(
          title: 'Listening summary',
          icon: Icons.insights_rounded,
          child: StatsSummaryGrid(stats: previewUserListeningStats(), referenceDate: previewReferenceDate),
        ),
      ],
    );
  }
}
