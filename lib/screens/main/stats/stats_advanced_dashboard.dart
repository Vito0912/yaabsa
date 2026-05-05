import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/models/advanced_loading_progress_info.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/screens/main/stats/stats_ranked_bars.dart';

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
                _MetricChip(label: 'Loaded Pages', value: '${stats.loadedPages}'),
                _MetricChip(label: 'Loaded Sessions', value: '${stats.totalSessions}'),
                _MetricChip(label: 'Total Sessions', value: '${stats.totalAvailableSessions}'),
                _MetricChip(label: 'Total Listening', value: formatListeningSeconds(stats.totalListeningTime)),
                _MetricChip(label: 'Book Listening', value: formatListeningSeconds(stats.totalBookListeningTime)),
                _MetricChip(label: 'Podcast Listening', value: formatListeningSeconds(stats.totalPodcastListeningTime)),
                _MetricChip(label: 'Average Session', value: formatListeningSeconds(stats.averageSessionTime)),
                _MetricChip(label: 'Median Session', value: formatListeningSeconds(stats.medianSessionTime)),
                _MetricChip(label: 'Longest Session', value: formatListeningSeconds(stats.longestSessionTime)),
                _MetricChip(label: 'Unique Items', value: '${stats.uniqueItems}'),
                _MetricChip(label: 'Unique Authors', value: '${stats.uniqueAuthors}'),
                _MetricChip(label: 'Longest Streak', value: '${stats.longestStreakDays} day(s)'),
                if (stats.favoriteWeekday != null)
                  _MetricChip(label: 'Favorite Weekday', value: stats.favoriteWeekday!),
                if (stats.favoriteHour != null)
                  _MetricChip(label: 'Favorite Hour', value: '${stats.favoriteHour!.toString().padLeft(2, '0')}:00'),
                if (stats.firstSessionAt != null)
                  _MetricChip(label: 'First Session', value: formatDateTimeLabel(fromEpochMs(stats.firstSessionAt))),
                if (stats.lastSessionAt != null)
                  _MetricChip(label: 'Last Session', value: formatDateTimeLabel(fromEpochMs(stats.lastSessionAt))),
              ],
            ),
            const SizedBox(height: 16),
            _SubSection(
              title: 'Top Items',
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
                emptyMessage: 'No top items available.',
              ),
            ),
            const SizedBox(height: 16),
            _SubSection(
              title: 'Top Authors',
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
                emptyMessage: 'No top authors available.',
              ),
            ),
            const SizedBox(height: 16),
            _SubSection(
              title: 'Weekday Breakdown',
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
                emptyMessage: 'No weekday data available.',
              ),
            ),
            const SizedBox(height: 16),
            _SubSection(
              title: 'Busiest Hours',
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
                emptyMessage: 'No hourly data available.',
              ),
            ),
            if (stats.monthlyBreakdown.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SubSection(
                title: 'Top Months',
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
                  emptyMessage: 'No monthly data available.',
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
            Text('Loading advanced analytics...', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progressValue),
            const SizedBox(height: 8),
            Text(
              'Pages ${progress.loadedPages}/$totalPagesLabel • Sessions ${progress.loadedSessions}/$totalSessionsLabel',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      },
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Failed to compute advanced stats.', style: Theme.of(context).textTheme.bodyMedium),
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
            label: const Text('Retry Advanced Mode'),
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
