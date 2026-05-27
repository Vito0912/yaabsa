import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/admin_api_key.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class AdminApiKeyTable extends StatelessWidget {
  const AdminApiKeyTable({
    super.key,
    required this.apiKeys,
    required this.busyApiKeyIds,
    required this.onEdit,
    required this.onDelete,
    this.loading = false,
  });

  final List<AdminApiKey> apiKeys;
  final Set<String> busyApiKeyIds;
  final Future<void> Function(AdminApiKey apiKey) onEdit;
  final Future<void> Function(AdminApiKey apiKey) onDelete;
  final bool loading;

  String _ownerLabel(AdminApiKey apiKey) {
    final user = apiKey.user;
    if (user == null) {
      return apiKey.userId;
    }

    return user.username;
  }

  String _expiresLabel(AdminApiKey apiKey) {
    if (apiKey.expiresAt == null) {
      return 'Never';
    }

    if (apiKey.isExpired) {
      return 'Expired';
    }

    return formatDateTimeLabel(apiKey.expiresAt);
  }

  String _statusLabel(AdminApiKey apiKey) {
    if (!apiKey.isActive) {
      return 'Inactive';
    }
    if (apiKey.isExpired) {
      return 'Expired';
    }
    return 'Active';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ExpressiveActionTable<AdminApiKey>(
      rows: apiKeys,
      columns: [
        ExpressiveTableColumn<AdminApiKey>(
          id: 'name',
          label: 'Name',
          width: 180,
          cellBuilder: (context, apiKey) => Text(apiKey.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminApiKey>(
          id: 'owner',
          label: 'Owner',
          width: 130,
          cellBuilder: (context, apiKey) => Text(_ownerLabel(apiKey), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminApiKey>(
          id: 'status',
          label: 'Status',
          width: 108,
          cellBuilder: (context, apiKey) => Text(_statusLabel(apiKey)),
        ),
        ExpressiveTableColumn<AdminApiKey>(
          id: 'expires',
          label: 'Expires',
          width: 154,
          cellBuilder: (context, apiKey) => Text(
            _expiresLabel(apiKey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: apiKey.isExpired ? colorScheme.error : null),
          ),
        ),
        ExpressiveTableColumn<AdminApiKey>(
          id: 'created',
          label: 'Created',
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
      rowId: (apiKey) => apiKey.id,
      busyRowIds: busyApiKeyIds,
      actions: [
        ExpressiveTableAction<AdminApiKey>(
          icon: Icons.edit_outlined,
          tooltip: 'Edit API key',
          tone: ExpressiveTableActionTone.primary,
          onPressed: onEdit,
        ),
        ExpressiveTableAction<AdminApiKey>(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Delete API key',
          tone: ExpressiveTableActionTone.danger,
          onPressed: onDelete,
        ),
      ],
      loading: loading,
      emptyTitle: 'No API keys found',
      emptySubtitle: 'Create an API key to allow server integrations and automation clients.',
    );
  }
}
