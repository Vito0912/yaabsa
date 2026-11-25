import 'dart:async';

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/player/bluetooth_audio_devices_provider.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/player/player_action_settings_editor.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/bluetooth_auto_resume.dart';
import 'package:yaabsa/util/audio_handler/playback_keep_alive_level.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/l10n.dart';

class PlayerSettingsGeneral extends ConsumerWidget {
  const PlayerSettingsGeneral({super.key});

  static const String routeName = '/settings/player/general';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    const skipIntervalValues = [5, 10, 15, 20, 30, 45, 60];
    final autoQueueSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.autoQueue)).asData?.value;
    final autoQueueDefault = defaultSettings[SettingKeys.autoQueue] as bool? ?? true;
    final autoQueueEnabled = SettingsParser.decodeValue<bool>(autoQueueSetting, autoQueueDefault);
    final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final autoResumeSetting = ref
        .watch(globalSettingByKeyProvider(SettingKeys.autoResumeOnBluetoothConnection))
        .asData
        ?.value;
    final autoResumeEnabled = SettingsParser.decodeValue<bool>(
      autoResumeSetting,
      defaultSettings[SettingKeys.autoResumeOnBluetoothConnection] as bool,
    );
    final restrictAutoResumeSetting = ref
        .watch(globalSettingByKeyProvider(SettingKeys.restrictAutoResumeToSelectedBluetoothDevices))
        .asData
        ?.value;
    final restrictAutoResumeToSelectedDevices = SettingsParser.decodeValue<bool>(
      restrictAutoResumeSetting,
      defaultSettings[SettingKeys.restrictAutoResumeToSelectedBluetoothDevices] as bool,
    );
    final selectedBluetoothDeviceAddressesSetting = ref
        .watch(globalSettingByKeyProvider(SettingKeys.autoResumeBluetoothDeviceAddresses))
        .asData
        ?.value;
    final selectedBluetoothDeviceAddresses = decodeBluetoothDeviceAddresses(selectedBluetoothDeviceAddressesSetting);
    final bluetoothAudioDevices = isAndroid && autoResumeEnabled && restrictAutoResumeToSelectedDevices
        ? ref.watch(bluetoothAudioDevicesProvider)
        : null;
    final rawLayoutMode = ref.watch(globalSettingByKeyProvider(SettingKeys.playerLayoutMode)).asData?.value;
    final rawLayoutModeExplicit = ref
        .watch(globalSettingByKeyProvider(SettingKeys.playerLayoutModeExplicit))
        .asData
        ?.value;
    final rawLayoutConfig = ref.watch(globalSettingByKeyProvider(SettingKeys.playerLayoutConfig)).asData?.value;
    final layoutMode = PlayerLayoutMode.fromSettingValue(
      rawLayoutMode,
      hasSavedCustomLayout: hasCustomLayoutChanges(rawLayoutConfig),
      hasExplicitSelection: rawLayoutModeExplicit == 'true',
    );
    final rawAdaptivePreset = ref.watch(globalSettingByKeyProvider(SettingKeys.playerAdaptivePreset)).asData?.value;
    final adaptivePreset = PlayerAdaptivePreset.fromSettingValue(rawAdaptivePreset);
    final rawCoverSize = ref.watch(globalSettingByKeyProvider(SettingKeys.playerCoverSize)).asData?.value;
    final coverSize = PlayerCoverSize.fromSettingValue(rawCoverSize);
    final rawFullTransport = ref.watch(globalSettingByKeyProvider(SettingKeys.fullPlayerTransportMode)).asData?.value;
    final rawMiniTransport = ref.watch(globalSettingByKeyProvider(SettingKeys.miniPlayerTransportMode)).asData?.value;
    final rawMobileLeftAction = ref.watch(globalSettingByKeyProvider(SettingKeys.mobilePlayerLeftAction)).asData?.value;
    final rawMobileRightAction = ref
        .watch(globalSettingByKeyProvider(SettingKeys.mobilePlayerRightAction))
        .asData
        ?.value;
    final mobileLeftAction = decodeOptionalPlayerAction(rawMobileLeftAction, fallback: defaultMobilePlayerLeftAction);
    final mobileRightAction = decodeOptionalPlayerAction(
      rawMobileRightAction,
      fallback: defaultMobilePlayerRightAction,
    );
    PlayerTransportMode resolveTransport(String? rawValue) {
      return PlayerTransportMode.fromSettingValue(rawValue);
    }

    return SettingsPageScaffold(
      title: l10n.settingsCategoryGeneral,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingsNavigationSection(
          title: l10n.settingsCategoryTimeline,
          topPadding: 0,
          settings: [
            SettingDropdown<String>(
              label: l10n.fieldTimelineMode,
              description: l10n.settingTimelineModeDescription,
              values: PlayerSeekBarMode.values.map((mode) => mode.name).toList(),
              valueLabels: PlayerSeekBarMode.values.map((mode) => mode.label).toList(),
              valueDescriptions: [
                l10n.optionChapterTimelineDescription,
                l10n.optionFullAudiobookTimelineDescription,
                l10n.optionCombinedTimelineDescription,
              ],
              settingKey: SettingKeys.playerSeekBarMode,
            ),
            SettingDropdown<String>(
              label: l10n.settingTimelineMarkers,
              description: l10n.settingTimelineMarkersDescription,
              values: SeekBarMarkerMode.values.map((mode) => mode.name).toList(),
              valueLabels: SeekBarMarkerMode.values.map((mode) => mode.label).toList(),
              valueDescriptions: [
                l10n.optionChapterMarkersDescription,
                l10n.optionBookmarkMarkersDescription,
                l10n.optionChapterAndBookmarkMarkersDescription,
                l10n.optionNoTimelineMarkersDescription,
              ],
              settingKey: SettingKeys.playerSeekBarMarkerMode,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: l10n.settingsCategoryOnScreenControls,
          settings: [
            SettingDropdown<String>.remote(
              label: l10n.settingFullPlayerTransportButtons,
              description: l10n.settingTransportModeDescription(l10n.playerTypeFull),
              values: PlayerTransportMode.values.map((mode) => mode.name).toList(growable: false),
              valueLabels: PlayerTransportMode.values.map((mode) => mode.label(context.l10n)).toList(growable: false),
              value: resolveTransport(rawFullTransport).name,
              onValueChanged: (value) {
                ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<String>(SettingKeys.fullPlayerTransportMode, value);
              },
            ),
            PlayerActionSettingsEditor(
              title: l10n.settingFullPlayerActions,
              description: l10n.settingFullPlayerActionsDescription,
              settingKey: SettingKeys.fullPlayerActions,
              fallback: defaultFullPlayerActions,
            ),
            SettingDropdown<String>.remote(
              label: l10n.settingLeftQuickAction,
              description: l10n.settingLeftQuickActionDescription,
              values: <String>['none', ...PlayerActionType.values.map((action) => action.name)],
              valueLabels: <String>[
                context.l10n.optionNone,
                ...PlayerActionType.values.map((action) => action.label(context.l10n)),
              ],
              value: mobileLeftAction?.name ?? 'none',
              onValueChanged: (value) async {
                final settings = ref.read(settingsManagerProvider.notifier);
                if (value != 'none' && value == mobileRightAction?.name) {
                  await settings.setGlobalSetting<String>(
                    SettingKeys.mobilePlayerRightAction,
                    mobileLeftAction?.name ?? 'none',
                  );
                }
                await settings.setGlobalSetting<String>(SettingKeys.mobilePlayerLeftAction, value);
              },
            ),
            SettingDropdown<String>.remote(
              label: l10n.settingRightQuickAction,
              description: l10n.settingRightQuickActionDescription,
              values: <String>['none', ...PlayerActionType.values.map((action) => action.name)],
              valueLabels: <String>[
                context.l10n.optionNone,
                ...PlayerActionType.values.map((action) => action.label(context.l10n)),
              ],
              value: mobileRightAction?.name ?? 'none',
              onValueChanged: (value) async {
                final settings = ref.read(settingsManagerProvider.notifier);
                if (value != 'none' && value == mobileLeftAction?.name) {
                  await settings.setGlobalSetting<String>(
                    SettingKeys.mobilePlayerLeftAction,
                    mobileRightAction?.name ?? 'none',
                  );
                }
                await settings.setGlobalSetting<String>(SettingKeys.mobilePlayerRightAction, value);
              },
            ),
            SettingDropdown<String>.remote(
              label: l10n.settingMiniPlayerTransportButtons,
              description: l10n.settingTransportModeDescription(l10n.playerTypeMini),
              values: PlayerTransportMode.values.map((mode) => mode.name).toList(growable: false),
              valueLabels: PlayerTransportMode.values.map((mode) => mode.label(context.l10n)).toList(growable: false),
              value: resolveTransport(rawMiniTransport).name,
              onValueChanged: (value) {
                ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<String>(SettingKeys.miniPlayerTransportMode, value);
              },
            ),
            PlayerActionSettingsEditor(
              title: l10n.settingMiniPlayerActions,
              description: l10n.settingMiniPlayerActionsDescription,
              settingKey: SettingKeys.miniPlayerActions,
              fallback: defaultMiniPlayerActions,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: l10n.settingsCategorySkipIntervals,
          settings: [
            SettingSlider<int>(
              label: l10n.fieldFastForwardInterval,
              description: l10n.settingFastForwardIntervalDescription,
              values: skipIntervalValues,
              valueLabels: skipIntervalValues
                  .map((seconds) => Duration(seconds: seconds).toCompactRemainingString(localizations: l10n))
                  .toList(growable: false),
              settingKey: SettingKeys.fastForwardInterval,
            ),
            SettingSlider<int>(
              label: l10n.fieldRewindInterval,
              description: l10n.settingRewindIntervalDescription,
              values: skipIntervalValues,
              valueLabels: skipIntervalValues
                  .map((seconds) => Duration(seconds: seconds).toCompactRemainingString(localizations: l10n))
                  .toList(growable: false),
              settingKey: SettingKeys.rewindInterval,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: l10n.settingsCategoryPlaybackBehavior,
          settings: [
            SettingSwitchTile(
              label: l10n.settingRememberPlaybackSpeedPerBook,
              subtitle: l10n.settingRememberPlaybackSpeedPerBookDescription,
              settingKey: SettingKeys.playbackSpeedPerBook,
            ),
            SettingSwitchTile(
              label: l10n.settingStartPlaybackFromLocalProgress,
              subtitle: l10n.settingStartPlaybackFromLocalProgressDescription,
              settingKey: SettingKeys.startPlaybackFromLocalProgress,
            ),
            SettingSwitchTile(
              label: l10n.settingRestartListeningSessionAtMidnight,
              settingKey: SettingKeys.restartListeningSessionAtMidnight,
            ),
            SettingSwitchTile(
              label: l10n.settingSeekWithMediaSkipControls,
              subtitle: l10n.settingSeekWithMediaSkipControlsDescription,
              settingKey: SettingKeys.desktopSkipControlsSeek,
              onBeforeChanged: (context, enabled) async {
                if (!enabled) return true;

                return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.confirmSeekWithMediaSkipControlsTitle),
                        content: Text(l10n.confirmSeekWithMediaSkipControls),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.actionCancel)),
                          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.actionEnable)),
                        ],
                      ),
                    ) ??
                    false;
              },
            ),
            if (!kIsWeb && defaultTargetPlatform != TargetPlatform.fuchsia)
              SettingDropdown<String>(
                label: l10n.settingPreventWordClipping,
                description: l10n.settingPreventWordClippingDescription,
                values: PlaybackKeepAliveLevel.values.map((level) => level.name).toList(),
                valueLabels: PlaybackKeepAliveLevel.values.map((level) => level.label).toList(),
                settingKey: SettingKeys.preventWordClipping,
              ),
            if (isAndroid)
              SettingSwitchTile(
                label: l10n.settingSkipSilence,
                subtitle: l10n.settingSkipSilenceDescription,
                settingKey: SettingKeys.skipSilence,
              ),
            SettingSwitchTile(
              label: l10n.settingAutoQueue,
              subtitle: l10n.settingAutoQueueDescription,
              settingKey: SettingKeys.autoQueue,
            ),
            SettingSwitchTile(
              label: l10n.settingAutoQueueEverywhere,
              subtitle: l10n.settingAutoQueueEverywhereDescription,
              disabledReason: l10n.permissionEnableSettingToChangeOption(l10n.settingAutoQueue),
              settingKey: SettingKeys.autoQueueIncludeSeriesOutsideContext,
              enabled: autoQueueEnabled,
            ),
            SettingDropdown<String>(
              label: l10n.settingShowPlayerLoopShuffle,
              values: const ['off', 'music_only', 'on'],
              valueLabels: [l10n.statusOff, l10n.optionMusicOnly, l10n.statusOn],
              valueDescriptions: [
                l10n.optionLoopShuffleHiddenDescription,
                l10n.optionLoopShuffleMusicOnlyDescription,
                l10n.optionLoopShuffleAlwaysDescription,
              ],
              settingKey: SettingKeys.showPlayerLoopShuffle,
            ),
          ],
        ),
        if (isAndroid)
          SettingsNavigationSection(
            title: l10n.settingsCategoryAutoResume,
            settings: [
              // To my knowledge, we currently cannot detect wired changes without having a foreground service, so currently just bluetooth.
              // In a dev version I also had worked out a automatic resume for wired headphones, but this needed to have the app running.
              // As such feature is likley used by users who had the app not open for some hours, it would not work in most cases, so I decided to not add the overhead and just go with bluethoot
              // So if anyone comes across this, that is the reason for why only bluethoot currently, but happy to add wired too.
              SettingSwitchTile(
                label: l10n.settingAutoResumeOnBluetooth,
                subtitle: l10n.settingAutoResumeOnBluetoothDescription,
                settingKey: SettingKeys.autoResumeOnBluetoothConnection,
              ),
              SettingSwitchTile(
                label: l10n.settingOnlySelectedBluetoothDevices,
                subtitle: l10n.settingOnlySelectedBluetoothDevicesDescription,
                disabledReason: l10n.permissionEnableSettingToChangeOption(l10n.settingAutoResumeOnBluetooth),
                settingKey: SettingKeys.restrictAutoResumeToSelectedBluetoothDevices,
                enabled: autoResumeEnabled,
                onChanged: (enabled) {
                  if (enabled) {
                    ref.invalidate(bluetoothAudioDevicesProvider);
                  }
                },
              ),
              if (autoResumeEnabled && restrictAutoResumeToSelectedDevices)
                bluetoothAudioDevices!.when(
                  data: (devices) => SettingMultiSelectDropdown<String>(
                    label: l10n.fieldBluetoothAudioDevices,
                    description: l10n.settingOnlySelectedBluetoothDevicesDescription,
                    values: devices.map((device) => device.address).toList(growable: false),
                    valueLabels: devices.map((device) => device.name).toList(growable: false),
                    selectedValues: selectedBluetoothDeviceAddresses,
                    emptyValueLabel: l10n.statusNoBluetoothAudioDevices,
                    onValueChanged: (addresses) {
                      unawaited(
                        ref
                            .read(settingsManagerProvider.notifier)
                            .setGlobalSetting<String>(
                              SettingKeys.autoResumeBluetoothDeviceAddresses,
                              encodeBluetoothDeviceAddresses(addresses),
                            ),
                      );
                    },
                  ),
                  loading: () => SettingMultiSelectDropdown<String>(
                    label: l10n.fieldBluetoothAudioDevices,
                    values: [],
                    valueLabels: [],
                    selectedValues: [],
                    emptyValueLabel: l10n.statusLoadingBluetoothAudioDevices,
                    isLoading: true,
                    onValueChanged: _ignoreBluetoothAudioDeviceSelection,
                  ),
                  error: (error, stackTrace) => SettingMultiSelectDropdown<String>(
                    label: l10n.fieldBluetoothAudioDevices,
                    values: [],
                    valueLabels: [],
                    selectedValues: [],
                    emptyValueLabel: l10n.errorBluetoothPermissionRequired,
                    onValueChanged: _ignoreBluetoothAudioDeviceSelection,
                  ),
                ),
            ],
          ),
        SettingsNavigationSection(
          title: l10n.settingsCategoryPlayerAppearance,
          settings: [
            SettingDropdown<String>.remote(
              label: l10n.settingFullPlayerLayout,
              description: l10n.settingFullPlayerLayoutDescription,
              values: PlayerLayoutMode.values.map((mode) => mode.name).toList(growable: false),
              valueLabels: <String>[l10n.optionAdaptive, l10n.optionCustom],
              valueDescriptions: <String>[l10n.optionAdaptiveLayoutDescription, l10n.optionCustomLayoutDescription],
              value: layoutMode.name,
              onValueChanged: (value) {
                ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<bool>(SettingKeys.playerLayoutModeExplicit, true);
                ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<String>(SettingKeys.playerLayoutMode, value);
              },
            ),
            SettingDropdown<String>.remote(
              label: l10n.settingAdaptivePreset,
              description: l10n.settingAdaptivePresetDescription,
              values: PlayerAdaptivePreset.values.map((preset) => preset.name).toList(growable: false),
              valueLabels: PlayerAdaptivePreset.values
                  .map((preset) => preset.label(context.l10n))
                  .toList(growable: false),
              valueDescriptions: <String>[
                l10n.optionAdaptivePresetFullDescription,
                l10n.optionAdaptivePresetMinimalisticDescription,
              ],
              value: adaptivePreset.name,
              onValueChanged: (value) {
                ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<String>(SettingKeys.playerAdaptivePreset, value);
              },
              enabled: layoutMode == PlayerLayoutMode.adaptive,
            ),
            SettingDropdown<String>.remote(
              label: l10n.fieldCoverSize,
              description: l10n.settingCoverSizeDescription,
              values: PlayerCoverSize.values.map((size) => size.name).toList(growable: false),
              valueLabels: PlayerCoverSize.values.map((size) => size.label(context.l10n)).toList(growable: false),
              valueDescriptions: <String>[
                l10n.optionCoverSizeAutomaticDescription,
                l10n.optionCoverSizeCompactDescription,
                l10n.optionCoverSizeLargeDescription,
              ],
              value: coverSize.name,
              onValueChanged: (value) {
                ref.read(settingsManagerProvider.notifier).setGlobalSetting<String>(SettingKeys.playerCoverSize, value);
              },
              enabled: layoutMode == PlayerLayoutMode.adaptive,
            ),
            SettingSwitchTile(
              label: l10n.fieldImmersivePlayerColors,
              subtitle: l10n.settingImmersivePlayerColorsDescription,
              settingKey: SettingKeys.playerImmersiveColors,
            ),
          ],
        ),
        if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS))
          SettingsNavigationSection(
            title: l10n.settingsCategoryAudioInterruptions,
            settings: [
              SettingDropdown<String>(
                label: l10n.settingInterruptionBehavior,
                description: l10n.settingInterruptionBehaviorDescription,
                values: ['pause', 'duck'],
                valueLabels: [l10n.playbackPause, l10n.playbackLowerVolume],
                valueDescriptions: [l10n.optionPausePlayback, l10n.optionLowerPlaybackVolumeDescription],
                settingKey: SettingKeys.audioAnnouncementMode,
              ),
            ],
          ),
      ],
    );
  }
}

void _ignoreBluetoothAudioDeviceSelection(List<String> _) {}
