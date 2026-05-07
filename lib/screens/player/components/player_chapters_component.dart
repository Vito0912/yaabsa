import 'package:flutter/material.dart';
import 'package:yaabsa/screens/player/chapter.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';

class PlayerChaptersComponent extends StatelessWidget {
  const PlayerChaptersComponent({super.key, required this.emptyMode});

  final PlayerCollectionEmptyMode emptyMode;

  @override
  Widget build(BuildContext context) {
    return ChapterView(emptyMode: emptyMode);
  }
}
