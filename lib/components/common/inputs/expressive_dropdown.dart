import 'package:flutter/material.dart';

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
    final T? selectedValue = options.any((option) => option.value == value)
        ? value
        : options.isEmpty
        ? null
        : options.first.value;

    final TextStyle? effectiveTextStyle =
        textStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
          fontWeight: FontWeight.w500,
        );

    final ButtonStyle baseEntryStyle = MenuItemButton.styleFrom(
      padding: entryPadding,
      minimumSize: Size.fromHeight(entryMinHeight),
      textStyle: effectiveTextStyle,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    final List<DropdownMenuEntry<T>> entries = options
        .map((option) {
          final bool isSelected = option.value == selectedValue;
          final Color foregroundColor = isSelected
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onSurface;

          final Widget? defaultTrailingIcon = showSelectedCheckmark && isSelected
              ? Icon(Icons.check_rounded, size: 18, color: foregroundColor)
              : null;

          return DropdownMenuEntry<T>(
            value: option.value,
            label: option.label,
            enabled: option.enabled,
            labelWidget: option.labelWidget,
            leadingIcon: option.leadingIcon,
            trailingIcon: option.trailingIcon ?? defaultTrailingIcon,
            style: baseEntryStyle.copyWith(
              backgroundColor: WidgetStatePropertyAll<Color?>(
                showSelectedHighlight && isSelected
                    ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.78)
                    : null,
              ),
              foregroundColor: WidgetStatePropertyAll<Color?>(foregroundColor),
              iconColor: WidgetStatePropertyAll<Color?>(foregroundColor),
            ),
          );
        })
        .toList(growable: false);

    final MenuStyle effectiveMenuStyle =
        menuStyle ??
        MenuStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.surfaceContainerHigh),
          surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
          elevation: const WidgetStatePropertyAll<double>(3),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 4)),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double? resolvedWidth = width ?? (constraints.maxWidth.isFinite ? constraints.maxWidth : null);

        return DropdownMenuFormField<T>(
          key: ValueKey<T?>(selectedValue),
          initialSelection: selectedValue,
          enabled: enabled,
          width: resolvedWidth,
          menuHeight: menuHeight,
          selectOnly: selectOnly,
          requestFocusOnTap: requestFocusOnTap,
          dropdownMenuEntries: entries,
          trailingIcon:
              trailingIcon ?? Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
          selectedTrailingIcon:
              selectedTrailingIcon ?? Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onSurfaceVariant),
          alignmentOffset: alignmentOffset,
          menuStyle: effectiveMenuStyle,
          textStyle: effectiveTextStyle,
          decorationBuilder: (context, _) => decoration ?? const InputDecoration(),
          onSelected: enabled ? onChanged : null,
        );
      },
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
    final theme = Theme.of(context);
    final InputDecoration inlineDecoration =
        decoration ??
        InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.34)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.34)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
        );

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
