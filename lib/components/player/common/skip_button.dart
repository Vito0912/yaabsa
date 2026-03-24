import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key, required this.previous});

  final bool previous;

  @override
  Widget build(BuildContext context) {
    if (previous) {
      return IconButton(
        icon: const Icon(Icons.skip_previous_outlined),
        onPressed: () {
          audioHandler.skipToPrevious();
        },
      );
    }

    return StreamBuilder<bool>(
      stream: audioHandler.canSkipForwardStream,
      initialData: audioHandler.canSkipForwardNow,
      builder: (context, snapshot) {
        final canSkip = snapshot.data == true;
        return IconButton(
          icon: const Icon(Icons.skip_next_outlined),
          onPressed: canSkip
              ? () {
                  audioHandler.skipToNext();
                }
              : null,
        );
      },
    );
  }
}
