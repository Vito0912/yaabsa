import 'package:flutter/material.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';
import 'package:yaabsa/screens/player/queue.dart';

class PlayerQueueComponent extends StatelessWidget {
  const PlayerQueueComponent({super.key, required this.emptyMode});

  final PlayerCollectionEmptyMode emptyMode;

  @override
  Widget build(BuildContext context) {
    return PlayerQueueView(showEmptyIcon: false, emptyMode: emptyMode);
  }
}
