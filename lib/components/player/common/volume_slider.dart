import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:flutter/material.dart';

class VolumeSlider extends StatelessWidget {
  const VolumeSlider({super.key});

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
              final volume = snapshot.data ?? 1.0;
              return Slider(
                year2023: false,
                value: volume,
                min: 0.0,
                max: BGAudioHandler.maxVolume,
                onChanged: (value) {
                  audioHandler.setVolume(value);
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
