import 'package:background_downloader/background_downloader.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';

class ItemDownloadIndicator extends StatelessWidget {
  const ItemDownloadIndicator({super.key, required this.status, this.size = 26});

  final ItemDownloadStatus status;
  final double size;

  String get label => switch (status.status) {
    TaskStatus.running => 'Downloading ${status.percent}%',
    TaskStatus.paused => 'Download paused at ${status.percent}%',
    TaskStatus.waitingToRetry => 'Download retrying at ${status.percent}%',
    _ => 'Download queued',
  };

  @override
  Widget build(BuildContext context) {
    final running = status.status == TaskStatus.running;
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: SizedBox.square(
          dimension: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (running || status.percent > 0)
                SizedBox.square(
                  dimension: size,
                  child: CircularProgressIndicator(
                    value: status.percent / 100,
                    strokeWidth: 2,
                    color: IconTheme.of(context).color,
                    backgroundColor: IconTheme.of(context).color?.withValues(alpha: 0.2),
                  ),
                ),
              if (running)
                Text(
                  '${status.percent}%',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: IconTheme.of(context).color, fontSize: 9, fontWeight: FontWeight.w700),
                )
              else
                Icon(switch (status.status) {
                  TaskStatus.paused => Icons.pause_rounded,
                  TaskStatus.waitingToRetry => Icons.refresh_rounded,
                  _ => Icons.downloading_rounded,
                }, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
