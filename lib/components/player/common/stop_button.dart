import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';

class StopButton extends StatelessWidget {
  const StopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioHandler.shouldShowPlayer,
      builder: (BuildContext context, snapshot) {
        return IconButton(
          icon: Icon(Icons.stop),
          onPressed:
              snapshot.data == true
                  ? () {
                    audioHandler.stop();
                  }
                  : null,
        );
      },
    );
  }
}
