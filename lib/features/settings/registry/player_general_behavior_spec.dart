import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/widgets/settings_multi_choice_presentation.dart';
import 'package:yaabsa/provider/player/bluetooth_audio_devices_provider.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/util/audio_handler/playback_keep_alive_level.dart';
import 'package:yaabsa/util/l10n.dart';

PlayerLayoutMode _resolvePlayerLayoutMode(SettingsContext ctx) {
  final rawMode = ctx.readSetting(AppSettingDefs.playerLayoutMode);
  final explicit = ctx.readSetting(AppSettingDefs.playerLayoutModeExplicit);
  final rawConfig = ctx.readSetting(AppSettingDefs.playerLayoutConfig);

  return PlayerLayoutMode.fromSettingValue(
    rawMode,
    hasSavedCustomLayout: hasCustomLayoutChanges(rawConfig),
    hasExplicitSelection: explicit,
  );
}

List<SettingsSectionSpec> buildPlayerGeneralBehaviorSections() {
  return <SettingsSectionSpec>[
    _buildPlaybackBehaviorSection(),
    _buildAutoResumeSection(),
    _buildPlayerAppearanceSection(),
    _buildAudioInterruptionsSection(),
  ];
}

SettingsSectionSpec _buildPlaybackBehaviorSection() {
  return SettingsSectionSpec(
    id: 'player.general.behavior',
    title: (ctx) => ctx.l10n.settingsCategoryPlaybackBehavior,
    entries: [
      SettingsToggleEntry(
        id: 'playback_speed_per_book',
        title: (ctx) => ctx.l10n.settingRememberPlaybackSpeedPerBook,
        description: (ctx) => ctx.l10n.settingRememberPlaybackSpeedPerBookDescription,
        keywords: (l10n) => <String>[l10n.playbackSpeed, 'speed', 'rate', 'per book'],
        definition: AppSettingDefs.playbackSpeedPerBook,
      ),
      SettingsToggleEntry(
        id: 'start_playback_from_local_progress',
        title: (ctx) => ctx.l10n.settingStartPlaybackFromLocalProgress,
        description: (ctx) => ctx.l10n.settingStartPlaybackFromLocalProgressDescription,
        keywords: (l10n) => <String>['progress', 'sync', 'local', 'resume'],
        definition: AppSettingDefs.startPlaybackFromLocalProgress,
      ),
      SettingsToggleEntry(
        id: 'restart_listening_session_at_midnight',
        title: (ctx) => ctx.l10n.settingRestartListeningSessionAtMidnight,
        keywords: (l10n) => <String>['session', 'midnight', 'statistics'],
        definition: AppSettingDefs.restartListeningSessionAtMidnight,
      ),
      SettingsToggleEntry(
        id: 'desktop_skip_controls_seek',
        title: (ctx) => ctx.l10n.settingSeekWithMediaSkipControls,
        description: (ctx) => ctx.l10n.settingSeekWithMediaSkipControlsDescription,
        keywords: (l10n) => <String>['skip', 'seek', 'media keys', 'keyboard'],
        definition: AppSettingDefs.desktopSkipControlsSeek,
        onBeforeChanged: (context, enabled) async {
          if (!enabled) {
            return true;
          }

          final l10n = context.l10n;
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(l10n.confirmSeekWithMediaSkipControlsTitle),
              content: Text(l10n.confirmSeekWithMediaSkipControls),
              actions: [
                TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.actionCancel)),
                FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.actionEnable)),
              ],
            ),
          );

          return confirmed ?? false;
        },
      ),
      SettingsChoiceEntry<String>(
        id: 'prevent_word_clipping',
        title: (ctx) => ctx.l10n.settingPreventWordClipping,
        description: (ctx) => ctx.l10n.settingPreventWordClippingDescription,
        keywords: (l10n) => <String>['word clipping', 'audio', 'bluetooth', 'keep alive'],
        definition: AppSettingDefs.preventWordClipping,
        availability: (ctx) {
          if (ctx.isWeb || ctx.platform == TargetPlatform.fuchsia) {
            return const SettingsAvailability.hidden();
          }

          return const SettingsAvailability.available();
        },
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          for (final level in PlaybackKeepAliveLevel.values)
            SettingsChoiceOption(value: level.name, label: level.label),
        ],
      ),
      SettingsToggleEntry(
        id: 'skip_silence',
        title: (ctx) => ctx.l10n.settingSkipSilence,
        description: (ctx) => ctx.l10n.settingSkipSilenceDescription,
        keywords: (l10n) => <String>['silence', 'skip', 'speed', 'audio'],
        definition: AppSettingDefs.skipSilence,
        availability: (ctx) {
          if (ctx.isAndroid) {
            return const SettingsAvailability.available();
          }

          return const SettingsAvailability.hidden();
        },
      ),
      SettingsToggleEntry(
        id: 'auto_queue',
        title: (ctx) => ctx.l10n.settingAutoQueue,
        description: (ctx) => ctx.l10n.settingAutoQueueDescription,
        keywords: (l10n) => <String>['queue', 'next', 'auto queue', 'series'],
        definition: AppSettingDefs.autoQueue,
      ),
      SettingsToggleEntry(
        id: 'auto_queue_everywhere',
        title: (ctx) => ctx.l10n.settingAutoQueueEverywhere,
        description: (ctx) => ctx.l10n.settingAutoQueueEverywhereDescription,
        keywords: (l10n) => <String>['queue', 'auto queue', 'series'],
        definition: AppSettingDefs.autoQueueIncludeSeriesOutsideContext,
        availability: (ctx) {
          if (ctx.readSetting(AppSettingDefs.autoQueue)) {
            return const SettingsAvailability.available();
          }

          return SettingsAvailability.disabled(
            ctx.l10n.permissionEnableSettingToChangeOption(ctx.l10n.settingAutoQueue),
          );
        },
      ),
      SettingsChoiceEntry<String>(
        id: 'show_player_loop_shuffle',
        title: (ctx) => ctx.l10n.settingShowPlayerLoopShuffle,
        keywords: (l10n) => <String>['loop', 'repeat', 'shuffle'],
        definition: AppSettingDefs.showPlayerLoopShuffle,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(
            value: 'off',
            label: ctx.l10n.statusOff,
            description: ctx.l10n.optionLoopShuffleHiddenDescription,
          ),
          SettingsChoiceOption(
            value: 'music_only',
            label: ctx.l10n.optionMusicOnly,
            description: ctx.l10n.optionLoopShuffleMusicOnlyDescription,
          ),
          SettingsChoiceOption(
            value: 'on',
            label: ctx.l10n.statusOn,
            description: ctx.l10n.optionLoopShuffleAlwaysDescription,
          ),
        ],
      ),
    ],
  );
}

