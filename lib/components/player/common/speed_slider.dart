import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';

// TODO: Better solution. Speed is currently not linarally with the slider values. Maybe something like the settings slider.
class SpeedSlider extends StatelessWidget {
  static const List<double> speeds = [0.25, 0.5, 0.75, 0.8, 0.9, 1, 1.1, 1.2, 1.25, 1.5, 1.75, 2, 2.25, 2.5];

  const SpeedSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.slow_motion_video, color: Theme.of(context).colorScheme.primary),
        Expanded(
          child: StreamBuilder<double>(
            stream: audioHandler.player.speedStream,
            initialData: 1.0,
            builder: (context, snapshot) {
              final speed = snapshot.data ?? 1.0;
              print(speed);
              return Slider(
                value: speed,
                min: speeds.first,
                max: speeds.last,
                divisions: 15,
                year2023: false,
                label: speed.toStringAsFixed(2) + "x",
                onChanged: (value) {
                  final closest = speeds.reduce((a, b) => (a - value).abs() < (b - value).abs() ? a : b);
                  audioHandler.setSpeed(closest);
                },
              );
            },
          ),
        ),
        Icon(Icons.speed, color: Theme.of(context).colorScheme.primary),
      ],
    );
  }
}
