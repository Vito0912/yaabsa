import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/jump_button.dart' show JumpIcon;
import 'package:yaabsa/ui/components/buttons/media_play_button.dart';
import 'package:yaabsa/util/globals.dart' show BreakpointContextX;
import 'package:yaabsa/util/l10n.dart';

double wearPrimaryControlSize(BuildContext context) => context.screenWidth >= 225 ? 72 : 56;

class WearPlaybackControlsView extends StatelessWidget {
  const WearPlaybackControlsView({
    required this.isPlaying,
    required this.rewindSeconds,
    required this.forwardSeconds,
    required this.onPlayPause,
    required this.onRewind,
    required this.onForward,
    this.progress,
    this.isLoading = false,
    super.key,
  });

  final bool isPlaying;
  final int rewindSeconds;
  final int forwardSeconds;
  final VoidCallback? onPlayPause;
  final VoidCallback? onRewind;
  final VoidCallback? onForward;
  final double? progress;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final primarySize = wearPrimaryControlSize(context);
    final colors = Theme.of(context).colorScheme;
    final seekStyle = IconButton.styleFrom(
      backgroundColor: colors.primaryContainer.withValues(alpha: 0.65),
      foregroundColor: colors.onPrimaryContainer,
      minimumSize: const Size(48, 48),
      padding: EdgeInsets.zero,
      iconSize: 28,
      shape: const StadiumBorder(),
      side: BorderSide(color: colors.onPrimaryContainer.withValues(alpha: 0.14)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          style: seekStyle,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: onRewind,
          icon: JumpIcon(rewind: true, durationSeconds: rewindSeconds, size: 28),
          tooltip: context.l10n.playbackRewindInterval(rewindSeconds),
        ),
        YaabsaMediaPlayButton(
          style: YaabsaMediaPlayButtonStyle.scalloped,
          size: primarySize,
          iconSize: 36,
          tooltip: isPlaying ? context.l10n.playbackPause : context.l10n.playbackPlay,
          isPlaying: isPlaying,
          isFinished: false,
          isLoading: isLoading,
          progress: progress,
          onPressed: onPlayPause,
        ),
        IconButton(
          style: seekStyle,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          onPressed: onForward,
          icon: JumpIcon(rewind: false, durationSeconds: forwardSeconds, size: 28),
          tooltip: context.l10n.playbackForwardInterval(forwardSeconds),
        ),
      ],
    );
  }
}

class WearPlayerActionsView extends StatelessWidget {
  const WearPlayerActionsView({required this.onVolumePressed, required this.onSettingsPressed, super.key});

  final VoidCallback onVolumePressed;
  final VoidCallback onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final menuStyle = IconButton.styleFrom(
      backgroundColor: colors.surfaceContainerHighest.withValues(alpha: 0.72),
      foregroundColor: colors.onSurface,
      minimumSize: const Size(56, 48),
      padding: EdgeInsets.zero,
      iconSize: 28,
      shape: const StadiumBorder(),
      side: BorderSide(color: colors.onSurface.withValues(alpha: 0.14)),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          style: menuStyle,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          tooltip: context.l10n.fieldVolume,
          icon: const Icon(Icons.volume_up),
          onPressed: onVolumePressed,
        ),
        IconButton(
          style: menuStyle,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          tooltip: context.l10n.playbackSettings,
          icon: const Icon(Icons.speed_rounded),
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }
}
