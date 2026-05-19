import 'package:flutter/material.dart';
import 'package:yaabsa/api/library/stats/days_of_week.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

import 'package:yaabsa/generated/l10n.dart';

class StatsWeekdayBreakdown extends StatelessWidget {
  const StatsWeekdayBreakdown({super.key, required this.dayOfWeek});

  final DaysOfWeek? dayOfWeek;

  @override
  Widget build(BuildContext context) {
    final entries = <_WeekdayEntry>[
      _WeekdayEntry(label: 'Monday', shortLabel: 'Mon', value: dayOfWeek?.monday ?? 0),
      _WeekdayEntry(label: 'Tuesday', shortLabel: 'Tue', value: dayOfWeek?.tuesday ?? 0),
      _WeekdayEntry(label: 'Wednesday', shortLabel: 'Wed', value: dayOfWeek?.wednesday ?? 0),
      _WeekdayEntry(label: 'Thursday', shortLabel: 'Thu', value: dayOfWeek?.thursday ?? 0),
      _WeekdayEntry(label: 'Friday', shortLabel: 'Fri', value: dayOfWeek?.friday ?? 0),
      _WeekdayEntry(label: 'Saturday', shortLabel: 'Sat', value: dayOfWeek?.saturday ?? 0),
      _WeekdayEntry(label: 'Sunday', shortLabel: 'Sun', value: dayOfWeek?.sunday ?? 0),
    ];

    final maxValue = entries.fold<double>(0, (max, current) => current.value > max ? current.value : max);

    if (maxValue <= 0) {
      return Text(
        S.current.screensMainStatsStatsWeekdayBreakdownNoWeekdayListeningDataAvailable,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final theme = Theme.of(context);
    final maxBarHeight = MediaQuery.sizeOf(context).width < 500 ? 88.0 : 112.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatListeningSeconds(entries[i].value),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Tooltip(
                  message: '${entries[i].label}: ${formatListeningSeconds(entries[i].value)}',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    height: ((entries[i].value / maxValue).clamp(0, 1) * maxBarHeight).toDouble(),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(entries[i].shortLabel, style: theme.textTheme.labelMedium),
              ],
            ),
          ),
          if (i != entries.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _WeekdayEntry {
  const _WeekdayEntry({required this.label, required this.shortLabel, required this.value});

  final String label;
  final String shortLabel;
  final double value;
}
