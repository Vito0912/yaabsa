import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/util/l10n.dart';

class StatsActivityRangeChart extends StatefulWidget {
  const StatsActivityRangeChart({super.key, required this.activity, this.referenceDate, this.initialRange = 30});

  final ListeningActivityStats activity;
  final DateTime? referenceDate;
  final int initialRange;

  @override
  State<StatsActivityRangeChart> createState() => _StatsActivityRangeChartState();
}

class _StatsActivityRangeChartState extends State<StatsActivityRangeChart> {
  late int _selectedRange = _validRange(widget.initialRange);

  int _validRange(int value) {
    return const [7, 30, 365].contains(value) ? value : 30;
  }

  @override
  Widget build(BuildContext context) {
    final now = widget.referenceDate ?? DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(Duration(days: _selectedRange - 1));
    final values = widget.activity.valuesForLastDays(_selectedRange, reference: end);
    final total = values.fold<double>(0, (sum, value) => sum + value);
    final average = values.isEmpty ? 0.0 : total / values.length;
    final peak = values.fold<double>(0, math.max);
    final theme = Theme.of(context);

    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatListeningSeconds(total),
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          context.l10n.statsTotalOverDays(_selectedRange),
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
    final rangeSelector = SegmentedButton<int>(
      segments: [
        ButtonSegment(value: 7, label: Text(context.l10n.durationCompactDays(7))),
        ButtonSegment(value: 30, label: Text(context.l10n.durationCompactDays(30))),
        ButtonSegment(value: 365, label: Text(context.l10n.durationCompactYears(1))),
      ],
      selected: <int>{_selectedRange},
      showSelectedIcon: false,
      onSelectionChanged: (selection) {
        setState(() => _selectedRange = selection.first);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 440) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [summary, const SizedBox(height: 12), rangeSelector],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summary),
                const SizedBox(width: 12),
                rangeSelector,
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        YaabsaSurfaceCard(
          padding: const EdgeInsets.fromLTRB(8, 18, 12, 8),
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
            _ChartCaption(label: context.l10n.statsDailyAverage, value: formatListeningSeconds(average)),
            _ChartCaption(label: context.l10n.statsPeakDay, value: formatListeningSeconds(peak)),
            _ChartCaption(label: context.l10n.fieldRange, value: context.l10n.statsDateRange(start, end)),
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
                context.l10n.statsDateAndListeningTime(date, formatListeningSeconds(rod.toY)),
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
    final labelInterval = switch (values.length) {
      <= 30 => 7.0,
      <= 90 => 14.0,
      _ => 90.0,
    };

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
                  context.l10n.statsDateAndListeningTime(
                    start.add(Duration(days: spot.x.round())),
                    formatListeningSeconds(spot.y),
                  ),
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
          child: Text(formatCompactTimeAxis(value), style: Theme.of(context).textTheme.labelSmall),
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
          final isDenseRange = pointCount > 14 && pointCount <= 90;
          final isAnnualRange = pointCount > 90;
          if (!showWeekday &&
              ((isDenseRange && index >= pointCount - 2) || (isAnnualRange && index >= pointCount - 7))) {
            return const SizedBox.shrink();
          }

          final date = start.add(Duration(days: index));
          final label = showWeekday ? formatCompactWeekday(date) : formatShortDate(date);
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
