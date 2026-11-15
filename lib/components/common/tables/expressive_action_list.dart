import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/feedback/empty_state_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

typedef ExpressiveListActionTone = YaabsaActionTone;

class ExpressiveListField<T> {
  const ExpressiveListField({required this.id, required this.label, required this.valueBuilder, this.tooltipBuilder});

  final String id;
  final String label;
  final Widget Function(BuildContext context, T row) valueBuilder;
  final String? Function(T row)? tooltipBuilder;
}

class ExpressiveListAction<T> {
  const ExpressiveListAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.tone = ExpressiveListActionTone.neutral,
  });

  final IconData icon;
  final String tooltip;
  final Future<void> Function(T row) onPressed;
  final ExpressiveListActionTone tone;
}

class ExpressiveActionList<T> extends StatelessWidget {
  const ExpressiveActionList({
    super.key,
    required this.rows,
    required this.fields,
    required this.rowId,
    this.actions = const [],
    this.busyRowIds = const <String>{},
    this.onRowTap,
    this.onReorderItem,
    this.loading = false,
    this.emptyTitle = 'No data',
    this.emptySubtitle,
    this.padding = EdgeInsets.zero,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.shrinkWrap = false,
  });

  final List<T> rows;
  final List<ExpressiveListField<T>> fields;
  final String Function(T row) rowId;
  final List<ExpressiveListAction<T>> actions;
  final Set<String> busyRowIds;
  final Future<void> Function(T row)? onRowTap;
  final ReorderCallback? onReorderItem;
  final bool loading;
  final String emptyTitle;
  final String? emptySubtitle;
  final EdgeInsets padding;
  final ScrollPhysics physics;
  final bool shrinkWrap;

  bool get _isReorderable => onReorderItem != null;

  Future<void> _handleActionTap(ExpressiveListAction<T> action, T row) async {
    await action.onPressed.call(row);
  }

  Future<void> _handleRowTap(T row) async {
    final callback = onRowTap;
    if (callback == null) {
      return;
    }

    await callback.call(row);
  }

  String? _inferTooltipFromWidget(Widget widget) {
    if (widget is Text) {
      return widget.data ?? widget.textSpan?.toPlainText();
    }

    if (widget is SelectableText) {
      return widget.data;
    }

    if (widget is RichText) {
      return widget.text.toPlainText();
    }

    return null;
  }

  Widget _fieldValue(BuildContext context, ExpressiveListField<T> field, T row) {
    final valueWidget = field.valueBuilder(context, row);
    final explicitTooltip = field.tooltipBuilder?.call(row)?.trim();
    final inferredTooltip = _inferTooltipFromWidget(valueWidget)?.trim();

    final tooltipMessage = (explicitTooltip != null && explicitTooltip.isNotEmpty)
        ? explicitTooltip
        : (inferredTooltip != null && inferredTooltip.isNotEmpty)
        ? inferredTooltip
        : field.label;

    return Tooltip(message: tooltipMessage, child: valueWidget);
  }

  Widget _buildFieldRow(BuildContext context, ExpressiveListField<T> field, T row) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 108,
          child: Text(
            field.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: _fieldValue(context, field, row)),
      ],
    );
  }

  Widget _buildRowActions(BuildContext context, T row, {required int? index}) {
    final key = rowId(row);
    final colorScheme = Theme.of(context).colorScheme;

    final actionWidgets = <Widget>[
      if (busyRowIds.contains(key))
        const SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
      else
        Wrap(
          spacing: 2,
          runSpacing: 2,
          alignment: WrapAlignment.end,
          children: [
            for (final action in actions)
              YaabsaActionIconButton(
                icon: action.icon,
                tooltip: action.tooltip,
                tone: action.tone,
                onPressed: () => _handleActionTap(action, row),
              ),
          ],
        ),
      const Spacer(),
      if (_isReorderable && index != null)
        ReorderableDragStartListener(
          index: index,
          child: Icon(Icons.drag_indicator_rounded, color: colorScheme.onSurfaceVariant),
        ),
    ];

    return Row(children: actionWidgets);
  }

  Widget _buildRowCard(BuildContext context, T row, {required int? index}) {
    final colorScheme = Theme.of(context).colorScheme;

    final rowBody = Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.28)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onRowTap == null ? null : () => _handleRowTap(row),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var fieldIndex = 0; fieldIndex < fields.length; fieldIndex++) ...[
                _buildFieldRow(context, fields[fieldIndex], row),
                if (fieldIndex != fields.length - 1) const SizedBox(height: 8),
              ],
              if (actions.isNotEmpty || _isReorderable) ...[
                const SizedBox(height: 8),
                Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.25), height: 1),
                const SizedBox(height: 4),
                _buildRowActions(context, row, index: index),
              ],
            ],
          ),
        ),
      ),
    );

    if (_isReorderable) {
      return Padding(key: ValueKey(rowId(row)), padding: const EdgeInsets.only(bottom: 10), child: rowBody);
    }

    return rowBody;
  }

  Widget _buildEmptyState(BuildContext context) {
    return YaabsaEmptyStateCard(title: emptyTitle, subtitle: emptySubtitle);
  }

  Widget _buildLoadingList() {
    return ListView(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 28),
          child: Center(child: YaabsaCircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildEmptyList(BuildContext context) {
    return ListView(physics: physics, shrinkWrap: shrinkWrap, padding: padding, children: [_buildEmptyState(context)]);
  }

  Widget _buildStandardList(BuildContext context) {
    return ListView.separated(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: rows.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final row = rows[index];
        return _buildRowCard(context, row, index: null);
      },
    );
  }

  Widget _buildReorderableList(BuildContext context) {
    final reorderCallback = onReorderItem;
    if (reorderCallback == null) {
      return _buildStandardList(context);
    }

    return ReorderableListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: rows.length,
      onReorderItem: reorderCallback,
      buildDefaultDragHandles: false,
      itemBuilder: (context, index) {
        final row = rows[index];
        return _buildRowCard(context, row, index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading && rows.isEmpty) {
      return _buildLoadingList();
    }

    if (rows.isEmpty || fields.isEmpty) {
      return _buildEmptyList(context);
    }

    return _isReorderable ? _buildReorderableList(context) : _buildStandardList(context);
  }
}
