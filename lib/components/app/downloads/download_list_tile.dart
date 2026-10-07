import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/downloads/download_activity_indicator.dart';
import 'package:yaabsa/components/app/downloads/download_cover_thumbnail.dart';
import 'package:yaabsa/components/common/expressive_list_tile.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:yaabsa/util/globals.dart';

class DownloadListTile extends ConsumerWidget {
  const DownloadListTile({
    super.key,
    required this.download,
    required this.selectionMode,
    required this.isDeleting,
    required this.isSelected,
    required this.onToggleSelection,
    required this.onDelete,
    required this.onOpen,
    required this.onFiles,
  });

  final InternalDownload download;
  final bool selectionMode;
  final bool isDeleting;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final VoidCallback onDelete;
  final VoidCallback? onOpen;
  final VoidCallback onFiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemId = download.item?.id ?? download.episode?.libraryItemId;
    final status = ref.watch(
      itemDownloadStatusesProvider.select((value) => value.value?[(itemId, download.episode?.id)]),
    );
    final colors = Theme.of(context).colorScheme;
    final title = download.episode?.title ?? download.item?.title ?? 'Unknown item';
    final downloaded = download.numberOfDownloadedFiles;
    final total = download.numberOfFiles;
    final complete = total > 0 && downloaded >= total;
    return ExpressiveListTile(
      selected: selectionMode && isSelected,
      borderRadius: BorderRadius.circular(context.isMobile ? 20 : 24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onLongPress: isDeleting ? null : onToggleSelection,
      onTap: isDeleting
          ? null
          : selectionMode
          ? onToggleSelection
          : onOpen,
      leading: selectionMode
          ? Checkbox(value: isSelected, onChanged: isDeleting ? null : (_) => onToggleSelection())
          : null,
      edgeLeading: selectionMode ? null : DownloadCoverThumbnail(download: download, borderRadius: BorderRadius.zero),
      edgeLeadingWidth: context.isMobile ? 80 : 92,
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (download.isPodcast && download.item != null)
            Text(download.item!.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(
            children: [
              if (status != null) ...[
                RepaintBoundary(child: ItemDownloadIndicator(status: status, size: 22)),
                const SizedBox(width: 8),
              ] else ...[
                Icon(
                  complete ? Icons.offline_pin_rounded : Icons.cloud_download_outlined,
                  size: 18,
                  color: complete ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  status != null
                      ? ItemDownloadIndicator(status: status).label
                      : complete
                      ? 'Available offline'
                      : '$downloaded of $total files offline',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          if (!complete && status == null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : (downloaded / total).clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: colors.surfaceContainerHighest,
              ),
            ),
          ],
          if (download.downloadOrigin == 'smart')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Smart download',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
        ],
      ),
      trailing: selectionMode
          ? null
          : PopupMenuButton<String>(
              enabled: !isDeleting,
              tooltip: 'Download actions',
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                switch (value) {
                  case 'files':
                    onFiles();
                  case 'delete':
                    onDelete();
                  case 'open':
                    onOpen?.call();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'files', child: Text('Files')),
                const PopupMenuItem(value: 'open', child: Text('Open item')),
                const PopupMenuItem(value: 'delete', child: Text('Delete download')),
              ],
            ),
    );
  }
}
