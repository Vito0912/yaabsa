import 'dart:math' as math;

import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:flutter/material.dart';

class VolumeSlider extends StatelessWidget {
  const VolumeSlider({super.key});

  static const double _minDb = -30.0;
  static const double _dbCurve = 0.5;

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
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.volume_down, color: Theme.of(context).colorScheme.primary),
        Expanded(
          child: StreamBuilder<double>(
            stream: audioHandler.volumeStream,
            initialData: 1.0,
            builder: (context, snapshot) {
              final volume = (snapshot.data ?? 1.0).clamp(0.0, BGAudioHandler.maxVolume).toDouble();
              final sliderValue = _volumeToSliderValue(volume);
              return Slider(
                year2023: false,
                value: sliderValue,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  audioHandler.setVolume(_sliderValueToVolume(value));
                },
              );
            },
          ),
        ),
        Icon(Icons.volume_up, color: Theme.of(context).colorScheme.primary),
      ],
    );
  }
}
