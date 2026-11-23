import 'package:material_ui/material_ui.dart';

class MiniPlayerReadyPresentation extends StatelessWidget {
  const MiniPlayerReadyPresentation({
    super.key,
    required this.compact,
    required this.metadata,
    required this.transportControls,
    required this.seekBar,
    this.actionBar,
    this.moreActionsButton,
    this.stopButton,
  });

  final bool compact;
  final Widget metadata;
  final Widget transportControls;
  final Widget seekBar;
  final Widget? actionBar;
  final Widget? moreActionsButton;
  final Widget? stopButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(flex: compact ? 1 : 3, child: metadata),
            if (!compact) const SizedBox(width: 24),
            transportControls,
            if (compact) ?moreActionsButton,
            if (!compact) ...[
              const SizedBox(width: 18),
              ?actionBar,
              ?moreActionsButton,
              const SizedBox(width: 6),
              ?stopButton,
            ],
          ],
        ),
        const SizedBox(height: 5),
        seekBar,
      ],
    );
  }
}
