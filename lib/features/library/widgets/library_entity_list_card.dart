import 'package:material_ui/material_ui.dart';

class LibraryEntityListCard extends StatelessWidget {
  const LibraryEntityListCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.description,
    this.titleStyle,
    this.compact = false,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final String? description;
  final TextStyle? titleStyle;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resolvedSubtitle = subtitle?.trim();
    final resolvedDescription = description?.trim();
    final resolvedTitleStyle = titleStyle ?? theme.textTheme.titleMedium;

    final cardContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12, vertical: compact ? 8 : 10),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: resolvedTitleStyle),
                if (resolvedSubtitle != null && resolvedSubtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    resolvedSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
                if (resolvedDescription != null && resolvedDescription.isNotEmpty && !compact) ...[
                  const SizedBox(height: 4),
                  Text(
                    resolvedDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
          ],
        ],
      ),
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? cardContent : InkWell(onTap: onTap, child: cardContent),
    );
  }
}
