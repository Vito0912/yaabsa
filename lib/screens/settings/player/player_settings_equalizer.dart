import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

// TODO: These need fixing later. The presets are mostly random values with a bit of AI sanity help.
// Most of them are for music anyway, which should be neat, but if you are a dev and come across these values, because you think the presets are of
// Just open a PR
const Map<String, List<double>> equalizerPresets = {
  'Flat': [0.0, 0.0, 0.0, 0.0, 0.0],
  'Narration': [-4.0, -1.0, 2.0, 3.0, 0.0],
  'Classical': [0.0, 0.0, 0.0, 2.0, 4.0],
  'Dance': [6.0, 2.0, 0.0, 2.0, 4.0],
  'Heavy Metal': [5.0, 2.0, -3.0, 3.0, 4.0],
  'Rock': [5.0, 3.0, -3.0, 2.0, 5.0],
};

double getPresetGainForBand(String presetName, int bandIndex, int totalBands) {
  final preset = equalizerPresets[presetName];
  if (preset == null || preset.isEmpty) {
    return 0.0;
  }
  if (totalBands == 1) {
    return preset[0];
  }

  final double t = bandIndex / (totalBands - 1);
  final double idxDouble = t * (preset.length - 1);
  final int lowIdx = idxDouble.floor();
  final int highIdx = idxDouble.ceil();
  final double fraction = idxDouble - lowIdx;

  final double lowVal = preset[lowIdx];
  final double highVal = preset[highIdx];

  return lowVal + fraction * (highVal - lowVal);
}

class PlayerSettingsEqualizer extends ConsumerStatefulWidget {
  const PlayerSettingsEqualizer({super.key});

  static const String routeName = '/settings/player/equalizer';

  @override
  ConsumerState<PlayerSettingsEqualizer> createState() => _PlayerSettingsEqualizerState();
}

class _PlayerSettingsEqualizerState extends ConsumerState<PlayerSettingsEqualizer> {
  Map<int, double> currentGains = {};
  String currentPreset = 'Flat';
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final l10n = context.l10n;

