import 'package:flutter/material.dart';
import 'package:yaabsa/util/globals.dart';

enum ExpressiveTableActionTone { neutral, primary, danger }

enum ExpressiveTableCellAlignment { start, center, end }

class ExpressiveTableColumn<T> {
  const ExpressiveTableColumn({
    required this.id,
    required this.label,
    required this.cellBuilder,
    this.mobileCellBuilder,
    this.tooltipBuilder,
    this.headerTooltip,
    this.width = 180,
    this.alignment = ExpressiveTableCellAlignment.start,
    this.showOnMobile = true,
  });

  final String id;
  final String label;
  final double width;
  final ExpressiveTableCellAlignment alignment;
  final bool showOnMobile;
  final Widget Function(BuildContext context, T row) cellBuilder;
  final Widget Function(BuildContext context, T row)? mobileCellBuilder;
  final String? Function(T row)? tooltipBuilder;
  final String? headerTooltip;

  int get flex {
    final raw = (width / 72).round();
    final clamped = raw < 1 ? 1 : raw;
    return clamped > 8 ? 8 : clamped;
  }
}

class ExpressiveTableAction<T> {
  const ExpressiveTableAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.tone = ExpressiveTableActionTone.neutral,
    this.isVisible,
    this.isEnabled,
    this.iconBuilder,
    this.tooltipBuilder,
  });

  final IconData icon;
  final String tooltip;
  final Future<void> Function(T row) onPressed;
  final ExpressiveTableActionTone tone;
  final bool Function(T row)? isVisible;
  final bool Function(T row)? isEnabled;
  final IconData Function(T row)? iconBuilder;
  final String Function(T row)? tooltipBuilder;
}

