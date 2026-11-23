import 'package:material_ui/material_ui.dart';

class YaabsaFeedbackPanel extends StatelessWidget {
  const YaabsaFeedbackPanel({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.details,
    this.messageMaxLines,
    this.action,
    this.iconSize = 36,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    this.contentMaxWidth = 520,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? details;
  final int? messageMaxLines;
  final Widget? action;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double? contentMaxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resolvedMessage = message;
    final resolvedDetails = details;

    return Center(
      child: Padding(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentMaxWidth ?? double.infinity),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(title, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
              if (resolvedMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolvedMessage,
                  maxLines: messageMaxLines,
                  overflow: messageMaxLines == null ? null : TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
              if (resolvedDetails != null && resolvedDetails.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  resolvedDetails,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
              if (action != null) ...[const SizedBox(height: 14), action!],
            ],
          ),
        ),
      ),
    );
  }
}
