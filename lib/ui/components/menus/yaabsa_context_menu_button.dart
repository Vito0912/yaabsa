import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';

typedef YaabsaContextMenuNodeBuilder = List<M3EMenuNode> Function(BuildContext context);

class YaabsaContextMenuButton<T> extends StatefulWidget {
  const YaabsaContextMenuButton({
    super.key,
    this.itemBuilder,
    this.menuNodeBuilder,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.padding = const EdgeInsets.all(8),
    this.child,
    this.icon,
    this.iconSize,
    this.offset = Offset.zero,
    this.enabled = true,
    this.iconColor,
    this.shape,
    this.color,
    this.elevation,
    this.constraints,
    this.position,
    this.style,
    this.menuVariant = M3EMenuVariant.vertical,
    this.triggerVariant,
    this.triggerShape = YaabsaActionButtonShape.round,
    this.compact = true,
    this.buttonSize,
  }) : assert(!(child != null && icon != null), 'Only one of child or icon can be provided.'),
       assert(itemBuilder != null || menuNodeBuilder != null),
       assert(itemBuilder == null || menuNodeBuilder == null);

  final PopupMenuItemBuilder<T>? itemBuilder;
  final YaabsaContextMenuNodeBuilder? menuNodeBuilder;
  final T? initialValue;
  final VoidCallback? onOpened;
  final PopupMenuItemSelected<T>? onSelected;
  final PopupMenuCanceled? onCanceled;
  final String? tooltip;
  final EdgeInsetsGeometry padding;
  final Widget? child;
  final Widget? icon;
  final double? iconSize;
  final Offset offset;
  final bool enabled;
  final Color? iconColor;
  final ShapeBorder? shape;
  final Color? color;
  final double? elevation;
  final BoxConstraints? constraints;
  final PopupMenuPosition? position;
  final ButtonStyle? style;
  final M3EMenuVariant menuVariant;
  final YaabsaActionButtonVariant? triggerVariant;
  final YaabsaActionButtonShape triggerShape;
  final bool compact;
  final double? buttonSize;

  @override
  State<YaabsaContextMenuButton<T>> createState() => _YaabsaContextMenuButtonState<T>();
}

Future<T?> showYaabsaContextMenuAt<T>({
  required BuildContext context,
  required Offset globalPosition,
  required List<M3EMenuNode> children,
  M3EMenuVariant variant = M3EMenuVariant.baseline,
  BoxConstraints? constraints,
}) {
  if (children.isEmpty) {
    return Future<T?>.value();
  }

  final screenHeight = MediaQuery.sizeOf(context).height;
  final maxHeight = constraints?.maxHeight ?? (screenHeight - 32).clamp(0.0, double.infinity).toDouble();
  final preferredWidth = constraints?.maxWidth;
  final baseMenuTheme = M3ETheme.of(context).menuTheme.metricsFor(variant);

  return showM3EMenu<T>(
    context: context,
    anchor: Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 1, 1),
    children: children,
    position: M3EMenuAnchorPosition.bottomStart,
    variant: variant,
    preferredWidth: preferredWidth != null && preferredWidth.isFinite ? preferredWidth : null,
    themeOverride: baseMenuTheme.copyWith(maxHeight: maxHeight),
  );
}

class _YaabsaContextMenuButtonState<T> extends State<YaabsaContextMenuButton<T>> {
  final GlobalKey _anchorKey = GlobalKey();
  final FocusNode _focusNode = FocusNode(debugLabel: 'YaabsaContextMenuAnchor');
  bool _isOpen = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _openMenu() async {
    if (!widget.enabled || _isOpen) {
      return;
    }

    final anchorContext = _anchorKey.currentContext;
    if (anchorContext == null) {
      return;
    }

    final anchor = m3eOverlayRectFor(anchorContext);
    if (anchor == null) {
      return;
    }

    final nodes = _buildMenuNodes(anchorContext);
    if (nodes.isEmpty) {
      return;
    }

    setState(() {
      _isOpen = true;
    });
    widget.onOpened?.call();

    final selection = await showM3EMenu<T>(
      context: context,
      anchor: anchor,
      children: nodes,
      position: _menuPosition,
      selectedValue: widget.initialValue,
      variant: widget.menuVariant,
      preferredWidth: _preferredWidth,
      callerFocusNode: _focusNode,
      themeOverride: _menuTheme(context),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isOpen = false;
    });

    if (selection == null) {
      widget.onCanceled?.call();
      return;
    }

