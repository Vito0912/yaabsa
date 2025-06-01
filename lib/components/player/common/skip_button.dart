import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key, required this.previous});

  final bool previous;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(!previous ? Icons.skip_next_outlined : Icons.skip_previous_outlined),
      onPressed: () {
        !previous ? audioHandler.skipToNext() : audioHandler.skipToPrevious();
      },
    );
  }
}
