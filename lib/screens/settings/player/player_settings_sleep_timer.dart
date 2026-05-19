import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class PlayerSettingsSleepTimer extends ConsumerWidget {
  const PlayerSettingsSleepTimer({super.key});

  static const String routeName = '/settings/player/sleep-timer';

  static final List<int> _timeRangeValues = List<int>.generate(48, (index) => index * 30);

  static String _formatMinutesOfDay(int minutes, String locale) {
    final normalized = ((minutes % (24 * 60)) + (24 * 60)) % (24 * 60);
    final hour24 = normalized ~/ 60;
    final minute = normalized % 60;
    return DateFormat.jm(locale).format(DateTime(2024, 1, 1, hour24, minute));
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
    final locale = Localizations.localeOf(context).toString();
    final timeRangeLabels = _timeRangeValues
        .map((minutes) => _formatMinutesOfDay(minutes, locale))
        .toList(growable: false);

    final timeRangeEnabled = autoRestartEnabled && useTimeRange;

    return SettingsPageScaffold(
      title: S.current.screensSettingsPlayerPlayerSettingsSleepTimerTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingDropdown<String>(
          label: S.current.screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerEndAction,
          description:
              S.current.screensSettingsPlayerPlayerSettingsSleepTimerChooseWhetherPlaybackIsStoppedOrPausedWhen,
          values: SleepTimerExpireAction.values.map((action) => action.name).toList(),
          valueLabels: SleepTimerExpireAction.values.map((action) => action.label).toList(),
          settingKey: SettingKeys.sleepTimerExpireAction,
        ),
        SettingSlider<int>(
          label: S.current.screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerEndRewind,
          description: S.current.screensSettingsPlayerPlayerSettingsSleepTimerAfterSleepTimerStopsPlaybackRewindThis,
          values: const [0, 5, 10, 15, 30],
          valueLabels: [
            S.current.screensSettingsPlayerPlayerSettingsSleepTimerOff,
            S.current.screensSettingsPlayerPlayerSettingsSleepTimerM005,
            S.current.screensSettingsPlayerPlayerSettingsSleepTimerM010,
            S.current.screensSettingsPlayerPlayerSettingsSleepTimerM015,
            S.current.screensSettingsPlayerPlayerSettingsSleepTimerM030,
          ],
          settingKey: SettingKeys.sleepTimerAutoRewindMinutes,
        ),
        SettingSwitch(
          label: S.current.screensSettingsPlayerPlayerSettingsSleepTimerAutorestartTimerOnPlaybackStart,
          description: S.current.screensSettingsPlayerPlayerSettingsSleepTimerWhenPlaybackStartsAndNoTimerIs,
          settingKey: SettingKeys.sleepTimerAutoRestartEnabled,
        ),
        SettingSwitch(
          label: S.current.screensSettingsPlayerPlayerSettingsSleepTimerOnlyAutorestartDuringATimeRange,
          description: S.current.screensSettingsPlayerPlayerSettingsSleepTimerLimitAutomaticSleepTimerRestartToSpecific,
          disabledReason: S.current.screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartToConfigureThisOption,
          settingKey: SettingKeys.sleepTimerAutoRestartUseTimeRange,
          enabled: autoRestartEnabled,
        ),
        SettingSlider<int>(
          label: S.current.screensSettingsPlayerPlayerSettingsSleepTimerAutorestartRangeStart,
          description: S.current.screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerAutorestartBecomesActiveAt,
          disabledReason: S.current.screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartAndTimeRangeTo,
          values: _timeRangeValues,
          valueLabels: timeRangeLabels,
          settingKey: SettingKeys.sleepTimerAutoRestartRangeStartMinutes,
          enabled: timeRangeEnabled,
        ),
        SettingSlider<int>(
          label: S.current.screensSettingsPlayerPlayerSettingsSleepTimerAutorestartRangeEnd,
          description: S.current.screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerAutorestartRemainsActiveUntil,
          disabledReason: S.current.screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartAndTimeRangeTo,
          values: _timeRangeValues,
          valueLabels: timeRangeLabels,
          settingKey: SettingKeys.sleepTimerAutoRestartRangeEndMinutes,
          enabled: timeRangeEnabled,
        ),
      ],
    );
  }
}
