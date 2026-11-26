import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/player/player_settings_equalizer.dart';
import 'package:yaabsa/util/device_capabilities.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';

SettingsPageSpec buildPlayerSubtitlesPage() {
  return SettingsPageSpec(
    id: 'player.subtitles',
    parentId: 'player',
    route: SettingsRoutes.playerSubtitles,
    scope: SettingScope.account,
    icon: Icons.subtitles_outlined,
    title: (ctx) => ctx.l10n.playerComponentSubtitles,
    subtitle: (ctx) => ctx.l10n.messageSubtitleSettings,
    requiresSignIn: true,
    sections: [
      SettingsSectionSpec(
        id: 'player.subtitles.main',
        title: (ctx) => ctx.l10n.playerComponentSubtitles,
        entries: [
          SettingsToggleEntry(
            id: 'subtitles_enabled',
            title: (ctx) => ctx.l10n.settingEnableSubtitles,
            description: (ctx) => ctx.l10n.settingEnableSubtitlesDescription,
            keywords: (l10n) => <String>[l10n.playerComponentSubtitles, 'subtitles', 'captions', 'transcript'],
            definition: AppSettingDefs.subtitlesEnabled,
          ),
          SettingsToggleEntry(
            id: 'subtitle_speaker_highlighting',
            title: (ctx) => ctx.l10n.settingHighlightSpeakerLabels,
            description: (ctx) => ctx.l10n.settingHighlightSpeakerLabelsDescription,
            keywords: (l10n) => <String>[l10n.playerComponentSubtitles, 'subtitles', 'speaker'],
            definition: AppSettingDefs.subtitleSpeakerHighlighting,
          ),
          SettingsToggleEntry(
            id: 'subtitle_read_along',
            title: (ctx) => ctx.l10n.settingEnableReadAlong,
            description: (ctx) => ctx.l10n.settingEnableReadAlongDescription,
            keywords: (l10n) => <String>[l10n.playerComponentSubtitles, 'subtitles', 'read along', 'karaoke'],
            definition: AppSettingDefs.subtitleReadAlong,
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec buildPlayerEqualizerPage() {
  return SettingsPageSpec(
    id: 'player.equalizer',
    parentId: 'player',
    route: SettingsRoutes.playerEqualizer,
    scope: SettingScope.app,
    icon: Icons.equalizer_rounded,
    title: (ctx) => ctx.l10n.navEqualizer,
    subtitle: (ctx) => ctx.l10n.messageEqualizerSettings,
    availability: (ctx) {
      if (ctx.isAndroid) {
        return const SettingsAvailability.available();
      }

      return const SettingsAvailability.hidden();
    },
    customPageBuilder: (context, {focusEntryId}) => const PlayerSettingsEqualizer(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'equalizer_meta',
        title: (ctx) => ctx.l10n.navEqualizer,
        description: (ctx) => ctx.l10n.messageEqualizerSettings,
        keywords: (l10n) => <String>[
          l10n.navEqualizer,
          l10n.equalizerPresetFlat,
          l10n.equalizerPresetNarration,
          'eq',
          'equalizer',
          'audio',
          'bass',
          'preset',
        ],
      ),
    ],
  );
}

SettingsPageSpec buildPlayerShakeControlsPage() {
  final sensitivityValues = List<double>.generate(25, (index) => (index + 11) / 10);

  SettingsAvailability requireShakeSensors(SettingsContext ctx) {
    if (ctx.supportsShakeActions) {
      return const SettingsAvailability.available();
    }

    return SettingsAvailability.disabled(ctx.l10n.permissionMotionSensorsRequired);
  }

  return SettingsPageSpec(
    id: 'player.shake_controls',
    parentId: 'player',
    route: SettingsRoutes.playerShakeControls,
    scope: SettingScope.app,
    icon: Icons.vibration_rounded,
    title: (ctx) => ctx.l10n.settingsCategoryShakeControls,
    subtitle: (ctx) {
      if (ctx.supportsShakeActions) {
        return ctx.l10n.messageShakeControlsSettings;
      }

      return ctx.l10n.statusMotionSensorsRequired;
    },
    sections: [
      SettingsSectionSpec(
        id: 'player.shake_controls.main',
        title: (ctx) => ctx.l10n.settingsCategoryShakeControls,
        entries: [
          SettingsToggleEntry(
            id: 'shake_reset_sleep_timer',
            title: (ctx) => ctx.l10n.settingShakeToResetSleepTimer,
            description: (ctx) => ctx.l10n.settingShakeToResetSleepTimerDescription,
            keywords: (l10n) => <String>['shake', 'sleep timer', 'motion'],
            definition: AppSettingDefs.shakeToResetSleepTimer,
            availability: requireShakeSensors,
          ),
          SettingsToggleEntry(
            id: 'shake_to_rewind',
            title: (ctx) => ctx.l10n.settingShakeToRewind,
            description: (ctx) => ctx.l10n.settingShakeToRewindDescription,
            keywords: (l10n) => <String>['shake', 'rewind', 'motion'],
            definition: AppSettingDefs.shakeToRewind,
            availability: requireShakeSensors,
          ),
          SettingsSliderEntry<double>(
            id: 'shake_sensitivity',
            title: (ctx) => ctx.l10n.settingShakeSensitivity,
            description: (ctx) => ctx.l10n.settingShakeSensitivityDescription,
            keywords: (l10n) => <String>['shake', 'sensitivity', 'motion'],
            definition: AppSettingDefs.shakeSensitivity,
            values: sensitivityValues,
            labelForValue: (ctx, value) => ctx.l10n.settingShakeSensitivityValue(value),
            availability: requireShakeSensors,
          ),
          SettingsCustomEntry(
            id: 'shake_vibration_feedback',
            title: (ctx) => ctx.l10n.settingShakeVibrationFeedback,
            description: (ctx) => ctx.l10n.settingShakeVibrationFeedbackDescription,
            keywords: (l10n) => <String>['shake', 'vibration', 'haptic'],
            availability: requireShakeSensors,
            builder: (context, ref, ctx) => const _ShakeVibrationFeedbackTile(),
          ),
        ],
      ),
    ],
  );
}

class _ShakeVibrationFeedbackTile extends StatefulWidget {
  const _ShakeVibrationFeedbackTile();

  @override
  State<_ShakeVibrationFeedbackTile> createState() => _ShakeVibrationFeedbackTileState();
}

class _ShakeVibrationFeedbackTileState extends State<_ShakeVibrationFeedbackTile> {
  late final Future<bool> _vibrationSupportFuture = DeviceCapabilities.supportsVibrationFeedback();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final supportsShakeActions = DeviceCapabilities.supportsShakeActions;

    return FutureBuilder<bool>(
      future: _vibrationSupportFuture,
      builder: (context, snapshot) {
        final finished = snapshot.connectionState == ConnectionState.done;
        final supportsVibration = snapshot.data == true;
        final enabled = supportsShakeActions && supportsVibration;

        String? disabledReason;
        if (!supportsShakeActions) {
          disabledReason = l10n.permissionMotionSensorsRequired;
        } else if (!finished) {
          disabledReason = l10n.statusCheckingVibrationSupport;
        } else if (!supportsVibration) {
          disabledReason = l10n.statusVibrationUnavailable;
        }

        return SettingSwitchTile(
          label: l10n.settingShakeVibrationFeedback,
          subtitle: l10n.settingShakeVibrationFeedbackDescription,
          settingKey: SettingKeys.shakeVibrate,
          enabled: enabled,
          disabledReason: disabledReason,
        );
      },
    );
  }
}

SettingsPageSpec buildPlayerCompatibilityPage() {
  return SettingsPageSpec(
    id: 'player.compatibility',
    parentId: 'player',
    route: SettingsRoutes.playerCompatibility,
    scope: SettingScope.app,
    icon: Icons.build_outlined,
    title: (ctx) => ctx.l10n.settingsCategoryCompatibility,
    subtitle: (ctx) => ctx.l10n.settingsCompatibilityDescription,
    availability: (ctx) {
      if (ctx.isLinux || ctx.isAndroid) {
        return const SettingsAvailability.available();
      }

      return const SettingsAvailability.hidden();
    },
    sections: [
      SettingsSectionSpec(
        id: 'player.compatibility.decoding',
        title: (ctx) => ctx.l10n.settingsCategoryAudioDecoding,
        entries: [
          SettingsToggleEntry(
            id: 'disable_fdk_aac_decoder',
            title: (ctx) => ctx.l10n.settingDisableFdkAacDecoder,
            description: (ctx) => ctx.l10n.settingDisableFdkAacDecoderDescription,
            keywords: (l10n) => <String>['aac', 'fdk', 'decoder', 'audio', 'compatibility'],
            definition: AppSettingDefs.disableFdkAacDecoder,
            availability: (ctx) {
              if (ctx.isLinux) {
                return const SettingsAvailability.available();
              }

              return const SettingsAvailability.hidden();
            },
          ),
          SettingsToggleEntry(
            id: 'enable_index_seeking',
            title: (ctx) => ctx.l10n.settingEnableMp3IndexSeeking,
            description: (ctx) => ctx.l10n.settingEnableMp3IndexSeekingDescription,
            keywords: (l10n) => <String>['mp3', 'seeking', 'index', 'compatibility'],
            definition: AppSettingDefs.enableIndexSeeking,
            availability: (ctx) {
              if (ctx.isAndroid) {
                return const SettingsAvailability.available();
              }

              return const SettingsAvailability.hidden();
            },
          ),
        ],
      ),
    ],
  );
}
