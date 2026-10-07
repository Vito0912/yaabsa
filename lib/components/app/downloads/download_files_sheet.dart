import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/downloads/download_cover_thumbnail.dart';
import 'package:yaabsa/components/app/downloads/download_activity_indicator.dart';
import 'package:yaabsa/models/download_file_entry.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:yaabsa/provider/common/stored_downloads_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';

Future<void> showDownloadFiles(BuildContext context, String itemId, {String? episodeId}) {
  if (!context.isMobile) {
    return showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 720,
          height: MediaQuery.sizeOf(context).height * 0.8,
          child: DownloadFilesSheet(itemId: itemId, episodeId: episodeId, desktop: true),
        ),
      ),
    );
  }
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 720),
    builder: (context) => FractionallySizedBox(
      heightFactor: context.isMobile ? 0.85 : 0.8,
      child: DownloadFilesSheet(itemId: itemId, episodeId: episodeId),
    ),
  );
}

class DownloadFilesSheet extends ConsumerStatefulWidget {
  const DownloadFilesSheet({super.key, required this.itemId, this.episodeId, this.desktop = false});

  final String itemId;
  final String? episodeId;
  final bool desktop;

  @override
  ConsumerState<DownloadFilesSheet> createState() => _DownloadFilesSheetState();
}

class _DownloadFilesSheetState extends ConsumerState<DownloadFilesSheet> {
  bool _busy = false;
  String? _deletingInode;

  Future<void> _download({String? inode}) async {
    if (_busy) return;
    final user = ref.read(currentUserProvider).value;
    final download = ref.read(storedDownloadForItemProvider(widget.itemId, episodeId: widget.episodeId));
    if (user == null || !user.permissions.download || download == null) return;
    setState(() => _busy = true);
    try {
      await downloadHandler.downloadFile(
        widget.itemId,
        episodeId: widget.episodeId,
        downloadType: download.downloadType,
        fileInodes: inode == null ? null : {inode},
        requiredUserId: user.id,
      );
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not download: $error')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteFile(DownloadFileEntry file) async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete file'),
        content: Text('Remove ${file.name} from offline storage?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted || _busy) return;
    final userId = ref.read(currentUserProvider).value?.id;
    final download = ref.read(storedDownloadForItemProvider(widget.itemId, episodeId: widget.episodeId));
    if (userId == null || download == null) return;
    setState(() {
      _busy = true;
      _deletingInode = file.inode;
    });
    try {
      final deleted = await downloadHandler.deleteDownloadedFile(download, file.inode, userId: userId);
      if (mounted && !deleted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not delete this file')));
      }
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not delete file: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _deletingInode = null;
        });
      }
    }
  }

  Future<void> _cancel() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await downloadHandler.cancelDownloadForItem(widget.itemId, episodeId: widget.episodeId);
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not cancel: $error')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final download = ref.watch(storedDownloadForItemProvider(widget.itemId, episodeId: widget.episodeId));
    final files = ref.watch(downloadFilesForItemProvider(widget.itemId, episodeId: widget.episodeId));
    final active = ref.watch(
      itemDownloadStatusesProvider.select(
        (value) => value.value?.containsKey((widget.itemId, widget.episodeId)) ?? false,
      ),
    );
    final canDownload = ref.watch(currentUserProvider.select((value) => value.value?.permissions.download ?? false));
    final colors = Theme.of(context).colorScheme;
    if (download == null) {
      final entry = ref.watch(storedDownloadEntryProvider(widget.itemId, episodeId: widget.episodeId));
      if (entry.isLoading) return const Center(child: CircularProgressIndicator());
      if (entry.hasError) return const Center(child: Text('Could not load this download'));
      return const Center(child: Text('This download has been removed'));
    }
    final title = download.episode?.title ?? download.item?.title ?? 'Download';
    return SafeArea(
      top: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.desktop) const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Row(
              children: [
                DownloadCoverThumbnail(download: download, size: 56),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${download.numberOfDownloadedFiles} of ${download.numberOfFiles} files offline',
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Row(
              children: [
                Expanded(child: Text('Files', style: Theme.of(context).textTheme.titleSmall)),
                if (active)
                  TextButton.icon(
                    onPressed: _busy ? null : _cancel,
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Cancel download'),
                  )
                else if (download.numberOfDownloadedFiles < download.numberOfFiles)
                  FilledButton.tonalIcon(
                    onPressed: _busy || !canDownload || !files.hasValue ? null : () => _download(),
                    icon: _busy && _deletingInode == null
                        ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.download_rounded),
                    label: const Text('Download missing'),
                  )
                else
                  const Icon(Icons.offline_pin_rounded),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: files.when(
              skipLoadingOnReload: true,
              data: (entries) => ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                itemCount: entries.length,
                itemBuilder: (context, index) => _DownloadFileRow(
                  key: ValueKey(entries[index].inode),
                  file: entries[index],
                  itemId: widget.itemId,
                  episodeId: widget.episodeId,
                  canDownload: canDownload && !_busy && !active,
                  onDownload: () => _download(inode: entries[index].inode),
                  onDelete: _busy ? null : () => _deleteFile(entries[index]),
                  deleting: _deletingInode == entries[index].inode,
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: TextButton.icon(
                  onPressed: () =>
                      ref.invalidate(downloadFilesForItemProvider(widget.itemId, episodeId: widget.episodeId)),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry loading files'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadFileRow extends ConsumerWidget {
  const _DownloadFileRow({
    super.key,
    required this.file,
    required this.itemId,
    this.episodeId,
    required this.canDownload,
    required this.onDownload,
    required this.onDelete,
    required this.deleting,
  });

  final DownloadFileEntry file;
  final String itemId;
  final String? episodeId;
  final bool canDownload;
  final VoidCallback onDownload;
  final VoidCallback? onDelete;
  final bool deleting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      downloadFileStatusesProvider.select((value) => value.value?[(itemId, episodeId, file.inode)]),
    );
    final colors = Theme.of(context).colorScheme;
    final label = file.downloaded
        ? 'Offline'
        : status != null
        ? ItemDownloadIndicator(status: status).label
        : 'Not downloaded';
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(
        file.downloaded
            ? Icons.offline_pin_rounded
            : file.kind == 'audio'
            ? Icons.audiotrack_rounded
            : Icons.insert_drive_file_outlined,
        color: file.downloaded ? colors.primary : colors.onSurfaceVariant,
      ),
      title: Text(file.name, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text('$label${file.size != null && file.size! > 0 ? ' · ${formatBytes(file.size!)}' : ''}'),
      trailing: deleting
          ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2))
          : file.downloaded
          ? IconButton(tooltip: 'Delete file', onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded))
          : status != null
          ? RepaintBoundary(child: ItemDownloadIndicator(status: status))
          : IconButton.filledTonal(
              tooltip: 'Download file',
              onPressed: canDownload ? onDownload : null,
              icon: const Icon(Icons.download_rounded),
            ),
    );
  }
}
