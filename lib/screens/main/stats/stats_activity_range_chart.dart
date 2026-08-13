import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class StatsActivityRangeChart extends StatefulWidget {
  const StatsActivityRangeChart({super.key, required this.activity});

  final ListeningActivityStats activity;

  @override
  State<StatsActivityRangeChart> createState() => _StatsActivityRangeChartState();
}

class _StatsActivityRangeChartState extends State<StatsActivityRangeChart> {
  int _selectedRange = 30;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(Duration(days: _selectedRange - 1));
    final values = widget.activity.valuesForLastDays(_selectedRange, reference: end);
    final total = values.fold<double>(0, (sum, value) => sum + value);
    final average = values.isEmpty ? 0.0 : total / values.length;
    final peak = values.fold<double>(0, math.max);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatListeningSeconds(total),
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Total over the last $_selectedRange days',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 7, label: Text('7d')),
                ButtonSegment(value: 30, label: Text('30d')),
                ButtonSegment(value: 365, label: Text('1y')),
              ],
              selected: <int>{_selectedRange},
              showSelectedIcon: false,
              onSelectionChanged: (selection) {
                setState(() => _selectedRange = selection.first);
              },
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 18, 12, 8),
          decoration: BoxDecoration(color: theme.colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(20)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final preferredWidth = _selectedRange == 7 ? 620.0 : 840.0;
              final chartWidth = math.min(constraints.maxWidth, preferredWidth);

              return Center(
                child: SizedBox(
                  width: chartWidth,
                  height: 220,
                  child: _selectedRange == 7
                      ? _SevenDayBarChart(values: values, start: start, peak: peak)
                      : _ListeningLineChart(values: values, start: start, peak: peak),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 18,
          runSpacing: 6,
          children: [
            _ChartCaption(label: 'Daily average', value: formatListeningSeconds(average)),
            _ChartCaption(label: 'Peak day', value: formatListeningSeconds(peak)),
            _ChartCaption(label: 'Range', value: '${_shortDate(start)} – ${_shortDate(end)}'),
          ],
        ),
      ],
    );
  }
}

class _SevenDayBarChart extends StatelessWidget {
  const _SevenDayBarChart({required this.values, required this.start, required this.peak});

  final List<double> values;
  final DateTime start;
  final double peak;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final chartPeak = math.max(peak * 1.14, 1.0).toDouble();

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: chartPeak,
        alignment: BarChartAlignment.spaceAround,
        groupsSpace: 10,
        barGroups: [
          for (var index = 0; index < values.length; index++)
            BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],
                  width: 22,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  color: colors.primary,
                ),
              ],
            ),
        ],
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: _axisInterval(chartPeak),
          getDrawingHorizontalLine: (_) => FlLine(color: colors.outlineVariant.withValues(alpha: 0.45), strokeWidth: 1),
        ),
        titlesData: _chartTitles(
          context,
          start: start,
          pointCount: values.length,
          bottomInterval: 1,
          showWeekday: true,
          peak: chartPeak,
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (_) => colors.surfaceContainerHighest,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = start.add(Duration(days: group.x));
              return BarTooltipItem(
                '${_fullDate(date)}\n${formatListeningSeconds(rod.toY)}',
                Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
              );
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 280),
    );
  }
}

class _ListeningLineChart extends StatelessWidget {
  const _ListeningLineChart({required this.values, required this.start, required this.peak});

  final List<double> values;
  final DateTime start;
  final double peak;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final chartPeak = math.max(peak * 1.14, 1.0).toDouble();
    final labelInterval = values.length <= 30 ? 7.0 : 60.0;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: math.max(0, values.length - 1).toDouble(),
        minY: 0,
        maxY: chartPeak,
        lineBarsData: [
          LineChartBarData(
            spots: [for (var index = 0; index < values.length; index++) FlSpot(index.toDouble(), values[index])],
            isCurved: values.length <= 30,
            curveSmoothness: 0.18,
            color: colors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: values.length <= 30),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colors.primary.withValues(alpha: 0.28), colors.primary.withValues(alpha: 0.02)],
              ),
            ),
          ),
        ],
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: _axisInterval(chartPeak),
          getDrawingHorizontalLine: (_) => FlLine(color: colors.outlineVariant.withValues(alpha: 0.45), strokeWidth: 1),
        ),
        titlesData: _chartTitles(
          context,
          start: start,
          pointCount: values.length,
          bottomInterval: labelInterval,
          showWeekday: false,
          peak: chartPeak,
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (_) => colors.surfaceContainerHighest,
            getTooltipItems: (spots) => [
              for (final spot in spots)
                LineTooltipItem(
                  '${_fullDate(start.add(Duration(days: spot.x.round())))}\n${formatListeningSeconds(spot.y)}',
                  Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
                ),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 280),
    );
  }
}

FlTitlesData _chartTitles(
  BuildContext context, {
  required DateTime start,
  required int pointCount,
  required double bottomInterval,
  required bool showWeekday,
  required double peak,
}) {
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 48,
        interval: _axisInterval(peak),
        getTitlesWidget: (value, meta) => SideTitleWidget(
          meta: meta,
          space: 6,
          child: Text(_axisLabel(value), style: Theme.of(context).textTheme.labelSmall),
        ),
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        interval: bottomInterval,
        getTitlesWidget: (value, meta) {
          final index = value.round();
          if (index < 0 || index >= pointCount) {
            return const SizedBox.shrink();
          }
          final date = start.add(Duration(days: index));
          final label = showWeekday ? _weekdayLabel(date.weekday) : '${date.month}/${date.day}';
          return SideTitleWidget(
            meta: meta,
            space: 8,
            child: Text(label, style: Theme.of(context).textTheme.labelSmall),
          );
        },
      ),
    ),
  );
}

class _ChartCaption extends StatelessWidget {
  const _ChartCaption({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text.rich(
      TextSpan(
        text: '$label  ',
        style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

double _axisInterval(double peak) {
  if (peak <= 1800) return 600;
  if (peak <= 3600) return 1200;
  if (peak <= 7200) return 1800;
  if (peak <= 14400) return 3600;
  if (peak <= 28800) return 7200;
  return 14400;
}

String _axisLabel(double seconds) {
  if (seconds <= 0) return '0';
  if (seconds < 3600) return '${(seconds / 60).round()}m';
  return '${(seconds / 3600).round()}h';
}

String _weekdayLabel(int weekday) => const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];

String _shortDate(DateTime value) => '${value.month}/${value.day}';

String _fullDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
