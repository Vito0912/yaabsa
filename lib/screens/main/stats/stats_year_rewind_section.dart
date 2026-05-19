import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/stats/year_in_review_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/screens/main/stats/stats_ranked_bars.dart';

import 'package:yaabsa/generated/l10n.dart';

class StatsYearRewindSection extends StatelessWidget {
  const StatsYearRewindSection({
    super.key,
    required this.selectedYear,
    required this.availableYears,
    required this.onYearSelected,
    required this.onRefresh,
    required this.statsAsync,
  });

  final int selectedYear;
  final List<int> availableYears;
  final ValueChanged<int> onYearSelected;
  final VoidCallback onRefresh;
  final AsyncValue<YearInReviewStats?> statsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: availableYears.contains(selectedYear) ? selectedYear : availableYears.first,
                decoration: InputDecoration(
                  labelText: S.current.screensMainStatsStatsYearRewindSectionYear,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  for (final year in availableYears) DropdownMenuItem<int>(value: year, child: Text(year.toString())),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onYearSelected(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              tooltip: S.current.screensMainStatsStatsYearRewindSectionRefresh,
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        const SizedBox(height: 14),
        statsAsync.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (stats) {
            if (stats == null) {
              return Text(S.current.screensMainStatsStatsYearRewindSectionNoYearInReviewDataAvailable);
            }

            final totalSessions = stats.totalListeningSessions ?? stats.numListeningSessions ?? 0;
            final totalTime = stats.totalListeningTime ?? 0;
            final booksFinished = stats.numBooksFinished ?? 0;
            final booksListened = stats.numBooksListened ?? 0;
            final mostListenedMonth = _monthName(stats.mostListenedMonth?.month);
            final peakMonthListening = formatListeningSeconds(stats.mostListenedMonth?.time);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _YearSpotlightCard(
                  year: selectedYear,
                  totalTime: formatListeningSeconds(totalTime),
                  sessions: '$totalSessions sessions',
                  peakMonth: mostListenedMonth == null ? null : '$mostListenedMonth • $peakMonthListening',
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _YearMetricChip(icon: Icons.headset_rounded, label: 'Sessions', value: '$totalSessions'),
                    _YearMetricChip(
                      icon: Icons.schedule_rounded,
                      label: 'Listening',
                      value: formatListeningSeconds(totalTime),
                    ),
                    _YearMetricChip(icon: Icons.task_alt_rounded, label: 'Books Finished', value: '$booksFinished'),
                    _YearMetricChip(icon: Icons.menu_book_rounded, label: 'Books Listened', value: '$booksListened'),
                    if (mostListenedMonth != null)
                      _YearMetricChip(
                        icon: Icons.calendar_month_rounded,
                        label: 'Peak Month',
                        value: '$mostListenedMonth ($peakMonthListening)',
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _YearRankSectionCard(
                  title: 'Top Authors',
                  icon: Icons.person_outline_rounded,
                  child: StatsRankedBars(
                    entries: [
                      for (final author in stats.topAuthors)
                        StatsRankedBarEntry(
                          label: author.name ?? 'Unknown Author',
                          value: (author.time ?? 0).toDouble(),
                          trailing: formatListeningSeconds(author.time),
                        ),
                    ],
                    maxItems: 5,
                    emptyMessage: 'No top authors for this year.',
                  ),
                ),
                const SizedBox(height: 16),
                _YearRankSectionCard(
                  title: 'Top Genres',
                  icon: Icons.local_offer_outlined,
                  child: StatsRankedBars(
                    entries: [
                      for (final genre in stats.topGenres)
                        StatsRankedBarEntry(
                          label: genre.genre ?? 'Unknown Genre',
                          value: (genre.time ?? 0).toDouble(),
                          trailing: formatListeningSeconds(genre.time),
                        ),
                    ],
                    maxItems: 5,
                    emptyMessage: 'No top genres for this year.',
                  ),
                ),
                if (stats.topNarrators.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _YearRankSectionCard(
                    title: 'Top Narrators',
                    icon: Icons.record_voice_over_rounded,
                    child: StatsRankedBars(
                      entries: [
                        for (final narrator in stats.topNarrators)
                          StatsRankedBarEntry(
                            label: narrator.name ?? 'Unknown Narrator',
                            value: (narrator.time ?? 0).toDouble(),
                            trailing: formatListeningSeconds(narrator.time),
                          ),
                      ],
                      maxItems: 5,
                      emptyMessage: 'No top narrators for this year.',
                    ),
                  ),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _YearErrorView(error: error, onRefresh: onRefresh),
        ),
      ],
    );
  }

  String? _monthName(int? month) {
    if (month == null || month < 1 || month > 12) {
      return null;
    }

    const names = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return names[month - 1];
  }
}

class _YearMetricChip extends StatelessWidget {
  const _YearMetricChip({required this.icon, required this.label, required this.value});

  final IconData icon;

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainer,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(label, style: theme.textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}

class _YearSpotlightCard extends StatelessWidget {
  const _YearSpotlightCard({
    required this.year,
    required this.totalTime,
    required this.sessions,
    required this.peakMonth,
  });

  final int year;
  final String totalTime;
  final String sessions;
  final String? peakMonth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.current.screensMainStatsStatsYearRewindSectionInRewind(year), style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(totalTime, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(sessions, style: theme.textTheme.bodyMedium),
            if (peakMonth != null) ...[
              const SizedBox(height: 6),
              Text(
                S.current.screensMainStatsStatsYearRewindSectionPeakMonth(peakMonth!),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _YearRankSectionCard extends StatelessWidget {
  const _YearRankSectionCard({required this.title, required this.icon, required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _YearErrorView extends StatelessWidget {
  const _YearErrorView({required this.error, required this.onRefresh});

  final Object error;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.screensMainStatsStatsYearRewindSectionFailedToLoadYearInReview,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        Text(
          error.toString(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(S.current.screensMainStatsStatsYearRewindSectionRetry),
        ),
      ],
    );
  }
}
