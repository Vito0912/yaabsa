import 'package:flutter/material.dart';

class SettingsCategory extends StatelessWidget {
  const SettingsCategory({super.key, required this.title, this.description, this.icon, this.topPadding = 32});

  final String title;
  final String? description;
  final IconData? icon;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 18, color: colorScheme.primary), const SizedBox(width: 8)],
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          if (description != null && description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}
