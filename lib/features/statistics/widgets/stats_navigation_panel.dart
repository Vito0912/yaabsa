import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/statistics/widgets/stats_panel_header.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';

class StatsNavigationPanel extends StatelessWidget {
  const StatsNavigationPanel({super.key, required this.title, required this.icon, required this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return YaabsaSurfaceCard(
      padding: EdgeInsets.zero,
      borderRadius: 12,
      borderColor: theme.colorScheme.outlineVariant,
      color: theme.colorScheme.surface,
      child: StatsPanelHeader(
        title: title,
        icon: icon,
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
