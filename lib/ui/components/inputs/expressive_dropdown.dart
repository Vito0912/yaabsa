import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/field_decoration.dart';

class YaabsaDropdownOption<T> {
  const YaabsaDropdownOption({
    required this.value,
    required this.label,
    this.enabled = true,
    this.leadingIcon,
    this.trailingIcon,
    this.labelWidget,
  });

  final T value;
  final String label;
  final bool enabled;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Widget? labelWidget;
}

class YaabsaExpressiveDropdownField<T> extends StatelessWidget {
  const YaabsaExpressiveDropdownField({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.focusNode,
    this.width,
    this.menuHeight = 320,
    this.decoration,
    this.textStyle,
    this.menuStyle,
    this.selectOnly = true,
    this.requestFocusOnTap = false,
    this.alignmentOffset = const Offset(0, 4),
    this.showSelectedCheckmark = true,
    this.showSelectedHighlight = true,
    this.trailingIcon,
    this.selectedTrailingIcon,
    this.entryPadding = const EdgeInsetsDirectional.only(start: 8, end: 10),
    this.entryMinHeight = 44,
  });

  final List<YaabsaDropdownOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final FocusNode? focusNode;
  final double? width;
  final double menuHeight;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final MenuStyle? menuStyle;
  final bool selectOnly;
  final bool requestFocusOnTap;
  final Offset alignmentOffset;
  final bool showSelectedCheckmark;
  final bool showSelectedHighlight;
  final Widget? trailingIcon;
  final Widget? selectedTrailingIcon;
  final EdgeInsetsGeometry entryPadding;
  final double entryMinHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sourceDecoration = decoration;
    final fieldDecoration = _fieldDecoration(context);
    final selectedValue = _resolveSelectedValue();
    final foregroundColor = enabled ? theme.colorScheme.onSurface : theme.disabledColor;
    final fieldLabel = fieldDecoration.labelText;
    final fieldHint = fieldDecoration.hintText;
    final menuBackground = menuStyle?.backgroundColor?.resolve(const <WidgetState>{});
    final menuElevation = menuStyle?.elevation?.resolve(const <WidgetState>{});
    final menuRadius = _menuRadius(menuStyle);
    final verticalPadding = yaabsaDropdownFieldVerticalPadding(
      context,
      fieldDecoration,
      textStyle: textStyle ?? theme.textTheme.bodyMedium ?? const TextStyle(),
      suffixIcon: _fieldSuffixIcon(context, fieldDecoration),
    );

    final items = [
      for (final option in options)
        M3EDropdownItem<T>(
          value: option.value,
          label: option.label,
          disabled: !option.enabled,
          selected: option.value == selectedValue,
        ),
    ];

