import 'package:flutter/material.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';

class PlayerTransportControlsComponent extends StatelessWidget {
  const PlayerTransportControlsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: 1,
      runSpacing: 1,
      children: <Widget>[
        SkipButton(previous: true),
        JumpButton(rewind: true),
        ControlButton(),
        JumpButton(rewind: false),
        SkipButton(previous: false),
      ],
    );
  }
}
