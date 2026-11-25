import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';

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
    final l10n = context.l10n;
    final summary = <String>[
      if (selectedProviderCount > 0) l10n.metadataProviderCount(selectedProviderCount),
      if (title.trim().isNotEmpty) l10n.matchSearchFieldSummary(l10n.fieldTitle, title.trim()),
      if (author.trim().isNotEmpty) l10n.matchSearchFieldSummary(l10n.fieldAuthor, author.trim()),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: const Icon(Icons.tune_rounded),
        title: Text(l10n.headingSearchFiltersCollapsed),
        subtitle: Text(summary.isEmpty ? l10n.hintTapToEditSearchFilters : summary.join(' • '), maxLines: 2),
        trailing: TextButton.icon(
          onPressed: onExpand,
          icon: const Icon(Icons.edit_rounded),
          label: Text(l10n.actionEdit),
        ),
      ),
    );
  }
}
