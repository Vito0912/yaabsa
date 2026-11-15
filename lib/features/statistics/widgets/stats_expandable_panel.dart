import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/statistics/widgets/stats_panel_header.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';

class StatsExpandablePanel extends StatelessWidget {
  const StatsExpandablePanel({
    super.key,
    required this.title,
    required this.icon,
    required this.expanded,
    required this.onExpansionChanged,
    required this.child,
  });

  final String title;
  final IconData icon;
  final bool expanded;
  final ValueChanged<bool> onExpansionChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return YaabsaSurfaceCard(
      padding: EdgeInsets.zero,
      borderRadius: 12,
      borderColor: expanded ? theme.colorScheme.primary.withValues(alpha: 0.35) : theme.colorScheme.outlineVariant,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          StatsPanelHeader(
            title: title,
            icon: icon,
            onTap: () => onExpansionChanged(!expanded),
            trailing: AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ),
          AnimatedCrossFade(
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeOut,
            sizeCurve: Curves.easeOut,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 12), child: child),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}