class ExpressiveActionTable<T> extends StatelessWidget {
  const ExpressiveActionTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.rowId,
    this.actions = const [],
    this.busyRowIds = const <String>{},
    this.showSelection = false,
    this.selectedRowIds = const <String>{},
    this.onSelectionChanged,
    this.onRowTap,
    this.emptyTitle = 'No data',
    this.emptySubtitle,
    this.loading = false,
    this.padding = EdgeInsets.zero,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.shrinkWrap = false,
    this.topActions,
    this.topActionsPadding = EdgeInsets.zero,
    this.topActionsSpacing = 10,
    this.actionsColumnWidth = 118,
  });

  final List<T> rows;
  final List<ExpressiveTableColumn<T>> columns;
  final String Function(T row) rowId;
  final Set<String> busyRowIds;
  final bool showSelection;
  final Set<String> selectedRowIds;
  final void Function(T row, bool selected)? onSelectionChanged;
  final List<ExpressiveTableAction<T>> actions;
  final Future<void> Function(T row)? onRowTap;
  final String emptyTitle;
  final String? emptySubtitle;
  final bool loading;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final Widget? topActions;
  final EdgeInsetsGeometry topActionsPadding;
  final double topActionsSpacing;
  final double actionsColumnWidth;

  Color _actionColor(BuildContext context, ExpressiveTableActionTone tone) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (tone) {
      case ExpressiveTableActionTone.primary:
        return colorScheme.primary;
      case ExpressiveTableActionTone.danger:
        return colorScheme.error;
      case ExpressiveTableActionTone.neutral:
        return colorScheme.onSurfaceVariant;
    }
  }

  AlignmentDirectional _cellAlignment(ExpressiveTableCellAlignment alignment) {
    switch (alignment) {
      case ExpressiveTableCellAlignment.start:
        return AlignmentDirectional.centerStart;
      case ExpressiveTableCellAlignment.center:
        return AlignmentDirectional.center;
      case ExpressiveTableCellAlignment.end:
        return AlignmentDirectional.centerEnd;
    }
  }

  TextAlign _headerTextAlign(ExpressiveTableCellAlignment alignment) {
    switch (alignment) {
      case ExpressiveTableCellAlignment.start:
        return TextAlign.start;
      case ExpressiveTableCellAlignment.center:
        return TextAlign.center;
      case ExpressiveTableCellAlignment.end:
        return TextAlign.end;
    }
  }

  Future<void> _handleRowTap(T row) async {
    final callback = onRowTap;
    if (callback == null) {
      return;
    }
    await callback.call(row);
  }

  Future<void> _handleActionTap(ExpressiveTableAction<T> action, T row) async {
    await action.onPressed.call(row);
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

  Widget _buildCellWithTooltip(BuildContext context, ExpressiveTableColumn<T> column, T row, {required bool mobile}) {
    final cellWidget = mobile
        ? (column.mobileCellBuilder?.call(context, row) ?? column.cellBuilder(context, row))
        : column.cellBuilder(context, row);

    final explicitMessage = column.tooltipBuilder?.call(row)?.trim();
    final inferredMessage = _inferTooltipFromWidget(cellWidget)?.trim();
    final tooltipMessage = (explicitMessage != null && explicitMessage.isNotEmpty)
        ? explicitMessage
        : (inferredMessage != null && inferredMessage.isNotEmpty)
        ? inferredMessage
        : column.label;

    return Tooltip(message: tooltipMessage, child: cellWidget);
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
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
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, T row, {required bool compact}) {
    final key = rowId(row);
    if (busyRowIds.contains(key)) {
      return const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2));
    }

    final visibleActions = actions.where((action) => action.isVisible?.call(row) ?? true).toList(growable: false);
    if (visibleActions.isEmpty) {
      return const SizedBox.shrink();
    }

    final disabledColor = Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.42);

    return Wrap(
      spacing: compact ? 2 : 4,
      runSpacing: compact ? 2 : 4,
      alignment: WrapAlignment.end,
      children: [
        for (final action in visibleActions)
          Builder(
            builder: (context) {
              final enabled = action.isEnabled?.call(row) ?? true;
              final color = enabled ? _actionColor(context, action.tone) : disabledColor;
              final icon = action.iconBuilder?.call(row) ?? action.icon;
              final tooltip = action.tooltipBuilder?.call(row) ?? action.tooltip;

              return IconButton(
                tooltip: tooltip,
                visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
                onPressed: enabled ? () => _handleActionTap(action, row) : null,
                icon: Icon(icon, size: compact ? 19 : 20, color: color),
              );
            },
          ),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(showSelection ? 2 : 12, 8, 12, 8),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh),
      child: Row(
        children: [
          if (showSelection) const SizedBox(width: 40),
          for (var i = 0; i < columns.length; i++) ...[
            Expanded(
              flex: columns[i].flex,
              child: Builder(
                builder: (context) {
                  final headerText = Text(
                    columns[i].label,
                    textAlign: _headerTextAlign(columns[i].alignment),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  );

                  final headerTooltip = columns[i].headerTooltip?.trim();
                  if (headerTooltip == null || headerTooltip.isEmpty) {
                    return headerText;
                  }

                  return Tooltip(message: headerTooltip, child: headerText);
                },
              ),
            ),
            if (i < columns.length - 1) const SizedBox(width: 8),
          ],
          if (actions.isNotEmpty)
            SizedBox(
              width: actionsColumnWidth,
              child: actionsColumnWidth >= 80
                  ? Text(
                      'Actions',
                      textAlign: TextAlign.end,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(BuildContext context, T row, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = showSelection && selectedRowIds.contains(rowId(row));
    final backgroundColor = isSelected
        ? colorScheme.primaryContainer.withValues(alpha: 0.15)
        : index.isEven
        ? colorScheme.surfaceContainerLowest.withValues(alpha: 0.55)
        : colorScheme.surfaceContainerLow.withValues(alpha: 0.48);

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onRowTap == null ? null : () => _handleRowTap(row),
        child: Padding(
          padding: EdgeInsets.fromLTRB(showSelection ? 2 : 12, 8, 12, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showSelection)
                SizedBox(
                  width: 40,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: onSelectionChanged == null ? null : (value) => onSelectionChanged!(row, value ?? false),
                  ),
                ),
              for (var i = 0; i < columns.length; i++) ...[
                Expanded(
                  flex: columns[i].flex,
                  child: Align(
                    alignment: _cellAlignment(columns[i].alignment),
                    child: _buildCellWithTooltip(context, columns[i], row, mobile: false),
                  ),
                ),
                if (i < columns.length - 1) const SizedBox(width: 8),
              ],
              if (actions.isNotEmpty)
                SizedBox(
                  width: actionsColumnWidth,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildActionButtons(context, row, compact: false),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopList(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.34);
    const radius = Radius.circular(18);

    return ListView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: rows.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topLeft: radius, topRight: radius),
              border: Border(
                top: BorderSide(color: borderColor),
                left: BorderSide(color: borderColor),
                right: BorderSide(color: borderColor),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: radius, topRight: radius),
              child: _buildDesktopHeader(context),
            ),
          );
        }

        final row = rows[index - 1];
        final isLastRow = index == rows.length;
        return RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: isLastRow
                  ? const BorderRadius.only(bottomLeft: radius, bottomRight: radius)
                  : BorderRadius.zero,
              border: Border(
                left: BorderSide(color: borderColor),
                right: BorderSide(color: borderColor),
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: ClipRRect(
              borderRadius: isLastRow
                  ? const BorderRadius.only(bottomLeft: radius, bottomRight: radius)
                  : BorderRadius.zero,
              child: _buildDesktopRow(context, row, index - 1),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileRowCard(BuildContext context, T row) {
    final colorScheme = Theme.of(context).colorScheme;
    final mobileColumns = columns.where((column) => column.showOnMobile).toList(growable: false);
    final isSelected = showSelection && selectedRowIds.contains(rowId(row));

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.15) : colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.28),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: (onRowTap == null && (!showSelection || onSelectionChanged == null))
            ? null
            : () {
                if (showSelection && selectedRowIds.isNotEmpty && onSelectionChanged != null) {
                  onSelectionChanged!(row, !isSelected);
                } else if (onRowTap != null) {
                  _handleRowTap(row);
                }
              },
        onLongPress: showSelection && onSelectionChanged != null ? () => onSelectionChanged!(row, !isSelected) : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < mobileColumns.length; index++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: Builder(
                        builder: (context) {
                          final labelText = Text(
                            mobileColumns[index].label,
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          );

                          final headerTooltip = mobileColumns[index].headerTooltip?.trim();
                          if (headerTooltip == null || headerTooltip.isEmpty) {
                            return labelText;
                          }

                          return Tooltip(message: headerTooltip, child: labelText);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: _buildCellWithTooltip(context, mobileColumns[index], row, mobile: true),
                      ),
                    ),
                  ],
                ),
                if (index != mobileColumns.length - 1) const SizedBox(height: 8),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 8),
                Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.25), height: 1),
                const SizedBox(height: 4),
                Align(alignment: Alignment.centerRight, child: _buildActionButtons(context, row, compact: true)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context) {
    return ListView.separated(
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemCount: rows.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return RepaintBoundary(child: _buildMobileRowCard(context, rows[index]));
      },
    );
  }

  Widget _buildProgressList() {
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

  Widget _buildTableBody(BuildContext context) {
    if (columns.isEmpty) {
      return _buildEmptyList(context);
    }

    if (loading && rows.isEmpty) {
      return _buildProgressList();
    }

    if (rows.isEmpty) {
      return _buildEmptyList(context);
    }

    return context.isMobile ? _buildMobileList(context) : _buildDesktopList(context);
  }

  @override
  Widget build(BuildContext context) {
    final tableBody = _buildTableBody(context);
    final actions = topActions;
    if (actions == null) {
      return tableBody;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final hasBoundedHeight = constraints.hasBoundedHeight && maxHeight.isFinite;
        final minHeightForActions = 72.0 + topActionsSpacing;

        // In very small viewports, prioritizing table scroll space avoids flex overflow.
        if (!hasBoundedHeight || maxHeight <= minHeightForActions) {
          if (shrinkWrap) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: topActionsPadding, child: actions),
                SizedBox(height: topActionsSpacing),
                tableBody,
              ],
            );
          }
          return tableBody;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: topActionsPadding, child: actions),
            SizedBox(height: topActionsSpacing),
            Expanded(child: tableBody),
          ],
        );
      },
    );
  }
}
