import 'package:flutter/material.dart';
import 'package:yaabsa/components/app/downloads/download_cover_thumbnail.dart';
import 'package:yaabsa/models/internal_download.dart';

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
    final title = download.item?.title ?? download.episode?.title ?? 'Unknown Item';
    final totalFiles = download.numberOfFiles;
    final downloadedFiles = download.numberOfDownloadedFiles;
    final downloadRatio = totalFiles == 0 ? 0.0 : (downloadedFiles / totalFiles).clamp(0.0, 1.0);

    return ListTile(
      enabled: targetItemId != null,
      onLongPress: isDeleting ? null : onToggleSelection,
      onTap: selectionMode ? (isDeleting ? null : onToggleSelection) : (targetItemId == null ? null : onOpen),
      leading: selectionMode
          ? Checkbox(value: isSelected, onChanged: isDeleting ? null : (_) => onToggleSelection())
          : DownloadCoverThumbnail(download: download),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Downloaded files: $downloadedFiles/$totalFiles'),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: downloadRatio, minHeight: 5),
          ),
          if (!download.isComplete)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Warning: Download unfinished or incomplete. Not available for offline use yet.',
                style: TextStyle(color: Colors.red),
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
