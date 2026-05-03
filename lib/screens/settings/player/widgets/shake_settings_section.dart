import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/util/device_capabilities.dart';
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
    const shakeUnsupportedReason = 'Shake actions require a device with motion sensors.';
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
          vibrationDisabledReason = 'Checking vibration support...';
        } else if (!supportsVibration) {
          vibrationDisabledReason = 'This device does not support vibration feedback.';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Text('Shake Controls', style: Theme.of(context).textTheme.titleLarge),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider(height: 16)),
            SettingSwitch(
              label: 'Shake to reset sleep timer',
              description: 'Shake to reset an active sleep timer back to its full duration.',
              settingKey: SettingKeys.shakeToResetSleepTimer,
              enabled: supportsShakeActions,
              disabledReason: shakeUnsupportedReason,
            ),
            SettingSwitch(
              label: 'Shake to rewind',
              description: 'Shake while playing to rewind by the configured rewind interval.',
              settingKey: SettingKeys.shakeToRewind,
              enabled: supportsShakeActions,
              disabledReason: shakeUnsupportedReason,
            ),
            SettingSlider<double>(
              label: 'Shake sensitivity',
              description: 'Lower values trigger more easily, higher values require a stronger shake.',
              values: const [1.5, 2.0, 2.5, 3.0, 3.5],
              valueLabels: const ['1.5 g', '2.0 g', '2.5 g', '3.0 g', '3.5 g'],
              settingKey: SettingKeys.shakeSensitivity,
              enabled: supportsShakeActions,
              disabledReason: shakeUnsupportedReason,
            ),
            SettingSwitch(
              label: 'Shake vibration feedback',
              description: 'Vibrate when a shake action is triggered.',
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
