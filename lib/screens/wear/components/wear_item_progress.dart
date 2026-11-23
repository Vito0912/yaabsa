import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class WearItemProgress extends ConsumerWidget {
  const WearItemProgress({required this.itemId, this.episodeId, super.key});

  final String itemId;
  final String? episodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(wearPreferencesProvider.select((value) => value.itemProgress));
    if (!enabled) {
      return const SizedBox.shrink();
    }

    final key = mediaProgressKey(itemId, episodeId);
    final progress = ref.watch(mediaProgressByKeyProvider(key));
    if (progress == null || !progress.progress.isFinite) {
      return const SizedBox.shrink();
    }

    final value = progress.isFinished ? 1.0 : progress.progress.clamp(0.0, 1.0);
    final label = progress.isFinished ? 'Finished' : '${(value * 100).floor()}%';
    return Row(
      children: [
        Expanded(
          child: ExcludeSemantics(child: YaabsaLinearProgressIndicator(value: value, minHeight: 2)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, height: 1.2)),
      ],
    );
  }
}
