import 'package:flutter/material.dart';

import 'package:yaabsa/generated/l10n.dart';

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
      if (selectedProviderCount > 0) S.current.manualMatchCollapsedProvidersCount(selectedProviderCount),
      if (title.trim().isNotEmpty) S.current.manualMatchCollapsedTitleSummary(title.trim()),
      if (author.trim().isNotEmpty) S.current.manualMatchCollapsedAuthorSummary(author.trim()),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: const Icon(Icons.tune_rounded),
        title: Text(S.current.componentsAppItemMatchManualMatchManualMatchCollapsedSearchBarSearchFiltersCollapsed),
        subtitle: Text(
          summary.isEmpty ? S.current.manualMatchCollapsedTapToEditFilters : summary.join(' • '),
          maxLines: 2,
        ),
        trailing: TextButton.icon(
          onPressed: onExpand,
          icon: const Icon(Icons.edit_rounded),
          label: Text(S.current.componentsAppItemMatchManualMatchManualMatchCollapsedSearchBarEdit),
        ),
      ),
    );
  }
}
