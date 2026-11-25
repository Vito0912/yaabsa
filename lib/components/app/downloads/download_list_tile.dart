import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/downloads/download_activity_indicator.dart';
import 'package:yaabsa/components/app/downloads/download_cover_thumbnail.dart';
import 'package:yaabsa/components/common/expressive_list_tile.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';

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
    final title = download.episode?.title ?? download.item?.title ?? context.l10n.unknownMediaItem;
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
                      ? context.l10n.statusAvailableOffline
                      : context.l10n.downloadedFileCountSummary(downloaded, total),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          if (!complete && status == null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: YaabsaLinearProgressIndicator(
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
                context.l10n.statusSmartDownload,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
        ],
      ),
      trailing: selectionMode
          ? null
          : YaabsaContextMenuButton<String>(
              enabled: !isDeleting,
              tooltip: context.l10n.headingDownloadActions,
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
                PopupMenuItem(value: 'files', child: Text(context.l10n.fieldFiles)),
                PopupMenuItem(value: 'open', child: Text(context.l10n.actionOpen)),
                PopupMenuItem(value: 'delete', child: Text(context.l10n.actionDeleteDownload)),
              ],
            ),
    );
  }
}
