import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class SettingsSwitchPresentation extends StatelessWidget {
  const SettingsSwitchPresentation({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.icon,
    this.tooltip,
    this.enabled = true,
    this.isLoading = false,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? description;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;
  final bool isLoading;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onChanged != null && !isLoading;

    return YaabsaSwitchTile(
      value: value,
      onChanged: isEnabled ? onChanged : null,
      contentPadding: contentPadding,
      title: SettingsControlLabel(
        label: label,
        description: description,
        enabled: isEnabled,
        icon: icon,
        tooltip: tooltip,
      ),
      secondary: isLoading
          ? const SizedBox(height: 18, width: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2.2))
          : null,
    );
  }
}
