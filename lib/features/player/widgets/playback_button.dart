import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/util/l10n.dart';

class PlaybackButton extends StatelessWidget {
  const PlaybackButton({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.onPressed,
    this.prominent = false,
    this.iconSize,
    this.buttonSize,
  });

  final bool isPlaying;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool prominent;
  final double? iconSize;
  final double? buttonSize;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final size = buttonSize ?? (prominent ? 68 : 48);
      final progressSize = iconSize ?? (prominent ? 34 : 26);

      return Semantics(
        label: context.l10n.playbackSpeedLoading,
        liveRegion: true,
        child: RepaintBoundary(
          child: YaabsaActionIconButton(
            icon: Icons.play_arrow_rounded,
            isLoading: true,
            iconSize: progressSize,
            buttonSize: size,
            compact: false,
            variant: YaabsaActionButtonVariant.filled,
            tooltip: context.l10n.playbackSpeedLoading,
            onPressed: null,
          ),
        ),
      );
    }

    return YaabsaActionIconButton(
      icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      iconSize: iconSize ?? (prominent ? 34 : 26),
      buttonSize: buttonSize ?? (prominent ? 68 : 48),
      compact: false,
      variant: YaabsaActionButtonVariant.filled,
      tooltip: isPlaying ? context.l10n.playbackPause : context.l10n.playbackPlay,
      onPressed: onPressed,
    );
  }
}
