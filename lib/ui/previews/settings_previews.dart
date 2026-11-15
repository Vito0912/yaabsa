import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_button.dart';
import 'package:yaabsa/features/settings/widgets/settings_control_status_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_slider_presentation.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';

import 'preview_theme.dart';

@Preview(name: 'Settings controls / light', size: Size(640, 680), wrapper: yaabsaPreviewLight)
@Preview(name: 'Settings controls / dark', size: Size(640, 680), wrapper: yaabsaPreviewDark)
@Preview(name: 'Settings controls / AMOLED', size: Size(640, 680), wrapper: yaabsaPreviewAmoled)
Widget settingsControlsPreview() => const SettingsControlsPreview();

class SettingsControlsPreview extends StatefulWidget {
  const SettingsControlsPreview({super.key});

  @override
  State<SettingsControlsPreview> createState() => _SettingsControlsPreviewState();
}

class _SettingsControlsPreviewState extends State<SettingsControlsPreview> {
  bool _wifiOnly = true;
  bool _includeArtwork = false;
  bool _notifications = true;
  int _quality = 2;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingButton(
          label: 'Export preferences',
          description: 'Save a local copy of your preferences',
          buttonText: 'Export',
          buttonIcon: Icons.save_alt,
          onPressed: () {},
        ),
        const SettingButton(label: 'Unavailable action', buttonText: 'Export'),
        const SettingButton(label: 'Saving preferences', buttonText: 'Save', isLoading: true),
        SettingsSwitchPresentation(
          label: 'Wi-Fi only',
          description: 'Use Wi-Fi for automatic downloads',
          value: _wifiOnly,
          icon: Icons.wifi_rounded,
          tooltip: 'Download network preference',
          onChanged: (value) => setState(() => _wifiOnly = value),
        ),
        const SettingsSwitchPresentation(
          label: 'Unavailable setting',
          description: 'This option is not available for this account',
          value: false,
          enabled: false,
          onChanged: null,
        ),
        const SettingsSwitchPresentation(
          label: 'Saving setting',
          description: 'Applying your preference',
          value: true,
          isLoading: true,
          onChanged: null,
        ),
        const SettingsControlStatusPresentation(
          label: 'Loading remote setting',
          state: SettingsControlLoadState.loading,
        ),
        const SettingsControlStatusPresentation(
          label: 'Unavailable remote setting',
          state: SettingsControlLoadState.error,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SettingsSliderPresentation<int>(
            label: 'Download quality',
            description: 'Choose a balance between size and fidelity',
            values: const [0, 1, 2, 3, 4],
            valueLabels: const ['Small', 'Low', 'Balanced', 'High', 'Maximum'],
            value: _quality,
            icon: Icons.high_quality_outlined,
            tooltip: 'Download quality',
            onChanged: (value) => setState(() => _quality = value),
          ),
        ),
        SettingsSwitchPresentation(
          label: 'Include cover artwork',
          value: _includeArtwork,
          onChanged: (value) => setState(() => _includeArtwork = value),
        ),
        SettingsSwitchPresentation(
          label: 'Notify when complete',
          value: _notifications,
          onChanged: (value) => setState(() => _notifications = value),
        ),
      ],
    );
  }
}
