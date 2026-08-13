import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/stats/stats_components.dart';
import 'package:yaabsa/models/advanced_loading_progress_info.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/globals.dart';

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
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatsMetricGrid(
            minimumTileWidth: 154,
            metrics: [
              StatsMetric(
                icon: Icons.schedule_rounded,
                label: 'Total listening',
                value: formatListeningSeconds(stats.totalListeningTime),
                emphasized: true,
              ),
              StatsMetric(
                icon: Icons.history_rounded,
                label: 'Sessions',
                value: '${stats.totalSessions}',
                emphasized: true,
              ),
              StatsMetric(
                icon: Icons.timer_outlined,
                label: 'Average session',
                value: formatListeningSeconds(stats.averageSessionTime),
              ),
              StatsMetric(
                icon: Icons.align_horizontal_left_rounded,
                label: 'Median session',
                value: formatListeningSeconds(stats.medianSessionTime),
              ),
              StatsMetric(
                icon: Icons.hourglass_top_rounded,
                label: 'Longest session',
                value: formatListeningSeconds(stats.longestSessionTime),
              ),
              StatsMetric(
                icon: Icons.local_fire_department_rounded,
                label: 'Longest streak',
                value: '${stats.longestStreakDays} days',
              ),
              StatsMetric(
                icon: Icons.menu_book_rounded,
                label: 'Book listening',
                value: formatListeningSeconds(stats.totalBookListeningTime),
              ),
              StatsMetric(
                icon: Icons.podcasts_rounded,
                label: 'Podcast listening',
                value: formatListeningSeconds(stats.totalPodcastListeningTime),
              ),
              StatsMetric(icon: Icons.library_books_rounded, label: 'Unique items', value: '${stats.uniqueItems}'),
              StatsMetric(icon: Icons.people_alt_rounded, label: 'Unique authors', value: '${stats.uniqueAuthors}'),
              if (stats.favoriteWeekday != null)
                StatsMetric(icon: Icons.today_rounded, label: 'Favorite weekday', value: stats.favoriteWeekday!),
              if (stats.favoriteHour != null)
                StatsMetric(
                  icon: Icons.access_time_rounded,
                  label: 'Favorite hour',
                  value: '${stats.favoriteHour!.toString().padLeft(2, '0')}:00',
                ),
              if (stats.firstSessionAt != null)
                StatsMetric(
                  icon: Icons.first_page_rounded,
                  label: 'First session',
                  value: formatDateTimeLabel(fromEpochMs(stats.firstSessionAt)),
                ),
              if (stats.lastSessionAt != null)
                StatsMetric(
                  icon: Icons.last_page_rounded,
                  label: 'Latest session',
                  value: formatDateTimeLabel(fromEpochMs(stats.lastSessionAt)),
                ),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = context.isMobile || constraints.maxWidth < 760 ? 1 : 2;
              const spacing = 16.0;
              final width = (constraints.maxWidth - ((columns - 1) * spacing)) / columns;
              final panels = [
                _AdvancedRankPanel(
                  title: 'Top items',
                  icon: Icons.library_books_rounded,
                  entries: [
                    for (final item in stats.topItems)
                      StatsRankedEntry(
                        label: '${item.title} • ${item.author}',
                        value: item.totalListeningTime,
                        trailing: formatListeningSeconds(item.totalListeningTime),
                        onTap: item.id.isEmpty ? null : () => context.push('/item/${item.id}'),
                      ),
                  ],
                ),
                _AdvancedRankPanel(
                  title: 'Top authors',
                  icon: Icons.people_alt_rounded,
                  entries: [
                    for (final author in stats.topAuthors)
                      StatsRankedEntry(
                        label: author.name,
                        value: author.totalListeningTime,
                        trailing: formatListeningSeconds(author.totalListeningTime),
                        onTap: author.id == null || author.id!.isEmpty
                            ? null
                            : () => context.push('/author/${Uri.encodeComponent(author.id!)}'),
                      ),
                  ],
                ),
                _AdvancedRankPanel(
                  title: 'Weekday breakdown',
                  icon: Icons.view_week_rounded,
                  entries: [
                    for (final bucket in stats.weekdayBreakdown)
                      StatsRankedEntry(
                        label: bucket.label,
                        value: bucket.totalListeningTime,
                        trailing: formatListeningSeconds(bucket.totalListeningTime),
                      ),
                  ],
                  previewCount: 7,
                ),
                _AdvancedRankPanel(
                  title: 'Busiest hours',
                  icon: Icons.schedule_rounded,
                  entries: [
                    for (final bucket in stats.hourlyBreakdown)
                      StatsRankedEntry(
                        label: bucket.label,
                        value: bucket.totalListeningTime,
                        trailing: formatListeningSeconds(bucket.totalListeningTime),
                      ),
                  ],
                  previewCount: 8,
                ),
                if (stats.monthlyBreakdown.isNotEmpty)
                  _AdvancedRankPanel(
                    title: 'Top months',
                    icon: Icons.calendar_month_rounded,
                    entries: [
                      for (final bucket in stats.monthlyBreakdown)
                        StatsRankedEntry(
                          label: bucket.label,
                          value: bucket.totalListeningTime,
                          trailing: formatListeningSeconds(bucket.totalListeningTime),
                        ),
                    ],
                  ),
              ];

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [for (final panel in panels) SizedBox(width: width, child: panel)],
              );
            },
          ),
        ],
      ),
      loading: () => _AdvancedLoading(progress: loadingProgress),
      error: (error, _) => StatsMessage(
        icon: Icons.error_outline_rounded,
        title: 'Advanced analytics could not be calculated',
        message: error.toString(),
        action: OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Try again'),
        ),
      ),
    );
  }
}

class _AdvancedRankPanel extends StatelessWidget {
  const _AdvancedRankPanel({required this.title, required this.icon, required this.entries, this.previewCount = 5});

  final String title;
  final IconData icon;
  final List<StatsRankedEntry> entries;
  final int previewCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 10),
          StatsRankedList(entries: entries, previewCount: previewCount),
        ],
      ),
    );
  }
}

class _AdvancedLoading extends StatelessWidget {
  const _AdvancedLoading({required this.progress});

  final AdvancedLoadingProgressInfo? progress;

  @override
  Widget build(BuildContext context) {
    final value = progress?.progress;
    final pages = progress == null ? null : '${progress!.loadedPages}/${progress!.totalPages ?? '?'} pages';
    final sessions = progress == null ? null : '${progress!.loadedSessions}/${progress!.totalSessions ?? '?'} sessions';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          LinearProgressIndicator(value: value),
          const SizedBox(height: 12),
          Text(
            progress == null ? 'Loading advanced analytics…' : 'Loading advanced analytics • $pages • $sessions',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
