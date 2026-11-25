import 'package:yaabsa/util/globals.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';

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

        return YaabsaActionIconButton(
          icon: Icons.stop_circle_outlined,
          buttonSize: 48,
          compact: false,
          tooltip: context.l10n.playbackStop,
          onPressed: () {
            audioHandler.stop();
          },
        );
      },
    );
  }
}
