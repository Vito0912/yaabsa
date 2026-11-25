import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/util/device_capabilities.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';

class ShakeSettingsSection extends StatefulWidget {
  const ShakeSettingsSection({super.key});

  @override
  State<ShakeSettingsSection> createState() => _ShakeSettingsSectionState();
}

class _ShakeSettingsSectionState extends State<ShakeSettingsSection> {
  late final Future<bool> _vibrationSupportFuture;

  @override
  void initState() {
    super.initState();
    _vibrationSupportFuture = DeviceCapabilities.supportsVibrationFeedback();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shakeUnsupportedReason = l10n.permissionMotionSensorsRequired;
    final supportsShakeActions = DeviceCapabilities.supportsShakeActions;

    return FutureBuilder<bool>(
      future: _vibrationSupportFuture,
      builder: (context, snapshot) {
        final vibrationCheckFinished = snapshot.connectionState == ConnectionState.done;
        final supportsVibration = snapshot.data == true;
        final vibrationEnabled = supportsShakeActions && supportsVibration;

        String? vibrationDisabledReason;
        if (!supportsShakeActions) {
          vibrationDisabledReason = shakeUnsupportedReason;
        } else if (!vibrationCheckFinished) {
          vibrationDisabledReason = l10n.statusCheckingVibrationSupport;
        } else if (!supportsVibration) {
          vibrationDisabledReason = l10n.statusVibrationUnavailable;
        }

        return SettingsNavigationSection(
          title: l10n.settingsCategoryShakeControls,
          topPadding: 0,
          settings: [
            SettingSwitchTile(
              label: l10n.settingShakeToResetSleepTimer,
              subtitle: l10n.settingShakeToResetSleepTimerDescription,
              settingKey: SettingKeys.shakeToResetSleepTimer,
              enabled: supportsShakeActions,
              disabledReason: shakeUnsupportedReason,
            ),
            SettingSwitchTile(
              label: l10n.settingShakeToRewind,
              subtitle: l10n.settingShakeToRewindDescription,
              settingKey: SettingKeys.shakeToRewind,
              enabled: supportsShakeActions,
              disabledReason: shakeUnsupportedReason,
            ),
            SettingSlider<double>(
              label: l10n.settingShakeSensitivity,
              description: l10n.settingShakeSensitivityDescription,
              values: List.generate(25, (index) => (index + 11) / 10),
              valueLabels: List.generate(25, (index) => l10n.settingShakeSensitivityValue((index + 11) / 10)),
              settingKey: SettingKeys.shakeSensitivity,
              enabled: supportsShakeActions,
              disabledReason: shakeUnsupportedReason,
            ),
            SettingSwitchTile(
              label: l10n.settingShakeVibrationFeedback,
              subtitle: l10n.settingShakeVibrationFeedbackDescription,
              settingKey: SettingKeys.shakeVibrate,
              enabled: vibrationEnabled,
              disabledReason: vibrationDisabledReason,
            ),
          ],
        );
      },
    );
  }
}
