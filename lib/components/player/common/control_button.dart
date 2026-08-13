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
    return StreamBuilder<PlayerState>(
      stream: audioHandler.playerControlStateStream,
      initialData: audioHandler.playerControlState,
      builder: (BuildContext context, snapshot) {
        final PlayerState? playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;

        if (playerState == null ||
            playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering) {
          return RepaintBoundary(
            child: SizedBox.square(
              dimension: buttonSize ?? (prominent ? 68 : 48),
              child: const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2.5)),
            ),
          );
        }

        return IconButton.filled(
          style: prominent
              ? IconButton.styleFrom(
                  minimumSize: Size.square(buttonSize ?? 68),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                )
              : IconButton.styleFrom(minimumSize: Size.square(buttonSize ?? 48)),
          iconSize: iconSize ?? (prominent ? 34 : 26),
          tooltip: isPlaying ? 'Pause' : 'Play',
          icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
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