    final dropdown = M3EDropdownMenu<T>(
      items: items,
      singleSelect: true,
      showChipAnimation: false,
      enabled: enabled && (sourceDecoration?.enabled ?? true),
      focusNode: focusNode,
      containerRadius: 12,
      fieldStyle: M3EDropdownFieldStyle(
        hintText: fieldHint ?? fieldLabel ?? 'Select',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        selectedTextStyle: textStyle ?? theme.textTheme.bodyMedium,
        prefixIcon: fieldDecoration.prefixIcon,
        suffixIcon: _fieldSuffixIcon(context, fieldDecoration),
        showArrow: trailingIcon == null && fieldDecoration.suffixIcon == null,
        padding: EdgeInsetsDirectional.fromSTEB(12, verticalPadding, 10, verticalPadding),
        backgroundColor: fieldDecoration.fillColor ?? theme.colorScheme.surfaceContainer,
        foregroundColor: foregroundColor,
        border: _borderSide(fieldDecoration.enabledBorder ?? fieldDecoration.border),
        focusedBorder: _borderSide(fieldDecoration.focusedBorder ?? fieldDecoration.enabledBorder),
        errorBorder: _borderSide(fieldDecoration.errorBorder ?? fieldDecoration.enabledBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      dropdownStyle: M3EDropdownPanelStyle(
        backgroundColor: menuBackground ?? theme.colorScheme.surfaceContainerHigh,
        elevation: menuElevation ?? 3,
        maxHeight: menuHeight,
        containerRadius: menuRadius,
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      ),
      itemStyle: M3EDropdownItemStyle(
        itemPadding: entryPadding,
        textStyle: textStyle ?? theme.textTheme.bodyMedium,
        selectedBackgroundColor: showSelectedHighlight
            ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.78)
            : Colors.transparent,
        selectedTextColor: theme.colorScheme.onSecondaryContainer,
        selectedIcon: showSelectedCheckmark
            ? Icon(Icons.check_rounded, size: 18, color: theme.colorScheme.onSecondaryContainer)
            : const SizedBox.shrink(),
        outerRadius: 10,
        innerRadius: 8,
        itemGap: 2,
      ),
      itemBuilder: (item, {required selected, required onTap}) =>
          _buildOptionItem(context, item, selected: selected, onTap: onTap, foregroundColor: foregroundColor),
      selectedItemBuilder: (item) => _buildSelectedItem(context, item, fieldLabel),
      onSelectionChanged: (items) {
        onChanged?.call(items.isEmpty ? null : items.first.value);
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedWidth = width ?? (constraints.maxWidth.isFinite ? constraints.maxWidth : null);
        final boundedWidth = resolvedWidth != null && constraints.maxWidth.isFinite
            ? resolvedWidth.clamp(0, constraints.maxWidth).toDouble()
            : resolvedWidth;
        final errorText = fieldDecoration.errorText;
        final helperText = fieldDecoration.helperText;

        return SizedBox(
          width: boundedWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(constraints: fieldDecoration.constraints ?? const BoxConstraints(), child: dropdown),
              if (errorText != null && errorText.isNotEmpty)
                _buildSupportingText(context, errorText, color: theme.colorScheme.error)
              else if (helperText != null && helperText.isNotEmpty)
                _buildSupportingText(context, helperText, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        );
      },
    );
  }

  T? _resolveSelectedValue() {
    if (options.any((option) => option.value == value)) {
      return value;
    }
    return options.isEmpty ? null : options.first.value;
  }

  Widget _buildOptionItem(
    BuildContext context,
    M3EDropdownItem<T> item, {
    required bool selected,
    required VoidCallback onTap,
    required Color foregroundColor,
  }) {
    final theme = Theme.of(context);
    final option = options.firstWhere(
      (candidate) => candidate.value == item.value,
      orElse: () => YaabsaDropdownOption<T>(value: item.value, label: item.label, enabled: false),
    );
    final itemColor = item.disabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
        : selected && showSelectedHighlight
        ? theme.colorScheme.onSecondaryContainer
        : foregroundColor;

    return M3ECard(
      variant: M3ECardVariant.filled,
      borderRadius: BorderRadius.circular(selected ? 10 : 8),
      color: selected && showSelectedHighlight
          ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.78)
          : Colors.transparent,
      elevation: 0,
      padding: entryPadding,
      width: double.infinity,
      focusable: false,
      showFocusRing: false,
      onPressed: item.disabled ? null : onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: entryMinHeight),
        child: Row(
          children: [
            if (option.leadingIcon != null) ...[option.leadingIcon!, const SizedBox(width: 8)],
            Expanded(
              child: DefaultTextStyle(
                style: textStyle ?? theme.textTheme.bodyMedium ?? const TextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: IconTheme(
                  data: IconThemeData(color: itemColor, size: 18),
                  child: option.labelWidget ?? Text(item.label, style: TextStyle(color: itemColor)),
                ),
              ),
            ),
            if (option.trailingIcon != null)
              option.trailingIcon!
            else if (selected && showSelectedCheckmark)
              Icon(Icons.check_rounded, size: 18, color: itemColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedItem(BuildContext context, M3EDropdownItem<T> item, String? fieldLabel) {
    final option = options.firstWhere(
      (candidate) => candidate.value == item.value,
      orElse: () => YaabsaDropdownOption<T>(value: item.value, label: item.label, enabled: false),
    );
    final theme = Theme.of(context);
    final selectedText = option.labelWidget ?? Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis);

    if (fieldLabel == null || fieldLabel.isEmpty) {
      return DefaultTextStyle(
        style: textStyle ?? theme.textTheme.bodyMedium ?? const TextStyle(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: selectedText,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldLabel, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelSmall),
        DefaultTextStyle(
          style: textStyle ?? theme.textTheme.bodyMedium ?? const TextStyle(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: selectedText,
        ),
      ],
    );
  }

  Widget? _fieldSuffixIcon(BuildContext context, InputDecoration decoration) {
    final explicitSuffix = decoration.suffixIcon;
    if (explicitSuffix != null) {
      return explicitSuffix;
    }
    if (trailingIcon != null) {
      return trailingIcon;
    }
    final theme = Theme.of(context);
    return Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant);
  }

  BorderSide? _borderSide(InputBorder? border) {
    if (border is OutlineInputBorder) {
      return border.borderSide;
    }
    return null;
  }

  double? _menuRadius(MenuStyle? style) {
    final shape = style?.shape?.resolve(const <WidgetState>{});
    if (shape is RoundedRectangleBorder) {
      final radius = shape.borderRadius.resolve(TextDirection.ltr).topLeft.x;
      return radius;
    }
    return null;
  }

  InputDecoration _fieldDecoration(BuildContext context) {
    final sourceDecoration = decoration;
    final isDense = sourceDecoration?.isDense ?? false;
    final contentPadding = isDense
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 12);

    final baseDecoration = yaabsaFieldDecoration(
      context,
      contentPadding: contentPadding,
      isDense: isDense,
      textStyle: textStyle,
    );

    return baseDecoration.copyWith(
      labelText: sourceDecoration?.labelText,
      hintText: sourceDecoration?.hintText,
      helperText: sourceDecoration?.helperText,
      errorText: sourceDecoration?.errorText,
      prefixIcon: sourceDecoration?.prefixIcon,
      suffixIcon: sourceDecoration?.suffixIcon,
      alignLabelWithHint: sourceDecoration?.alignLabelWithHint,
      isDense: isDense,
      enabled: enabled && (sourceDecoration?.enabled ?? true),
      constraints: yaabsaFieldConstraints(sourceDecoration?.constraints, baseDecoration.constraints),
    );
  }

  Widget _buildSupportingText(BuildContext context, String text, {required Color color}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, top: 5),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
    );
  }
}

