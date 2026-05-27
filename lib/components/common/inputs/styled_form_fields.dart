import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';

InputDecoration yaabsaFieldDecoration(
  BuildContext context, {
  required String label,
  String? hintText,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.34)),
  );
  final focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
  );

  return InputDecoration(
    labelText: label,
    hintText: hintText,
    filled: true,
    fillColor: colorScheme.surfaceContainer,
    contentPadding: contentPadding,
    border: defaultBorder,
    enabledBorder: defaultBorder,
    focusedBorder: focusedBorder,
  );
}

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.helperText,
    this.errorText,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.inputFormatters,
    this.autofocus = false,
    this.readOnly = false,
    this.style,
    this.enabled = true,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool readOnly;
  final TextStyle? style;
  final bool enabled;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final decoration = yaabsaFieldDecoration(
      context,
      label: label,
      hintText: hintText,
      contentPadding: contentPadding,
    ).copyWith(helperText: helperText, errorText: errorText, prefixIcon: prefixIcon, suffixIcon: suffixIcon);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      readOnly: readOnly,
      style: style,
      enabled: enabled,
      obscureText: obscureText,
      decoration: decoration,
    );
  }
}

class InlineTextField extends StatelessWidget {
  const InlineTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.inputFormatters,
    this.autofocus = false,
    this.enabled = true,
    this.style,
    this.textAlignVertical,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool enabled;
  final TextStyle? style;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      enabled: enabled,
      style: style,
      textAlignVertical: textAlignVertical,
      decoration: InputDecoration.collapsed(hintText: hintText),
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
  });

  final String label;
  final T? value;
  final String? hintText;
  final bool enabled;
  final bool isExpanded;
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
      decoration: yaabsaFieldDecoration(context, label: label, hintText: hintText),
    );
  }
}
