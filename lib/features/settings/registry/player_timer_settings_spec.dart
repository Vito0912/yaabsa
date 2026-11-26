import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/setting_key.dart';

SettingsPageSpec buildPlayerSmartRewindPage() {
  const shortPauseValues = <int>[15, 30, 45, 60, 90, 120, 180, 300];
  const longPauseValues = <int>[300, 600, 900, 1200, 1800, 2700, 3600];
  const shortRewindValues = <int>[3, 5, 10, 15, 20, 30];
  const mediumRewindValues = <int>[10, 15, 20, 30, 45, 60];
  const longRewindValues = <int>[20, 30, 45, 60, 90, 120];

  SettingsAvailability requireSmartRewind(SettingsContext ctx) {
    if (ctx.readSetting(AppSettingDefs.smartRewindEnabled)) {
      return const SettingsAvailability.available();
    }

    return SettingsAvailability.disabled(ctx.l10n.permissionEnableSettingToChangeOption(ctx.l10n.settingSmartRewind));
  }

  return SettingsPageSpec(
    id: 'player.smart_rewind',
    parentId: 'player',
    route: SettingsRoutes.playerSmartRewind,
    scope: SettingScope.app,
    icon: Icons.replay_rounded,
    title: (ctx) => ctx.l10n.settingSmartRewind,
    subtitle: (ctx) => ctx.l10n.messageSmartRewindSettings,
    sections: [
      SettingsSectionSpec(
        id: 'player.smart_rewind.main',
        title: (ctx) => ctx.l10n.settingSmartRewind,
        entries: [
          SettingsToggleEntry(
            id: 'smart_rewind_enabled',
            title: (ctx) => ctx.l10n.settingSmartRewind,
            description: (ctx) => ctx.l10n.settingSmartRewindDescription,
            keywords: (l10n) => <String>['smart rewind', 'rewind', 'pause', 'resume'],
            definition: AppSettingDefs.smartRewindEnabled,
          ),
          SettingsSliderEntry<int>(
            id: 'smart_rewind_short_pause_threshold',
            title: (ctx) => ctx.l10n.settingShortPauseThreshold,
            description: (ctx) => ctx.l10n.settingShortPauseThresholdDescription,
            keywords: (l10n) => <String>['smart rewind', 'rewind', 'pause'],
            definition: AppSettingDefs.smartRewindShortPauseThresholdSeconds,
            values: shortPauseValues,
            labelForValue: (ctx, seconds) =>
                Duration(seconds: seconds).toCompactRemainingString(localizations: ctx.l10n),
            availability: requireSmartRewind,
          ),
          SettingsSliderEntry<int>(
            id: 'smart_rewind_long_pause_threshold',
            title: (ctx) => ctx.l10n.settingLongPauseThreshold,
            description: (ctx) => ctx.l10n.settingLongPauseThresholdDescription,
            keywords: (l10n) => <String>['smart rewind', 'rewind', 'pause'],
            definition: AppSettingDefs.smartRewindLongPauseThresholdSeconds,
            values: longPauseValues,
            labelForValue: (ctx, seconds) =>
                Duration(seconds: seconds).toCompactRemainingString(localizations: ctx.l10n),
            availability: requireSmartRewind,
          ),
          SettingsSliderEntry<int>(
            id: 'smart_rewind_short_amount',
            title: (ctx) => ctx.l10n.settingShortRewindAmount,
            description: (ctx) => ctx.l10n.settingShortRewindAmountDescription,
            keywords: (l10n) => <String>['smart rewind', 'rewind'],
            definition: AppSettingDefs.smartRewindShortRewindSeconds,
            values: shortRewindValues,
            labelForValue: (ctx, seconds) =>
                Duration(seconds: seconds).toCompactRemainingString(localizations: ctx.l10n),
            availability: requireSmartRewind,
          ),
          SettingsSliderEntry<int>(
            id: 'smart_rewind_medium_amount',
            title: (ctx) => ctx.l10n.settingMediumRewindAmount,
            description: (ctx) => ctx.l10n.settingMediumRewindAmountDescription,
            keywords: (l10n) => <String>['smart rewind', 'rewind'],
            definition: AppSettingDefs.smartRewindMediumRewindSeconds,
            values: mediumRewindValues,
            labelForValue: (ctx, seconds) =>
                Duration(seconds: seconds).toCompactRemainingString(localizations: ctx.l10n),
            availability: requireSmartRewind,
          ),
          SettingsSliderEntry<int>(
            id: 'smart_rewind_long_amount',
            title: (ctx) => ctx.l10n.settingLongRewindAmount,
            description: (ctx) => ctx.l10n.settingLongRewindAmountDescription,
            keywords: (l10n) => <String>['smart rewind', 'rewind'],
            definition: AppSettingDefs.smartRewindLongRewindSeconds,
            values: longRewindValues,
            labelForValue: (ctx, seconds) =>
                Duration(seconds: seconds).toCompactRemainingString(localizations: ctx.l10n),
            availability: requireSmartRewind,
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec buildPlayerSleepTimerPage() {
  const rewindValues = <int>[0, 5, 10, 15, 30];

  SettingsAvailability requireAutoRestart(SettingsContext ctx) {
    if (ctx.readSetting(AppSettingDefs.sleepTimerAutoRestartEnabled)) {
      return const SettingsAvailability.available();
    }

    return SettingsAvailability.disabled(ctx.l10n.permissionAutomaticRestartRequired);
  }

  SettingsAvailability requireTimeRange(SettingsContext ctx) {
    final autoRestart = ctx.readSetting(AppSettingDefs.sleepTimerAutoRestartEnabled);
    final useTimeRange = ctx.readSetting(AppSettingDefs.sleepTimerAutoRestartUseTimeRange);
    if (autoRestart && useTimeRange) {
      return const SettingsAvailability.available();
    }

    return SettingsAvailability.disabled(ctx.l10n.permissionTimerRangeRequired);
  }

  return SettingsPageSpec(
    id: 'player.sleep_timer',
    parentId: 'player',
    route: SettingsRoutes.playerSleepTimer,
    scope: SettingScope.app,
    icon: Icons.bedtime_outlined,
    title: (ctx) => ctx.l10n.playbackSleepTimer,
    subtitle: (ctx) => ctx.l10n.messageSleepTimerSettings,
    sections: [
      SettingsSectionSpec(
        id: 'player.sleep_timer.expiry',
        title: (ctx) => ctx.l10n.settingsCategoryTimerExpiry,
        entries: [
          SettingsChoiceEntry<String>(
            id: 'sleep_timer_expire_action',
            title: (ctx) => ctx.l10n.settingSleepTimerEndAction,
            description: (ctx) => ctx.l10n.settingSleepTimerEndActionDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'bedtime'],
            definition: AppSettingDefs.sleepTimerExpireAction,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(
                value: SleepTimerExpireAction.stop.name,
                label: SleepTimerExpireAction.stop.label,
                description: ctx.l10n.playbackStop,
              ),
              SettingsChoiceOption(
                value: SleepTimerExpireAction.pause.name,
                label: SleepTimerExpireAction.pause.label,
                description: ctx.l10n.playbackPause,
              ),
            ],
          ),
          SettingsSliderEntry<int>(
            id: 'sleep_timer_end_rewind',
            title: (ctx) => ctx.l10n.settingSleepTimerEndRewind,
            description: (ctx) => ctx.l10n.settingSleepTimerEndRewindDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'rewind'],
            definition: AppSettingDefs.sleepTimerAutoRewindMinutes,
            values: rewindValues,
            labelForValue: (ctx, minutes) {
              if (minutes == 0) {
                return ctx.l10n.statusOff;
              }

              return Duration(minutes: minutes).toLargestUnitCompactString(localizations: ctx.l10n);
            },
          ),
          SettingsToggleEntry(
            id: 'sleep_timer_fade_out',
            title: (ctx) => ctx.l10n.settingFadeAudio,
            description: (ctx) => ctx.l10n.settingFadeAudioDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'fade'],
            definition: AppSettingDefs.sleepTimerFadeOutEnabled,
          ),
          SettingsToggleEntry(
            id: 'sleep_timer_show_marker',
            title: (ctx) => ctx.l10n.settingShowSleepTimerMarker,
            description: (ctx) => ctx.l10n.settingShowSleepTimerMarkerDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'marker'],
            definition: AppSettingDefs.sleepTimerShowMarker,
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'player.sleep_timer.auto_restart',
        title: (ctx) => ctx.l10n.settingsCategoryAutoRestart,
        entries: [
          SettingsToggleEntry(
            id: 'sleep_timer_auto_restart',
            title: (ctx) => ctx.l10n.settingAutoRestartTimerOnPlaybackStart,
            description: (ctx) => ctx.l10n.settingAutoRestartTimerOnPlaybackStartDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'auto restart', 'night'],
            definition: AppSettingDefs.sleepTimerAutoRestartEnabled,
          ),
          SettingsChoiceEntry<String>(
            id: 'sleep_timer_auto_mode',
            title: (ctx) => ctx.l10n.fieldTimerMode,
            description: (ctx) => ctx.l10n.settingTimerModeDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'chapters', 'minutes'],
            definition: AppSettingDefs.sleepTimerAutoMode,
            availability: requireAutoRestart,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(value: 'minutes', label: ctx.l10n.fieldMinutes),
              SettingsChoiceOption(value: 'chapters', label: ctx.l10n.navChapters),
            ],
          ),
          SettingsNumberEntry(
            id: 'sleep_timer_auto_minutes',
            title: (ctx) => ctx.l10n.fieldMinutes,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'duration'],
            definition: AppSettingDefs.sleepTimerAutoMinutes,
            min: 1,
            max: 1440,
            unitLabel: (ctx) => ctx.l10n.fieldMinutes.toLowerCase(),
            fallbackBuilder: (ctx) {
              final remembered = ctx.readSetting(AppSettingDefs.sleepTimerLastDurationMinutes);
              if (remembered > 0) {
                return remembered;
              }

              return 30;
            },
            availability: (ctx) {
              if (ctx.readSetting(AppSettingDefs.sleepTimerAutoMode) == 'chapters') {
                return const SettingsAvailability.hidden();
              }

              return requireAutoRestart(ctx);
            },
          ),
          SettingsNumberEntry(
            id: 'sleep_timer_auto_chapters',
            title: (ctx) => ctx.l10n.fieldChapterCount,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'chapters'],
            definition: AppSettingDefs.sleepTimerAutoChapters,
            min: 1,
            max: 5000,
            availability: (ctx) {
              if (ctx.readSetting(AppSettingDefs.sleepTimerAutoMode) != 'chapters') {
                return const SettingsAvailability.hidden();
              }

              return requireAutoRestart(ctx);
            },
          ),
          SettingsToggleEntry(
            id: 'sleep_timer_use_time_range',
            title: (ctx) => ctx.l10n.settingAutoRestartDuringTimeRange,
            description: (ctx) => ctx.l10n.settingAutoRestartDuringTimeRangeDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'schedule', 'night'],
            definition: AppSettingDefs.sleepTimerAutoRestartUseTimeRange,
            availability: requireAutoRestart,
          ),
          SettingsTimeOfDayEntry(
            id: 'sleep_timer_range_start',
            title: (ctx) => ctx.l10n.settingAutoRestartRangeStart,
            description: (ctx) => ctx.l10n.settingAutoRestartRangeStartDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'schedule'],
            definition: AppSettingDefs.sleepTimerAutoRestartRangeStartMinutes,
            availability: requireTimeRange,
          ),
          SettingsTimeOfDayEntry(
            id: 'sleep_timer_range_end',
            title: (ctx) => ctx.l10n.settingAutoRestartRangeEnd,
            description: (ctx) => ctx.l10n.settingAutoRestartRangeEndDescription,
            keywords: (l10n) => <String>[l10n.playbackSleepTimer, 'sleep', 'timer', 'schedule'],
            definition: AppSettingDefs.sleepTimerAutoRestartRangeEndMinutes,
            availability: requireTimeRange,
          ),
        ],
      ),
    ],
  );
}
