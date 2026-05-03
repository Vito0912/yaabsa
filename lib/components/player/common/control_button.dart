import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioHandler.playerControlStateStream,
      initialData: audioHandler.playerControlState,
      builder: (BuildContext context, snapshot) {
        final PlayerState? playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;

        if (playerState == null ||
            playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering) {
          return const CircularProgressIndicator();
        }

        return IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) {
              audioHandler.pause();
            } else {
              audioHandler.play();
            }
          },
        );
      },
    );
  }
}
