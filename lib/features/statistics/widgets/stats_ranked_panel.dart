import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';

class StatsRankedPanel extends StatelessWidget {
  const StatsRankedPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.entries,
    this.previewCount = 5,
    this.emptyMessage = 'No data available.',
  });

  final String title;
  final IconData icon;
  final List<StatsRankedEntry> entries;
  final int previewCount;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return YaabsaSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 10),
          StatsRankedList(entries: entries, previewCount: previewCount, emptyMessage: emptyMessage),
        ],
      ),
    );
  }
}
