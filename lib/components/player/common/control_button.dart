import 'package:yaabsa/features/player/widgets/playback_button.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:material_ui/material_ui.dart';
import 'package:just_audio/just_audio.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({super.key, this.prominent = false, this.iconSize, this.buttonSize});

  final bool prominent;
  final double? iconSize;
  final double? buttonSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: audioHandler.castControlActiveStream,
      initialData: audioHandler.isCastControlActive,
      builder: (context, castSnapshot) => StreamBuilder<PlayerState>(
        stream: audioHandler.playerControlStateStream,
        initialData: audioHandler.playerControlState,
        builder: (BuildContext context, snapshot) {
          final PlayerState? playerState = snapshot.data;
          final isPlaying = playerState?.playing ?? false;
          final castActive = castSnapshot.data ?? false;

          final isLoading =
              playerState == null ||
              playerState.processingState == ProcessingState.loading ||
              (!castActive && playerState.processingState == ProcessingState.buffering);

          return PlaybackButton(
            isPlaying: isPlaying,
            isLoading: isLoading,
            prominent: prominent,
            iconSize: iconSize,
            buttonSize: buttonSize,
            onPressed: () {
              if (isPlaying) {
                audioHandler.pause();
              } else {
                audioHandler.play();
              }
            },
          );
        },
      ),
    );
  }
}
