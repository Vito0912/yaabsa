import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';

class NotificationPreviewCard extends StatelessWidget {
  const NotificationPreviewCard({
    super.key,
    required this.currentPageActions,
    required this.iconForAction,
    required this.onSlotTap,
  });

  final List<String> currentPageActions;
  final IconData? Function(String actionId) iconForAction;
  final ValueChanged<int> onSlotTap;

  Widget _buildPreviewButton(ColorScheme colorScheme, int index) {
    final action = index < currentPageActions.length ? currentPageActions[index] : '';
    final icon = iconForAction(action);

    final Widget buttonChild;
    if (action.isEmpty || icon == null) {
      buttonChild = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add_rounded, size: 14, color: colorScheme.outline),
      );
    } else {
      buttonChild = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          shape: BoxShape.circle,
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: colorScheme.onSurface, size: 18),
      );
    }

    return InkWell(onTap: () => onSlotTap(index), borderRadius: BorderRadius.circular(18), child: buttonChild);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.fieldTitle,
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.l10n.fieldAuthor,
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.pause_rounded, color: colorScheme.onPrimaryContainer, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildPreviewButton(colorScheme, 0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 4,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Positioned(
                              left: 56,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildPreviewButton(colorScheme, 1),
                    const SizedBox(width: 8),
                    _buildPreviewButton(colorScheme, 2),
                    const SizedBox(width: 8),
                    _buildPreviewButton(colorScheme, 3),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  context.l10n.statusNotificationLayoutMayVary,
                  style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
