import 'package:flutter/material.dart';

class ManualMatchCollapsedSearchBar extends StatelessWidget {
  const ManualMatchCollapsedSearchBar({
    super.key,
    required this.title,
    required this.author,
    required this.selectedProviderCount,
    required this.onExpand,
  });

  final String title;
  final String author;
  final int selectedProviderCount;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final summary = <String>[
      if (selectedProviderCount > 0) '$selectedProviderCount provider${selectedProviderCount == 1 ? '' : 's'}',
      if (title.trim().isNotEmpty) 'Title: ${title.trim()}',
      if (author.trim().isNotEmpty) 'Author: ${author.trim()}',
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: const Icon(Icons.tune_rounded),
        title: const Text('Search filters collapsed'),
        subtitle: Text(summary.isEmpty ? 'Tap to edit search filters' : summary.join(' • '), maxLines: 2),
        trailing: TextButton.icon(onPressed: onExpand, icon: const Icon(Icons.edit_rounded), label: const Text('Edit')),
      ),
    );
  }
}
