import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

import 'package:yaabsa/generated/l10n.dart';

class StatsActivityRangeChart extends StatefulWidget {
  const StatsActivityRangeChart({super.key, required this.activity});

  final ListeningActivityStats activity;

  @override
  State<StatsActivityRangeChart> createState() => _StatsActivityRangeChartState();
}

class _StatsActivityRangeChartState extends State<StatsActivityRangeChart> {
  static const List<int> _ranges = <int>[7, 30, 365];

  int _selectedRange = 30;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(Duration(days: _selectedRange - 1));

    final values = widget.activity.valuesForLastDays(_selectedRange, reference: end);
    final maxValue = values.fold<double>(0, (maxValue, value) => math.max(maxValue, value));
    final chartPeak = math.max(maxValue, 1.0).toDouble();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final range in _ranges)
              ChoiceChip(
                label: Text(S.current.screensMainStatsStatsActivityRangeChartD(range)),
                selected: _selectedRange == range,
                onSelected: (selected) {
                  if (!selected) {
                    return;
                  }
                  setState(() {
                    _selectedRange = range;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 6),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fillCompactWidth = constraints.maxWidth < 560 && values.length <= 30;
                final groupSpace = fillCompactWidth ? 2.0 : _groupSpace(values.length);
                final barWidth = fillCompactWidth
                    ? _fillBarWidth(constraints.maxWidth, values.length)
                    : _barWidth(values.length);
                final minChartWidth = _minimumChartWidth(values.length, barWidth, groupSpace);
                final chartWidth = fillCompactWidth
                    ? constraints.maxWidth
                    : math.max(constraints.maxWidth, minChartWidth).toDouble();
                final leftAxisInterval = _leftAxisInterval(chartPeak);

                final barGroups = List<BarChartGroupData>.generate(values.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 0,
                    barRods: [
                      BarChartRodData(
                        toY: values[index],
                        width: barWidth,
                        borderRadius: BorderRadius.circular(3),
                        color: colorScheme.primary,
                      ),
                    ],
                  );
                }, growable: false);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    height: 170,
                    child: BarChart(
                      BarChartData(
                        minY: 0,
                        maxY: chartPeak * 1.1,
                        barGroups: barGroups,
                        alignment: fillCompactWidth ? BarChartAlignment.spaceBetween : BarChartAlignment.center,
                        groupsSpace: groupSpace,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: leftAxisInterval,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(color: colorScheme.outlineVariant.withValues(alpha: 0.35), strokeWidth: 1);
                          },
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 58,
                              interval: leftAxisInterval,
                              getTitlesWidget: (value, meta) {
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 6,
                                  child: Text(_formatAxisLabel(value), style: Theme.of(context).textTheme.labelSmall),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              interval: _bottomLabelInterval(values.length),
                              getTitlesWidget: (value, meta) {
                                final index = value.round();
                                if (index < 0 || index >= values.length) {
                                  return const SizedBox.shrink();
                                }

                                final isFirst = index == 0;
                                final isMiddle = index == values.length ~/ 2;
                                final isLast = index == values.length - 1;
                                if (!isFirst && !isMiddle && !isLast) {
                                  return const SizedBox.shrink();
                                }

                                final day = start.add(Duration(days: index));
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 6,
                                  child: Text(
                                    S.current.screensMainStatsStatsActivityRangeChartText(day.month, day.day),
                                    style: Theme.of(context).textTheme.labelSmall,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            fitInsideHorizontally: true,
                            fitInsideVertically: true,
                            getTooltipColor: (_) => colorScheme.surfaceContainerHighest,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final day = start.add(Duration(days: group.x));
                              return BarTooltipItem(
                                '${_formatDate(day)}\n${formatListeningSeconds(rod.toY)}',
                                Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDate(start), style: Theme.of(context).textTheme.labelSmall),
            Text(
              S.current.screensMainStatsStatsActivityRangeChartLastDays(_selectedRange),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(_formatDate(end), style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime value) {
    return formatDateLabel(value);
  }

  double _bottomLabelInterval(int points) {
    if (points <= 8) {
      return 1;
    }
    if (points <= 30) {
      return 5;
    }
    if (points <= 90) {
      return 15;
    }
    return 60;
  }

  double _barWidth(int points) {
    if (points <= 7) {
      return 16;
    }
    if (points <= 30) {
      return 10;
    }
    if (points <= 90) {
      return 6;
    }
    return 4;
  }

  double _groupSpace(int points) {
    if (points <= 7) {
      return 3;
    }
    if (points <= 30) {
      return 2;
    }
    if (points <= 90) {
      return 1.4;
    }
    return 1;
  }

  double _minimumChartWidth(int points, double barWidth, double groupSpace) {
    final barsWidth = (points * barWidth) + ((points - 1) * groupSpace);
    return barsWidth + 78;
  }

  double _leftAxisInterval(double chartPeak) {
    if (chartPeak <= 0) {
      return 600;
    }

    if (chartPeak < 3600) {
      final totalMinutes = chartPeak / 60;
      if (totalMinutes <= 30) {
        return 600;
      }
      if (totalMinutes <= 60) {
        return 1200;
      }
      if (totalMinutes <= 120) {
        return 1800;
      }
      return 3600;
    }

    final totalHours = chartPeak / 3600;
    if (totalHours <= 4) {
      return 3600;
    }
    if (totalHours <= 8) {
      return 7200;
    }
    if (totalHours <= 16) {
      return 14400;
    }
    return 21600;
  }

  String _formatAxisLabel(double seconds) {
    if (seconds <= 0) {
      return '0m';
    }

    if (seconds < 3600) {
      final minutes = (seconds / 60).round();
      return '${minutes}m';
    }

    final hours = (seconds / 3600).round();
    return '${hours}h';
  }

  double _fillBarWidth(double availableWidth, int points) {
    final drawableWidth = math.max(120.0, availableWidth - 78).toDouble();
    final totalSpacing = (points - 1) * 2.0;
    final rawWidth = (drawableWidth - totalSpacing) / points;
    return rawWidth.clamp(8.0, 28.0).toDouble();
  }
}
