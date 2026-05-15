import 'package:flutter/material.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';

class ManualMatchResultsPane extends StatelessWidget {
  const ManualMatchResultsPane({
    super.key,
    required this.searching,
    required this.results,
    required this.selectedResult,
    required this.onSelectResult,
  });

  final bool searching;
  final List<ManualMatchResult> results;
  final ManualMatchResult? selectedResult;
  final ValueChanged<ManualMatchResult> onSelectResult;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.manage_search_rounded),
            title: const Text('Match candidates'),
            subtitle: Text(results.isEmpty ? 'No results yet' : '${results.length} result(s)'),
          ),
          const Divider(height: 1),
          Expanded(
            child: searching
                ? const Center(child: CircularProgressIndicator())
                : results.isEmpty
                ? const Center(child: Text('Run a search to load metadata match results.'))
                : ListView.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final result = results[index];
                      final selected = selectedResult == result;
                      return _ManualMatchResultTile(
                        result: result,
                        selected: selected,
                        onTap: () => onSelectResult(result),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ManualMatchResultTile extends StatelessWidget {
  const _ManualMatchResultTile({required this.result, required this.selected, required this.onTap});

  final ManualMatchResult result;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final identifierLabel = result.asin != null
        ? 'ASIN: ${result.asin!}'
        : result.isbn != null
        ? 'ISBN: ${result.isbn!}'
        : null;

    final providerBadgeColor = selected
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceContainerHighest;

    return ListTile(
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 46,
          height: 64,
          child: result.coverUrl == null
              ? Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.menu_book_rounded, size: 20),
                )
              : Image.network(
                  result.coverUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.menu_book_rounded, size: 20),
                  ),
                ),
        ),
      ),
      title: Text(result.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.authorDisplay != null) Text(result.authorDisplay!, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), color: providerBadgeColor),
                child: Text(result.providerLabel, style: Theme.of(context).textTheme.labelSmall),
              ),
              if (result.publishedYear != null)
                Text(
                  result.publishedYear!,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              if (result.runtimeLabel != null)
                Text(
                  result.runtimeLabel!,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              if (identifierLabel != null)
                Text(
                  identifierLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        ],
      ),
      trailing: selected ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.chevron_right_rounded),
      isThreeLine: result.authorDisplay != null,
    );
  }
}
