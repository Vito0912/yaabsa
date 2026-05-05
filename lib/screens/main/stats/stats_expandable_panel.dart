import 'package:flutter/material.dart';

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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: expanded ? theme.colorScheme.primary.withValues(alpha: 0.35) : theme.colorScheme.outlineVariant,
        ),
        color: theme.colorScheme.surface,
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
            highlightColor: Colors.transparent,
            onTap: () => onExpansionChanged(!expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(icon, size: 18, color: theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ],
              ),
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
