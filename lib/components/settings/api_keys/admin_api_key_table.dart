import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/admin/admin_api_key.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminApiKeyTable extends StatelessWidget {
  const AdminApiKeyTable({
    super.key,
    required this.apiKeys,
    required this.busyApiKeyIds,
    required this.onEdit,
    required this.onDelete,
    this.loading = false,
    this.topActions,
    this.showSelection = false,
    this.selectedApiKeyIds = const <String>{},
    this.onSelectionChanged,
  });

  final List<AdminApiKey> apiKeys;
  final Set<String> busyApiKeyIds;
  final Future<void> Function(AdminApiKey apiKey) onEdit;
  final Future<void> Function(AdminApiKey apiKey) onDelete;
  final bool loading;
  final Widget? topActions;
  final bool showSelection;
  final Set<String> selectedApiKeyIds;
  final void Function(AdminApiKey apiKey, bool selected)? onSelectionChanged;

  String _ownerLabel(AdminApiKey apiKey) {
    final user = apiKey.user;
    if (user == null) {
      return apiKey.userId;
    }

    return user.username;
  }

  String _expiresLabel(AdminApiKey apiKey, AppLocalizations l10n) {
    if (apiKey.expiresAt == null) {
      return l10n.statusNeverExpires;
    }

    if (apiKey.isExpired) {
      return l10n.statusExpired;
    }

    return formatDateTimeLabel(apiKey.expiresAt);
  }

  String _statusLabel(AdminApiKey apiKey, AppLocalizations l10n) {
    if (!apiKey.isActive) {
      return l10n.statusInactive;
    }
    if (apiKey.isExpired) {
      return l10n.statusExpired;
    }
    return l10n.statusActive;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return ExpressiveActionTable<AdminApiKey>(
      rows: apiKeys,
      columns: [
        ExpressiveTableColumn<AdminApiKey>(
          id: 'name',
          label: l10n.fieldName,
          width: 180,
          cellBuilder: (context, apiKey) => Text(apiKey.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminApiKey>(
          id: 'owner',
          label: l10n.fieldOwner,
          width: 130,
          cellBuilder: (context, apiKey) => Text(_ownerLabel(apiKey), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminApiKey>(
          id: 'status',
          label: l10n.fieldStatus,
          width: 108,
          cellBuilder: (context, apiKey) => Text(_statusLabel(apiKey, l10n)),
        ),
        ExpressiveTableColumn<AdminApiKey>(
          id: 'expires',
          label: l10n.fieldExpires,
          width: 154,
          cellBuilder: (context, apiKey) => Text(
            _expiresLabel(apiKey, l10n),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: apiKey.isExpired ? colorScheme.error : null),
          ),
        ),
        ExpressiveTableColumn<AdminApiKey>(
          id: 'created',
          label: l10n.fieldCreated,
          width: 154,
          showOnMobile: false,
          cellBuilder: (context, apiKey) => Text(
            formatDateTimeLabel(apiKey.createdAt),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
      topActions: topActions,
      rowId: (apiKey) => apiKey.id,
      busyRowIds: busyApiKeyIds,
      showSelection: showSelection,
      selectedRowIds: selectedApiKeyIds,
      onSelectionChanged: onSelectionChanged,
      actions: [
        ExpressiveTableAction<AdminApiKey>(
          icon: Icons.edit_outlined,
          tooltip: l10n.actionEdit,
          tone: ExpressiveTableActionTone.primary,
          onPressed: onEdit,
        ),
        ExpressiveTableAction<AdminApiKey>(
          icon: Icons.delete_outline_rounded,
          tooltip: l10n.actionDelete,
          tone: ExpressiveTableActionTone.danger,
          onPressed: onDelete,
        ),
      ],
      loading: loading,
      emptyTitle: l10n.statusNoApiKeysFound,
      emptySubtitle: l10n.messageApiKeyPurpose,
    );
  }
}
