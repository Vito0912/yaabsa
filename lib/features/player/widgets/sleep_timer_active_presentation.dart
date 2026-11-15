import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';

class SleepTimerActivePresentation extends StatelessWidget {
  const SleepTimerActivePresentation({super.key, required this.isRunning, required this.description});

  final bool isRunning;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: YaabsaSurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: colors.secondaryContainer,
        borderRadius: 16,
        child: Row(
          children: [
            Icon(isRunning ? Icons.timer_outlined : Icons.pause_circle_outline, color: colors.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRunning ? 'Timer active' : 'Timer paused',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.onSecondaryContainer),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onSecondaryContainer),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
