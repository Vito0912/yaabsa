import 'package:material_ui/material_ui.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';

class BookPlaybackPanel extends StatelessWidget {
  const BookPlaybackPanel({
    super.key,
    required this.itemId,
    required this.hasAudio,
    required this.durationSeconds,
    required this.progress,
    required this.isPlaying,
    required this.isLoading,
    required this.actionsBuilder,
  });

  final String itemId;
  final bool hasAudio;
  final double durationSeconds;
  final MediaProgress? progress;
  final bool isPlaying;
  final bool isLoading;
  final Widget Function(String label, String? detail) actionsBuilder;

  @override
  Widget build(BuildContext context) {
    if (!hasAudio) {
      return actionsBuilder('Read', null);
    }

    final isCurrentItem = audioHandler.currentMediaItem?.itemId == itemId;

    return StreamBuilder<Duration>(
      key: ValueKey('$itemId:$isCurrentItem'),
      stream: isCurrentItem ? audioHandler.positionStream.sampleTime(const Duration(seconds: 1)) : null,
      initialData: isCurrentItem ? audioHandler.position : null,
      builder: (context, snapshot) {
        final total = durationSeconds > 0 ? durationSeconds : (progress?.duration ?? 0);
        final savedFraction = (progress?.progress ?? 0).clamp(0.0, 1.0).toDouble();
        final savedPosition = progress?.currentTime ?? 0;
        var position = savedPosition > 0 ? savedPosition : total * savedFraction;
        if (isCurrentItem && snapshot.data != null) {
          position = snapshot.data!.inMilliseconds / 1000;
        }

        final isFinished = ((progress?.isFinished ?? false) && !isCurrentItem) || (total > 0 && position >= total);
        final fraction = isFinished ? 1.0 : (total > 0 ? position / total : savedFraction).clamp(0.0, 1.0).toDouble();
        final hasProgress = position > 0 || fraction > 0;
        final remaining = total > 0 ? (total - position).clamp(0.0, total).toDouble() : null;

        var label = hasProgress && !isFinished ? 'Resume' : 'Play';
        if (isFinished) {
          label = 'Listen again';
        }
        if (isPlaying) {
          label = 'Pause';
        }
        if (isLoading) {
          label = 'Loading';
        }

        String? detail;
        if (hasProgress && !isFinished && remaining != null) {
          detail = '${formatDurationLong(Duration(minutes: (remaining / 60).ceil()))} left';
          if (remaining > 0 && remaining < 60) {
            detail = '< 1 min left';
          }
        }

        return Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  label: 'Listening progress ${(fraction * 100).toStringAsFixed(1)}%',
                  child: actionsBuilder(label, detail),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
