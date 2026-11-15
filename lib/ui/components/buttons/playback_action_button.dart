import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/theme/component_styles.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class YaabsaPlaybackActionButton extends StatelessWidget {
  const YaabsaPlaybackActionButton({
    super.key,
    required this.label,
    required this.isPlaying,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Widget icon;
    if (isLoading) {
      icon = const SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2.2));
    } else {
      icon = Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded);
    }

    return FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: YaabsaButtonStyles.compactProminentAction,
      icon: icon,
      label: Text(label),
    );
  }
}
