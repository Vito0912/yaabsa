import 'package:buchshelfly/components/player/common/control_button.dart';
import 'package:buchshelfly/components/player/common/jump_button.dart';
import 'package:buchshelfly/components/player/common/seek_bar.dart';
import 'package:buchshelfly/components/player/common/stop_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PlayBar extends HookWidget {
  const PlayBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [JumpButton(rewind: true), ControlButton(), JumpButton(rewind: false), StopButton()],
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: SeekBar()),
        ],
      ),
    );
  }
}
