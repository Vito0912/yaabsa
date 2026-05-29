import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/admin_backup.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/item_formatters.dart';

class AdminBackupTable extends StatelessWidget {
  const AdminBackupTable({
    super.key,
    required this.backups,
    required this.busyBackupIds,
    required this.onRestore,
    required this.onDownload,
    required this.onDelete,
    this.loading = false,
    this.topActions,
    this.physics = const ClampingScrollPhysics(),
  });

  final List<AdminBackup> backups;
  final Set<String> busyBackupIds;
  final Future<void> Function(AdminBackup backup) onRestore;
  final Future<void> Function(AdminBackup backup) onDownload;
  final Future<void> Function(AdminBackup backup) onDelete;
  final bool loading;
  final Widget? topActions;
  final ScrollPhysics physics;

  String _fileLabel(AdminBackup backup) {
    final rawPath = (backup.path ?? backup.filename ?? backup.id).trim();
    if (rawPath.isEmpty) {
      return backup.id;
    }

    final normalized = rawPath.replaceAll('\\', '/');
    return normalized.startsWith('/') ? normalized : '/$normalized';
  }

  String _createdLabel(AdminBackup backup) {
    return formatDateTimeLabel(backup.createdDateTime);
  }

  String _sizeLabel(AdminBackup backup) {
    final size = backup.fileSize;
    if (size == null || size <= 0) {
      return '--';
    }

    return formatBytes(size);
  }

  @override
  Widget build(BuildContext context) {
    return ExpressiveActionTable<AdminBackup>(
      rows: backups,
      columns: [
        ExpressiveTableColumn<AdminBackup>(
          id: 'file',
          label: 'File',
          width: 280,
          cellBuilder: (context, backup) =>
              Text(_fileLabel(backup), softWrap: true, maxLines: 3, overflow: TextOverflow.ellipsis),
          tooltipBuilder: _fileLabel,
        ),
        ExpressiveTableColumn<AdminBackup>(
          id: 'created',
          label: 'Created',
          width: 152,
          cellBuilder: (context, backup) => Text(_createdLabel(backup)),
        ),
        ExpressiveTableColumn<AdminBackup>(
          id: 'size',
          label: 'Size',
          width: 110,
          alignment: ExpressiveTableCellAlignment.end,
          cellBuilder: (context, backup) => Text(_sizeLabel(backup), textAlign: TextAlign.end),
        ),
      ],
      topActions: topActions,
      rowId: (backup) => backup.id,
      busyRowIds: busyBackupIds,
      actions: [
        ExpressiveTableAction<AdminBackup>(
          icon: Icons.settings_backup_restore_rounded,
          tooltip: 'Restore backup',
          tone: ExpressiveTableActionTone.primary,
          onPressed: onRestore,
        ),
        ExpressiveTableAction<AdminBackup>(
          icon: Icons.download_rounded,
          tooltip: 'Download backup',
          tone: ExpressiveTableActionTone.primary,
          onPressed: onDownload,
        ),
        ExpressiveTableAction<AdminBackup>(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Delete backup',
          tone: ExpressiveTableActionTone.danger,
          onPressed: onDelete,
        ),
      ],
      loading: loading,
      physics: physics,
      emptyTitle: 'No backups found',
      emptySubtitle: 'Create or upload a backup to protect your Audiobookshelf metadata and database.',
    );
  }
}
