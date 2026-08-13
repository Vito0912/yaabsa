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
import 'package:yaabsa/util/setting_key.dart';

class PlayerSettingsGeneral extends ConsumerWidget {
  const PlayerSettingsGeneral({super.key});

  static const String routeName = '/settings/player/general';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoQueueSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.autoQueue)).asData?.value;
    final autoQueueDefault = defaultSettings[SettingKeys.autoQueue] as bool? ?? true;
    final autoQueueEnabled = SettingsParser.decodeValue<bool>(autoQueueSetting, autoQueueDefault);
    final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final isDesktop =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows);
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
      title: 'Player - General',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingsNavigationSection(
          title: 'Timeline',
          topPadding: 0,
          settings: [
            SettingDropdown<String>(
              label: 'Timeline mode',
              description: 'Choose whether the seek bar tracks a chapter, the full audiobook, or both',
              values: PlayerSeekBarMode.values.map((mode) => mode.name).toList(),
              valueLabels: PlayerSeekBarMode.values.map((mode) => mode.label).toList(),
              valueDescriptions: const [
                'Track currently playing chapter',
                'Track full audiobook timeline',
                'Track chapter and full audiobook timeline',
              ],
              settingKey: SettingKeys.playerSeekBarMode,
            ),
            SettingDropdown<String>(
              label: 'Timeline markers',
              description: 'Choose whether the full timeline displays chapter markers, bookmark markers, both, or none',
              values: SeekBarMarkerMode.values.map((mode) => mode.name).toList(),
              valueLabels: SeekBarMarkerMode.values.map((mode) => mode.label).toList(),
              valueDescriptions: const [
                'Display chapter tick marks',
                'Display bookmark markers',
                'Display chapters and bookmarks',
                'Hide all timeline markers',
              ],
              settingKey: SettingKeys.playerSeekBarMarkerMode,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'On-screen controls',
          settings: [
            SettingDropdown<String>.remote(
              label: 'Full player transport buttons',
              description: 'Choose whether the full player shows timed jumps, item/chapter skips, or both',
              values: PlayerTransportMode.values.map((mode) => mode.name).toList(growable: false),
              valueLabels: PlayerTransportMode.values.map((mode) => mode.label).toList(growable: false),
              value: resolveTransport(rawFullTransport).name,
              onValueChanged: (value) {
                ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<String>(SettingKeys.fullPlayerTransportMode, value);
              },
            ),
            const PlayerActionSettingsEditor(
              title: 'Full player actions',
              description: 'Actions available in the full player',
              settingKey: SettingKeys.fullPlayerActions,
              fallback: defaultFullPlayerActions,
            ),
            SettingDropdown<String>.remote(
              label: 'Left quick action',
              description: 'Action shown at the lower left of the Minimalistic player',
              values: <String>['none', ...PlayerActionType.values.map((action) => action.name)],
              valueLabels: <String>['None', ...PlayerActionType.values.map((action) => action.label)],
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
              label: 'Right quick action',
              description: 'Action shown at the lower right of the Minimalistic player',
              values: <String>['none', ...PlayerActionType.values.map((action) => action.name)],
              valueLabels: <String>['None', ...PlayerActionType.values.map((action) => action.label)],
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
              label: 'Mini player transport buttons',
              description: 'Choose whether the mini player shows timed jumps, item/chapter skips, or both',
              values: PlayerTransportMode.values.map((mode) => mode.name).toList(growable: false),
              valueLabels: PlayerTransportMode.values.map((mode) => mode.label).toList(growable: false),
              value: resolveTransport(rawMiniTransport).name,
              onValueChanged: (value) {
                ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<String>(SettingKeys.miniPlayerTransportMode, value);
              },
            ),
            const PlayerActionSettingsEditor(
              title: 'Mini player actions',
              description: 'Actions available from the mini-player menu',
              settingKey: SettingKeys.miniPlayerActions,
              fallback: defaultMiniPlayerActions,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Skip Intervals',
          settings: [
            SettingSlider<int>(
              label: 'Fast forward interval',
              description: 'How many seconds to skip when jumping forward',
              values: const [5, 10, 15, 20, 30, 45, 60],
              valueLabels: const ['5 s', '10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
              settingKey: SettingKeys.fastForwardInterval,
            ),
            SettingSlider<int>(
              label: 'Rewind interval',
              description: 'How many seconds to skip when rewinding',
              values: const [5, 10, 15, 20, 30, 45, 60],
              valueLabels: const ['5 s', '10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
              settingKey: SettingKeys.rewindInterval,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Playback Behavior',
          settings: [
            const SettingSwitchTile(
              label: 'Remember playback speed per book',
              subtitle: 'Each book remembers its own speed and new books start with your last used speed',
              settingKey: SettingKeys.playbackSpeedPerBook,
            ),
            if (isDesktop)
              SettingSwitchTile(
                label: 'Seek with media skip controls',
                subtitle: 'Make external next/previous media controls seek by the configured skip intervals',
                settingKey: SettingKeys.desktopSkipControlsSeek,
                onBeforeChanged: (context, enabled) async {
                  if (!enabled) return true;

                  return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Seek with media skip controls?'),
                          content: const Text(
                            'This changes how Yaabsa handles external media controls, such as Bluetooth headset buttons and media keyboard hotkeys. '
                            'Next and previous will seek by the configured intervals instead of skipping chapters or queue items.\n\n'
                            'Buttons inside Yaabsa keep their normal skip behavior. This setting affects only Yaabsa.',
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Enable')),
                          ],
                        ),
                      ) ??
                      false;
                },
              ),
            if (isAndroid)
              const SettingSwitchTile(
                label: 'Skip silence',
                subtitle: 'Automatically skip silent gaps during playback',
                settingKey: SettingKeys.skipSilence,
              ),
            const SettingSwitchTile(
              label: 'Auto queue',
              subtitle: 'Automatically queue upcoming books when playback starts from library, series, playlist, or collection views',
              settingKey: SettingKeys.autoQueue,
            ),
            SettingSwitchTile(
              label: 'Auto queue everywhere',
              subtitle: 'Auto queue books from the first linked series even when starting playback outside a series view, including via car, Bluetooth, or voice',
              disabledReason: 'Enable Auto queue to use this option',
              settingKey: SettingKeys.autoQueueIncludeSeriesOutsideContext,
              enabled: autoQueueEnabled,
            ),
            SettingDropdown<String>(
              label: 'Show Loop & Shuffle controls',
              values: const ['off', 'music_only', 'on'],
              valueLabels: const ['Off', 'Music Only', 'On'],
              valueDescriptions: const [
                'Never show loop and shuffle controls',
                'Only show loop and shuffle for music libraries',
                'Always show loop and shuffle controls',
              ],
              settingKey: SettingKeys.showPlayerLoopShuffle,
            ),
          ],
        ),
        if (isAndroid)
          SettingsNavigationSection(
            title: 'Auto Resume',
            settings: [
              // To my knowledge, we currently cannot detect wired changes without having a foreground service, so currently just bluetooth.
              // In a dev version I also had worked out a automatic resume for wired headphones, but this needed to have the app running.
              // As such feature is likley used by users who had the app not open for some hours, it would not work in most cases, so I decided to not add the overhead and just go with bluethoot
              // So if anyone comes across this, that is the reason for why only bluethoot currently, but happy to add wired too.
              SettingSwitchTile(
                label: 'Auto-resume on Bluetooth',
                subtitle: 'Automatically resume playback when connecting a Bluetooth audio device',
                settingKey: SettingKeys.autoResumeOnBluetoothConnection,
              ),
              SettingSwitchTile(
                label: 'Only selected Bluetooth devices',
                subtitle: 'Choose which paired Bluetooth audio devices can resume playback',
                disabledReason: 'Enable Auto-resume on Bluetooth to choose devices',
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
                    label: 'Bluetooth audio devices',
                    description: 'Only selected paired Bluetooth audio devices will resume playback when connected.',
                    values: devices.map((device) => device.address).toList(growable: false),
                    valueLabels: devices.map((device) => device.name).toList(growable: false),
                    selectedValues: selectedBluetoothDeviceAddresses,
                    emptyValueLabel: 'No paired Bluetooth audio devices found',
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
                  loading: () => const SettingMultiSelectDropdown<String>(
                    label: 'Bluetooth audio devices',
                    values: [],
                    valueLabels: [],
                    selectedValues: [],
                    emptyValueLabel: 'Loading paired Bluetooth audio devices',
                    isLoading: true,
                    onValueChanged: _ignoreBluetoothAudioDeviceSelection,
                  ),
                  error: (error, stackTrace) => const SettingMultiSelectDropdown<String>(
                    label: 'Bluetooth audio devices',
                    values: [],
                    valueLabels: [],
                    selectedValues: [],
                    emptyValueLabel: 'Bluetooth permission is required to list audio devices',
                    onValueChanged: _ignoreBluetoothAudioDeviceSelection,
                  ),
                ),
            ],
          ),
        SettingsNavigationSection(
          title: 'Player appearance',
          settings: [
            SettingDropdown<String>.remote(
              label: 'Full player layout',
              description: 'Selects how the full player arranges its components',
              values: PlayerLayoutMode.values.map((mode) => mode.name).toList(growable: false),
              valueLabels: const <String>['Adaptive', 'Custom'],
              valueDescriptions: const <String>[
                'Adapts the selected preset to the available screen space',
                'Uses the saved component grid',
              ],
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
              label: 'Adaptive preset',
              description: 'Selects the controls shown by the adaptive player',
              values: PlayerAdaptivePreset.values.map((preset) => preset.name).toList(growable: false),
              valueLabels: PlayerAdaptivePreset.values.map((preset) => preset.label).toList(growable: false),
              valueDescriptions: const <String>[
                'Shows configured actions in a bottom action bar on mobile',
                'Shows two quick actions',
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
              label: 'Cover size',
              description: 'Sets the artwork size in the adaptive player',
              values: PlayerCoverSize.values.map((size) => size.name).toList(growable: false),
              valueLabels: PlayerCoverSize.values.map((size) => size.label).toList(growable: false),
              valueDescriptions: const <String>[
                'Uses the size associated with the selected preset',
                'Uses the smaller artwork size',
                'Uses the larger artwork size',
              ],
              value: coverSize.name,
              onValueChanged: (value) {
                ref.read(settingsManagerProvider.notifier).setGlobalSetting<String>(SettingKeys.playerCoverSize, value);
              },
              enabled: layoutMode == PlayerLayoutMode.adaptive,
            ),
            const SettingSwitchTile(
              label: 'Immersive player colors',
              subtitle: 'Uses artwork colors for players',
              settingKey: SettingKeys.playerImmersiveColors,
            ),
          ],
        ),
      ],
    );
  }
}

void _ignoreBluetoothAudioDeviceSelection(List<String> _) {}
