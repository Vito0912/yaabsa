import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';

class JumpButton extends StatelessWidget {
  const JumpButton({super.key, required this.rewind});

  final bool rewind;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(rewind ? Icons.replay_10 : Icons.forward_10),
      onPressed: () {
        rewind ? audioHandler.rewind() : audioHandler.fastForward();
      },
    );
  }
}
