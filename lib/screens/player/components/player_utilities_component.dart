import 'package:flutter/material.dart';
import 'package:yaabsa/components/player/common/sleep_timer_button.dart';
import 'package:yaabsa/components/player/common/speed_slider.dart';
import 'package:yaabsa/components/player/common/volume_slider.dart';
import 'package:yaabsa/screens/player/chapter_quick_picker.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';

class PlayerUtilitiesComponent extends StatelessWidget {
  const PlayerUtilitiesComponent({
    super.key,
    required this.utilityOrder,
    required this.hiddenUtilities,
    required this.hasChapters,
  });

  final List<PlayerUtilityType> utilityOrder;
  final Set<PlayerUtilityType> hiddenUtilities;
  final bool hasChapters;

  @override
  Widget build(BuildContext context) {
    final visibleUtilities = utilityOrder
        .where((utility) => !hiddenUtilities.contains(utility))
        .toList(growable: false);

    if (visibleUtilities.isEmpty) {
      return Text(
        'No utility actions selected. Enable at least one in component settings.',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: visibleUtilities.map((utility) => _buildUtility(context, utility)).toList(growable: false),
    );
  }

  Widget _buildUtility(BuildContext context, PlayerUtilityType utility) {
    switch (utility) {
      case PlayerUtilityType.sleepTimer:
        return const SleepTimerButton();
      case PlayerUtilityType.speed:
        return const SpeedSlider();
      case PlayerUtilityType.chapter:
        return ChapterQuickPicker(enabled: hasChapters);
      case PlayerUtilityType.volume:
        return const VolumeSlider();
    }
  }
}
