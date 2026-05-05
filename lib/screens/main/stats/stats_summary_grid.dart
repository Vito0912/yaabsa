import 'package:flutter/material.dart';
import 'package:yaabsa/api/library/stats/items_listened_to.dart';
import 'package:yaabsa/api/library/stats/user_listening_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class StatsSummaryGrid extends StatelessWidget {
  const StatsSummaryGrid({super.key, required this.stats});

  final UserListeningStats stats;

  @override
  Widget build(BuildContext context) {
    final items = stats.items?.values.toList(growable: false) ?? const <ItemsListenedTo>[];
    final totalTime = stats.totalTime ?? 0;

    var bookListening = 0.0;
    var podcastListening = 0.0;
    var activeDays = 0;

    for (final item in items) {
      final time = item.timeListening ?? 0;
      if (item.mediaMetadata?.podcastMetadata != null) {
        podcastListening += time;
      } else {
        bookListening += time;
      }
    }

    final dayEntries = stats.days?.entries;
    if (dayEntries != null) {
      for (final entry in dayEntries) {
        if (entry.value > 0) {
          activeDays += 1;
        }
      }
    }

    final averagePerActiveDay = activeDays > 0 ? totalTime / activeDays : 0.0;

    final metrics = <_SummaryMetric>[
      _SummaryMetric(label: 'Total', value: formatListeningSeconds(totalTime)),
      _SummaryMetric(label: 'Today', value: formatListeningSeconds(stats.today)),
      _SummaryMetric(label: 'Items', value: '${items.length}'),
      _SummaryMetric(label: 'Book', value: formatListeningSeconds(bookListening)),
      _SummaryMetric(label: 'Podcast', value: formatListeningSeconds(podcastListening)),
      _SummaryMetric(label: 'Active Days', value: '$activeDays'),
      _SummaryMetric(label: 'Avg Active Day', value: formatListeningSeconds(averagePerActiveDay)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1300
            ? 6
            : width >= 1050
            ? 5
            : width >= 820
            ? 4
            : width >= 620
            ? 3
            : 2;
        final compactTileWidth = ((width - ((columns - 1) * 8)) / columns).clamp(112.0, 220.0).toDouble();

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: compactTileWidth,
                child: _SummaryMetricTile(metric: metric),
              ),
          ],
        );
      },
    );
  }
}

class _SummaryMetric {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;
}

class _SummaryMetricTile extends StatelessWidget {
  const _SummaryMetricTile({required this.metric});

  final _SummaryMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              metric.label,
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(metric.value, style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
