import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/library_item_overlay_play_button.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;

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

class ItemDownloadBadges extends ConsumerWidget {
  const ItemDownloadBadges({super.key, required this.itemId, this.episodeId, this.sequenceBadge});

  final String itemId;
  final String? episodeId;
  final Widget? sequenceBadge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(itemDownloadStatusesProvider.select((value) => value.value?[(itemId, episodeId)]));
    final downloaded = ref.watch(completedDownloadForItemProvider(itemId, episodeId: episodeId));
    final colors = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (status != null || downloaded)
          RepaintBoundary(
            child: Container(
              width: status != null ? LibraryItemOverlayPlayButton.size : 26,
              height: status != null ? LibraryItemOverlayPlayButton.size : 26,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: colors.primary),
              padding: EdgeInsets.all(status != null ? 1 : 6),
              child: IconTheme(
                data: IconThemeData(color: colors.onPrimary),
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: colors.onPrimary),
                  child: status != null
                      ? ItemDownloadIndicator(status: status, size: LibraryItemOverlayPlayButton.size - 2)
                      : const Icon(Icons.cloud_done_rounded, size: 14),
                ),
              ),
            ),
          ),
        ?sequenceBadge,
      ],
    );
  }
}

class ItemDownloadButton extends ConsumerStatefulWidget {
  const ItemDownloadButton({
    super.key,
    required this.itemId,
    this.episodeId,
    required this.isDownloaded,
    required this.onDownload,
    required this.onDeleteDownload,
  });

  final String itemId;
  final String? episodeId;
  final bool isDownloaded;
  final VoidCallback onDownload;
  final VoidCallback onDeleteDownload;

  @override
  ConsumerState<ItemDownloadButton> createState() => _ItemDownloadButtonState();
}

class _ItemDownloadButtonState extends ConsumerState<ItemDownloadButton> {
  bool _isCanceling = false;

  Future<void> _cancelDownload() async {
    if (_isCanceling) return;
    setState(() => _isCanceling = true);
    try {
      final canceled = await downloadHandler.cancelDownloadForItem(widget.itemId, episodeId: widget.episodeId);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(canceled ? 'Download canceled.' : 'Could not cancel download.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not cancel download: $e')));
    } finally {
      if (mounted) setState(() => _isCanceling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(
      itemDownloadStatusesProvider.select((value) => value.value?[(widget.itemId, widget.episodeId)]),
    );
    return IconButton.filledTonal(
      onPressed: _isCanceling
          ? null
          : status != null
          ? _cancelDownload
          : (widget.isDownloaded ? widget.onDeleteDownload : widget.onDownload),
      tooltip: status != null ? 'Cancel download' : (widget.isDownloaded ? 'Delete download' : 'Download'),
      icon: status != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                RepaintBoundary(child: ItemDownloadIndicator(status: status)),
                const Icon(Icons.close_rounded, size: 18),
              ],
            )
          : Icon(widget.isDownloaded ? Icons.delete_outline_rounded : Icons.download_rounded),
      visualDensity: VisualDensity.compact,
    );
  }
}
