import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/library_file_metadata.dart';
import 'package:yaabsa/components/app/item/library_item_file_info_dialog.dart';
import 'package:yaabsa/components/app/item/library_item_file_download_dialog.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';

class LibraryItemFileMenu extends ConsumerStatefulWidget {
  const LibraryItemFileMenu({
    super.key,
    required this.itemId,
    required this.fileIno,
    required this.metadata,
    this.audioFile,
  });

  final String itemId;
  final String fileIno;
  final LibraryFileMetadata metadata;
  final AudioFile? audioFile;

  @override
  ConsumerState<LibraryItemFileMenu> createState() => _LibraryItemFileMenuState();
}

class _LibraryItemFileMenuState extends ConsumerState<LibraryItemFileMenu> {
  var _busy = false;

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _download() async {
    final user = ref.read(currentUserProvider).value;
    final api = ref.read(absApiProvider);
    final item = ref.read(libraryItemProvider(widget.itemId)).value;
    if (user?.permissions.download != true ||
        api == null ||
        item == null ||
        item.isMissing == true ||
        item.isInvalid == true) {
      return;
    }

    final destination = await showLibraryItemFileDownloadDialog(
      context: context,
      api: api,
      itemId: widget.itemId,
      fileIno: widget.fileIno,
      filename: widget.metadata.filename,
    );
    if (destination != null) {
      _showMessage('File saved.');
    }
  }

  Future<void> _delete() async {
    if (ref.read(currentUserProvider).value?.permissions.delete != true) {
      return;
    }
    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: 'Delete file?',
      message: 'Permanently delete "${widget.metadata.filename}" from the server? This cannot be undone.',
      confirmLabel: 'Delete file',
    );
    if (!mounted || !confirmed || ref.read(currentUserProvider).value?.permissions.delete != true) {
      return;
    }
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No server connection available.');
    }

    final deleted = await api.getLibraryItemApi().deleteLibraryFile(widget.itemId, widget.fileIno);
    if (!deleted) {
      throw StateError('Could not delete the file.');
    }
    if (!mounted) {
      return;
    }

    try {
      final response = await api.getLibraryItemApi().getLibraryItem(itemId: widget.itemId, extra: {'doNotCache': true});
      if (!mounted) {
        return;
      }
      final updated = response.data;
      if (updated == null) {
        throw StateError('Could not refresh item details.');
      }
      await processLibraryItemUpdate(container: ref.container, item: updated, source: 'item.file.delete');
    } catch (_) {
      if (mounted) {
        await invalidateCachedLibraryItemEntries(container: ref.container, itemId: widget.itemId);
        if (mounted) {
          ref.invalidate(libraryItemProvider(widget.itemId));
        }
      }
    }
    _showMessage('File deleted.');
  }

  Future<void> _act(String action) async {
    if (_busy) {
      return;
    }
    if (action == 'info') {
      final type = ref.read(currentUserProvider).value?.type.toLowerCase();
      final audio = widget.audioFile;
      if ((type == 'admin' || type == 'root') && audio != null) {
        await showDialog<void>(
          context: context,
          builder: (context) => LibraryItemFileInfoDialog(itemId: widget.itemId, audioFile: audio),
        );
      }
      return;
    }

    setState(() {
      _busy = true;
    });
    try {
      if (action == 'download') {
        await _download();
      } else if (action == 'delete') {
        await _delete();
      }
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: 'Could not complete the file action. $error'));
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final item = ref.watch(libraryItemProvider(widget.itemId)).value;
    final canDownload =
        user?.permissions.download == true && item != null && item.isMissing != true && item.isInvalid != true;
    final canDelete = user?.permissions.delete == true;
    final type = user?.type.toLowerCase();
    final canViewInfo = (type == 'admin' || type == 'root') && widget.audioFile != null;
    if (!canDownload && !canDelete && !canViewInfo) {
      return const SizedBox.shrink();
    }
    if (_busy) {
      return const SizedBox(
        width: 40,
        height: 40,
        child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    return PopupMenuButton<String>(
      tooltip: 'File actions',
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: _act,
      itemBuilder: (context) {
        return [
          if (canDownload) const PopupMenuItem(value: 'download', child: Text('Download')),
          if (canDelete) const PopupMenuItem(value: 'delete', child: Text('Delete file')),
          if (canViewInfo) const PopupMenuItem(value: 'info', child: Text('More info')),
        ];
      },
    );
  }
}