    if (!isAndroid) {
      return SettingsPageScaffold(
        title: l10n.navEqualizer,
        embedded: true,
        showEmbeddedBackButton: true,
        embeddedBackFallbackRoute: SettingsRoutes.player,
        children: [
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: Text(l10n.errorEqualizerUnavailableOnDevice, textAlign: TextAlign.center)),
          ),
        ],
      );
    }

    final equalizerEnabledStr = ref.watch(globalSettingByKeyProvider(SettingKeys.equalizerEnabled)).asData?.value;
    final equalizerEnabled = SettingsParser.decodeValue<bool>(equalizerEnabledStr, false);
    final equalizer = audioHandler.equalizer;

    return SettingsPageScaffold(
      title: l10n.navEqualizer,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: SettingsRoutes.player,
      children: [
        StreamBuilder<AudioEffectStatus>(
          stream: equalizer?.statusStream,
          initialData: equalizer?.status,
          builder: (context, statusSnapshot) {
            final unavailable =
                equalizer == null || statusSnapshot.data?.availability == AudioEffectAvailability.unavailable;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsSwitchPresentation(
                  label: l10n.settingEnableEqualizer,
                  value: equalizerEnabled,
                  enabled: !unavailable,
                  onChanged: (newValue) => ref
                      .read(settingsManagerProvider.notifier)
                      .setGlobalSetting<bool>(SettingKeys.equalizerEnabled, newValue),
                ),
                const SizedBox(height: 12),
                if (!equalizerEnabled)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.equalizer_rounded, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            l10n.statusEqualizerDisabled,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.promptEnableEqualizerToAdjustBands,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (unavailable)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.equalizer_rounded, size: 64, color: Colors.orange),
                          const SizedBox(height: 16),
                          Text(
                            l10n.statusEqualizerUnavailable,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.messageEqualizerWillRetry,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  StreamBuilder<int?>(
                    stream: audioHandler.androidAudioSessionIdStream,
                    initialData: audioHandler.androidAudioSessionId,
                    builder: (context, sessionSnapshot) {
                      final sessionId = sessionSnapshot.data;
                      if (sessionId == null) {
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.play_circle_outline, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.statusNoActivePlaybackSession,
                                  style: Theme.of(context).textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.promptStartPlaybackToConfigureEqualizer,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return _buildEqualizerParameters(context, ref, equalizer, equalizerEnabled);
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildEqualizerParameters(
    BuildContext context,
    WidgetRef ref,
    AndroidEqualizer equalizer,
    bool equalizerEnabled,
  ) {
    final l10n = context.l10n;

    return FutureBuilder<AndroidEqualizerParameters>(
      future: equalizer.parameters,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: YaabsaCircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                l10n.errorOperationFailed(l10n.operationLoadEqualizerParameters, l10n.errorUnknown),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final params = snapshot.data;
        if (params == null || params.bands.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: Text(l10n.statusNoEqualizerBands, textAlign: TextAlign.center)),
          );
        }

        if (!_isInitialized) {
          final savedGainsStr = ref.read(globalSettingByKeyProvider(SettingKeys.equalizerBandGains)).asData?.value;
          final savedPreset = ref.read(globalSettingByKeyProvider(SettingKeys.equalizerPreset)).asData?.value;

          if (savedPreset != null) {
            currentPreset = savedPreset;
          }

          if (savedGainsStr != null && savedGainsStr.isNotEmpty) {
            try {
              final Map<String, dynamic> decoded = jsonDecode(savedGainsStr);
              currentGains = decoded.map((key, value) => MapEntry(int.parse(key), (value as num).toDouble()));
            } catch (e) {
              currentGains = {};
            }
          }

          for (final band in params.bands) {
            if (!currentGains.containsKey(band.index)) {
              if (currentPreset != 'Custom') {
                currentGains[band.index] = getPresetGainForBand(currentPreset, band.index, params.bands.length);
              } else {
                currentGains[band.index] = band.gain;
              }
            }
          }

          _isInitialized = true;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: YaabsaDropdownField<String>(
                label: context.l10n.settingEqualizerPreset,
                value: currentPreset,
                items: [
                  ...equalizerPresets.keys.map(
                    (preset) => DropdownMenuItem(
                      value: preset,
                      child: Text(switch (preset) {
                        'Flat' => context.l10n.equalizerPresetFlat,
                        'Narration' => context.l10n.equalizerPresetNarration,
                        'Classical' => context.l10n.equalizerPresetClassical,
                        'Dance' => context.l10n.equalizerPresetDance,
                        'Heavy Metal' => context.l10n.equalizerPresetHeavyMetal,
                        'Rock' => context.l10n.equalizerPresetRock,
                        _ => preset,
                      }),
                    ),
                  ),
                  DropdownMenuItem(value: 'Custom', child: Text(context.l10n.optionCustom)),
                ],
                onChanged: (newPreset) {
                  if (newPreset != null) {
                    _applyPreset(newPreset, params.bands);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                child: SizedBox(
                  height: 260,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(params.bands.length, (index) {
                          final band = params.bands[index];
                          final double gain = currentGains[band.index] ?? 0.0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              width: 72,
                              child: EqualizerBandSlider(
                                band: band,
                                currentGain: gain,
                                minDb: params.minDecibels,
                                maxDb: params.maxDecibels,
                                enabled: equalizerEnabled,
                                onChanged: (newVal) {
                                  setState(() {
                                    currentPreset = 'Custom';
                                    currentGains[band.index] = newVal;
                                  });
                                  band.setGain(newVal);
                                },
                                onChangeEnd: (finalVal) {
                                  ref
                                      .read(settingsManagerProvider.notifier)
                                      .setGlobalSetting(SettingKeys.equalizerPreset, 'Custom');
                                  _saveGainsToDb(currentGains);
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _applyPreset(String presetName, List<AndroidEqualizerBand> bands) {
    if (presetName == 'Custom') {
      return;
    }
    final updatedGains = <int, double>{};
    for (final band in bands) {
      final gain = getPresetGainForBand(presetName, band.index, bands.length);
      updatedGains[band.index] = gain;
      band.setGain(gain);
    }
    setState(() {
      currentPreset = presetName;
      currentGains = updatedGains;
    });

    ref.read(settingsManagerProvider.notifier).setGlobalSetting(SettingKeys.equalizerPreset, presetName);
    _saveGainsToDb(updatedGains);
  }

  void _saveGainsToDb(Map<int, double> gains) {
    final Map<String, double> stringKeyMap = gains.map((key, value) => MapEntry(key.toString(), value));
    final jsonStr = jsonEncode(stringKeyMap);
    ref.read(settingsManagerProvider.notifier).setGlobalSetting(SettingKeys.equalizerBandGains, jsonStr);
  }
}

class EqualizerBandSlider extends StatelessWidget {
  final AndroidEqualizerBand band;
  final double currentGain;
  final double minDb;
  final double maxDb;
  final bool enabled;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const EqualizerBandSlider({
    super.key,
    required this.band,
    required this.currentGain,
    required this.minDb,
    required this.maxDb,
    required this.enabled,
    required this.onChanged,
    required this.onChangeEnd,
  });

  String _formatFrequency(BuildContext context, double hertz) {
    final l10n = context.l10n;
    if (hertz >= 1000) {
      return l10n.equalizerFrequencyKilohertz(hertz / 1000);
    }

    return l10n.equalizerFrequencyHertz(hertz.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.equalizerGain(currentGain > 0 ? '+' : '', currentGain),
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w500, color: enabled ? null : Theme.of(context).disabledColor),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: RotatedBox(
            quarterTurns: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(
                value: currentGain.clamp(minDb, maxDb),
                min: minDb,
                max: maxDb,
                onChanged: enabled ? onChanged : null,
                onChangeEnd: enabled ? onChangeEnd : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatFrequency(context, band.centerFrequency),
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: enabled ? null : Theme.of(context).disabledColor),
        ),
      ],
    );
  }
}
