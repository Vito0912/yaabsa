import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class PlayerSettingsSleepTimer extends ConsumerWidget {
  const PlayerSettingsSleepTimer({super.key});

  static const String routeName = '/settings/player/sleep-timer';

  static final List<int> _timeRangeValues = List<int>.generate(48, (index) => index * 30);
  static final List<String> _timeRangeLabels = _timeRangeValues
      .map((minutes) => _formatMinutesOfDay(minutes))
      .toList(growable: false);

  static String _formatMinutesOfDay(int minutes) {
    final normalized = ((minutes % (24 * 60)) + (24 * 60)) % (24 * 60);
    final hour24 = normalized ~/ 60;
    final minute = normalized % 60;
    final suffix = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minutePadded = minute.toString().padLeft(2, '0');
    return '$hour12:$minutePadded $suffix';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoRestartEnabledSetting = ref
        .watch(globalSettingByKeyProvider(SettingKeys.sleepTimerAutoRestartEnabled))
        .asData
        ?.value;
    final autoRestartEnabledDefault = defaultSettings[SettingKeys.sleepTimerAutoRestartEnabled] as bool? ?? false;
    final autoRestartEnabled = SettingsParser.decodeValue<bool>(autoRestartEnabledSetting, autoRestartEnabledDefault);

    final useTimeRangeSetting = ref
        .watch(globalSettingByKeyProvider(SettingKeys.sleepTimerAutoRestartUseTimeRange))
        .asData
        ?.value;
    final useTimeRangeDefault = defaultSettings[SettingKeys.sleepTimerAutoRestartUseTimeRange] as bool? ?? false;
    final useTimeRange = SettingsParser.decodeValue<bool>(useTimeRangeSetting, useTimeRangeDefault);

    final timeRangeEnabled = autoRestartEnabled && useTimeRange;

    return SettingsPageScaffold(
      title: 'Player - Sleep Timer',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingsNavigationSection(
          title: 'Expiry Behavior',
          topPadding: 0,
          settings: [
            SettingDropdown<String>(
              label: 'Sleep timer end action',
              description: 'Choose whether playback is stopped or paused when the sleep timer expires',
              values: SleepTimerExpireAction.values.map((action) => action.name).toList(),
              valueLabels: SleepTimerExpireAction.values.map((action) => action.label).toList(),
              valueDescriptions: const ['Stop playback completely', 'Pause playback only'],
              settingKey: SettingKeys.sleepTimerExpireAction,
            ),
            const SettingSlider<int>(
              label: 'Sleep timer end rewind',
              description: 'After sleep timer stops playback, rewind this much when the same item is played again',
              values: [0, 5, 10, 15, 30],
              valueLabels: ['Off', '5 min', '10 min', '15 min', '30 min'],
              settingKey: SettingKeys.sleepTimerAutoRewindMinutes,
            ),
            const SettingSwitchTile(
              label: 'Fade audio',
              subtitle: 'Gradually lower playback volume before the sleep timer ends',
              settingKey: SettingKeys.sleepTimerFadeOutEnabled,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Auto Restart Options',
          settings: [
            const SettingSwitchTile(
              label: 'Auto-restart timer on playback start',
              subtitle:
                  'When playback starts and no timer is active, automatically start a new sleep timer using your last duration',
              settingKey: SettingKeys.sleepTimerAutoRestartEnabled,
            ),
            SettingSwitchTile(
              label: 'Only auto-restart during a time range',
              subtitle: 'Limit automatic sleep timer restart to specific hours',
              disabledReason: 'Enable auto-restart to configure this option',
              settingKey: SettingKeys.sleepTimerAutoRestartUseTimeRange,
              enabled: autoRestartEnabled,
            ),
            SettingSlider<int>(
              label: 'Auto-restart range start',
              description: 'Sleep timer auto-restart becomes active at this time',
              disabledReason: 'Enable auto-restart and time range to configure this option',
              values: _timeRangeValues,
              valueLabels: _timeRangeLabels,
              settingKey: SettingKeys.sleepTimerAutoRestartRangeStartMinutes,
              enabled: timeRangeEnabled,
            ),
            SettingSlider<int>(
              label: 'Auto-restart range end',
              description: 'Sleep timer auto-restart remains active until this time',
              disabledReason: 'Enable auto-restart and time range to configure this option',
              values: _timeRangeValues,
              valueLabels: _timeRangeLabels,
              settingKey: SettingKeys.sleepTimerAutoRestartRangeEndMinutes,
              enabled: timeRangeEnabled,
            ),
          ],
        ),
      ],
    );
  }
}
