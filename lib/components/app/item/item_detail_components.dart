import 'package:flutter/material.dart';

class ItemHeroCard extends StatelessWidget {
  const ItemHeroCard({
    super.key,
    required this.cover,
    required this.title,
    this.subtitle,
    required this.actions,
    required this.compactLayout,
    required this.onBack,
  });

  final Widget cover;
  final String title;
  final String? subtitle;
  final Widget actions;
  final bool compactLayout;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final coverSize = compactLayout ? 186.0 : 236.0;
    final coverWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(width: coverSize, height: coverSize, child: cover),
    );

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded), tooltip: 'Back'),
                const SizedBox(width: 4),
                Text('Book details', style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 6),
            if (compactLayout)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(alignment: Alignment.centerLeft, child: coverWidget),
                  const SizedBox(height: 10),
                  _TitleAndActions(title: title, subtitle: subtitle, actions: actions),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  coverWidget,
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TitleAndActions(title: title, subtitle: subtitle, actions: actions),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _TitleAndActions extends StatelessWidget {
  const _TitleAndActions({required this.title, this.subtitle, required this.actions});

  final String title;
  final String? subtitle;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, maxLines: 3, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
        if (subtitle != null && subtitle!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        const SizedBox(height: 10),
        actions,
      ],
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
      child: ExpansionTile(
        title: Text(title),
        initiallyExpanded: initiallyExpanded,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: children,
      ),
    );
  }
}

class ItemMetadataCard extends StatelessWidget {
  const ItemMetadataCard({super.key, required this.rows, this.inlineValues = false, this.useCard = true});

  final List<ItemMetadataRowData> rows;
  final bool inlineValues;
  final bool useCard;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows.map((row) => _ItemMetadataRow(row: row, inlineValues: inlineValues)).toList(),
      ),
    );

    if (!useCard) {
      return content;
    }

    return Card(elevation: 0, clipBehavior: Clip.antiAlias, child: content);
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
    final labelStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, letterSpacing: 0.4);
    const labelColumnWidth = 120.0;

    if (inlineValues) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: labelColumnWidth,
              child: Text(row.label.toUpperCase(), style: labelStyle),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.label.toUpperCase(), style: labelStyle),
          const SizedBox(height: 3),
          if (row.value != null)
            Text(row.value!, style: Theme.of(context).textTheme.bodyLarge)
          else if (row.values != null)
            Wrap(
              spacing: 6,
              runSpacing: -4,
              children: row.values!
                  .map(
                    (value) => value.onTap == null
                        ? Chip(label: Text(value.label), visualDensity: VisualDensity.compact)
                        : ActionChip(
                            label: Text(value.label),
                            visualDensity: VisualDensity.compact,
                            onPressed: value.onTap,
                          ),
                  )
                  .toList(),
            ),
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
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final surface = Theme.of(context).colorScheme.onSurface;

    return Wrap(
      children: [
        for (int i = 0; i < values.length; i++) ...[
          if (i > 0) Text(', ', style: textStyle?.copyWith(color: muted)),
          _InlineLinkText(label: values[i].label, onTap: values[i].onTap, color: surface),
        ],
      ],
    );
  }
}

class _InlineLinkText extends StatelessWidget {
  const _InlineLinkText({required this.label, this.onTap, required this.color});

  final String label;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            decoration: onTap == null ? TextDecoration.none : TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
