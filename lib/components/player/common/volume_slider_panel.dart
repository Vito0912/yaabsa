import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/setting_key.dart';

class VolumeSliderPanel extends ConsumerWidget {
  const VolumeSliderPanel({super.key, required this.axis});

  static const double _minDb = -30.0;
  static const double _dbCurve = 0.5;

  final Axis axis;

  double _volumeToSliderValue(double volume) {
    final maxVolume = BGAudioHandler.maxVolume;
    if (maxVolume <= 0) {
      return 0.0;
    }

    final clampedVolume = volume.clamp(0.0, maxVolume).toDouble();
    if (clampedVolume == 0.0) {
      return 0.0;
    }

    final maxDb = 20 * math.log(maxVolume) / math.ln10;
    final dbRange = maxDb - _minDb;
    if (dbRange <= 0) {
      return (clampedVolume / maxVolume).clamp(0.0, 1.0);
    }

    final volumeDb = 20 * math.log(clampedVolume) / math.ln10;
    final normalizedDb = ((volumeDb - _minDb) / dbRange).clamp(0.0, 1.0);
    return math.pow(normalizedDb, 1 / _dbCurve).toDouble().clamp(0.0, 1.0);
  }

  double _sliderValueToVolume(double sliderValue) {
    final maxVolume = BGAudioHandler.maxVolume;
    if (maxVolume <= 0) {
      return 0.0;
    }

    final clampedSliderValue = sliderValue.clamp(0.0, 1.0).toDouble();
    if (clampedSliderValue == 0.0) {
      return 0.0;
    }

    final maxDb = 20 * math.log(maxVolume) / math.ln10;
    final dbRange = maxDb - _minDb;
    if (dbRange <= 0) {
      return (clampedSliderValue * maxVolume).clamp(0.0, maxVolume);
    }

    final easedSliderValue = math.pow(clampedSliderValue, _dbCurve).toDouble();
    final volumeDb = _minDb + (dbRange * easedSliderValue);
    final volume = math.pow(10, volumeDb / 20).toDouble();
    return volume.clamp(0.0, maxVolume);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBoostToggle = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    return StreamBuilder<double>(
      stream: audioHandler.volumeStream,
      initialData: 1.0,
      builder: (context, snapshot) {
        final maxVolume = BGAudioHandler.maxVolume;
        final volume = (snapshot.data ?? 1.0).clamp(0.0, maxVolume).toDouble();
        final sliderValue = _volumeToSliderValue(volume);

        if (axis == Axis.vertical) {
          return _VerticalVolumePanel(
            sliderValue: sliderValue,
            onChanged: (value) => audioHandler.setVolume(_sliderValueToVolume(value)),
          );
        }

        return _HorizontalVolumePanel(
          volume: volume,
          sliderValue: sliderValue,
          onChanged: (value) => audioHandler.setVolume(_sliderValueToVolume(value)),
          boostToggle: showBoostToggle ? const _VolumeBoostToggle() : null,
        );
      },
    );
  }
}

class _HorizontalVolumePanel extends StatelessWidget {
  const _HorizontalVolumePanel({
    required this.volume,
    required this.sliderValue,
    required this.onChanged,
    this.boostToggle,
  });

  final double volume;
  final double sliderValue;
  final ValueChanged<double> onChanged;
  final Widget? boostToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Volume', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.volume_down_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: _VolumeSlider(value: sliderValue, onChanged: onChanged),
            ),
            const SizedBox(width: 8),
            Icon(Icons.volume_up_rounded, color: Theme.of(context).colorScheme.primary),
          ],
        ),
        const SizedBox(height: 8),
        Text('${(volume * 100).round()}%', style: Theme.of(context).textTheme.bodyMedium),
        if (boostToggle != null) ...[const Divider(height: 24), boostToggle!],
      ],
    );
  }
}

class _VerticalVolumePanel extends StatelessWidget {
  const _VerticalVolumePanel({required this.sliderValue, required this.onChanged});

  final double sliderValue;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 182,
      child: RotatedBox(
        quarterTurns: 3,
        child: _VolumeSlider(value: sliderValue, onChanged: onChanged),
      ),
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  const _VolumeSlider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(value: value, min: 0.0, max: 1.0, onChanged: onChanged);
  }
}

class _VolumeBoostToggle extends ConsumerWidget {
  const _VolumeBoostToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(globalSettingByKeyProvider(SettingKeys.volumeBoostEnabled)).asData?.value;
    final isEnabled = SettingsParser.decodeValue<bool>(setting, false);

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Volume Boost'),
      value: isEnabled,
      onChanged: (value) {
        ref.read(settingsManagerProvider.notifier).setGlobalSetting<bool>(SettingKeys.volumeBoostEnabled, value);
      },
    );
  }
}
