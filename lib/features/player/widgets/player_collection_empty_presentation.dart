import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

enum PlayerCollectionEmptyDensity { compact, full }

class PlayerCollectionEmptyPresentation extends StatelessWidget {
  const PlayerCollectionEmptyPresentation({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.density = PlayerCollectionEmptyDensity.full,
    this.showIcon = true,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final PlayerCollectionEmptyDensity density;
  final bool showIcon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (density == PlayerCollectionEmptyDensity.compact) {
      return _buildCompact(context);
    }

    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon) ...[Icon(icon, size: 16, color: colors.onSurfaceVariant), const SizedBox(width: 6)],
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    final theme = Theme.of(context);
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(icon, size: 36, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 10),
            ],
            Text(title, style: theme.textTheme.titleMedium),
            if (hasSubtitle) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            if (isLoading) ...[
              const SizedBox(height: 8),
              const SizedBox(width: 20, height: 20, child: YaabsaCircularProgressIndicator(strokeWidth: 2)),
            ],
          ],
        ),
      ),
    );
  }
}
