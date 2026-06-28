import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';

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
  if (preset == null || preset.isEmpty) return 0.0;
  if (totalBands == 1) return preset[0];

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
    if (!isAndroid) {
      return const SettingsPageScaffold(
        title: 'Equalizer',
        embedded: true,
        showEmbeddedBackButton: true,
        embeddedBackFallbackRoute: PlayerSettings.routeName,
        children: [
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text('Equalizer is not available on this device/platform.', textAlign: TextAlign.center),
            ),
          ),
        ],
      );
    }

    final equalizerEnabledStr = ref.watch(globalSettingByKeyProvider(SettingKeys.equalizerEnabled)).asData?.value;
    final equalizerEnabled = SettingsParser.decodeValue<bool>(equalizerEnabledStr, false);
    final equalizer = audioHandler.equalizer;

    return SettingsPageScaffold(
      title: 'Equalizer',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SwitchListTile(
          title: const Text('Enable Equalizer'),
          value: equalizerEnabled,
          onChanged: (newValue) async {
            if (newValue) {
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Enable Equalizer'),
                  content: const Text(
                    'After enabling the equalizer, you must restart the app for it to take effect.'
                    'Note: On some devices, the equalizer is not supported and might cause crashes during playback. If playback fails to start, disable the equalizer and restart the app.',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Enable')),
                  ],
                ),
              );
              if (confirm == true) {
                await ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<bool>(SettingKeys.equalizerEnabled, true);
              }
            } else {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Disable Equalizer'),
                  content: const Text('Please restart the app to apply this change.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Disable')),
                  ],
                ),
              );
              if (confirm == true) {
                await ref
                    .read(settingsManagerProvider.notifier)
                    .setGlobalSetting<bool>(SettingKeys.equalizerEnabled, false);
              }
            }
          },
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
                    'Equalizer is currently disabled',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Note that you must restart the app after enabling the equalizer for it to take effect and edit the band gains while listening.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else if (equalizer == null)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.restart_alt_rounded, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text('Restart Required', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text(
                    'The equalizer has been enabled but requires restarting the app to apply to the playback pipeline.',
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
                          'No Active Playback Session',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please start playing an item to configure the equalizer band gains.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return FutureBuilder<AndroidEqualizerParameters>(
                future: equalizer.parameters,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'Error loading equalizer parameters: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final params = snapshot.data;
                  if (params == null || params.bands.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: Text('No equalizer bands found', textAlign: TextAlign.center)),
                    );
                  }

                  if (!_isInitialized) {
                    final savedGainsStr = ref
                        .read(globalSettingByKeyProvider(SettingKeys.equalizerBandGains))
                        .asData
                        ?.value;
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
                          currentGains[band.index] = getPresetGainForBand(
                            currentPreset,
                            band.index,
                            params.bands.length,
                          );
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
                        child: DropdownButtonFormField<String>(
                          initialValue: currentPreset,
                          decoration: const InputDecoration(
                            labelText: 'Equalizer Preset',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          items: [
                            ...equalizerPresets.keys.map(
                              (preset) => DropdownMenuItem(value: preset, child: Text(preset)),
                            ),
                            const DropdownMenuItem(value: 'Custom', child: Text('Custom')),
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
            },
          ),
      ],
    );
  }

  void _applyPreset(String presetName, List<AndroidEqualizerBand> bands) {
    if (presetName == 'Custom') return;
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

  String _formatFrequency(double hertz) {
    if (hertz >= 1000) {
      return '${(hertz / 1000).toStringAsFixed(1).replaceAll('.0', '')} kHz';
    }
    return '${hertz.toInt()} Hz';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${currentGain > 0 ? '+' : ''}${currentGain.toStringAsFixed(1)} dB',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: enabled ? null : Theme.of(context).disabledColor,
          ),
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
          _formatFrequency(band.centerFrequency),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: enabled ? null : Theme.of(context).disabledColor,
          ),
        ),
      ],
    );
  }
}
