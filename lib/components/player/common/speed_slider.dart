import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/components/common/feature_gate.dart';
import 'package:yaabsa/features/player/widgets/playback_speed_sheet.dart';
import 'package:yaabsa/models/playback_feature.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';

Future<void> showPlaybackSpeedSheet(BuildContext context, {double? currentSpeed}) {
  if (!audioHandler.supportsFeature(PlaybackFeature.speed)) {
    return Future.value();
  }

  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: PlaybackSpeedSheet(
          initialSpeed: currentSpeed ?? audioHandler.effectivePlaybackSpeed,
          onApplySpeed: audioHandler.setSpeed,
        ),
      );
    },
  );
}

class SpeedSlider extends StatelessWidget {
  static const double minSpeed = PlaybackSpeedSheet.minSpeed;
  static const double maxSpeed = PlaybackSpeedSheet.maxSpeed;
  static const double defaultSpeed = PlaybackSpeedSheet.defaultSpeed;
  static const double step = PlaybackSpeedSheet.step;

  const SpeedSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureGate(
      enabled: audioHandler.supportsFeature(PlaybackFeature.speed),
      availability: audioHandler.featureAvailability(PlaybackFeature.speed),
      disabledReason: context.l10n.errorPlaybackSpeedUnavailable,
      child: _buildControl(context),
    );
  }

  Widget _buildControl(BuildContext context) {
    return StreamBuilder<double>(
      stream: audioHandler.effectivePlaybackSpeedStream,
      initialData: audioHandler.effectivePlaybackSpeed,
      builder: (context, snapshot) {
        final speed = (snapshot.data ?? defaultSpeed).clamp(minSpeed, maxSpeed).toDouble();

        return YaabsaActionIconButton(
          iconWidget: Text(
            context.l10n.playbackSpeedMultiplier(speed),
            style: TextStyle(
              letterSpacing: -1.25,
              fontFeatures: [const FontFeature.tabularFigures()],
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
          iconSize: 24,
          buttonSize: 48,
          compact: false,
          tooltip: context.l10n.playbackSpeed,
          onPressed: () => showPlaybackSpeedSheet(context, currentSpeed: speed),
        );
      },
    );
  }
}