class YaabsaExpressiveDropdown<T> extends StatelessWidget {
  const YaabsaExpressiveDropdown({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.width,
    this.menuHeight = 320,
    this.decoration,
    this.textStyle,
    this.menuStyle,
    this.alignmentOffset = const Offset(0, 4),
    this.showSelectedCheckmark = true,
    this.showSelectedHighlight = true,
    this.entryPadding = const EdgeInsetsDirectional.only(start: 8, end: 10),
    this.entryMinHeight = 40,
  });

  final List<YaabsaDropdownOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final double? width;
  final double menuHeight;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final MenuStyle? menuStyle;
  final Offset alignmentOffset;
  final bool showSelectedCheckmark;
  final bool showSelectedHighlight;
  final EdgeInsetsGeometry entryPadding;
  final double entryMinHeight;

  @override
  Widget build(BuildContext context) {
    final inlineDecoration =
        decoration ??
        yaabsaFieldDecoration(
          context,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ).copyWith(isDense: true);

    return YaabsaExpressiveDropdownField<T>(
      options: options,
      value: value,
      onChanged: onChanged,
      enabled: enabled,
      width: width,
      menuHeight: menuHeight,
      decoration: inlineDecoration,
      textStyle: textStyle,
      menuStyle: menuStyle,
      alignmentOffset: alignmentOffset,
      showSelectedCheckmark: showSelectedCheckmark,
      showSelectedHighlight: showSelectedHighlight,
      entryPadding: entryPadding,
      entryMinHeight: entryMinHeight,
    );
  }
}

class YaabsaDropdownField<T> extends StatelessWidget {
  const YaabsaDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.enabled = true,
    this.isExpanded = true,
    this.isDense = false,
    this.focusNode,
  });

  final String label;
  final T? value;
  final String? hintText;
  final bool enabled;
  final bool isExpanded;
  final bool isDense;
  final FocusNode? focusNode;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  List<YaabsaDropdownOption<T>> _mapItemsToOptions() {
    return items
        .where((item) => item.value != null || null is T)
        .map(
          (item) => YaabsaDropdownOption<T>(
            value: item.value as T,
            label: _extractDropdownItemLabel(item.child),
            enabled: item.enabled,
            labelWidget: item.child,
          ),
        )
        .toList(growable: false);
  }

  String _extractDropdownItemLabel(Widget child) {
    if (child is Text) {
      return child.data ?? child.textSpan?.toPlainText() ?? '';
    }
    return child.toStringShort();
  }

  @override
  Widget build(BuildContext context) {
    return YaabsaExpressiveDropdownField<T>(
      value: value,
      options: _mapItemsToOptions(),
      onChanged: enabled ? onChanged : null,
      decoration: yaabsaFieldDecoration(
        context,
        label: label,
        hintText: hintText,
        isDense: isDense,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: isDense ? 8 : 12),
      ),
      focusNode: focusNode,
    );
  }
}
