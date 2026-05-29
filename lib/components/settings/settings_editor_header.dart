import 'package:flutter/material.dart';

class SettingsEditorHeader extends StatelessWidget {
  const SettingsEditorHeader({super.key, required this.title, required this.onReset, this.topPadding = 20});

  final String title;
  final VoidCallback? onReset;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(title, style: Theme.of(context).textTheme.titleMedium)],
            ),
          ),
          const SizedBox(width: 12),
          TextButton.icon(onPressed: onReset, icon: const Icon(Icons.restart_alt_rounded), label: const Text('Reset')),
        ],
      ),
    );
  }
}