SettingsSectionSpec _buildAutoResumeSection() {
  return SettingsSectionSpec(
    id: 'player.general.auto_resume',
    title: (ctx) => ctx.l10n.settingsCategoryAutoResume,
    availability: (ctx) {
      if (ctx.isAndroid) {
        return const SettingsAvailability.available();
      }

      return const SettingsAvailability.hidden();
    },
    entries: [
      SettingsToggleEntry(
        id: 'auto_resume_bluetooth',
        title: (ctx) => ctx.l10n.settingAutoResumeOnBluetooth,
        description: (ctx) => ctx.l10n.settingAutoResumeOnBluetoothDescription,
        keywords: (l10n) => <String>['bluetooth', 'headset', 'headphones', 'auto resume', 'car'],
        definition: AppSettingDefs.autoResumeOnBluetoothConnection,
      ),
      SettingsToggleEntry(
        id: 'restrict_auto_resume_bluetooth_devices',
        title: (ctx) => ctx.l10n.settingOnlySelectedBluetoothDevices,
        description: (ctx) => ctx.l10n.settingOnlySelectedBluetoothDevicesDescription,
        keywords: (l10n) => <String>['bluetooth', 'devices', 'headset', 'auto resume'],
        definition: AppSettingDefs.restrictAutoResumeToSelectedBluetoothDevices,
        availability: (ctx) {
          if (ctx.readSetting(AppSettingDefs.autoResumeOnBluetoothConnection)) {
            return const SettingsAvailability.available();
          }

          return SettingsAvailability.disabled(
            ctx.l10n.permissionEnableSettingToChangeOption(ctx.l10n.settingAutoResumeOnBluetooth),
          );
        },
        onChanged: (ref, enabled) {
          if (enabled) {
            ref.invalidate(bluetoothAudioDevicesProvider);
          }
        },
      ),
      SettingsCustomEntry(
        id: 'auto_resume_bluetooth_device_addresses',
        title: (ctx) => ctx.l10n.fieldBluetoothAudioDevices,
        description: (ctx) => ctx.l10n.settingOnlySelectedBluetoothDevicesDescription,
        keywords: (l10n) => <String>['bluetooth', 'devices', 'audio', 'headset', 'auto resume'],
        availability: (ctx) {
          final autoResume = ctx.readSetting(AppSettingDefs.autoResumeOnBluetoothConnection);
          final restrict = ctx.readSetting(AppSettingDefs.restrictAutoResumeToSelectedBluetoothDevices);
          if (ctx.isAndroid && autoResume && restrict) {
            return const SettingsAvailability.available();
          }

          return const SettingsAvailability.hidden();
        },
        builder: (context, ref, ctx) {
          final selectedAddresses = watchSettingDefinition(ref, AppSettingDefs.autoResumeBluetoothDeviceAddresses);
          final devicesAsync = ref.watch(bluetoothAudioDevicesProvider);

          return devicesAsync.when(
            data: (devices) => SettingsMultiChoicePresentation<String>(
              label: ctx.l10n.fieldBluetoothAudioDevices,
              description: ctx.l10n.settingOnlySelectedBluetoothDevicesDescription,
              options: [
                for (final device in devices) SettingsChoiceOption<String>(value: device.address, label: device.name),
              ],
              selectedValues: selectedAddresses,
              emptyLabel: ctx.l10n.statusNoBluetoothAudioDevices,
              onChanged: (addresses) {
                unawaited(writeSettingDefinition(ref, AppSettingDefs.autoResumeBluetoothDeviceAddresses, addresses));
              },
            ),
            loading: () => SettingsMultiChoicePresentation<String>(
              label: ctx.l10n.fieldBluetoothAudioDevices,
              description: ctx.l10n.settingOnlySelectedBluetoothDevicesDescription,
              options: const <SettingsChoiceOption<String>>[],
              selectedValues: const <String>{},
              emptyLabel: ctx.l10n.statusLoadingBluetoothAudioDevices,
              isLoading: true,
              onChanged: null,
            ),
            error: (error, stackTrace) => SettingsMultiChoicePresentation<String>(
              label: ctx.l10n.fieldBluetoothAudioDevices,
              description: ctx.l10n.settingOnlySelectedBluetoothDevicesDescription,
              options: const <SettingsChoiceOption<String>>[],
              selectedValues: const <String>{},
              emptyLabel: ctx.l10n.errorBluetoothPermissionRequired,
              enabled: false,
              onChanged: null,
            ),
          );
        },
      ),
    ],
  );
}

