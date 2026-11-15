import 'package:material_ui/material_ui.dart';

import 'styled_form_fields.dart';

class YaabsaSearchField extends StatelessWidget {
  const YaabsaSearchField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.suffixIcon,
    this.autofocus = false,
    this.enabled = true,
    this.isDense = true,
    this.style,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  });

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final Widget? suffixIcon;
  final bool autofocus;
  final bool enabled;
  final bool isDense;
  final TextStyle? style;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      label: label,
      controller: controller,
      hintText: hintText,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      autofocus: autofocus,
      enabled: enabled,
      isDense: isDense,
      style: style,
      contentPadding: contentPadding,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon:
          suffixIcon ??
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                tooltip: 'Clear search',
                onPressed: enabled
                    ? () {
                        if (onClear != null) {
                          onClear!();
                          return;
                        }

                        controller.clear();
                        onChanged?.call('');
                      }
                    : null,
                icon: const Icon(Icons.close_rounded),
              );
            },
          ),
    );
  }
}
