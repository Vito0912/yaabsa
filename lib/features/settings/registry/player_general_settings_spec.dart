import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/player_general_behavior_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/screens/settings/player/player_action_settings_editor.dart';
import 'package:yaabsa/util/setting_key.dart';

SettingsPageSpec buildPlayerGeneralPage() {
  return SettingsPageSpec(
    id: 'player.general',
    parentId: 'player',
    route: SettingsRoutes.playerGeneral,
    scope: SettingScope.app,
    icon: Icons.tune_rounded,
    title: (ctx) => ctx.l10n.settingsCategoryGeneral,
    subtitle: (ctx) => ctx.l10n.messagePlayerGeneralSettings,
    sections: [
      _buildTimelineSection(),
      _buildControlsSection(),
      _buildSkipIntervalsSection(),
      ...buildPlayerGeneralBehaviorSections(),
    ],
  );
}

SettingsSectionSpec _buildTimelineSection() {
  return SettingsSectionSpec(
    id: 'player.general.timeline',
    title: (ctx) => ctx.l10n.settingsCategoryTimeline,
    entries: [
      SettingsChoiceEntry<String>(
        id: 'player_seek_bar_mode',
        title: (ctx) => ctx.l10n.fieldTimelineMode,
        description: (ctx) => ctx.l10n.settingTimelineModeDescription,
        keywords: (l10n) => <String>['timeline', 'seek bar', 'progress', 'chapter'],
        definition: AppSettingDefs.playerSeekBarMode,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(
            value: PlayerSeekBarMode.chapter.name,
            label: ctx.l10n.fieldChapter,
            description: ctx.l10n.optionChapterTimelineDescription,
          ),
          SettingsChoiceOption(
            value: PlayerSeekBarMode.full.name,
            label: ctx.l10n.playbackFullTimeline,
            description: ctx.l10n.optionFullAudiobookTimelineDescription,
          ),
          SettingsChoiceOption(
            value: PlayerSeekBarMode.both.name,
            label: ctx.l10n.optionBoth,
            description: ctx.l10n.optionCombinedTimelineDescription,
          ),
        ],
      ),
      SettingsChoiceEntry<String>(
        id: 'player_seek_bar_marker_mode',
        title: (ctx) => ctx.l10n.settingTimelineMarkers,
        description: (ctx) => ctx.l10n.settingTimelineMarkersDescription,
        keywords: (l10n) => <String>['markers', 'bookmarks', 'chapters', 'timeline'],
        definition: AppSettingDefs.playerSeekBarMarkerMode,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(
            value: SeekBarMarkerMode.chapters.name,
            label: ctx.l10n.seekBarMarkersChapters,
            description: ctx.l10n.optionChapterMarkersDescription,
          ),
          SettingsChoiceOption(
            value: SeekBarMarkerMode.bookmarks.name,
            label: ctx.l10n.seekBarMarkersBookmarks,
            description: ctx.l10n.optionBookmarkMarkersDescription,
          ),
          SettingsChoiceOption(
            value: SeekBarMarkerMode.both.name,
            label: ctx.l10n.seekBarMarkersBoth,
            description: ctx.l10n.optionChapterAndBookmarkMarkersDescription,
          ),
          SettingsChoiceOption(
            value: SeekBarMarkerMode.none.name,
            label: ctx.l10n.optionNone,
            description: ctx.l10n.optionNoTimelineMarkersDescription,
          ),
        ],
      ),
    ],
  );
}

