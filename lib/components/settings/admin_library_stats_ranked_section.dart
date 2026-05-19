import 'package:flutter/material.dart';

import 'package:yaabsa/generated/l10n.dart';

class AdminLibraryStatsRankedEntry {
  const AdminLibraryStatsRankedEntry({required this.label, required this.value, required this.trailing, this.onTap});

  final String label;
  final double value;
  final String trailing;
  final VoidCallback? onTap;
}

class AdminLibraryStatsRankedSection extends StatelessWidget {
  const AdminLibraryStatsRankedSection({
    super.key,
    required this.title,
    required this.entries,
    required this.emptyMessage,
    this.maxItems = 10,
  });

  final String title;
  final List<AdminLibraryStatsRankedEntry> entries;
  final String emptyMessage;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    final sorted = List<AdminLibraryStatsRankedEntry>.from(entries)..sort((a, b) => b.value.compareTo(a.value));
    final visibleEntries = sorted.take(maxItems).toList(growable: false);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            if (visibleEntries.isEmpty)
              Text(emptyMessage, style: Theme.of(context).textTheme.bodyMedium)
            else
              _RankedEntriesList(entries: visibleEntries),
          ],
        ),
      ),
    );
  }
}

class _RankedEntriesList extends StatelessWidget {
  const _RankedEntriesList({required this.entries});

  final List<AdminLibraryStatsRankedEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < entries.length; index++)
          Padding(
            padding: EdgeInsets.only(bottom: index == entries.length - 1 ? 0 : 8),
            child: _RankedEntryRow(rank: index + 1, entry: entries[index]),
          ),
      ],
    );
  }
}

class _RankedEntryRow extends StatelessWidget {
  const _RankedEntryRow({required this.rank, required this.entry});

  final int rank;
  final AdminLibraryStatsRankedEntry entry;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            S.current.componentsSettingsAdminLibraryStatsRankedSectionText(rank),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Text(
            entry.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 8),
        Text(entry.trailing, style: Theme.of(context).textTheme.bodySmall),
      ],
    );

    final onTap = entry.onTap;
    if (onTap == null) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: content);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4), child: content),
      ),
    );
  }
}
