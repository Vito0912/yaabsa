import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

import 'package:yaabsa/generated/l10n.dart';

class StatsActivityHeatmap extends StatefulWidget {
  const StatsActivityHeatmap({super.key, required this.activity, this.days = 365});

  final ListeningActivityStats activity;
  final int days;

  @override
  State<StatsActivityHeatmap> createState() => _StatsActivityHeatmapState();
}

class _StatsActivityHeatmapState extends State<StatsActivityHeatmap> {
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedDays = widget.days < 1 ? 1 : widget.days;
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(Duration(days: normalizedDays - 1));
    final firstColumnStart = start.subtract(Duration(days: start.weekday % 7));

    final weeks = <List<DateTime?>>[];
    var cursor = firstColumnStart;
    while (!cursor.isAfter(end)) {
      weeks.add(
        List<DateTime?>.generate(7, (index) {
          final day = cursor.add(Duration(days: index));
          if (day.isBefore(start) || day.isAfter(end)) {
            return null;
          }
          return day;
        }, growable: false),
      );
      cursor = cursor.add(const Duration(days: 7));
    }

    final values = widget.activity.valuesForLastDays(normalizedDays);
    final maxValue = values.fold<double>(0, (maxValue, value) => math.max(maxValue, value));
    final palette = _palette(Theme.of(context).colorScheme);
    final weekdayFormat = DateFormat.E(Localizations.localeOf(context).toString());
    final weekdayLabels = <String?>[
      weekdayFormat.format(DateTime.utc(2024, 1, 1)),
      null,
      weekdayFormat.format(DateTime.utc(2024, 1, 3)),
      null,
      weekdayFormat.format(DateTime.utc(2024, 1, 5)),
      null,
      weekdayFormat.format(DateTime.utc(2024, 1, 7)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final weekCount = weeks.length;
            const weekSpacing = 2.0;
            const minCellSize = 12.0;
            const maxCellSize = 14.0;
            const dayLabelWidth = 32.0;
            const labelGap = 12.0;

            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final gridVisibleWidth = math.max(0.0, availableWidth - dayLabelWidth - labelGap);

            final desiredCellSize = weekCount > 0
                ? (gridVisibleWidth - ((weekCount - 1) * weekSpacing)) / weekCount
                : minCellSize;
            final cellSize = desiredCellSize.clamp(minCellSize, maxCellSize).toDouble();

            final fullGridWidth = weekCount > 0 ? (weekCount * cellSize) + ((weekCount - 1) * weekSpacing) : 0.0;
            final needsHorizontalScroll = fullGridWidth > gridVisibleWidth + 0.5;

            final heatmapGrid = SizedBox(
              width: fullGridWidth,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var weekIndex = 0; weekIndex < weeks.length; weekIndex++) ...[
                    Column(
                      children: [
                        for (var dayIndex = 0; dayIndex < weeks[weekIndex].length; dayIndex++)
                          Padding(
                            padding: EdgeInsets.only(bottom: dayIndex == weeks[weekIndex].length - 1 ? 0 : 2),
                            child: _HeatmapCell(
                              size: cellSize,
                              value: weeks[weekIndex][dayIndex] == null
                                  ? null
                                  : widget.activity.dailyListeningSeconds[dayKeyFromDate(
                                          weeks[weekIndex][dayIndex]!,
                                        )] ??
                                        0,
                              day: weeks[weekIndex][dayIndex],
                              color: weeks[weekIndex][dayIndex] == null
                                  ? Theme.of(context).colorScheme.surface.withValues(alpha: 0)
                                  : palette[_levelFor(
                                      widget.activity.dailyListeningSeconds[dayKeyFromDate(
                                            weeks[weekIndex][dayIndex]!,
                                          )] ??
                                          0,
                                      maxValue,
                                    )],
                            ),
                          ),
                      ],
                    ),
                    if (weekIndex != weeks.length - 1) const SizedBox(width: weekSpacing),
                  ],
                ],
              ),
            );

            final scrollableGrid = SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: heatmapGrid,
            );

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: dayLabelWidth,
                  child: Column(
                    children: [
                      for (var i = 0; i < weekdayLabels.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: i == weekdayLabels.length - 1 ? 0 : 2),
                          child: SizedBox(
                            height: cellSize,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                weekdayLabels[i] ?? '',
                                style: Theme.of(context).textTheme.labelSmall,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: labelGap),
                needsHorizontalScroll
                    ? SizedBox(
                        width: gridVisibleWidth,
                        child: Scrollbar(
                          controller: _horizontalScrollController,
                          thumbVisibility: true,
                          child: scrollableGrid,
                        ),
                      )
                    : scrollableGrid,
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final legendCellSize = (availableWidth / 55).clamp(4.0, 11.0).toDouble();

            return Center(
              child: Wrap(
                spacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    S.current.screensMainStatsStatsActivityHeatmapLess,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  for (final color in palette)
                    DecoratedBox(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: color),
                      child: SizedBox(width: legendCellSize, height: legendCellSize),
                    ),
                  Text(
                    S.current.screensMainStatsStatsActivityHeatmapMore,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  List<Color> _palette(ColorScheme colorScheme) {
    final base = colorScheme.primary;
    return <Color>[
      colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      base.withValues(alpha: 0.24),
      base.withValues(alpha: 0.42),
      base.withValues(alpha: 0.62),
      base.withValues(alpha: 0.88),
    ];
  }

  int _levelFor(double value, double maxValue) {
    if (value <= 0 || maxValue <= 0) {
      return 0;
    }

    final ratio = value / maxValue;
    if (ratio < 0.25) {
      return 1;
    }
    if (ratio < 0.5) {
      return 2;
    }
    if (ratio < 0.75) {
      return 3;
    }
    return 4;
  }
}

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({required this.size, required this.day, required this.value, required this.color});

  final double size;
  final DateTime? day;
  final double? value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: color),
      child: SizedBox(width: size, height: size),
    );

    if (day == null) {
      return child;
    }

    final tooltip = '${formatDateLabel(day)} • ${formatListeningSeconds(value)}';

    return Tooltip(message: tooltip, child: child);
  }
}
