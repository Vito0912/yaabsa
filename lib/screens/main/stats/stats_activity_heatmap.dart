import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/globals.dart';

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
    final days = math.max(widget.days, 1);
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(Duration(days: days - 1));
    final values = widget.activity.valuesForLastDays(days, reference: end);
    final maxValue = values.fold<double>(0, math.max);
    final palette = _palette(Theme.of(context).colorScheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.isMobile)
          _MobileMonthlyHeatmap(activity: widget.activity, start: start, end: end, maxValue: maxValue, palette: palette)
        else
          _DesktopHeatmap(
            activity: widget.activity,
            start: start,
            end: end,
            maxValue: maxValue,
            palette: palette,
            scrollController: _horizontalScrollController,
          ),
        const SizedBox(height: 12),
        _HeatmapLegend(palette: palette),
      ],
    );
  }
}

class _MobileMonthlyHeatmap extends StatelessWidget {
  const _MobileMonthlyHeatmap({
    required this.activity,
    required this.start,
    required this.end,
    required this.maxValue,
    required this.palette,
  });

  final ListeningActivityStats activity;
  final DateTime start;
  final DateTime end;
  final double maxValue;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    final months = <DateTime>[];
    var month = DateTime(start.year, start.month);
    final lastMonth = DateTime(end.year, end.month);
    while (!month.isAfter(lastMonth)) {
      months.add(month);
      month = DateTime(month.year, month.month + 1);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 2 : 1;
        const spacing = 12.0;
        final width = (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final value in months)
              SizedBox(
                width: width,
                child: _MonthHeatmap(
                  month: value,
                  activity: activity,
                  start: start,
                  end: end,
                  maxValue: maxValue,
                  palette: palette,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MonthHeatmap extends StatelessWidget {
  const _MonthHeatmap({
    required this.month,
    required this.activity,
    required this.start,
    required this.end,
    required this.maxValue,
    required this.palette,
  });

  final DateTime month;
  final ListeningActivityStats activity;
  final DateTime start;
  final DateTime end;
  final double maxValue;
  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    final firstDayOffset = DateTime(month.year, month.month).weekday - 1;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final cells = firstDayOffset + daysInMonth;
    final rowCount = (cells / 7).ceil();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_monthLabel(month), style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final label in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
                Expanded(
                  child: Text(label, textAlign: TextAlign.center, style: theme.textTheme.labelSmall),
                ),
            ],
          ),
          const SizedBox(height: 5),
          for (var row = 0; row < rowCount; row++) ...[
            Row(
              children: [
                for (var weekday = 0; weekday < 7; weekday++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: AspectRatio(
                        aspectRatio: 1.7,
                        child: _monthCell(firstDayOffset, row, weekday, daysInMonth),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _monthCell(int firstDayOffset, int row, int weekday, int daysInMonth) {
    final dayNumber = (row * 7) + weekday - firstDayOffset + 1;
    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return const SizedBox.shrink();
    }

    final day = DateTime(month.year, month.month, dayNumber);
    if (day.isBefore(start) || day.isAfter(end)) {
      return const SizedBox.shrink();
    }

    final value = activity.dailyListeningSeconds[dayKeyFromDate(day)] ?? 0;
    return _HeatmapCell(day: day, value: value, color: palette[_levelFor(value, maxValue)]);
  }
}

class _DesktopHeatmap extends StatelessWidget {
  const _DesktopHeatmap({
    required this.activity,
    required this.start,
    required this.end,
    required this.maxValue,
    required this.palette,
    required this.scrollController,
  });

  final ListeningActivityStats activity;
  final DateTime start;
  final DateTime end;
  final double maxValue;
  final List<Color> palette;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final firstWeekStart = start.subtract(Duration(days: start.weekday - 1));
    final weeks = <List<DateTime?>>[];
    var cursor = firstWeekStart;
    while (!cursor.isAfter(end)) {
      weeks.add([
        for (var weekday = 0; weekday < 7; weekday++)
          switch (cursor.add(Duration(days: weekday))) {
            final day when !day.isBefore(start) && !day.isAfter(end) => day,
            _ => null,
          },
      ]);
      cursor = cursor.add(const Duration(days: 7));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const labelWidth = 34.0;
        const gap = 10.0;
        const spacing = 3.0;
        final gridViewport = math.max(0.0, constraints.maxWidth - labelWidth - gap);
        final idealCell = (gridViewport - ((weeks.length - 1) * spacing)) / weeks.length;
        final cellSize = idealCell.clamp(11.0, 15.0).toDouble();
        final gridWidth = (weeks.length * cellSize) + ((weeks.length - 1) * spacing);
        final needsScroll = gridWidth > gridViewport + 0.5;

        final grid = SizedBox(
          width: gridWidth,
          child: Row(
            children: [
              for (var weekIndex = 0; weekIndex < weeks.length; weekIndex++) ...[
                Column(
                  children: [
                    for (var weekday = 0; weekday < 7; weekday++) ...[
                      SizedBox(
                        width: cellSize,
                        height: cellSize,
                        child: switch (weeks[weekIndex][weekday]) {
                          final day? => _HeatmapCell(
                            day: day,
                            value: activity.dailyListeningSeconds[dayKeyFromDate(day)] ?? 0,
                            color:
                                palette[_levelFor(activity.dailyListeningSeconds[dayKeyFromDate(day)] ?? 0, maxValue)],
                          ),
                          null => const SizedBox.shrink(),
                        },
                      ),
                      if (weekday != 6) const SizedBox(height: spacing),
                    ],
                  ],
                ),
                if (weekIndex != weeks.length - 1) const SizedBox(width: spacing),
              ],
            ],
          ),
        );

        final scrollView = SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: grid,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: labelWidth,
              child: Column(
                children: [
                  for (var weekday = 0; weekday < 7; weekday++) ...[
                    SizedBox(
                      height: cellSize,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(switch (weekday) {
                          0 => 'Mon',
                          2 => 'Wed',
                          4 => 'Fri',
                          6 => 'Sun',
                          _ => '',
                        }, style: Theme.of(context).textTheme.labelSmall),
                      ),
                    ),
                    if (weekday != 6) const SizedBox(height: spacing),
                  ],
                ],
              ),
            ),
            const SizedBox(width: gap),
            Expanded(
              child: needsScroll
                  ? Scrollbar(controller: scrollController, thumbVisibility: true, child: scrollView)
                  : Align(alignment: Alignment.centerRight, child: scrollView),
            ),
          ],
        );
      },
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({required this.day, required this.value, required this.color});

  final DateTime day;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${_fullDate(day)} • ${formatListeningSeconds(value)}',
      excludeFromSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
      ),
    );
  }
}

class _HeatmapLegend extends StatelessWidget {
  const _HeatmapLegend({required this.palette});

  final List<Color> palette;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Less', style: Theme.of(context).textTheme.labelSmall),
        for (final color in palette)
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
        Text('More', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

List<Color> _palette(ColorScheme colors) => [
  colors.surfaceContainerHighest,
  colors.primary.withValues(alpha: 0.24),
  colors.primary.withValues(alpha: 0.42),
  colors.primary.withValues(alpha: 0.64),
  colors.primary.withValues(alpha: 0.9),
];

int _levelFor(double value, double maxValue) {
  if (value <= 0 || maxValue <= 0) return 0;
  final ratio = value / maxValue;
  if (ratio < 0.25) return 1;
  if (ratio < 0.5) return 2;
  if (ratio < 0.75) return 3;
  return 4;
}

String _monthLabel(DateTime month) => const [
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
][month.month - 1];

String _fullDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
