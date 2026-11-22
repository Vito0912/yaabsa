import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_browse_scaffold.dart';
import 'package:yaabsa/screens/wear/components/wear_cover.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';

class WearMediaBrowseButton extends ConsumerWidget {
  const WearMediaBrowseButton({required this.entry, required this.onPressed, super.key});

  final CompactBrowseEntry entry;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showProgress = ref.watch(wearPreferencesProvider.select((preferences) => preferences.itemProgress));
    final itemId = entry.itemId;
    double? progressValue;
    if (showProgress && itemId != null) {
      final key = mediaProgressKey(itemId, entry.episodeId);
      final progress = ref.watch(mediaProgressByKeyProvider(key));
      if (progress?.isFinished == true) {
        progressValue = 1.0;
      } else if (progress != null && progress.progress.isFinite) {
        progressValue = progress.progress.clamp(0.0, 1.0);
      }
    }

    return WearBrowseButton(
      title: entry.title,
      subtitle: entry.subtitle,
      leading: WearCover(uri: entry.coverUri),
      progress: progressValue,
      onPressed: onPressed,
    );
  }
}
