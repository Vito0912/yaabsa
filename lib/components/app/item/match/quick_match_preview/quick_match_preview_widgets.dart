import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';
import 'package:yaabsa/components/app/item/match/quick_match_preview/quick_match_preview_models.dart';
import 'package:yaabsa/util/globals.dart';

class QuickMatchPreviewHeader extends StatelessWidget {
  const QuickMatchPreviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Preview changes', style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          IconButton(
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class QuickMatchPreviewSummary extends StatelessWidget {
  const QuickMatchPreviewSummary({
    super.key,
    required this.changedCount,
    required this.totalCount,
    required this.onSelectAll,
    required this.onClearSelection,
  });

  final int changedCount;
  final int totalCount;
  final VoidCallback? onSelectAll;
  final VoidCallback? onClearSelection;

  @override
  Widget build(BuildContext context) {
    final actionButtons = <Widget>[
      TextButton(onPressed: onSelectAll, child: const Text('Select all changes')),
      TextButton(onPressed: onClearSelection, child: const Text('Clear selection')),
    ];

    if (context.isMobile) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Wrap(spacing: 8, runSpacing: 8, children: actionButtons),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _SummaryChip(label: '$changedCount/$totalCount with changes'),
          ...actionButtons,
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class QuickMatchPreviewActionRow extends StatelessWidget {
  const QuickMatchPreviewActionRow({
    super.key,
    required this.applying,
    required this.selectedCount,
    required this.onClose,
    required this.onApply,
  });

  final bool applying;
  final int selectedCount;
  final VoidCallback onClose;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final applyLabel = applying ? 'Applying...' : 'Apply $selectedCount';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: applying ? null : onClose, child: const Text('Close')),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: applying ? null : onApply,
            icon: applying
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.2))
                : const Icon(Icons.checklist_rounded),
            label: Text(applyLabel),
          ),
        ],
      ),
    );
  }
}

class QuickMatchPreviewLoading extends StatelessWidget {
  const QuickMatchPreviewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2.4)),
            SizedBox(height: 10),
            Text('Searching best metadata matches...'),
          ],
        ),
      ),
    );
  }
}

class QuickMatchPreviewFailure extends StatelessWidget {
  const QuickMatchPreviewFailure({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Could not load preview: $error',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

class QuickMatchPreviewNoResultCard extends StatelessWidget {
  const QuickMatchPreviewNoResultCard({super.key, required this.item, required this.error});

  final LibraryItem item;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Text('No match', style: Theme.of(context).textTheme.labelSmall),
                ),
              ],
            ),
            if (trimmedOrNull(item.authorString) != null) ...[
              const SizedBox(height: 2),
              Text(
                item.authorString!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              error == null
                  ? 'No metadata result was returned for this item with the selected provider.'
                  : 'Metadata search failed: $error',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickMatchPreviewResultCard extends StatelessWidget {
  const QuickMatchPreviewResultCard({
    super.key,
    required this.item,
    required this.result,
    required this.rows,
    required this.coverWillChange,
    required this.overrideCover,
    required this.selectable,
    required this.selected,
    required this.onSelectionChanged,
    required this.buildCurrentCover,
  });

  final LibraryItem item;
  final ManualMatchResult result;
  final List<QuickMatchComparisonRow> rows;
  final bool coverWillChange;
  final bool overrideCover;
  final bool selectable;
  final bool selected;
  final ValueChanged<bool> onSelectionChanged;
  final Widget Function() buildCurrentCover;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (trimmedOrNull(item.authorString) != null)
                        Text(
                          item.authorString!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                Checkbox(
                  value: selected,
                  visualDensity: VisualDensity.compact,
                  onChanged: selectable ? (value) => onSelectionChanged(value ?? false) : null,
                ),
              ],
            ),
            if (overrideCover) const SizedBox(height: 10),
            if (overrideCover)
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  _CoverCard(label: 'Before cover', child: buildCurrentCover()),
                  _CoverCard(
                    label: 'After cover',
                    child: coverWillChange ? _networkCoverPreview(context, result.coverUrl!) : buildCurrentCover(),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            if (rows.isEmpty)
              Text(
                'No metadata field changes detected for this item.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              )
            else
              QuickMatchComparisonTable(rows: rows),
          ],
        ),
      ),
    );
  }

  Widget _networkCoverPreview(BuildContext context, String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: quickMatchCoverPreviewSize,
        height: quickMatchCoverPreviewSize,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => quickMatchFallbackCoverPlaceholder(context, icon: Icons.broken_image_rounded),
        ),
      ),
    );
  }
}

class QuickMatchComparisonTable extends StatelessWidget {
  const QuickMatchComparisonTable({super.key, required this.rows});

  final List<QuickMatchComparisonRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 640) {
                  return Row(
                    children: [
                      Expanded(child: Text('Before', style: Theme.of(context).textTheme.labelMedium)),
                      const SizedBox(width: 10),
                      Expanded(child: Text('After', style: Theme.of(context).textTheme.labelMedium)),
                    ],
                  );
                }

                return Row(
                  children: [
                    const SizedBox(width: 150),
                    Expanded(child: Text('Before', style: Theme.of(context).textTheme.labelMedium)),
                    const SizedBox(width: 10),
                    Expanded(child: Text('After', style: Theme.of(context).textTheme.labelMedium)),
                  ],
                );
              },
            ),
          ),
          for (var index = 0; index < rows.length; index++) ...[
            _ComparisonRowTile(row: rows[index]),
            if (index != rows.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _ComparisonRowTile extends StatelessWidget {
  const _ComparisonRowTile({required this.row});

  final QuickMatchComparisonRow row;

  @override
  Widget build(BuildContext context) {
    final changedColor = row.changed
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
        : Colors.transparent;

    return Container(
      color: changedColor,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 640) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _valueText(context, row.before)),
                    const SizedBox(width: 10),
                    Expanded(child: _valueText(context, row.after)),
                  ],
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 150, child: Text(row.label, style: Theme.of(context).textTheme.labelLarge)),
              Expanded(child: _valueText(context, row.before)),
              const SizedBox(width: 10),
              Expanded(child: _valueText(context, row.after)),
            ],
          );
        },
      ),
    );
  }

  Widget _valueText(BuildContext context, String value) {
    return Text(
      value,
      maxLines: row.label == 'Description' ? 4 : 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _CoverCard extends StatelessWidget {
  const _CoverCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

Widget quickMatchFallbackCoverPlaceholder(BuildContext context, {required IconData icon}) {
  return Container(
    width: quickMatchCoverPreviewSize,
    height: quickMatchCoverPreviewSize,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
    ),
    child: Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurfaceVariant),
  );
}
