import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';

class SettingButton extends StatelessWidget {
  final String label;
  final String? description;
  final String? tooltip;
  final IconData? icon;
  final String buttonText;
  final IconData? buttonIcon;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isLoading;

  const SettingButton({
    super.key,
    required this.label,
    this.description,
    this.tooltip,
    this.icon,
    required this.buttonText,
    this.buttonIcon,
    this.onPressed,
    this.isDestructive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = onPressed != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SettingsControlLabel(
              label: label,
              description: description,
              enabled: isEnabled,
              icon: icon,
              tooltip: tooltip,
            ),
          ),
          const SizedBox(width: 16),
          isLoading
              ? const SizedBox(width: 20, height: 20, child: YaabsaCircularProgressIndicator(strokeWidth: 2.5))
              : YaabsaButton.small(
                  onPressed: onPressed,
                  icon: buttonIcon != null ? Icon(buttonIcon, size: 16) : null,
                  label: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w600)),
                  variant: YaabsaButtonVariant.filled,
                  style: isDestructive
                      ? FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError)
                      : null,
                ),
        ],
      ),
    );
  }
}
