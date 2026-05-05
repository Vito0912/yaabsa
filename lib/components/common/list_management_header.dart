import 'package:flutter/material.dart';

class ListManagementHeader extends StatelessWidget {
  const ListManagementHeader({
    required this.title,
    this.subtitle,
    this.onCreate,
    this.createLabel,
    this.padding,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onCreate;
  final String? createLabel;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final hasCreateAction = onCreate != null;

    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
              ],
            ),
          ),
          if (hasCreateAction)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: FilledButton.tonal(
                onPressed: onCreate,
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(createLabel ?? 'Create'),
              ),
            ),
        ],
      ),
    );
  }
}
