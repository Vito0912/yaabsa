import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/models/advanced_loading_progress_info.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/screens/main/stats/stats_ranked_bars.dart';

import 'package:yaabsa/generated/l10n.dart';

class StatsAdvancedDashboard extends StatelessWidget {
  const StatsAdvancedDashboard({super.key, required this.statsAsync, required this.onRefresh, this.loadingProgress});

  final AsyncValue<AdvancedListeningStats> statsAsync;
  final VoidCallback onRefresh;
  final AdvancedLoadingProgressInfo? loadingProgress;

  @override
  Widget build(BuildContext context) {
    return statsAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (stats) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardLoadedPages,
                  value: '${stats.loadedPages}',
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardLoadedSessions,
                  value: '${stats.totalSessions}',
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardTotalSessions,
                  value: '${stats.totalAvailableSessions}',
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardTotalListening,
                  value: formatListeningSeconds(stats.totalListeningTime),
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardBookListening,
                  value: formatListeningSeconds(stats.totalBookListeningTime),
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardPodcastListening,
                  value: formatListeningSeconds(stats.totalPodcastListeningTime),
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardAverageSession,
                  value: formatListeningSeconds(stats.averageSessionTime),
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardMedianSession,
                  value: formatListeningSeconds(stats.medianSessionTime),
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardLongestSession,
                  value: formatListeningSeconds(stats.longestSessionTime),
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardUniqueItems,
                  value: '${stats.uniqueItems}',
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardUniqueAuthors,
                  value: '${stats.uniqueAuthors}',
                ),
                _MetricChip(
                  label: S.current.screensMainStatsStatsAdvancedDashboardLongestStreak,
                  value: S.current.statsAdvancedLongestStreakDays(stats.longestStreakDays),
                ),
                if (stats.favoriteWeekday != null)
                  _MetricChip(
                    label: S.current.screensMainStatsStatsAdvancedDashboardFavoriteWeekday,
                    value: stats.favoriteWeekday!,
                  ),
                if (stats.favoriteHour != null)
                  _MetricChip(
                    label: S.current.screensMainStatsStatsAdvancedDashboardFavoriteHour,
                    value: DateFormat.jm(Intl.getCurrentLocale()).format(DateTime(2024, 1, 1, stats.favoriteHour!)),
                  ),
                if (stats.firstSessionAt != null)
                  _MetricChip(
                    label: S.current.screensMainStatsStatsAdvancedDashboardFirstSession,
                    value: formatDateTimeLabel(fromEpochMs(stats.firstSessionAt)),
                  ),
                if (stats.lastSessionAt != null)
                  _MetricChip(
                    label: S.current.screensMainStatsStatsAdvancedDashboardLastSession,
                    value: formatDateTimeLabel(fromEpochMs(stats.lastSessionAt)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _SubSection(
              title: S.current.screensMainStatsStatsAdvancedDashboardTopItems,
              child: StatsRankedBars(
                entries: [
                  for (final item in stats.topItems)
                    StatsRankedBarEntry(
                      label: '${item.title} • ${item.author}',
                      value: item.totalListeningTime,
                      trailing: formatListeningSeconds(item.totalListeningTime),
                    ),
                ],
                maxItems: 10,
                emptyMessage: S.current.screensMainStatsStatsAdvancedDashboardNoTopItemsAvailable,
              ),
            ),
            const SizedBox(height: 16),
            _SubSection(
              title: S.current.screensMainStatsStatsAdvancedDashboardTopAuthors,
              child: StatsRankedBars(
                entries: [
                  for (final author in stats.topAuthors)
                    StatsRankedBarEntry(
                      label: author.name,
                      value: author.totalListeningTime,
                      trailing: formatListeningSeconds(author.totalListeningTime),
                    ),
                ],
                maxItems: 10,
                emptyMessage: S.current.screensMainStatsStatsAdvancedDashboardNoTopAuthorsAvailable,
              ),
            ),
            const SizedBox(height: 16),
            _SubSection(
              title: S.current.screensMainStatsStatsAdvancedDashboardWeekdayBreakdown,
              child: StatsRankedBars(
                entries: [
                  for (final bucket in stats.weekdayBreakdown)
                    StatsRankedBarEntry(
                      label: bucket.label,
                      value: bucket.totalListeningTime,
                      trailing: formatListeningSeconds(bucket.totalListeningTime),
                    ),
                ],
                maxItems: 7,
                emptyMessage: S.current.screensMainStatsStatsAdvancedDashboardNoWeekdayDataAvailable,
              ),
            ),
            const SizedBox(height: 16),
            _SubSection(
              title: S.current.screensMainStatsStatsAdvancedDashboardBusiestHours,
              child: StatsRankedBars(
                entries: [
                  for (final bucket in stats.hourlyBreakdown)
                    StatsRankedBarEntry(
                      label: bucket.label,
                      value: bucket.totalListeningTime,
                      trailing: formatListeningSeconds(bucket.totalListeningTime),
                    ),
                ],
                maxItems: 8,
                emptyMessage: S.current.screensMainStatsStatsAdvancedDashboardNoHourlyDataAvailable,
              ),
            ),
            if (stats.monthlyBreakdown.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SubSection(
                title: S.current.screensMainStatsStatsAdvancedDashboardTopMonths,
                child: StatsRankedBars(
                  entries: [
                    for (final bucket in stats.monthlyBreakdown)
                      StatsRankedBarEntry(
                        label: bucket.label,
                        value: bucket.totalListeningTime,
                        trailing: formatListeningSeconds(bucket.totalListeningTime),
                      ),
                  ],
                  maxItems: 10,
                  emptyMessage: S.current.screensMainStatsStatsAdvancedDashboardNoMonthlyDataAvailable,
                ),
              ),
            ],
          ],
        );
      },
      loading: () {
        final progress = loadingProgress;
        if (progress == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final progressValue = progress.progress;
        final totalPagesLabel = progress.totalPages?.toString() ?? '?';
        final totalSessionsLabel = progress.totalSessions?.toString() ?? '?';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.screensMainStatsStatsAdvancedDashboardLoadingAdvancedAnalytics,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progressValue),
            const SizedBox(height: 8),
            Text(
              S.current.screensMainStatsStatsAdvancedDashboardPagesSessions(
                progress.loadedPages,
                totalPagesLabel,
                progress.loadedSessions,
                totalSessionsLabel,
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      },
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.screensMainStatsStatsAdvancedDashboardFailedToComputeAdvancedStats,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            error.toString(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(S.current.screensMainStatsStatsAdvancedDashboardRetryAdvancedMode),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _SubSection extends StatelessWidget {
  const _SubSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