SettingsSectionSpec _buildPlayerAppearanceSection() {
  return SettingsSectionSpec(
    id: 'player.general.appearance',
    title: (ctx) => ctx.l10n.settingsCategoryPlayerAppearance,
    entries: [
      SettingsChoiceEntry<String>(
        id: 'player_layout_mode',
        title: (ctx) => ctx.l10n.settingFullPlayerLayout,
        description: (ctx) => ctx.l10n.settingFullPlayerLayoutDescription,
        keywords: (l10n) => <String>['layout', 'player', 'adaptive', 'custom'],
        definition: AppSettingDefs.playerLayoutMode,
        valueResolver: (ctx) => _resolvePlayerLayoutMode(ctx).name,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(
            value: PlayerLayoutMode.adaptive.name,
            label: ctx.l10n.optionAdaptive,
            description: ctx.l10n.optionAdaptiveLayoutDescription,
          ),
          SettingsChoiceOption(
            value: PlayerLayoutMode.custom.name,
            label: ctx.l10n.optionCustom,
            description: ctx.l10n.optionCustomLayoutDescription,
          ),
        ],
        onValueSelected: (context, ref, nextValue) async {
          await writeSettingDefinition(ref, AppSettingDefs.playerLayoutModeExplicit, true);
          await writeSettingDefinition(ref, AppSettingDefs.playerLayoutMode, nextValue);
        },
      ),
      SettingsChoiceEntry<String>(
        id: 'player_adaptive_preset',
        title: (ctx) => ctx.l10n.settingAdaptivePreset,
        description: (ctx) => ctx.l10n.settingAdaptivePresetDescription,
        keywords: (l10n) => <String>['preset', 'adaptive', 'minimalistic', 'player'],
        definition: AppSettingDefs.playerAdaptivePreset,
        availability: (ctx) {
          if (_resolvePlayerLayoutMode(ctx) == PlayerLayoutMode.adaptive) {
            return const SettingsAvailability.available();
          }

          return SettingsAvailability.disabled(ctx.l10n.permissionEnableSettingToChangeOption(ctx.l10n.optionAdaptive));
        },
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(
            value: PlayerAdaptivePreset.full.name,
            label: PlayerAdaptivePreset.full.label(ctx.l10n),
            description: ctx.l10n.optionAdaptivePresetFullDescription,
          ),
          SettingsChoiceOption(
            value: PlayerAdaptivePreset.minimalistic.name,
            label: PlayerAdaptivePreset.minimalistic.label(ctx.l10n),
            description: ctx.l10n.optionAdaptivePresetMinimalisticDescription,
          ),
        ],
      ),
      SettingsChoiceEntry<String>(
        id: 'player_cover_size',
        title: (ctx) => ctx.l10n.fieldCoverSize,
        description: (ctx) => ctx.l10n.settingCoverSizeDescription,
        keywords: (l10n) => <String>['cover', 'artwork', 'size', 'player'],
        definition: AppSettingDefs.playerCoverSize,
        availability: (ctx) {
          if (_resolvePlayerLayoutMode(ctx) == PlayerLayoutMode.adaptive) {
            return const SettingsAvailability.available();
          }

          return SettingsAvailability.disabled(ctx.l10n.permissionEnableSettingToChangeOption(ctx.l10n.optionAdaptive));
        },
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(
            value: PlayerCoverSize.automatic.name,
            label: PlayerCoverSize.automatic.label(ctx.l10n),
            description: ctx.l10n.optionCoverSizeAutomaticDescription,
          ),
          SettingsChoiceOption(
            value: PlayerCoverSize.compact.name,
            label: PlayerCoverSize.compact.label(ctx.l10n),
            description: ctx.l10n.optionCoverSizeCompactDescription,
          ),
          SettingsChoiceOption(
            value: PlayerCoverSize.large.name,
            label: PlayerCoverSize.large.label(ctx.l10n),
            description: ctx.l10n.optionCoverSizeLargeDescription,
          ),
        ],
      ),
      SettingsToggleEntry(
        id: 'player_immersive_colors',
        title: (ctx) => ctx.l10n.fieldImmersivePlayerColors,
        description: (ctx) => ctx.l10n.settingImmersivePlayerColorsDescription,
        keywords: (l10n) => <String>['colors', 'theme', 'immersive', 'cover', 'player'],
        definition: AppSettingDefs.playerImmersiveColors,
      ),
    ],
  );
}

SettingsSectionSpec _buildAudioInterruptionsSection() {
  return SettingsSectionSpec(
    id: 'player.general.interruptions',
    title: (ctx) => ctx.l10n.settingsCategoryAudioInterruptions,
    availability: (ctx) {
      if (ctx.isMobilePlatform) {
        return const SettingsAvailability.available();
      }

      return const SettingsAvailability.hidden();
    },
    entries: [
      SettingsChoiceEntry<String>(
        id: 'audio_announcement_mode',
        title: (ctx) => ctx.l10n.settingInterruptionBehavior,
        description: (ctx) => ctx.l10n.settingInterruptionBehaviorDescription,
        keywords: (l10n) => <String>['duck', 'pause', 'navigation', 'audio focus', 'interruptions'],
        definition: AppSettingDefs.audioAnnouncementMode,
        optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
          SettingsChoiceOption(
            value: 'pause',
            label: ctx.l10n.playbackPause,
            description: ctx.l10n.optionPausePlayback,
          ),
          SettingsChoiceOption(
            value: 'duck',
            label: ctx.l10n.playbackLowerVolume,
            description: ctx.l10n.optionLowerPlaybackVolumeDescription,
          ),
        ],
      ),
    ],
  );
}
