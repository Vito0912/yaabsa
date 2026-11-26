import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';

class SettingsActionPresentation extends StatelessWidget {
  const SettingsActionPresentation({
    super.key,
    required this.label,
    required this.buttonLabel,
    required this.onPressed,
    this.description,
    this.icon,
    this.tooltip,
    this.buttonIcon,
    this.isDestructive = false,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final String buttonLabel;
  final VoidCallback? onPressed;
  final String? description;
  final IconData? icon;
  final String? tooltip;
  final IconData? buttonIcon;
  final bool isDestructive;
  final bool isLoading;
  final bool enabled;

  bool _fitsInline(BuildContext context, double maxWidth) {
    if (!maxWidth.isFinite) {
      return true;
    }

    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final textScale = textScaler.scale(1);
    final labelStyle = theme.textTheme.labelLarge ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    final painter = TextPainter(
      text: TextSpan(text: buttonLabel, style: labelStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: textScaler,
    )..layout();

    final iconAllowance = (buttonIcon != null || isLoading) ? 24.0 : 0.0;
    final buttonWidth = painter.width + iconAllowance + 32.0;
    final minLabelWidth = 150.0 * textScale;
    return maxWidth >= minLabelWidth + 16.0 + buttonWidth;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = enabled && onPressed != null && !isLoading;

    final labelWidget = SettingsControlLabel(
      label: label,
      description: description,
      enabled: enabled && onPressed != null,
      icon: icon,
      tooltip: tooltip,
    );

    final actionButton = YaabsaButton.small(
      label: Text(buttonLabel),
      icon: buttonIcon != null ? Icon(buttonIcon, size: 16) : null,
      variant: isDestructive ? YaabsaButtonVariant.filled : YaabsaButtonVariant.tonal,
      isLoading: isLoading,
      onPressed: isEnabled ? onPressed : null,
      style: isDestructive
          ? FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError)
          : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_fitsInline(context, constraints.maxWidth)) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: labelWidget),
                const SizedBox(width: 16),
                actionButton,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              labelWidget,
              const SizedBox(height: 10),
              Align(alignment: AlignmentDirectional.centerEnd, child: actionButton),
            ],
          );
        },
      ),
    );
  }
}
