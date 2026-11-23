import 'package:material_ui/material_ui.dart';

class YaabsaEmptyStateCard extends StatelessWidget {
  const YaabsaEmptyStateCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.centered = false,
    this.compact = false,
    this.topPadding = 0,
    this.borderRadius = 18,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool centered;
  final bool compact;
  final double topPadding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final resolvedSubtitle = subtitle?.trim();
    final compactInline = compact && icon != null && (resolvedSubtitle == null || resolvedSubtitle.isEmpty);

    final iconPresentation = icon == null
        ? null
        : Container(
            width: compact ? 40 : 56,
            height: compact ? 40 : 56,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(compact ? 14 : 20),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: compact ? 22 : 28, color: colorScheme.onSecondaryContainer),
          );
    final titlePresentation = Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      textAlign: centered ? TextAlign.center : TextAlign.start,
    );

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Container(
        width: double.infinity,
        padding: compact && icon != null
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
            : const EdgeInsets.fromLTRB(16, 20, 16, 18),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: compactInline
            ? Align(
                alignment: centered ? Alignment.center : Alignment.centerLeft,
                child: Wrap(
                  alignment: centered ? WrapAlignment.center : WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [iconPresentation!, titlePresentation],
                ),
              )
            : Column(
                crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  if (iconPresentation != null) ...[iconPresentation, SizedBox(height: compact ? 8 : 12)],
                  titlePresentation,
                  if (resolvedSubtitle != null && resolvedSubtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      resolvedSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      textAlign: centered ? TextAlign.center : TextAlign.start,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
