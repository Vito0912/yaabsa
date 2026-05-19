import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_badge.dart';

import 'package:yaabsa/generated/l10n.dart';

enum AdminUserTileAction { edit, toggleActive, unlinkOpenId, delete }

class AdminUserListTile extends StatelessWidget {
  const AdminUserListTile({
    super.key,
    required this.user,
    required this.isBusy,
    required this.compactActions,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
    this.onUnlinkOpenId,
  });

  final AdminUser user;
  final bool isBusy;
  final bool compactActions;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;
  final VoidCallback? onUnlinkOpenId;

  String _formatEpoch(int? value) {
    if (value == null || value <= 0) {
      return S.current.componentsSettingsAdminUsersAdminUserListTileUnknown;
    }

    final dt = DateTime.fromMillisecondsSinceEpoch(value);
    return DateFormat.yMd(Intl.getCurrentLocale()).add_Hm().format(dt);
  }

  int _typeRank(String type) {
    switch (type.trim().toLowerCase()) {
      case 'root':
        return 0;
      case 'admin':
        return 1;
      case 'user':
        return 2;
      case 'guest':
        return 3;
      default:
        return 4;
    }
  }

  Color _typeColor(BuildContext context) {
    final rank = _typeRank(user.type);
    final colorScheme = Theme.of(context).colorScheme;
    switch (rank) {
      case 0:
        return colorScheme.tertiary;
      case 1:
        return colorScheme.primary;
      case 2:
        return colorScheme.secondary;
      case 3:
        return colorScheme.outline;
      default:
        return colorScheme.outlineVariant;
    }
  }

  void _onActionSelected(AdminUserTileAction action) {
    switch (action) {
      case AdminUserTileAction.edit:
        onEdit();
        break;
      case AdminUserTileAction.toggleActive:
        onToggleActive();
        break;
      case AdminUserTileAction.unlinkOpenId:
        onUnlinkOpenId?.call();
        break;
      case AdminUserTileAction.delete:
        onDelete();
        break;
    }
  }

  Widget _buildCompactActions() {
    final canToggleActive = !user.isRoot;

    return PopupMenuButton<AdminUserTileAction>(
      enabled: !isBusy,
      onSelected: _onActionSelected,
      itemBuilder: (_) => <PopupMenuEntry<AdminUserTileAction>>[
        PopupMenuItem<AdminUserTileAction>(
          value: AdminUserTileAction.edit,
          child: Text(S.current.componentsSettingsAdminUsersAdminUserListTileEditUser),
        ),
        if (canToggleActive)
          PopupMenuItem<AdminUserTileAction>(
            value: AdminUserTileAction.toggleActive,
            child: Text(
              user.isActive
                  ? S.current.componentsSettingsAdminUsersAdminUserListTileDisableUser
                  : S.current.componentsSettingsAdminUsersAdminUserListTileEnableUser,
            ),
          ),
        if (user.hasLinkedOpenId)
          PopupMenuItem<AdminUserTileAction>(
            value: AdminUserTileAction.unlinkOpenId,
            child: Text(S.current.componentsSettingsAdminUsersAdminUserListTileUnlinkOpenID),
          ),
        PopupMenuItem<AdminUserTileAction>(
          value: AdminUserTileAction.delete,
          textStyle: const TextStyle(color: Colors.red),
          child: Text(S.current.componentsSettingsAdminUsersAdminUserListTileDeleteUser),
        ),
      ],
    );
  }

  Widget _buildWideActions(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 8,
        runSpacing: 6,
        children: [
          OutlinedButton.icon(
            onPressed: isBusy ? null : onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text(S.current.componentsSettingsAdminUsersAdminUserListTileEdit),
          ),
          if (!user.isRoot)
            OutlinedButton.icon(
              onPressed: isBusy ? null : onToggleActive,
              icon: Icon(user.isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded, size: 18),
              label: Text(
                user.isActive
                    ? S.current.componentsSettingsAdminUsersAdminUserListTileDisable
                    : S.current.componentsSettingsAdminUsersAdminUserListTileEnable,
              ),
            ),
          OutlinedButton.icon(
            onPressed: isBusy ? null : onDelete,
            style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: Text(S.current.componentsSettingsAdminUsersAdminUserListTileDelete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(context);
    final statusColor = user.isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline;
    final email = user.email?.trim();
    final subtitleParts = <String>[
      (email?.isNotEmpty ?? false)
          ? (email ?? S.current.componentsSettingsAdminUsersAdminUserListTileNoEmail)
          : S.current.componentsSettingsAdminUsersAdminUserListTileNoEmail,
      S.current.componentsSettingsAdminUsersAdminUserListTileCreated(_formatEpoch(user.createdAt)),
      S.current.componentsSettingsAdminUsersAdminUserListTileLastSeen(_formatEpoch(user.lastSeen)),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      Text(
                        user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      AdminUserBadge(label: user.type.toUpperCase(), color: typeColor),
                      AdminUserBadge(
                        label: user.isActive
                            ? S.current.componentsSettingsAdminUsersAdminUserListTileActive
                            : S.current.componentsSettingsAdminUsersAdminUserListTileDisabled,
                        color: statusColor,
                        icon: user.isActive ? Icons.check_circle_rounded : Icons.do_not_disturb_on_rounded,
                      ),
                      if (user.hasLinkedOpenId)
                        AdminUserBadge(
                          label: S.current.componentsSettingsAdminUsersAdminUserListTileOpenId,
                          color: Theme.of(context).colorScheme.secondary,
                          icon: Icons.link_rounded,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isBusy)
                  const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                else if (compactActions)
                  _buildCompactActions(),
              ],
            ),
            const SizedBox(height: 6),
            Text(subtitleParts.join(' • '), style: Theme.of(context).textTheme.bodySmall),
            if (!compactActions) ...[const SizedBox(height: 10), _buildWideActions(context)],
          ],
        ),
      ),
    );
  }
}
