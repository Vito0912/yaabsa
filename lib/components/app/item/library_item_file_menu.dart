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
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/util/l10n.dart';

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
    final l10n = context.l10n;
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
      _showMessage(l10n.statusFileSaved);
    }
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    if (ref.read(currentUserProvider).value?.permissions.delete != true) {
      return;
    }
    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: l10n.headingDeleteFile,
      message: l10n.promptDeleteServerFilePermanently(widget.metadata.filename),
      confirmLabel: l10n.actionDelete,
    );
    if (!mounted || !confirmed || ref.read(currentUserProvider).value?.permissions.delete != true) {
      return;
    }
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError(l10n.errorConnectionUnavailable);
    }

    final deleted = await api.getLibraryItemApi().deleteLibraryFile(widget.itemId, widget.fileIno);
    if (!deleted) {
      throw StateError(l10n.errorDeleteServerFileFailed);
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
        await _invalidateItemCache();
      } else {
        await processLibraryItemUpdate(container: ref.container, item: updated, source: 'item.file.delete');
      }
    } catch (_) {
      await _invalidateItemCache();
    }
    _showMessage(l10n.statusFileDeleted);
  }

  Future<void> _invalidateItemCache() async {
    if (!mounted) {
      return;
    }

    await invalidateCachedLibraryItemEntries(container: ref.container, itemId: widget.itemId);
    if (!mounted) {
      return;
    }

    ref.invalidate(libraryItemProvider(widget.itemId));
  }

  Future<void> _act(String action) async {
    final l10n = context.l10n;
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
      _showMessage(l10n.errorCompleteFileActionFailed(error.toString()));
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
        child: Center(child: SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2))),
      );
    }

    return YaabsaContextMenuButton<String>(
      tooltip: context.l10n.headingFileActions,
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: _act,
      itemBuilder: (context) {
        return [
          if (canDownload) PopupMenuItem(value: 'download', child: Text(context.l10n.actionDownload)),
          if (canDelete) PopupMenuItem(value: 'delete', child: Text(context.l10n.actionDelete)),
          if (canViewInfo) PopupMenuItem(value: 'info', child: Text(context.l10n.actionMoreInfo)),
        ];
      },
    );
  }
}
