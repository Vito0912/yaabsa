import 'package:flutter/material.dart';

class StatsRankedBarEntry {
  const StatsRankedBarEntry({required this.label, required this.value, required this.trailing});

  final String label;
  final double value;
  final String trailing;
}

class StatsRankedBars extends StatelessWidget {
  const StatsRankedBars({super.key, required this.entries, this.maxItems = 6, this.emptyMessage = 'No data available'});

  final List<StatsRankedBarEntry> entries;
  final int maxItems;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Text(emptyMessage, style: Theme.of(context).textTheme.bodyMedium);
    }

    final sorted = List<StatsRankedBarEntry>.from(entries)..sort((a, b) => b.value.compareTo(a.value));
    final visible = sorted.take(maxItems).toList(growable: false);
    final maxValue = visible.first.value <= 0 ? 1.0 : visible.first.value;

    return Column(
      children: [
        for (final entry in visible)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(entry.trailing, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: (entry.value / maxValue).clamp(0, 1)),
              ],
            ),
          ),
      ],
    );
  }
}
