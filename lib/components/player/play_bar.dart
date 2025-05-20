import 'package:buchshelfly/components/player/common/control_button.dart';
import 'package:buchshelfly/components/player/common/seek_bar.dart';
import 'package:buchshelfly/components/player/common/stop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PlayBar extends HookWidget {
  const PlayBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [ControlButton(), StopButton()]),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: SeekBar()),
      ],
    );
  }
}
