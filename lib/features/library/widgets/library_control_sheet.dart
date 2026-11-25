import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryControlSheet extends StatelessWidget {
  const LibraryControlSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.headerAction,
    this.heightFactor = 0.88,
  });

  final String title;
  final String? subtitle;
  final Widget? headerAction;
  final Widget child;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final height = MediaQuery.sizeOf(context).height * heightFactor;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
                      IconButton(
                        tooltip: context.l10n.actionClose,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  if (subtitle != null || headerAction != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (subtitle != null)
                          Expanded(
                            child: Text(
                              subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                          ),
                        if (headerAction != null) ...[if (subtitle != null) const SizedBox(width: 8), headerAction!],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
