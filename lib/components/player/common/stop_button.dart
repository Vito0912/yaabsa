import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class StopButton extends StatelessWidget {
  const StopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioHandler.playerControlStateStream,
      initialData: audioHandler.playerControlState,
      builder: (BuildContext context, snapshot) {
        final state = snapshot.data;
        final shouldShowStop =
            state != null &&
            (state.processingState == ProcessingState.ready ||
                state.processingState == ProcessingState.loading ||
                state.processingState == ProcessingState.buffering ||
                state.processingState == ProcessingState.completed);

        if (!shouldShowStop) {
          return const SizedBox.shrink();
        }

        return IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () {
            audioHandler.stop();
          },
        );
      },
    );
  }
}
