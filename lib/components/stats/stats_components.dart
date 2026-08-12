import 'package:flutter/material.dart';

class StatsMetric {
  const StatsMetric({
    required this.label,
    required this.value,
    required this.icon,
    this.supportingText,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? supportingText;
  final bool emphasized;
}

class StatsMetricGrid extends StatelessWidget {
  const StatsMetricGrid({super.key, required this.metrics, this.minimumTileWidth = 168, this.maximumColumns = 4});

  final List<StatsMetric> metrics;
  final double minimumTileWidth;
  final int maximumColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final availableWidth = constraints.maxWidth;
        final possibleColumns = ((availableWidth + spacing) / (minimumTileWidth + spacing)).floor();
        final columns = possibleColumns.clamp(1, maximumColumns);
        final tileWidth = (availableWidth - ((columns - 1) * spacing)) / columns;
        final rows = <List<StatsMetric>>[];
        for (var index = 0; index < metrics.length; index += columns) {
          rows.add(metrics.skip(index).take(columns).toList(growable: false));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var rowIndex = 0; rowIndex < rows.length; rowIndex++)
              Padding(
                padding: EdgeInsets.only(bottom: rowIndex == rows.length - 1 ? 0 : spacing),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var columnIndex = 0; columnIndex < columns; columnIndex++) ...[
                        if (columnIndex > 0) const SizedBox(width: spacing),
                        SizedBox(
                          width: tileWidth,
                          child: columnIndex < rows[rowIndex].length
                              ? _StatsMetricCard(metric: rows[rowIndex][columnIndex])
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StatsMetricCard extends StatelessWidget {
  const _StatsMetricCard({required this.metric});

  final StatsMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: metric.emphasized ? colors.primaryContainer : colors.surfaceContainer,
        borderRadius: BorderRadius.circular(metric.emphasized ? 24 : 20),
        border: Border.all(
          color: metric.emphasized
              ? colors.primary.withValues(alpha: 0.28)
              : colors.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(metric.icon, size: 22, color: metric.emphasized ? colors.onPrimaryContainer : colors.primary),
          const SizedBox(height: 16),
          Text(
            metric.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: metric.emphasized ? colors.onPrimaryContainer : colors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: metric.emphasized ? colors.onPrimaryContainer : colors.onSurfaceVariant,
            ),
          ),
          if (metric.supportingText case final supportingText?) ...[
            const SizedBox(height: 2),
            Text(
              supportingText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: metric.emphasized ? colors.onPrimaryContainer : colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
    this.compact = false,
  });

  final String title;
  final IconData? icon;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 21, color: theme.colorScheme.onSecondaryContainer),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))],
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
          if (!compact) ...[const SizedBox(height: 18), child],
        ],
      ),
    );
  }
}

class StatsRankedEntry {
  const StatsRankedEntry({required this.label, required this.value, required this.trailing, this.onTap});

  final String label;
  final double value;
  final String trailing;
  final VoidCallback? onTap;
}

class StatsRankedList extends StatefulWidget {
  const StatsRankedList({
    super.key,
    required this.entries,
    this.previewCount = 5,
    this.emptyMessage = 'No data available.',
    this.showRanks = false,
  });

  final List<StatsRankedEntry> entries;
  final int previewCount;
  final String emptyMessage;
  final bool showRanks;

  @override
  State<StatsRankedList> createState() => _StatsRankedListState();
}

class _StatsRankedListState extends State<StatsRankedList> {
  bool _expanded = false;

  @override
  void didUpdateWidget(covariant StatsRankedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entries != widget.entries) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(widget.emptyMessage, style: Theme.of(context).textTheme.bodyMedium),
      );
    }

    final sorted = List<StatsRankedEntry>.from(widget.entries)..sort((a, b) => b.value.compareTo(a.value));
    final visible = _expanded ? sorted : sorted.take(widget.previewCount).toList(growable: false);
    final maxValue = sorted.first.value <= 0 ? 1.0 : sorted.first.value;
    final canExpand = sorted.length > widget.previewCount;

    return Column(
      children: [
        for (var index = 0; index < visible.length; index++)
          _StatsRankedRow(
            entry: visible[index],
            rank: widget.showRanks ? index + 1 : null,
            fraction: (visible[index].value / maxValue).clamp(0, 1),
          ),
        if (canExpand) ...[
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
              label: Text(_expanded ? 'Show less' : 'Show ${sorted.length - widget.previewCount} more'),
            ),
          ),
        ],
      ],
    );
  }
}

class _StatsRankedRow extends StatelessWidget {
  const _StatsRankedRow({required this.entry, required this.fraction, this.rank});

  final StatsRankedEntry entry;
  final double fraction;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (rank != null)
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text('$rank', style: theme.textTheme.labelMedium),
                ),
              Expanded(child: Text(entry.label, maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 12),
              Text(
                entry.trailing,
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              if (entry.onTap != null) ...[
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
              ],
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 5,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );

    if (entry.onTap == null) {
      return content;
    }

    return InkWell(borderRadius: BorderRadius.circular(12), onTap: entry.onTap, child: content);
  }
}

class StatsMessage extends StatelessWidget {
  const StatsMessage({super.key, required this.title, required this.icon, this.message, this.action});

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: theme.colorScheme.primary),
            const SizedBox(height: 14),
            Text(title, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
            if (message case final message?) ...[
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
