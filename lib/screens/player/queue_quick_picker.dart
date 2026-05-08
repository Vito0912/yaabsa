import 'package:flutter/material.dart';
import 'package:yaabsa/screens/player/queue.dart';

class QueueQuickPicker extends StatelessWidget {
  const QueueQuickPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (BuildContext context) {
              return SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: PlayerQueueView(showEmptyIcon: false),
                  ),
                ),
              );
            },
          );
        },
        icon: const Icon(Icons.queue_music_rounded),
      ),
    );
  }
}
