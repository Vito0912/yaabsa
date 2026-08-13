import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/stats/stats_components.dart';

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
    return StatsRankedList(
      entries: [
        for (final entry in entries) StatsRankedEntry(label: entry.label, value: entry.value, trailing: entry.trailing),
      ],
      previewCount: maxItems,
      emptyMessage: emptyMessage,
    );
  }
}
