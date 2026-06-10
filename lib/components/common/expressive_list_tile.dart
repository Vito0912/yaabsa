import 'package:flutter/material.dart';

class ExpressiveListTile extends StatelessWidget {
  const ExpressiveListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
    this.cardColor,
    this.selectedCardColor,
    this.borderRadius,
    this.contentPadding,
    this.elevation,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final bool enabled;
  final Color? cardColor;
  final Color? selectedCardColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final resolvedBorderRadius = borderRadius ?? BorderRadius.circular(24);

    // M3 Expressive Card Colors
    final defaultBgColor = cardColor ?? colorScheme.surfaceContainer;
    final selectedBgColor = selectedCardColor ?? colorScheme.primaryContainer;
    final activeBgColor = selected ? selectedBgColor : defaultBgColor;

    return Card(
      elevation: elevation ?? (selected ? 1.0 : 0.0),
      margin: EdgeInsets.zero,
      color: enabled ? activeBgColor : activeBgColor.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: resolvedBorderRadius,
        side: selected ? BorderSide(color: colorScheme.primary, width: 1.5) : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        borderRadius: resolvedBorderRadius,
        child: Padding(
          padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 16)],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: enabled
                            ? (selected ? colorScheme.onPrimaryContainer : colorScheme.onSurface)
                            : colorScheme.onSurface.withValues(alpha: 0.38),
                      ),
                      child: title,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: enabled
                              ? (selected
                                    ? colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                                    : colorScheme.onSurfaceVariant)
                              : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                        ),
                        child: subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 16), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
