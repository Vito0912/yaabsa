import 'package:flutter/material.dart';

enum ExpressiveTileActionTone { neutral, primary, danger }

class ExpressiveTileAction<T> {
  const ExpressiveTileAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.tone = ExpressiveTileActionTone.neutral,
  });

  final IconData icon;
  final String tooltip;
  final Future<void> Function(T item) onPressed;
  final ExpressiveTileActionTone tone;
}

class ExpressiveTileList<T> extends StatelessWidget {
  const ExpressiveTileList({
    super.key,
    required this.items,
    required this.itemId,
    required this.titleBuilder,
    this.subtitleBuilder,
    this.leadingIconBuilder,
    this.trailingBuilder,
    this.actions = const [],
    this.onItemTap,
    this.onReorderItem,
    this.isSelected,
    this.loading = false,
    this.emptyTitle = 'No entries',
    this.emptySubtitle,
    this.padding = EdgeInsets.zero,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.shrinkWrap = false,
    this.dragHandleTooltip = 'Reorder',
  });

  final List<T> items;
  final String Function(T item) itemId;
  final String Function(T item) titleBuilder;
  final String? Function(T item)? subtitleBuilder;
  final IconData? Function(T item)? leadingIconBuilder;
  final List<Widget> Function(BuildContext context, T item)? trailingBuilder;
  final List<ExpressiveTileAction<T>> actions;
  final Future<void> Function(T item)? onItemTap;
  final ReorderCallback? onReorderItem;
  final bool Function(T item)? isSelected;
  final bool loading;
  final String emptyTitle;
  final String? emptySubtitle;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final String dragHandleTooltip;

  bool get _isReorderable => onReorderItem != null;

  Color _actionColor(BuildContext context, ExpressiveTileActionTone tone) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (tone) {
      case ExpressiveTileActionTone.primary:
        return colorScheme.primary;
      case ExpressiveTileActionTone.danger:
        return colorScheme.error;
      case ExpressiveTileActionTone.neutral:
        return colorScheme.onSurfaceVariant;
    }
  }

  Future<void> _handleAction(ExpressiveTileAction<T> action, T item) async {
    await action.onPressed.call(item);
  }

  Future<void> _handleTap(T item) async {
    final callback = onItemTap;
    if (callback == null) {
      return;
    }

    await callback.call(item);
  }

  Widget _buildTileBody(BuildContext context, T item, {required int? index, required bool showBottomDivider}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selected = isSelected?.call(item) ?? false;
    final subtitle = subtitleBuilder?.call(item)?.trim();
    final leadingIcon = leadingIconBuilder?.call(item);
    final customTrailing = trailingBuilder?.call(context, item) ?? const <Widget>[];

    final rowActions = <Widget>[];

    if (actions.isNotEmpty) {
      rowActions.add(
        Wrap(
          spacing: 2,
          runSpacing: 2,
          children: [
            for (final action in actions)
              IconButton(
                tooltip: action.tooltip,
                visualDensity: VisualDensity.compact,
                onPressed: () => _handleAction(action, item),
                icon: Icon(action.icon, size: 19, color: _actionColor(context, action.tone)),
              ),
          ],
        ),
      );
    }

    rowActions.addAll(customTrailing);

    if (_isReorderable && index != null) {
      rowActions.add(
        Tooltip(
          message: dragHandleTooltip,
          child: ReorderableDragStartListener(
            index: index,
            child: Icon(Icons.drag_indicator_rounded, color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return Material(
      key: _isReorderable ? ValueKey(itemId(item)) : null,
      color: selected ? colorScheme.surfaceContainerHigh : colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onItemTap == null ? null : () => _handleTap(item),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: selected ? colorScheme.primary : Colors.transparent, width: 3),
              bottom: BorderSide(
                color: showBottomDivider ? colorScheme.outlineVariant.withValues(alpha: 0.34) : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleBuilder(item),
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              if (rowActions.isNotEmpty) ...[
                const SizedBox(width: 8),
                Wrap(spacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: rowActions),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emptyTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (emptySubtitle != null && emptySubtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(emptySubtitle!, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 28),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildEmptyList(BuildContext context) {
    return ListView(physics: physics, shrinkWrap: shrinkWrap, padding: padding, children: [_buildEmptyState(context)]);
  }

  Widget _buildDecoratedList({required Widget child, required BuildContext context}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.34)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildStandardList(BuildContext context) {
    final listView = ListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return _buildTileBody(context, item, index: null, showBottomDivider: !isLast);
      },
    );

    return Padding(
      padding: padding,
      child: _buildDecoratedList(child: listView, context: context),
    );
  }

  Widget _buildReorderableList(BuildContext context) {
    final reorderCallback = onReorderItem;
    if (reorderCallback == null) {
      return _buildStandardList(context);
    }

    final list = ReorderableListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: EdgeInsets.zero,
      itemCount: items.length,
      onReorderItem: reorderCallback,
      buildDefaultDragHandles: false,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return _buildTileBody(context, item, index: index, showBottomDivider: !isLast);
      },
    );

    return Padding(
      padding: padding,
      child: _buildDecoratedList(child: list, context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading && items.isEmpty) {
      return _buildLoadingList();
    }

    if (items.isEmpty) {
      return _buildEmptyList(context);
    }

    return _isReorderable ? _buildReorderableList(context) : _buildStandardList(context);
  }
}
