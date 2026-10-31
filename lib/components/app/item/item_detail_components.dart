import 'package:material_ui/material_ui.dart';

class ItemHeroCard extends StatelessWidget {
  const ItemHeroCard({
    super.key,
    required this.cover,
    required this.title,
    this.subtitle,
    this.byline,
    this.summary,
    this.progressValue = 0,
    required this.actions,
    required this.compactLayout,
    required this.onBack,
  });

  final Widget cover;
  final String title;
  final String? subtitle;
  final String? byline;
  final String? summary;
  final double progressValue;
  final Widget actions;
  final bool compactLayout;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final coverSize = compactLayout ? 128.0 : 200.0;
        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final coverSpacing = compactLayout ? 12.0 : 20.0;
        final actionSpace = constraints.maxWidth - 24 - coverSize - coverSpacing;
        final placeActionsBesideCover = actionSpace >= 320 * textScale;
        final coverWidget = SizedBox.square(
          dimension: coverSize,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                cover,
                if (progressValue > 0) ...[
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: LinearProgressIndicator(
                      value: progressValue.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: Colors.black54,
                      semanticsLabel: 'Listening progress',
                    ),
                  ),
                  Positioned(
                    right: 6,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${(progressValue.clamp(0.0, 1.0) * 100).toStringAsFixed(1)}%',
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: (compactLayout ? theme.textTheme.titleLarge : theme.textTheme.headlineSmall)?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(subtitle!, style: theme.textTheme.bodyMedium),
            ],
            if (byline != null && byline!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(byline!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            if (summary != null && summary!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(summary!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ],
        );

        return Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: theme.colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded), tooltip: 'Back'),
                    Text('Book details', style: theme.textTheme.labelLarge),
                  ],
                ),
                if (!placeActionsBesideCover) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      coverWidget,
                      const SizedBox(width: 12),
                      Expanded(child: heading),
                    ],
                  ),
                  const SizedBox(height: 12),
                  actions,
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      coverWidget,
                      SizedBox(width: coverSpacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [heading, const SizedBox(height: 12), actions],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemExpandableSection extends StatelessWidget {
  const ItemExpandableSection({super.key, required this.title, required this.children, this.initiallyExpanded = false});

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(title),
          initiallyExpanded: initiallyExpanded,
          shape: const Border(),
          collapsedShape: const Border(),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          childrenPadding: const EdgeInsets.only(bottom: 8),
          children: children,
        ),
      ),
    );
  }
}

class ItemMetadataCard extends StatelessWidget {
  const ItemMetadataCard({
    super.key,
    required this.rows,
    this.inlineValues = false,
    this.useCard = true,
    this.showHeading = true,
    this.gridLayout = false,
    this.maxColumns = 2,
  });

  final List<ItemMetadataRowData> rows;
  final bool inlineValues;
  final bool useCard;
  final bool showHeading;
  final bool gridLayout;
  final int maxColumns;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeading) ...[
            Text('Book information', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
          ],
          if (gridLayout)
            LayoutBuilder(
              builder: (context, constraints) {
                final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
                final columns = (constraints.maxWidth / (130 * textScale)).floor().clamp(1, maxColumns);
                final width = (constraints.maxWidth - (columns - 1) * 12) / columns;

                return Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    for (final row in rows)
                      SizedBox(
                        width: row.label == 'Series' || row.label == 'Tags' ? constraints.maxWidth : width,
                        child: _ItemMetadataRow(row: row, inlineValues: false),
                      ),
                  ],
                );
              },
            )
          else
            for (var index = 0; index < rows.length; index++) ...[
              if (index > 0)
                Divider(
                  height: 8,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.45),
                ),
              _ItemMetadataRow(row: rows[index], inlineValues: inlineValues),
            ],
        ],
      ),
    );

    if (!useCard) {
      return content;
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: content,
    );
  }
}

class ItemMetadataRowData {
  const ItemMetadataRowData({required this.label, this.value, this.values}) : assert(value != null || values != null);

  final String label;
  final String? value;
  final List<ItemLinkValue>? values;
}

class ItemLinkValue {
  const ItemLinkValue({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class _ItemMetadataRow extends StatelessWidget {
  const _ItemMetadataRow({required this.row, required this.inlineValues});

  final ItemMetadataRowData row;
  final bool inlineValues;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final labelColumnWidth = MediaQuery.textScalerOf(context).scale(80.0).clamp(80.0, 120.0);

    if (inlineValues) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: labelColumnWidth,
              child: Text(row.label, style: labelStyle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: row.value != null
                  ? Text(row.value!, style: Theme.of(context).textTheme.bodyMedium)
                  : (row.values != null ? _InlineLinkValues(values: row.values!) : const SizedBox.shrink()),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.label, style: labelStyle),
          const SizedBox(height: 2),
          if (row.value != null)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 28),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(row.value!, style: Theme.of(context).textTheme.bodyMedium),
              ),
            )
          else if (row.values != null)
            _InlineLinkValues(values: row.values!),
        ],
      ),
    );
  }
}

class _InlineLinkValues extends StatelessWidget {
  const _InlineLinkValues({required this.values});

  final List<ItemLinkValue> values;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < values.length; index++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (index > 0) ...[
                ExcludeSemantics(
                  child: Text(
                    '·',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: _InlineLinkText(label: values[index].label, onTap: values[index].onTap),
              ),
            ],
          ),
      ],
    );
  }
}

class _InlineLinkText extends StatelessWidget {
  const _InlineLinkText({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) {
      return Text(label, style: Theme.of(context).textTheme.bodyMedium);
    }

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 2),
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Text(label),
    );
  }
}