    widget.onSelected?.call(selection);
  }

  KeyEventResult _onAnchorKey(FocusNode node, KeyEvent event) {
    if (_isOpen || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    final shouldOpen =
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.space;
    if (!shouldOpen) {
      return KeyEventResult.ignored;
    }

    unawaited(_openMenu());
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final anchor = widget.child == null ? _buildIconButton() : _buildCustomButton();

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onAnchorKey,
      child: KeyedSubtree(key: _anchorKey, child: anchor),
    );
  }

  Widget _buildIconButton() {
    final triggerVariant = widget.triggerVariant;
    if (triggerVariant != null) {
      final resolvedIconSize = widget.iconSize ?? 19;
      final customIcon = widget.icon;
      final isPlainIcon =
          customIcon is Icon &&
          customIcon.icon != null &&
          customIcon.size == null &&
          customIcon.color == null &&
          widget.iconColor == null;
      final IconData? iconData = customIcon == null
          ? Icons.more_vert_rounded
          : isPlainIcon
          ? customIcon.icon
          : null;
      final Widget? iconWidget = customIcon != null && !isPlainIcon
          ? IconTheme.merge(
              data: IconThemeData(size: resolvedIconSize, color: widget.iconColor),
              child: customIcon,
            )
          : null;

      return YaabsaActionIconButton(
        icon: iconData,
        iconWidget: iconWidget,
        tooltip: widget.tooltip ?? '',
        onPressed: widget.enabled ? _openMenu : null,
        enabled: widget.enabled,
        iconSize: resolvedIconSize,
        compact: widget.compact,
        buttonSize: widget.buttonSize,
        variant: triggerVariant,
        shape: widget.triggerShape,
      );
    }

    return IconButton(
      focusNode: _focusNode,
      tooltip: widget.tooltip,
      padding: widget.padding,
      iconSize: widget.iconSize,
      color: widget.iconColor,
      style: widget.style,
      onPressed: widget.enabled ? _openMenu : null,
      icon: widget.icon ?? const Icon(Icons.more_vert_rounded),
    );
  }

  Widget _buildCustomButton() {
    final button = InkWell(
      focusNode: _focusNode,
      borderRadius: BorderRadius.circular(12),
      onTap: widget.enabled ? _openMenu : null,
      child: widget.child,
    );
    final tooltip = widget.tooltip;

    if (tooltip == null || tooltip.isEmpty) {
      return button;
    }

    return Tooltip(message: tooltip, child: button);
  }

  List<M3EMenuNode> _buildMenuNodes(BuildContext context) {
    final nodeBuilder = widget.menuNodeBuilder;
    if (nodeBuilder != null) {
      return nodeBuilder(context);
    }

    final itemBuilder = widget.itemBuilder;
    if (itemBuilder == null) {
      return const [];
    }

    final popupItems = itemBuilder(context);
    final nodes = <M3EMenuNode>[];

    for (final entry in popupItems) {
      if (entry is PopupMenuDivider) {
        nodes.add(const M3EMenuDivider());
        continue;
      }

      if (entry is! PopupMenuItem<T>) {
        continue;
      }

      final child = entry.child ?? const SizedBox.shrink();
      final label = _textLabel(child);
      final itemValue = entry.value;
      final selected = itemValue != null && itemValue == widget.initialValue;

      if (label == null || itemValue == null) {
        nodes.add(
          M3EMenuWidget(
            child: DefaultTextStyle(style: entry.textStyle ?? Theme.of(context).textTheme.bodyLarge!, child: child),
            semanticLabel: _semanticLabel(child),
            value: itemValue,
            onPressed: entry.onTap,
            enabled: entry.enabled,
            selected: selected,
          ),
        );
        continue;
      }

      if (entry is CheckedPopupMenuItem<T>) {
        nodes.add(
          M3EMenuSelectable(
            label: label,
            value: itemValue,
            selected: entry.checked || selected,
            enabled: entry.enabled,
            onPressed: entry.onTap,
          ),
        );
        continue;
      }

      final textWidget = child as Text;
      final isDestructive = textWidget.style?.color == Theme.of(context).colorScheme.error;
      nodes.add(
        M3EMenuEntry(
          label: label,
          value: itemValue,
          isDestructive: isDestructive,
          enabled: entry.enabled,
          onPressed: entry.onTap,
        ),
      );
    }

    return nodes;
  }

  String? _textLabel(Widget child) {
    if (child is Text) {
      final text = child.data ?? child.textSpan?.toPlainText();
      return text?.trim().isEmpty == true ? null : text;
    }

    if (child is Padding) {
      return _textLabel(child.child ?? const SizedBox.shrink());
    }

    return null;
  }

  String? _semanticLabel(Widget child) {
    final text = _textLabel(child);
    if (text != null) {
      return text;
    }

    if (child is Tooltip) {
      return child.message;
    }

    return null;
  }

  M3EMenuAnchorPosition get _menuPosition {
    final preferBelow = widget.position == PopupMenuPosition.under || widget.offset.dy > 0;
    if (preferBelow) {
      return widget.offset.dx < 0 ? M3EMenuAnchorPosition.bottomStart : M3EMenuAnchorPosition.bottomEnd;
    }
    if (widget.position == PopupMenuPosition.over) {
      return widget.offset.dx < 0 ? M3EMenuAnchorPosition.topStart : M3EMenuAnchorPosition.topEnd;
    }
    return M3EMenuAnchorPosition.bottomEnd;
  }

  double? get _preferredWidth {
    final maxWidth = widget.constraints?.maxWidth;
    if (maxWidth == null || !maxWidth.isFinite) {
      return null;
    }
    return maxWidth;
  }

  M3EMenuTheme _menuTheme(BuildContext context) {
    final baseTheme = M3ETheme.of(context).menuTheme.metricsFor(widget.menuVariant);
    final maxHeight = widget.constraints?.maxHeight;
    final radius = _shapeRadius(widget.shape);

    return baseTheme.copyWith(
      maxHeight: maxHeight != null && maxHeight.isFinite ? maxHeight : null,
      containerRadius: radius,
      containerBottomRadius: radius,
      backgroundColor: widget.color,
      elevation: widget.elevation,
    );
  }

  double? _shapeRadius(ShapeBorder? shape) {
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius.resolve(Directionality.of(context)).topLeft.x;
    }
    return null;
  }
}
