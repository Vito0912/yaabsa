import 'package:yaabsa/util/globals.dart';
import 'package:material_ui/material_ui.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key, required this.previous, this.iconSize, this.buttonSize = 48});

  final bool previous;
  final double? iconSize;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    if (previous) {
      return IconButton(
        style: IconButton.styleFrom(minimumSize: Size.square(buttonSize)),
        iconSize: iconSize,
        tooltip: 'Previous',
        icon: const Icon(Icons.skip_previous_rounded),
        onPressed: () {
          audioHandler.skipToPreviousInApp();
        },
      );
    }

    return StreamBuilder<bool>(
      stream: audioHandler.canSkipForwardStream,
      initialData: audioHandler.canSkipForwardNow,
      builder: (context, snapshot) {
        final canSkip = snapshot.data == true;
        return IconButton(
          style: IconButton.styleFrom(minimumSize: Size.square(buttonSize)),
          iconSize: iconSize,
          tooltip: 'Next',
          icon: const Icon(Icons.skip_next_rounded),
          onPressed: canSkip
              ? () {
                  audioHandler.skipToNextInApp();
                }
              : null,
        );
      },
    );
  }
}
