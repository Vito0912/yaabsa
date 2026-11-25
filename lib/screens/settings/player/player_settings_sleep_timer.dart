import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/components/settings/settings_positive_integer.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/l10n.dart';

class PlayerSettingsSleepTimer extends ConsumerWidget {
  const PlayerSettingsSleepTimer({super.key});

  static const String routeName = '/settings/player/sleep-timer';

  static final List<int> _timeRangeValues = List<int>.generate(48, (index) => index * 30);

  static String _formatMinutesOfDay(int minutes, String localeName) {
    final normalized = ((minutes % (24 * 60)) + (24 * 60)) % (24 * 60);
    final time = DateTime(2000).add(Duration(minutes: normalized));
    return DateFormat.jm(localeName).format(time);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final timeRangeLabels = _timeRangeValues
        .map((minutes) => _formatMinutesOfDay(minutes, l10n.localeName))
        .toList(growable: false);
    final rewindValues = const [0, 5, 10, 15, 30];

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
    final chapterMode =
        ref.watch(globalSettingByKeyProvider(SettingKeys.sleepTimerAutoMode)).asData?.value == 'chapters';
    final rememberedMinutes = ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<int>(SettingKeys.sleepTimerLastDurationMinutes);

    return SettingsPageScaffold(
      title: l10n.playbackSleepTimer,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingsNavigationSection(
          title: l10n.settingsCategoryTimerExpiry,
          topPadding: 0,
          settings: [
            SettingDropdown<String>(
              label: l10n.settingSleepTimerEndAction,
              description: l10n.settingSleepTimerEndActionDescription,
              values: SleepTimerExpireAction.values.map((action) => action.name).toList(),
              valueLabels: SleepTimerExpireAction.values.map((action) => action.label).toList(),
              valueDescriptions: [l10n.playbackStop, l10n.playbackPause],
              settingKey: SettingKeys.sleepTimerExpireAction,
            ),
            SettingSlider<int>(
              label: l10n.settingSleepTimerEndRewind,
              description: l10n.settingSleepTimerEndRewindDescription,
              values: rewindValues,
              valueLabels: [
                l10n.statusOff,
                ...rewindValues
                    .skip(1)
                    .map((minutes) => Duration(minutes: minutes).toLargestUnitCompactString(localizations: l10n)),
              ],
              settingKey: SettingKeys.sleepTimerAutoRewindMinutes,
            ),
            SettingSwitchTile(
              label: l10n.settingFadeAudio,
              subtitle: l10n.settingFadeAudioDescription,
              settingKey: SettingKeys.sleepTimerFadeOutEnabled,
            ),
            SettingSwitchTile(
              label: l10n.settingShowSleepTimerMarker,
              subtitle: l10n.settingShowSleepTimerMarkerDescription,
              settingKey: SettingKeys.sleepTimerShowMarker,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: l10n.settingsCategoryAutoRestart,
          settings: [
            SettingSwitchTile(
              label: l10n.settingAutoRestartTimerOnPlaybackStart,
              subtitle: l10n.settingAutoRestartTimerOnPlaybackStartDescription,
              settingKey: SettingKeys.sleepTimerAutoRestartEnabled,
            ),
            SettingDropdown<String>(
              label: l10n.fieldTimerMode,
              description: l10n.settingTimerModeDescription,
              values: const ['minutes', 'chapters'],
              valueLabels: [l10n.fieldMinutes, l10n.navChapters],
              settingKey: SettingKeys.sleepTimerAutoMode,
              enabled: autoRestartEnabled,
            ),
            SettingPositiveInteger(
              key: ValueKey(chapterMode),
              label: chapterMode ? l10n.fieldChapterCount : l10n.fieldMinutes,
              settingKey: chapterMode ? SettingKeys.sleepTimerAutoChapters : SettingKeys.sleepTimerAutoMinutes,
              fallback: chapterMode ? 1 : (rememberedMinutes > 0 ? rememberedMinutes : 30),
              enabled: autoRestartEnabled,
            ),
            SettingSwitchTile(
              label: l10n.settingAutoRestartDuringTimeRange,
              subtitle: l10n.settingAutoRestartDuringTimeRangeDescription,
              disabledReason: l10n.permissionAutomaticRestartRequired,
              settingKey: SettingKeys.sleepTimerAutoRestartUseTimeRange,
              enabled: autoRestartEnabled,
            ),
            SettingSlider<int>(
              label: l10n.settingAutoRestartRangeStart,
              description: l10n.settingAutoRestartRangeStartDescription,
              disabledReason: l10n.permissionTimerRangeRequired,
              values: _timeRangeValues,
              valueLabels: timeRangeLabels,
              settingKey: SettingKeys.sleepTimerAutoRestartRangeStartMinutes,
              enabled: timeRangeEnabled,
            ),
            SettingSlider<int>(
              label: l10n.settingAutoRestartRangeEnd,
              description: l10n.settingAutoRestartRangeEndDescription,
              disabledReason: l10n.permissionTimerRangeRequired,
              values: _timeRangeValues,
              valueLabels: timeRangeLabels,
              settingKey: SettingKeys.sleepTimerAutoRestartRangeEndMinutes,
              enabled: timeRangeEnabled,
            ),
          ],
        ),
      ],
    );
  }
}
