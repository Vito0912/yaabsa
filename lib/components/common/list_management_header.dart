import 'package:material_ui/material_ui.dart';

class ListManagementHeader extends StatelessWidget {
  const ListManagementHeader({this.title, this.subtitle, this.onCreate, this.createLabel, this.padding, super.key});

  final String? title;
  final String? subtitle;
  final VoidCallback? onCreate;
  final String? createLabel;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCreateAction = onCreate != null;
    final normalizedTitle = title?.trim();
    final hasTitle = normalizedTitle != null && normalizedTitle.isNotEmpty;
    final heading = hasTitle
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(normalizedTitle, style: theme.textTheme.titleLarge),
              if (subtitle != null && subtitle!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
            ],
          )
        : null;
    final createButton = onCreate == null
        ? null
        : FilledButton.tonalIcon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: Text(createLabel ?? 'Create'),
          );
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (!hasCreateAction) {
            return heading ?? const SizedBox.shrink();
          }

          if (!hasTitle) {
            return Align(alignment: Alignment.centerRight, child: createButton!);
          }

          final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
          final rowBreakpoint = 480 * textScale;

          if (constraints.maxWidth >= rowBreakpoint) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: heading!),
                const SizedBox(width: 12),
                createButton!,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading!,
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: createButton!),
            ],
          );
        },
      ),
    );
  }
}
