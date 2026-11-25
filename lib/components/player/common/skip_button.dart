import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key, required this.previous, this.iconSize, this.buttonSize = 48});

  final bool previous;
  final double? iconSize;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    if (previous) {
      return SkipButtonPresentation(
        previous: true,
        iconSize: iconSize,
        buttonSize: buttonSize,
        onPressed: audioHandler.skipToPreviousInApp,
      );
    }

    return StreamBuilder<bool>(
      stream: audioHandler.canSkipForwardStream,
      initialData: audioHandler.canSkipForwardNow,
      builder: (context, snapshot) {
        return SkipButtonPresentation(
          previous: false,
          iconSize: iconSize,
          buttonSize: buttonSize,
          onPressed: snapshot.data == true ? audioHandler.skipToNextInApp : null,
        );
      },
    );
  }
}

class SkipButtonPresentation extends StatelessWidget {
  const SkipButtonPresentation({
    super.key,
    required this.previous,
    required this.onPressed,
    this.iconSize,
    this.buttonSize = 48,
  });

  final bool previous;
  final VoidCallback? onPressed;
  final double? iconSize;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return YaabsaActionIconButton(
      icon: previous ? Icons.skip_previous_rounded : Icons.skip_next_rounded,
      iconSize: iconSize ?? 24,
      buttonSize: buttonSize,
      compact: false,
      tooltip: previous ? context.l10n.playbackPrevious : context.l10n.playbackNext,
      onPressed: onPressed,
    );
  }
}
