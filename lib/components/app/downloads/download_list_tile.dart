import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/downloads/download_cover_thumbnail.dart';
import 'package:yaabsa/components/common/expressive_list_tile.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/util/globals.dart';

class DownloadListTile extends StatelessWidget {
  const DownloadListTile({
    super.key,
    required this.download,
    required this.selectionMode,
    required this.isDeleting,
    required this.isSelected,
    required this.onToggleSelection,
    required this.onDelete,
    required this.onOpen,
  });

  final InternalDownload download;
  final bool selectionMode;
  final bool isDeleting;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final VoidCallback onDelete;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final targetItemId = download.item?.id ?? download.episode?.libraryItemId;
    final isPodcast = download.isPodcast;
    final title = isPodcast ? (download.episode?.title ?? 'Unknown Episode') : (download.item?.title ?? 'Unknown Item');
    final podcastTitle = isPodcast ? (download.item?.title ?? 'Unknown Podcast') : null;
    final totalFiles = download.numberOfFiles;
    final downloadedFiles = download.numberOfDownloadedFiles;
    final downloadRatio = totalFiles == 0 ? 0.0 : (downloadedFiles / totalFiles).clamp(0.0, 1.0);
    final thumbnailSize = context.isMobile
        ? 52.0
        : context.isTablet
        ? 60.0
        : 68.0;
    final contentPadding = context.isMobile
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    final borderRadius = BorderRadius.circular(context.isMobile ? 20 : 24);
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveListTile(
      enabled: targetItemId != null,
      selected: selectionMode && isSelected,
      borderRadius: borderRadius,
      contentPadding: contentPadding,
      onLongPress: isDeleting ? null : onToggleSelection,
      onTap: selectionMode ? (isDeleting ? null : onToggleSelection) : (targetItemId == null ? null : onOpen),
      leading: selectionMode
          ? Checkbox(value: isSelected, onChanged: isDeleting ? null : (_) => onToggleSelection())
          : DownloadCoverThumbnail(download: download, size: thumbnailSize),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (podcastTitle != null) ...[
            Text(
              podcastTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 2),
          ],
          Text('Downloaded files: $downloadedFiles/$totalFiles'),
          if (download.downloadOrigin == 'smart') ...[
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, size: 14, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  'Smart download',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: downloadRatio, minHeight: 5),
          ),
          if (!download.isComplete)
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Warning: Download unfinished or incomplete. Not available for offline use yet.',
                style: TextStyle(color: colorScheme.error),
              ),
            ),
        ],
      ),
      trailing: selectionMode
          ? null
          : IconButton(
              tooltip: 'Delete download',
              onPressed: isDeleting ? null : onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
    );
  }
}
