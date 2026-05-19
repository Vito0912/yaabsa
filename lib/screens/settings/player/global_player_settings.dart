import 'package:flutter/material.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class GlobalPlayerSettings extends StatelessWidget {
  const GlobalPlayerSettings({super.key});

  static const String routeName = '/settings/global-player';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: S.current.screensSettingsPlayerGlobalPlayerSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingSlider<int>(
          label: S.current.screensSettingsPlayerGlobalPlayerSettingsMaxBufferSize,
          tooltip: S.current.screensSettingsPlayerGlobalPlayerSettingsMaxBufferSizeTooltip,
          icon: Icons.info_outline,
          values: const [512 * 1024, 1024 * 1024, 2 * 1024 * 1024, 5 * 1024 * 1024, 10 * 1024 * 1024],
          valueLabels: const ['512 KB', '1 MB', '2 MB', '5 MB', '10 MB'],
          settingKey: SettingKeys.bufferSize,
        ),
        SettingSwitch(
          label: S.current.screensSettingsPlayerGlobalPlayerSettingsLockMediaNotification,
          settingKey: SettingKeys.lockMediaNotification,
        ),
        SettingSwitch(
          label: S.current.screensSettingsPlayerGlobalPlayerSettingsShowNotificationMoreButton,
          description: S.current.screensSettingsPlayerGlobalPlayerSettingsShowNotificationMoreButtonDescription,
          settingKey: SettingKeys.showNotificationMoreButton,
        ),
        SettingSwitch(
          label: S.current.screensSettingsPlayerGlobalPlayerSettingsAutoPlayLastPlayedOnAppStart,
          description: S.current.screensSettingsPlayerGlobalPlayerSettingsAutoPlayLastPlayedOnAppStartDescription,
          settingKey: SettingKeys.autoPlayLastPlayedOnLaunch,
        ),
        SettingSwitch(
          label: S.current.screensSettingsPlayerGlobalPlayerSettingsKeepScreenOn,
          settingKey: SettingKeys.keepScreenOn,
        ),
      ],
    );
  }
}
