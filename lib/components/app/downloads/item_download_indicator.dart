import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/library_item_overlay_play_button.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:yaabsa/provider/common/stored_downloads_provider.dart';
import 'package:yaabsa/components/app/downloads/download_files_sheet.dart';
import 'package:yaabsa/components/app/downloads/download_activity_indicator.dart';
export 'package:yaabsa/components/app/downloads/download_activity_indicator.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;

class ItemDownloadBadges extends ConsumerWidget {
  const ItemDownloadBadges({super.key, required this.itemId, this.episodeId, this.sequenceBadge});

  final String itemId;
  final String? episodeId;
  final Widget? sequenceBadge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(itemDownloadStatusesProvider.select((value) => value.value?[(itemId, episodeId)]));
    final availability =
        ref.watch(downloadAvailabilityProvider.select((value) => value.value?[(itemId, episodeId)])) ??
        (count: 0, total: 0, complete: false);
    final downloaded = availability.count > 0;
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
                      : Tooltip(
                          message: availability.complete ? 'Available offline' : '${availability.count} files offline',
                          child: Icon(
                            availability.complete ? Icons.cloud_done_rounded : Icons.cloud_download_rounded,
                            size: 14,
                          ),
                        ),
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
    final availability =
        ref.watch(downloadAvailabilityProvider.select((value) => value.value?[(widget.itemId, widget.episodeId)])) ??
        (count: 0, total: 0, complete: widget.isDownloaded);
    final partial = availability.total > 0 && !availability.complete;
    return IconButton.filledTonal(
      onPressed: _isCanceling
          ? null
          : status != null
          ? _cancelDownload
          : partial
          ? () => showDownloadFiles(context, widget.itemId, episodeId: widget.episodeId)
          : (widget.isDownloaded ? widget.onDeleteDownload : widget.onDownload),
      tooltip: status != null
          ? 'Cancel download'
          : partial
          ? '${availability.count} of ${availability.total} files offline. Manage files'
          : (widget.isDownloaded ? 'Delete download' : 'Download'),
      icon: status != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                RepaintBoundary(child: ItemDownloadIndicator(status: status)),
                const Icon(Icons.close_rounded, size: 18),
              ],
            )
          : partial
          ? SizedBox.square(
              dimension: 26,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: availability.total == 0 ? 0 : (availability.count / availability.total).clamp(0.0, 1.0),
                    strokeWidth: 2,
                    backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  const Icon(Icons.download_rounded, size: 16),
                ],
              ),
            )
          : Icon(widget.isDownloaded ? Icons.delete_outline_rounded : Icons.download_rounded),
      visualDensity: VisualDensity.compact,
    );
  }
}
