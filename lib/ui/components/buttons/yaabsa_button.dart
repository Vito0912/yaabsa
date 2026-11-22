import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/theme/component_styles.dart';

enum YaabsaButtonVariant { filled, tonal, outlined, text, elevated }

enum YaabsaButtonSize { regular, small }

class YaabsaButton extends StatelessWidget {
  const YaabsaButton({
    super.key,
    required Widget this.label,
    required this.onPressed,
    this.icon,
    this.variant = YaabsaButtonVariant.filled,
    this.size = YaabsaButtonSize.regular,
    this.isLoading = false,
    this.tooltip,
    this.style,
  }) : _iconOnly = false;

  const YaabsaButton.small({
    Key? key,
    required Widget label,
    required VoidCallback? onPressed,
    Widget? icon,
    YaabsaButtonVariant variant = YaabsaButtonVariant.filled,
    bool isLoading = false,
    String? tooltip,
    ButtonStyle? style,
  }) : this(
         key: key,
         label: label,
         onPressed: onPressed,
         icon: icon,
         variant: variant,
         size: YaabsaButtonSize.small,
         isLoading: isLoading,
         tooltip: tooltip,
         style: style,
       );

  const YaabsaButton.iconSmall({
    super.key,
    required Widget this.icon,
    required String this.tooltip,
    required this.onPressed,
    this.variant = YaabsaButtonVariant.filled,
    this.isLoading = false,
    this.style,
  }) : label = null,
       size = YaabsaButtonSize.small,
       _iconOnly = true;

  final Widget? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final YaabsaButtonVariant variant;
  final YaabsaButtonSize size;
  final bool isLoading;
  final String? tooltip;
  final ButtonStyle? style;
  final bool _iconOnly;

  @override
  Widget build(BuildContext context) {
    ButtonStyle? sizeStyle;
    if (size == YaabsaButtonSize.small) {
      sizeStyle = YaabsaButtonStyles.toolbarAction;
      if (_iconOnly) {
        sizeStyle = sizeStyle.copyWith(
          maximumSize: const WidgetStatePropertyAll<Size>(Size(40, 40)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
        );
      }
    }

    final effectiveStyle = sizeStyle?.merge(style) ?? style;
    final effectiveOnPressed = isLoading ? null : onPressed;
    final effectiveIcon = isLoading
        ? const SizedBox.square(dimension: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
        : icon;
    final button = _buildButton(onPressed: effectiveOnPressed, style: effectiveStyle, icon: effectiveIcon);
    final tooltip = this.tooltip;
    if (tooltip == null) {
      return button;
    }

    return Tooltip(message: tooltip, child: button);
  }

  Widget _buildButton({required VoidCallback? onPressed, required ButtonStyle? style, required Widget? icon}) {
    final label = this.label;
    if (!_iconOnly && icon != null && label != null) {
      return switch (variant) {
        YaabsaButtonVariant.filled => FilledButton.icon(onPressed: onPressed, style: style, icon: icon, label: label),
        YaabsaButtonVariant.tonal => FilledButton.tonalIcon(
          onPressed: onPressed,
          style: style,
          icon: icon,
          label: label,
        ),
        YaabsaButtonVariant.outlined => OutlinedButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon,
          label: label,
        ),
        YaabsaButtonVariant.text => TextButton.icon(onPressed: onPressed, style: style, icon: icon, label: label),
        YaabsaButtonVariant.elevated => ElevatedButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon,
          label: label,
        ),
      };
    }

    final child = _iconOnly ? icon! : label!;
    return switch (variant) {
      YaabsaButtonVariant.filled => FilledButton(onPressed: onPressed, style: style, child: child),
      YaabsaButtonVariant.tonal => FilledButton.tonal(onPressed: onPressed, style: style, child: child),
      YaabsaButtonVariant.outlined => OutlinedButton(onPressed: onPressed, style: style, child: child),
      YaabsaButtonVariant.text => TextButton(onPressed: onPressed, style: style, child: child),
      YaabsaButtonVariant.elevated => ElevatedButton(onPressed: onPressed, style: style, child: child),
    };
  }
}
