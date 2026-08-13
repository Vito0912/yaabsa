import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/bookmarks_button.dart';
import 'package:yaabsa/components/player/common/sleep_timer_button.dart';
import 'package:yaabsa/components/player/common/speed_slider.dart';
import 'package:yaabsa/components/player/common/volume_slider.dart';
import 'package:yaabsa/screens/player/chapter_quick_picker.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/screens/player/queue_quick_picker.dart';

class PlayerActionBar extends StatelessWidget {
  const PlayerActionBar({
    super.key,
    required this.actions,
    required this.hasChapters,
    this.alignment = WrapAlignment.center,
    this.spacing = 6,
    this.showLabels = false,
    this.grouped = false,
    this.actionOverrides = const <PlayerActionType, VoidCallback>{},
  });

  final List<PlayerActionType> actions;
  final bool hasChapters;
  final WrapAlignment alignment;
  final double spacing;
  final bool showLabels;
  final bool grouped;
  final Map<PlayerActionType, VoidCallback> actionOverrides;

  @override
  Widget build(BuildContext context) {
    final controls = Wrap(
      alignment: alignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing,
      runSpacing: 4,
      children: actions.map((action) => _buildAction(context, action)).toList(growable: false),
    );
    if (!grouped || showLabels) {
      return controls;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(padding: const EdgeInsets.all(4), child: controls),
    );
  }

  Widget _buildAction(BuildContext context, PlayerActionType action) {
    final override = actionOverrides[action];
    final control = override == null
        ? switch (action) {
            PlayerActionType.speed => const SpeedSlider(),
            PlayerActionType.bookmarks => const BookmarksButton(),
            PlayerActionType.chapter => ChapterQuickPicker(enabled: hasChapters),
            PlayerActionType.volume => const VolumeSlider(),
            PlayerActionType.sleepTimer => const SleepTimerButton(),
            PlayerActionType.queue => const QueueQuickPicker(),
          }
        : SizedBox.square(
            dimension: 48,
            child: IconButton(tooltip: action.label, onPressed: override, icon: Icon(action.icon)),
          );

    if (!showLabels && !grouped) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(18),
        ),
        child: control,
      );
    }

    if (grouped) {
      return control;
    }

    return SizedBox(
      width: 84,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
            ),
            child: control,
          ),
          const SizedBox(height: 5),
          Text(
            action.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
