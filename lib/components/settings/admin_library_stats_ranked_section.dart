import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/stats/stats_components.dart';

class AdminLibraryStatsRankedEntry {
  const AdminLibraryStatsRankedEntry({required this.label, required this.value, required this.trailing, this.onTap});

  final String label;
  final double value;
  final String trailing;
  final VoidCallback? onTap;
}

class AdminLibraryStatsRankedSection extends StatelessWidget {
  const AdminLibraryStatsRankedSection({
    super.key,
    required this.title,
    required this.entries,
    required this.emptyMessage,
    this.maxItems = 5,
    this.icon,
  });

  final String title;
  final List<AdminLibraryStatsRankedEntry> entries;
  final String emptyMessage;
  final int maxItems;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return StatsSection(
      title: title,
      icon: icon,
      child: StatsRankedList(
        entries: [
          for (final entry in entries)
            StatsRankedEntry(label: entry.label, value: entry.value, trailing: entry.trailing, onTap: entry.onTap),
        ],
        previewCount: maxItems,
        emptyMessage: emptyMessage,
        showRanks: true,
      ),
    );
  }
}
