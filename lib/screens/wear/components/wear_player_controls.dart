import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler;
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_playback_progress.dart';
import 'package:yaabsa/ui/components/wear/wear_volume_control.dart';
import 'package:yaabsa/screens/wear/wear_settings_screen.dart';
import 'package:yaabsa/ui/components/wear/wear_player_controls.dart';

export 'package:yaabsa/ui/components/wear/wear_player_controls.dart' show wearPrimaryControlSize;

class WearPlayerHeader extends StatelessWidget {
  const WearPlayerHeader({required this.media, this.lines = 1, super.key});

  final InternalMedia media;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: wearAudioHandler.playbackState,
      initialData: wearAudioHandler.playbackState.value,
      builder: (context, snapshot) {
        final failed = snapshot.data?.processingState == AudioProcessingState.error;
        final author = media.author?.trim();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              failed ? 'Playback failed. Tap play to retry.' : media.title,
              maxLines: lines,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.1,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            if (author != null && author.isNotEmpty)
              Text(
                author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.1,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  decoration: TextDecoration.none,
                ),
              ),
          ],
        );
      },
    );
  }
}

class WearPlaybackControls extends ConsumerWidget {
  const WearPlaybackControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handler = wearAudioHandler;
    final preferences = ref.watch(wearPreferencesProvider);
    return StreamBuilder<PlaybackState>(
      stream: handler.playbackState,
      initialData: handler.playbackState.value,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? false;
        return WearPlaybackPosition(
          builder: (context, position, total) {
            final fraction = total.inMilliseconds > 0
                ? (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0)
                : 0.0;
            return WearPlaybackControlsView(
              isPlaying: playing,
              rewindSeconds: preferences.rewindSeconds,
              forwardSeconds: preferences.forwardSeconds,
              progress: fraction,
              onPlayPause: playing ? handler.pause : handler.play,
              onRewind: handler.skipToPrevious,
              onForward: handler.skipToNext,
            );
          },
        );
      },
    );
  }
}

class WearPlayerActions extends StatelessWidget {
  const WearPlayerActions({super.key});

  @override
  Widget build(BuildContext context) {
    final handler = wearAudioHandler;
    return WearPlayerActionsView(
      onVolumePressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WearVolumeControl(volume: handler.player.volume, onChanged: handler.player.setVolume),
          ),
        );
      },
      onSettingsPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WearSettingsScreen()));
      },
    );
  }
}
