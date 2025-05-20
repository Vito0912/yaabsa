import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class StopButton extends StatelessWidget {
  const StopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioHandler.player.playerStateStream,
      builder: (BuildContext context, snapshot) {
        final PlayerState? playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;

        return IconButton(
          icon: Icon(Icons.stop),
          onPressed:
              isPlaying
                  ? () {
                    audioHandler.stop();
                  }
                  : null,
        );
      },
    );
  }
}
