import 'package:flutter/material.dart';

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

class YaabsaTextField extends StatelessWidget {
  const YaabsaTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      enabled: enabled,
      decoration: yaabsaFieldDecoration(context, label: label, hintText: hintText),
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

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      isExpanded: isExpanded,
      borderRadius: BorderRadius.circular(12),
      menuMaxHeight: 320,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: yaabsaFieldDecoration(context, label: label, hintText: hintText),
    );
  }
}
