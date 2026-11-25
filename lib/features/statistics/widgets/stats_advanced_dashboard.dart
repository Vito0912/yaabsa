import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/models/advanced_loading_progress_info.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/features/statistics/widgets/stats_ranked_panel.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

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
                label: context.l10n.fieldTotalListening,
                value: formatListeningSeconds(stats.totalListeningTime),
                emphasized: true,
              ),
              StatsMetric(
                icon: Icons.history_rounded,
                label: context.l10n.fieldSessions,
                value: context.l10n.sessionCount(stats.totalSessions),
                emphasized: true,
              ),
              StatsMetric(
                icon: Icons.timer_outlined,
                label: context.l10n.fieldAverageSession,
                value: formatListeningSeconds(stats.averageSessionTime),
              ),
              StatsMetric(
                icon: Icons.align_horizontal_left_rounded,
                label: context.l10n.fieldMedianSession,
                value: formatListeningSeconds(stats.medianSessionTime),
              ),
              StatsMetric(
                icon: Icons.hourglass_top_rounded,
                label: context.l10n.fieldLongestSession,
                value: formatListeningSeconds(stats.longestSessionTime),
              ),
              StatsMetric(
                icon: Icons.local_fire_department_rounded,
                label: context.l10n.fieldLongestStreak,
                value: context.l10n.dayCount(stats.longestStreakDays),
              ),
              StatsMetric(
                icon: Icons.menu_book_rounded,
                label: context.l10n.fieldBookListening,
                value: formatListeningSeconds(stats.totalBookListeningTime),
              ),
              StatsMetric(
                icon: Icons.podcasts_rounded,
                label: context.l10n.fieldPodcastListening,
                value: formatListeningSeconds(stats.totalPodcastListeningTime),
              ),
              StatsMetric(
                icon: Icons.library_books_rounded,
                label: context.l10n.fieldUniqueItems,
                value: context.l10n.itemCount(stats.uniqueItems),
              ),
              StatsMetric(
                icon: Icons.people_alt_rounded,
                label: context.l10n.fieldUniqueAuthors,
                value: context.l10n.authorCount(stats.uniqueAuthors),
              ),
              if (stats.favoriteWeekday != null)
                StatsMetric(
                  icon: Icons.today_rounded,
                  label: context.l10n.fieldFavoriteWeekday,
                  value: formatWeekdayName(stats.favoriteWeekday!),
                ),
              if (stats.favoriteHour != null)
                StatsMetric(
                  icon: Icons.access_time_rounded,
                  label: context.l10n.fieldFavoriteHour,
                  value: formatHourBucket('${stats.favoriteHour!.toString().padLeft(2, '0')}:00'),
                ),
              if (stats.firstSessionAt != null)
                StatsMetric(
                  icon: Icons.first_page_rounded,
                  label: context.l10n.fieldFirstSession,
                  value: formatDateTimeLabel(fromEpochMs(stats.firstSessionAt)),
                ),
              if (stats.lastSessionAt != null)
                StatsMetric(
                  icon: Icons.last_page_rounded,
                  label: context.l10n.fieldLatestSession,
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
                StatsRankedPanel(
                  title: context.l10n.headingTopItems,
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
                StatsRankedPanel(
                  title: context.l10n.headingTopAuthors,
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
                StatsRankedPanel(
                  title: context.l10n.headingWeekdayBreakdown,
                  icon: Icons.view_week_rounded,
                  entries: [
                    for (final bucket in stats.weekdayBreakdown)
                      StatsRankedEntry(
                        label: formatWeekdayName(bucket.label),
                        value: bucket.totalListeningTime,
                        trailing: formatListeningSeconds(bucket.totalListeningTime),
                      ),
                  ],
                  previewCount: 7,
                ),
                StatsRankedPanel(
                  title: context.l10n.headingBusiestHours,
                  icon: Icons.schedule_rounded,
                  entries: [
                    for (final bucket in stats.hourlyBreakdown)
                      StatsRankedEntry(
                        label: formatHourBucket(bucket.label),
                        value: bucket.totalListeningTime,
                        trailing: formatListeningSeconds(bucket.totalListeningTime),
                      ),
                  ],
                  previewCount: 8,
                ),
                if (stats.monthlyBreakdown.isNotEmpty)
                  StatsRankedPanel(
                    title: context.l10n.headingTopMonths,
                    icon: Icons.calendar_month_rounded,
                    entries: [
                      for (final bucket in stats.monthlyBreakdown)
                        StatsRankedEntry(
                          label: formatMonthBucket(bucket.label),
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
        title: context.l10n.statsAdvancedUnavailable,
        message: error.toString(),
        action: OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(context.l10n.actionRetry),
        ),
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
    final pages = progress == null
        ? null
        : context.l10n.progressCountLoaded(
            formatNumber(progress!.loadedPages),
            progress!.totalPages == null ? '?' : formatNumber(progress!.totalPages!),
            context.l10n.fieldPages,
          );
    final sessions = progress == null
        ? null
        : context.l10n.progressCountLoaded(
            formatNumber(progress!.loadedSessions),
            progress!.totalSessions == null ? '?' : formatNumber(progress!.totalSessions!),
            context.l10n.fieldSessions,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          YaabsaLinearProgressIndicator(value: value),
          const SizedBox(height: 12),
          Text(
            progress == null
                ? context.l10n.statsLoadingAnalytics
                : context.l10n.statsLoadingAnalyticsProgress(pages!, sessions!),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
