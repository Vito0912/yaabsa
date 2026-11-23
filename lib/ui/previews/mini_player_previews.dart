import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';
import 'package:yaabsa/features/player/widgets/mini_player_cover.dart';
import 'package:yaabsa/features/player/widgets/mini_player_gradient_surface.dart';
import 'package:yaabsa/features/player/widgets/mini_player_metadata_presentation.dart';
import 'package:yaabsa/features/player/widgets/mini_player_ready_presentation.dart';
import 'package:yaabsa/features/player/widgets/playback_button.dart';
import 'package:yaabsa/screens/player/components/player_action_bar.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';

import 'player_previews.dart';
import 'preview_theme.dart';

@Preview(name: 'Mini player / compact / light', size: Size(390, 180), wrapper: yaabsaPreviewLight)
@Preview(name: 'Mini player / compact / dark', size: Size(390, 180), wrapper: yaabsaPreviewDark)
@Preview(name: 'Mini player / compact / AMOLED', size: Size(390, 180), wrapper: yaabsaPreviewAmoled)
Widget miniPlayerCompactPreview() => const MiniPlayerPresentationPreview(compact: true);

@Preview(name: 'Mini player / desktop / light', size: Size(980, 180), wrapper: yaabsaPreviewLight)
@Preview(name: 'Mini player / desktop / dark', size: Size(980, 180), wrapper: yaabsaPreviewDark)
@Preview(name: 'Mini player / desktop / AMOLED', size: Size(980, 180), wrapper: yaabsaPreviewAmoled)
Widget miniPlayerDesktopPreview() => const MiniPlayerPresentationPreview(compact: false);

class MiniPlayerPresentationPreview extends StatelessWidget {
  const MiniPlayerPresentationPreview({super.key, required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final gradientStart = Color.alphaBlend(
      colorScheme.primaryContainer.withValues(alpha: dark ? 0.22 : 0.12),
      colorScheme.surfaceContainer,
    );
    final gradientEnd = Color.alphaBlend(
      colorScheme.secondaryContainer.withValues(alpha: dark ? 0.2 : 0.1),
      colorScheme.surfaceContainer,
    );
    final borderRadius = BorderRadius.circular(20);
    final actions = PlayerActionType.values;
    final actionOverrides = <PlayerActionType, VoidCallback>{for (final action in actions) action: _ignoreAction};
    final mediaMetadata = Row(
      children: [
        const SizedBox.square(
          dimension: 52,
          child: MiniPlayerCover(coverUri: null, requestHeaders: {}, borderRadius: 12),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: MiniPlayerMetadataPresentation(
            title: 'The Distant Shore: Stories from a Vanishing Coast',
            subtitle: 'Mira Ellery',
          ),
        ),
      ],
    );
    final transportControls = _MiniPlayerTransportPreview(compact: compact);
    final actionBar = compact
        ? null
        : PlayerActionBar(
            actions: actions.take(2).toList(growable: false),
            hasChapters: true,
            actionOverrides: actionOverrides,
            spacing: 6,
          );
    final moreActions = compact || actions.length > 2
        ? IconButton(
            tooltip: 'More player controls',
            onPressed: _ignoreAction,
            icon: const Icon(Icons.more_horiz_rounded),
          )
        : null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: MiniPlayerGradientSurface(
        startColor: gradientStart,
        endColor: gradientEnd,
        borderRadius: borderRadius,
        child: Material(
          color: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: MiniPlayerReadyPresentation(
                compact: compact,
                metadata: mediaMetadata,
                transportControls: transportControls,
                actionBar: actionBar,
                moreActionsButton: moreActions,
                stopButton: compact
                    ? null
                    : IconButton(
                        tooltip: 'Stop playback',
                        onPressed: _ignoreAction,
                        icon: const Icon(Icons.stop_circle_outlined),
                      ),
                seekBar: const SeekTimelinePreview(compact: true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniPlayerTransportPreview extends StatelessWidget {
  const _MiniPlayerTransportPreview({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Rewind 30 seconds',
            onPressed: _ignoreAction,
            icon: const JumpIcon(rewind: true, durationSeconds: 30),
          ),
          const PlaybackButton(isPlaying: true, isLoading: false, onPressed: _ignoreAction),
          IconButton(
            tooltip: 'Forward 30 seconds',
            onPressed: _ignoreAction,
            icon: const JumpIcon(rewind: false, durationSeconds: 30),
          ),
        ],
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 0,
      children: [
        const SkipButtonPresentation(previous: true, onPressed: null),
        IconButton(
          tooltip: 'Rewind 30 seconds',
          onPressed: _ignoreAction,
          icon: const JumpIcon(rewind: true, durationSeconds: 30),
        ),
        const PlaybackButton(isPlaying: true, isLoading: false, onPressed: _ignoreAction),
        IconButton(
          tooltip: 'Forward 30 seconds',
          onPressed: _ignoreAction,
          icon: const JumpIcon(rewind: false, durationSeconds: 30),
        ),
        const SkipButtonPresentation(previous: false, onPressed: null),
      ],
    );
  }
}

void _ignoreAction() {}