SettingsSectionSpec _buildControlsSection() {
  return SettingsSectionSpec(
    id: 'player.general.controls',
    title: (ctx) => ctx.l10n.settingsCategoryOnScreenControls,
    entries: [
      SettingsChoiceEntry<String>(
        id: 'full_player_transport_mode',
        title: (ctx) => ctx.l10n.settingFullPlayerTransportButtons,
        description: (ctx) => ctx.l10n.settingTransportModeDescription(ctx.l10n.playerTypeFull),
        keywords: (l10n) => <String>['transport', 'buttons', 'skip', 'controls'],
        definition: AppSettingDefs.fullPlayerTransportMode,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          for (final mode in PlayerTransportMode.values)
            SettingsChoiceOption(value: mode.name, label: mode.label(ctx.l10n)),
        ],
      ),
      SettingsCustomEntry(
        id: 'full_player_actions',
        title: (ctx) => ctx.l10n.settingFullPlayerActions,
        description: (ctx) => ctx.l10n.settingFullPlayerActionsDescription,
        keywords: (l10n) => <String>['actions', 'buttons', 'controls', 'speed', 'sleep timer'],
        builder: (context, ref, ctx) => PlayerActionSettingsEditor(
          title: ctx.l10n.settingFullPlayerActions,
          description: ctx.l10n.settingFullPlayerActionsDescription,
          settingKey: SettingKeys.fullPlayerActions,
          fallback: defaultFullPlayerActions,
        ),
      ),
      SettingsChoiceEntry<String>(
        id: 'mobile_player_left_action',
        title: (ctx) => ctx.l10n.settingLeftQuickAction,
        description: (ctx) => ctx.l10n.settingLeftQuickActionDescription,
        keywords: (l10n) => <String>['quick action', 'controls', 'player'],
        definition: AppSettingDefs.mobilePlayerLeftAction,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(value: 'none', label: ctx.l10n.optionNone),
          for (final action in PlayerActionType.values)
            SettingsChoiceOption(value: action.name, label: action.label(ctx.l10n)),
        ],
        onValueSelected: (context, ref, nextValue) async {
          final currentLeft = readSettingDefinition(ref, AppSettingDefs.mobilePlayerLeftAction);
          final currentRight = readSettingDefinition(ref, AppSettingDefs.mobilePlayerRightAction);
          if (nextValue != 'none' && nextValue == currentRight) {
            await writeSettingDefinition(ref, AppSettingDefs.mobilePlayerRightAction, currentLeft);
          }

          await writeSettingDefinition(ref, AppSettingDefs.mobilePlayerLeftAction, nextValue);
        },
      ),
      SettingsChoiceEntry<String>(
        id: 'mobile_player_right_action',
        title: (ctx) => ctx.l10n.settingRightQuickAction,
        description: (ctx) => ctx.l10n.settingRightQuickActionDescription,
        keywords: (l10n) => <String>['quick action', 'controls', 'player'],
        definition: AppSettingDefs.mobilePlayerRightAction,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(value: 'none', label: ctx.l10n.optionNone),
          for (final action in PlayerActionType.values)
            SettingsChoiceOption(value: action.name, label: action.label(ctx.l10n)),
        ],
        onValueSelected: (context, ref, nextValue) async {
          final currentLeft = readSettingDefinition(ref, AppSettingDefs.mobilePlayerLeftAction);
          final currentRight = readSettingDefinition(ref, AppSettingDefs.mobilePlayerRightAction);
          if (nextValue != 'none' && nextValue == currentLeft) {
            await writeSettingDefinition(ref, AppSettingDefs.mobilePlayerLeftAction, currentRight);
          }

          await writeSettingDefinition(ref, AppSettingDefs.mobilePlayerRightAction, nextValue);
        },
      ),
      SettingsChoiceEntry<String>(
        id: 'mini_player_transport_mode',
        title: (ctx) => ctx.l10n.settingMiniPlayerTransportButtons,
        description: (ctx) => ctx.l10n.settingTransportModeDescription(ctx.l10n.playerTypeMini),
        keywords: (l10n) => <String>['mini player', 'transport', 'buttons', 'controls'],
        definition: AppSettingDefs.miniPlayerTransportMode,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          for (final mode in PlayerTransportMode.values)
            SettingsChoiceOption(value: mode.name, label: mode.label(ctx.l10n)),
        ],
      ),
      SettingsCustomEntry(
        id: 'mini_player_actions',
        title: (ctx) => ctx.l10n.settingMiniPlayerActions,
        description: (ctx) => ctx.l10n.settingMiniPlayerActionsDescription,
        keywords: (l10n) => <String>['mini player', 'actions', 'controls'],
        builder: (context, ref, ctx) => PlayerActionSettingsEditor(
          title: ctx.l10n.settingMiniPlayerActions,
          description: ctx.l10n.settingMiniPlayerActionsDescription,
          settingKey: SettingKeys.miniPlayerActions,
          fallback: defaultMiniPlayerActions,
        ),
      ),
    ],
  );
}

SettingsSectionSpec _buildSkipIntervalsSection() {
  return SettingsSectionSpec(
    id: 'player.general.skip_intervals',
    title: (ctx) => ctx.l10n.settingsCategorySkipIntervals,
    entries: [
      SettingsSliderEntry<int>(
        id: 'fast_forward_interval',
        title: (ctx) => ctx.l10n.fieldFastForwardInterval,
        description: (ctx) => ctx.l10n.settingFastForwardIntervalDescription,
        keywords: (l10n) => <String>['skip', 'fast forward', 'seek', 'jump', 'seconds'],
        definition: AppSettingDefs.fastForwardInterval,
        values: const <int>[5, 10, 15, 20, 30, 45, 60],
        labelForValue: (ctx, seconds) => ctx.l10n.durationSeconds(seconds),
      ),
      SettingsSliderEntry<int>(
        id: 'rewind_interval',
        title: (ctx) => ctx.l10n.fieldRewindInterval,
        description: (ctx) => ctx.l10n.settingRewindIntervalDescription,
        keywords: (l10n) => <String>['skip', 'rewind', 'back', 'seek', 'seconds'],
        definition: AppSettingDefs.rewindInterval,
        values: const <int>[5, 10, 15, 20, 30, 45, 60],
        labelForValue: (ctx, seconds) => ctx.l10n.durationSeconds(seconds),
      ),
    ],
  );
}
