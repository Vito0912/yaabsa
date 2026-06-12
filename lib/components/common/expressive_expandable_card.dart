import 'package:flutter/material.dart';

class ExpressiveExpandableCard extends StatelessWidget {
  const ExpressiveExpandableCard({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
    this.initiallyExpanded = true,
    this.margin = EdgeInsets.zero,
    this.childrenPadding = const EdgeInsets.fromLTRB(12, 0, 12, 10),
    this.childrenCrossAxisAlignment,
    this.onExpansionChanged,
    this.cardColor,
    this.shape,
    this.elevation,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry childrenPadding;
  final CrossAxisAlignment? childrenCrossAxisAlignment;
  final ValueChanged<bool>? onExpansionChanged;
  final Color? cardColor;
  final ShapeBorder? shape;
  final double? elevation;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      color: cardColor,
      shape: shape,
      elevation: elevation,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          onExpansionChanged: onExpansionChanged,
          childrenPadding: childrenPadding,
          leading: icon == null ? null : Icon(icon, color: colorScheme.primary),
          iconColor: colorScheme.primary,
          collapsedIconColor: colorScheme.onSurfaceVariant,
          expandedCrossAxisAlignment: childrenCrossAxisAlignment,
          title: actions == null || actions!.isEmpty
              ? Text(title)
              : Row(
                  children: [
                    Expanded(child: Text(title)),
                    ...actions!,
                  ],
                ),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
          children: [
            Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
            ...children,
          ],
        ),
      ),
    );
  }
}
