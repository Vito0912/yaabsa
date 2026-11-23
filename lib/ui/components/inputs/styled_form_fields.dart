import 'package:material_ui/material_ui.dart';

export 'expressive_dropdown.dart' show YaabsaDropdownField;

import 'package:flutter/services.dart';

export 'field_decoration.dart';

import 'field_decoration.dart';

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    this.label,
    this.controller,
    this.onTap,
    this.showCursor,
    this.enableInteractiveSelection = true,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.maxLength,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.autofillHints,
    this.focusNode,
    this.hintText,
    this.helperText,
    this.suffixText,
    this.alignLabelWithHint,
    this.errorText,
    this.maxLines = 1,
    this.expands = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction,
    this.inputFormatters,
    this.autofocus = false,
    this.isDense,
    this.readOnly = false,
    this.style,
    this.enabled = true,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  });

  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final int? maxLength;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool enableInteractiveSelection;
  final bool? showCursor;
  final VoidCallback? onTap;
  final String? label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? helperText;
  final String? suffixText;
  final bool? alignLabelWithHint;
  final String? errorText;
  final int? maxLines;
  final bool expands;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool? isDense;
  final bool readOnly;
  final TextStyle? style;
  final bool enabled;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final decoration =
        yaabsaFieldDecoration(
          context,
          label: label,
          hintText: hintText,
          textStyle: style,
          isDense: isDense ?? false,
          contentPadding: contentPadding,
        ).copyWith(
          helperText: helperText,
          suffixText: suffixText,
          alignLabelWithHint: alignLabelWithHint,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isDense: isDense ?? false,
        );

    return TextField(
      controller: controller,
      onTap: onTap,
      showCursor: showCursor,
      enableInteractiveSelection: enableInteractiveSelection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      maxLength: maxLength,
      minLines: minLines,
      textCapitalization: textCapitalization,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      autofillHints: autofillHints,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLines: maxLines,
      expands: expands,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
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

class StyledTextFormField extends StatelessWidget {
  const StyledTextFormField({
    super.key,
    this.label,
    this.controller,
    this.isDense,
    this.autovalidateMode,
    this.onSaved,
    this.initialValue,
    this.onEditingComplete,
    this.focusNode,
    this.onTap,
    this.showCursor,
    this.enableInteractiveSelection = true,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.minLines,
    this.textCapitalization = TextCapitalization.none,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.autofillHints,
    this.hintText,
    this.helperText,
    this.suffixText,
    this.alignLabelWithHint,
    this.errorText,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.inputFormatters,
    this.autofocus = false,
    this.readOnly = false,
    this.style,
    this.enabled = true,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  });

  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final int? maxLength;
  final TextAlign textAlign;
  final bool enableInteractiveSelection;
  final bool? showCursor;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final String? initialValue;
  final FormFieldSetter<String>? onSaved;
  final AutovalidateMode? autovalidateMode;
  final bool? isDense;
  final String? label;
  final TextEditingController? controller;
  final String? hintText;
  final String? helperText;
  final String? suffixText;
  final bool? alignLabelWithHint;
  final String? errorText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool readOnly;
  final TextStyle? style;
  final bool enabled;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final decoration =
        yaabsaFieldDecoration(
          context,
          label: label,
          hintText: hintText,
          textStyle: style,
          isDense: isDense ?? false,
          contentPadding: contentPadding,
        ).copyWith(
          helperText: helperText,
          suffixText: suffixText,
          alignLabelWithHint: alignLabelWithHint,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isDense: isDense ?? false,
        );

    return TextFormField(
      controller: controller,
      autovalidateMode: autovalidateMode,
      onSaved: onSaved,
      initialValue: initialValue,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      onTap: onTap,
      showCursor: showCursor,
      enableInteractiveSelection: enableInteractiveSelection,
      textAlign: textAlign,
      maxLength: maxLength,
      minLines: minLines,
      textCapitalization: textCapitalization,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      autofillHints: autofillHints,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      readOnly: readOnly,
      style: style,
      enabled: enabled,
      obscureText: obscureText,
      decoration: decoration,
      validator: validator,
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
